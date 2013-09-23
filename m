Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3IWKAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:00:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42178 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3IWKAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:00:44 -0400
Date: Mon, 23 Sep 2013 12:59:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominik Paulus <dominik.paulus@fau.de>
Cc: usbip-devel@lists.sourceforge.net,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Harvey Yang <harvey.huawei.yang@gmail.com>,
        linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Bart Westgeest <bart@elbrys.com>, Joe Perches <joe@perches.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Bernard Blackham <b-linuxgit@largestprime.net>
Subject: Re: [PATCH 5/7] staging: usbip: Add encryption support to kernel
Message-ID: <20130923095929.GF6192@mwanda>
References: <1379599919-24763-1-git-send-email-dominik.paulus@fau.de>
 <1379599919-24763-6-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379599919-24763-6-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 04:11:57PM +0200, Dominik Paulus wrote:
> +int usbip_init_crypto(struct usbip_device *ud, unsigned char *sendkey, unsigned
> +		char *recvkey)
> +{
> +	int ret;
> +
> +	ud->use_crypto = 1;
> +
> +	ud->tfm_recv = crypto_alloc_aead("gcm(aes)", 0, 0);
> +	if (IS_ERR(ud->tfm_recv))
> +		return -PTR_ERR(ud->tfm_recv);

PTR_ERR() already returns a negative.

> +	ud->tfm_send = crypto_alloc_aead("gcm(aes)", 0, 0);
> +	if (IS_ERR(ud->tfm_send)) {
> +		crypto_free_aead(ud->tfm_recv);
> +		return -PTR_ERR(ud->tfm_send);

Again.  All the uses of PTR_ERR() in this patch have the same problem.

> +	plainbuf = kmalloc(USBIP_PACKETSIZE, GFP_KERNEL);
> +	if (IS_ERR(plainbuf))
> +		return -PTR_ERR(plainbuf);

kmalloc() returns NULL on error and not an ERR_PTR.  All the calls to
kmalloc() have this problem.

> +	cipherbuf = kmalloc(USBIP_PACKETSIZE, GFP_KERNEL);
> +	if (IS_ERR(cipherbuf)) {
> +		kfree(plainbuf);
> +		return -PTR_ERR(cipherbuf);
> +	}
> +
> +	while (total < size) {
> +		uint32_t packetsize;
> +		struct kvec recvvec;
> +
> +		/*
> +		 * We use a global kfifo to buffer unrequested plaintext bytes.
> +		 * Flush this buffer first before receiving new data.
> +		 */
> +		if (kfifo_len(&ud->recv_queue)) {
> +			size_t next = min_t(size_t, kfifo_len(&ud->recv_queue),
> +					size - total);
> +			/* No error checking necessary - see previous line */
> +			ret = kfifo_out(&ud->recv_queue, ((char *)
> +						vec[0].iov_base)+total, next);


The comment assume there is only one reader and one writer at a time,
yes?  The casting is not needed:

			ret = kfifo_out(&ud->recv_queue,
					vec[0].iov_base + total, next);


v> +			total += next;
> +			continue;
> +		}
> +
> +		/* See usbip_sendmsg() for the format of one encrypted packet */
> +
> +		/*
> +		 * Receive size of next crypto packet
> +		 */
> +		recvvec.iov_base = &packetsize;
> +		recvvec.iov_len = sizeof(packetsize);
> +
> +		ret = kernel_recvmsg(ud->tcp_socket, msg, &recvvec, 1,
> +				sizeof(packetsize), flags);
> +		packetsize = be32_to_cpu(packetsize);
> +		if (ret <= 0) {

I think a return of zero should mean total = -EBADMSG;.  In other words
this check should be "if (ret < 0) {" and we hit the next else if.
Same below again.

> +			total = ret;
> +			goto err;
> +		} else if (ret != sizeof(packetsize)) {
> +			total = -EBADMSG;
> +			goto err;
> +		}
> +
> +		if (packetsize > USBIP_PACKETSIZE) {
> +			total = -EBADMSG;
> +			goto err;
> +		}
> +

regards,
dan carpenter
