Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab3CSVHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:07:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49389 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3CSVHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:07:05 -0400
Message-ID: <5148D35F.5070704@ahsoftware.de>
Date: Tue, 19 Mar 2013 22:06:39 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Howells <dhowells@redhat.com>,
        rusty@rustcorp.com.au, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH] Fix x509_key_preparse() not to reject keys outside their
 validity time range
References: <5555.1348531649@warthog.procyon.org.uk>  <21845.1348585794@warthog.procyon.org.uk>  <20120925163037.20ba3f3c@pyramind.ukuu.org.uk>  <1363258094.4853.20.camel@i7.infradead.org> <1363263842.4853.35.camel@i7.infradead.org>
In-Reply-To: <1363263842.4853.35.camel@i7.infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.03.2013 13:24, schrieb David Woodhouse:
> The x509_key_preparse() function will refuse to even *parse* a
> certificate when the system clock happens to be set to a time before the
> ValidFrom or after the ValidTo date.
>
> This is wrong. If date checks are to be done, they need to be done at
> the time the cert is *used*. It should be perfectly possible to load a
> cert which is post-dated, and can only be used for validation at some
> point in the future. The key in question should immediately start
> working at its ValidFrom date, and stop again at its ValidTo date. It
> should be allowed to *exist* in the kernel both before and after those
> times.
>
> On systems where the hardware clock is inaccurate (a common occurrence
> and one which doesn't even get noticed when you use NTP or something
> else to fix it during the boot sequence), this was preventing the module
> signing cert from being loaded during boot. When the clock got fixed
> later on in he boot sequence, things *should* have started working. But
> they didn't...
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>
> Arguably, for the specific case of module signing we shouldn't bother
> checking for a current time before the ValidFrom date *at all*. It's
> *always* going to be a screwed up system clock, because we don't have a
> usage model of post-dating module signatures. We should simply document
> that the date is *not* checked for module signing, and have done with
> it. But that's a separate issue.
>
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index 06007f0..326dc80 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -154,8 +154,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
>   		     (now.tm_sec < cert->valid_from.tm_sec
>   		      ))))))))))) {
>   		pr_warn("Cert %s is not yet valid\n", cert->fingerprint);
> -		ret = -EKEYREJECTED;
> -		goto error_free_cert;
>   	}
>   	if (now.tm_year > cert->valid_to.tm_year ||
>   	    (now.tm_year == cert->valid_to.tm_year &&
> @@ -170,8 +168,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
>   		     (now.tm_sec > cert->valid_to.tm_sec
>   		      ))))))))))) {
>   		pr_warn("Cert %s has expired\n", cert->fingerprint);
> -		ret = -EKEYEXPIRED;
> -		goto error_free_cert;
>   	}
>
>   	cert->pub->algo = x509_public_key_algorithms[cert->pkey_algo];

Why not remove the check and warning there too?

Regards,

Alexander

