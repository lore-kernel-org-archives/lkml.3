Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3HYPxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 11:53:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37096 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3HYPxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 11:53:12 -0400
Date: Sun, 25 Aug 2013 17:53:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 02/18] asymmetric keys: implement
 EMSA_PKCS1-v1_5-ENCODE in rsa
Message-ID: <20130825155309.GA5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-3-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-3-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-08-22 19:01:41, Lee, Chun-Yi wrote:
> Implement EMSA_PKCS1-v1_5-ENCODE [RFC3447 sec 9.2] in rsa.c. It's the
> first step of signature generation operation
> (RSASSA-PKCS1-v1_5-SIGN).

Is this your own code, or did you copy it from somewhere?

> +	if (!T)
> +		goto error_T;
> +
> +	memcpy(T, RSA_ASN1_templates[hash_algo].data, RSA_ASN1_templates[hash_algo].size);
> +	memcpy(T + RSA_ASN1_templates[hash_algo].size, pks->digest, pks->digest_size);
> +
> +	/* 3) check If emLen < tLen + 11, output "intended encoded message length too short" */
> +	if (emLen < tLen + 11) {
> +		ret = EINVAL;
> +		goto error_emLen;
> +	}

Normal kernel calling convention is 0 / -EINVAL.

> +	memcpy(EM + 2, PS, emLen - tLen - 3);
> +	EM[2 + emLen - tLen - 3] = 0x00;
> +	memcpy(EM + 2 + emLen - tLen - 3 + 1, T, tLen);

ThisDoesNotLookLikeKernelCode, NoCamelCase, please.

> +	*_EM = EM;

And we don't usually use _ prefix like this.


> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -110,6 +110,8 @@ extern void public_key_destroy(void *payload);
>  struct public_key_signature {
>  	u8 *digest;
>  	u8 digest_size;			/* Number of bytes in digest */
> +	u8 *S;				/* signature S of length k octets */

u8 *signature?

> +	size_t k;			/* length k of signature S */

u8 *signature_length.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
