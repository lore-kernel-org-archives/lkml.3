Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3IWLDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:03:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27638 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3IWLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:03:28 -0400
Date: Mon, 23 Sep 2013 13:58:42 +0300
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
Message-ID: <20130923105842.GH6192@mwanda>
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
> +/*
> + * Perform encryption/decryption on one chunk of data.
> + * Uses global crypto state stored in usbip_device.
> + * Parameters:
> + * encrypt: 1 to perform encryption, 0 to perform decryption operation

Make this a define:
#define USBIP_ENCRYPT 1
#define USBIP_ENCRYPT 0

> + * packetsize: Size of the encrypted packet, including the authentication tag,
> + * not including the associated data (length field).
> + * plaintext and ciphertext have to be appropiately managed by the caller
> + * (i.e. they must be at least packetsize bytes long).
> + * Returns: 0 on success
> + */
> +static int usbip_crypt(struct usbip_device *ud, int encrypt, uint32_t
> +		packetsize, unsigned char *plaintext, unsigned char
> +		*ciphertext)

Don't break put line breaks between the type and the variable name.  It
should be:

static int usbip_crypt(struct usbip_device *ud, int encrypt,
		uint32_t packetsize, unsigned char *plaintext,
		unsigned char *ciphertext)

This applies to earlier patches in this series as well.

> +{
> +	struct crypto_aead *tfm;
> +	struct aead_request *req;
> +	struct tcrypt_result result;
> +	struct scatterlist plain, cipher, assoc;
> +	char iv[16];
> +	u64 *iv_num;
> +	u64 iv_net;
> +	const int plainsize = packetsize - USBIP_AUTHSIZE;

Is it possible that packetsize is less than USBIP_AUTHSIZE?

> +	int ret;
> +
> +	memset(iv, 0, sizeof(iv));
> +	if (encrypt) {
> +		tfm = ud->tfm_send;
> +		iv_num = &ud->ctr_send;
> +	} else {
> +		tfm = ud->tfm_recv;
> +		iv_num = &ud->ctr_recv;
> +	}
> +	iv_net = cpu_to_be64(*iv_num);
> +	memcpy(iv, &iv_net, sizeof(iv_net));
> +
> +	req = aead_request_alloc(tfm, GFP_KERNEL);
> +	if (IS_ERR(req))
> +		return -PTR_ERR(req);
> +
> +	init_completion(&result.completion);
> +	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +			tcrypt_complete, &result);

Align this up like:

	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
				  tcrypt_complete, &result);


> +
> +	sg_init_one(&cipher, ciphertext, packetsize);
> +	sg_init_one(&plain, plaintext, plainsize);
> +	crypto_aead_clear_flags(tfm, ~0);
> +
> +	if (encrypt)
> +		aead_request_set_crypt(req, &plain, &cipher, plainsize, iv);
> +	else
> +		aead_request_set_crypt(req, &cipher, &plain, packetsize, iv);
> +	packetsize = cpu_to_be32(packetsize);
> +	sg_init_one(&assoc, &packetsize, sizeof(packetsize));
> +	/* Associated data: Unencrypted length tag */
> +	aead_request_set_assoc(req, &assoc, sizeof(packetsize));
> +
> +	if (encrypt)
> +		ret = crypto_aead_encrypt(req);
> +	else
> +		ret = crypto_aead_decrypt(req);
> +

Good on you for figuring out what crypto_aead_en/decrypt() returns.
Where are these functions documented?

> +	switch (ret) {
> +	case 0: /* Success */
> +		break;
> +	case -EINPROGRESS:
> +	case -EBUSY:
> +		wait_for_completion(&result.completion);
> +		break;
> +	default:
> +		aead_request_free(req);
> +		return ret;
> +	}
> +

regards,
dan carpenter

