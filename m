Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3IWKgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:36:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22241 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3IWKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:36:22 -0400
Date: Mon, 23 Sep 2013 13:35:04 +0300
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
Message-ID: <20130923103504.GG6192@mwanda>
References: <1379599919-24763-1-git-send-email-dominik.paulus@fau.de>
 <1379599919-24763-6-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379599919-24763-6-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
> +	ud->tfm_send = crypto_alloc_aead("gcm(aes)", 0, 0);
> +	if (IS_ERR(ud->tfm_send)) {
> +		crypto_free_aead(ud->tfm_recv);
> +		return -PTR_ERR(ud->tfm_send);
> +	}
> +	ret = kfifo_alloc(&ud->recv_queue, RECVQ_SIZE, GFP_KERNEL);
> +	if (ret) {
> +		crypto_free_aead(ud->tfm_recv);
> +		crypto_free_aead(ud->tfm_send);
> +		return ret;
> +	}
> +
> +	if (crypto_aead_setkey(ud->tfm_send, sendkey, USBIP_KEYSIZE) != 0 ||
> +			crypto_aead_setkey(ud->tfm_recv, recvkey,
> +				USBIP_KEYSIZE) != 0 ||
> +			crypto_aead_setauthsize(ud->tfm_send,
> +				USBIP_AUTHSIZE) != 0 ||
> +			crypto_aead_setauthsize(ud->tfm_recv,
> +				USBIP_AUTHSIZE)) {
> +		crypto_free_aead(ud->tfm_recv);
> +		crypto_free_aead(ud->tfm_send);
> +		kfifo_free(&ud->recv_queue);
> +	}

This returns success on error instead of failure.

The indenting is messed up.  There are three places which check " != 0"
and doesn't.  Please leave off the "!= 0" throughout the whole patch.
It should look like:

	if (crypto_aead_setkey(ud->tfm_send, sendkey, USBIP_KEYSIZE) ||
	    crypto_aead_setkey(ud->tfm_recv, recvkey, USBIP_KEYSIZE) ||
	    crypto_aead_setauthsize(ud->tfm_send, USBIP_AUTHSIZE) ||
	    crypto_aead_setauthsize(ud->tfm_recv, USBIP_AUTHSIZE)) {
	    	ret = -EINVAL;
		goto err_free_fifo;
	}

Notice how the label name is chosen based on the label location and not
the goto location.

The end of the function should look like:

	return 0;

err_free_fifo:
	kfifo_free(&ud->recv_queue);
err_free_send:
	crypto_free_aead(ud->tfm_send);
err_free_recv:
	crypto_free_aead(ud->tfm_recv);

	return ret;

regards,
dan carpenter

