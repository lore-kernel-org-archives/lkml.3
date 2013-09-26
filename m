Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3IZKSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:18:39 -0400
Received: from d-paulus.de ([37.221.197.252]:57437 "EHLO d-paulus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab3IZKSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:18:36 -0400
Date: Thu, 26 Sep 2013 12:18:34 +0200
From: Dominik Paulus <dominik@d-paulus.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dominik Paulus <dominik.paulus@fau.de>, usbip-devel@lists.sourceforge.net,
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
Message-ID: <20130926101833.GA8677@d-paulus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923105842.GH6192@mwanda>
 <20130923103504.GG6192@mwanda>
 <20130923095929.GF6192@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thank you very much for your feedback!

On Mon, Sep 23, 2013 at 12:59:29PM +0300, Dan Carpenter wrote:
> > +	while (total < size) {
> > +		uint32_t packetsize;
> > +		struct kvec recvvec;
> > +
> > +		/*
> > +		 * We use a global kfifo to buffer unrequested plaintext bytes.
> > +		 * Flush this buffer first before receiving new data.
> > +		 */
> > +		if (kfifo_len(&ud->recv_queue)) {
> > +			size_t next = min_t(size_t, kfifo_len(&ud->recv_queue),
> > +					size - total);
> > +			/* No error checking necessary - see previous line */
> > +			ret = kfifo_out(&ud->recv_queue, ((char *)
> > +						vec[0].iov_base)+total, next);
> 
> 
> The comment assume there is only one reader and one writer at a time,
> yes?  The casting is not needed:

Actually, we have not only one reader and one writer, but exactly one
thread doing all the work on the fifo. No parallel access is done at
all.

> 			ret = kfifo_out(&ud->recv_queue,
> 					vec[0].iov_base + total, next);
> 
> 
> v> +			total += next;
> > +			continue;
> > +		}
> > +
> > +		/* See usbip_sendmsg() for the format of one encrypted packet */
> > +
> > +		/*
> > +		 * Receive size of next crypto packet
> > +		 */
> > +		recvvec.iov_base = &packetsize;
> > +		recvvec.iov_len = sizeof(packetsize);
> > +
> > +		ret = kernel_recvmsg(ud->tcp_socket, msg, &recvvec, 1,
> > +				sizeof(packetsize), flags);
> > +		packetsize = be32_to_cpu(packetsize);
> > +		if (ret <= 0) {
> 
> I think a return of zero should mean total = -EBADMSG;.  In other words
> this check should be "if (ret < 0) {" and we hit the next else if.
> Same below again.

As we are wrapping kernel_recvmsg here, we wanted to leave the semantics
intact as far as possible. The calling code already checks for the correct
size.

> > +			total = ret;
> > +			goto err;
> > +		} else if (ret != sizeof(packetsize)) {
> > +			total = -EBADMSG;
> > +			goto err;
> > +		}

On Mon, Sep 23, 2013 at 01:35:04PM +0300, Dan Carpenter wrote:
> On Thu, Sep 19, 2013 at 04:11:57PM +0200, Dominik Paulus wrote:
> > +	if (crypto_aead_setkey(ud->tfm_send, sendkey, USBIP_KEYSIZE) != 0 ||
> > +			crypto_aead_setkey(ud->tfm_recv, recvkey,
> > +				USBIP_KEYSIZE) != 0 ||
> > +			crypto_aead_setauthsize(ud->tfm_send,
> > +				USBIP_AUTHSIZE) != 0 ||
> > +			crypto_aead_setauthsize(ud->tfm_recv,
> > +				USBIP_AUTHSIZE)) {
> > +		crypto_free_aead(ud->tfm_recv);
> > +		crypto_free_aead(ud->tfm_send);
> > +		kfifo_free(&ud->recv_queue);
> > +	}
> 
> This returns success on error instead of failure.

Indeed, that was horribly broken. Thanks.

On Mon, Sep 23, 2013 at 01:58:42PM +0300, Dan Carpenter wrote:
> On Thu, Sep 19, 2013 at 04:11:57PM +0200, Dominik Paulus wrote:
> > +{
> > +	struct crypto_aead *tfm;
> > +	struct aead_request *req;
> > +	struct tcrypt_result result;
> > +	struct scatterlist plain, cipher, assoc;
> > +	char iv[16];
> > +	u64 *iv_num;
> > +	u64 iv_net;
> > +	const int plainsize = packetsize - USBIP_AUTHSIZE;
> 
> Is it possible that packetsize is less than USBIP_AUTHSIZE?

No, currently, the caller (usbip_sendmsg() / usbip_recvmsg() are the
only functions calling usbip_crypt(), which itself is static) ensures
this.
Admittedly, this isn't great design. We added a check for packetsize <
USBIP_AUTHSIZE and an appropiate return here.

> > +	if (encrypt)
> > +		ret = crypto_aead_encrypt(req);
> > +	else
> > +		ret = crypto_aead_decrypt(req);
> > +
> 
> Good on you for figuring out what crypto_aead_en/decrypt() returns.
> Where are these functions documented?
> 
> > +        switch (ret) {
> > +        case 0: /* Success */
> > +                break;
> > +        case -EINPROGRESS:
> > +        case -EBUSY:
> > +                wait_for_completion(&result.completion);
> > +                break;
> > +        default:
> > +                aead_request_free(req);
> > +                return ret;
> > +        }
> > +

They aren't, actually. Documentation/crypto/api-intro.txt refers to the
regression test module, which uses exactly those return-values in
crypto/testmgr.c.
We noticed that wait_for_completion might not be the best idea, since it could
hang indefinitely, testmgr.c uses wait_for_completion_interruptible. Do we
want 'interruptible' or 'killable' here?
(Also we forgot to error-check result.err afterwards. We also fixed that.)

Regards,
Dominik Paulus, Tobias Polzer
