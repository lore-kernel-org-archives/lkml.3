Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3IWENK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:13:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39313 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3IWENJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:13:09 -0400
Message-ID: <523FBF8E.3000600@zytor.com>
Date: Sun, 22 Sep 2013 21:11:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH, RFC 08/12] random: mix in architectural randomness earlier
 in extract_buf()
References: <1379882338-7209-1-git-send-email-tytso@mit.edu> <1379882338-7209-9-git-send-email-tytso@mit.edu>
In-Reply-To: <1379882338-7209-9-git-send-email-tytso@mit.edu>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 01:38 PM, Theodore Ts'o wrote:
> Previously if CPU chip had a built-in random number generator (i.e.,
> RDRAND on newer x86 chips), we mixed it in at the very end of
> extract_buf() using an XOR operation.
> 
> We now mix it in right after the calculate a hash across the entire
> pool.  This has the advantage that any contribution of entropy from
> the CPU's HWRNG will get mixed back into the pool.  In addition, it
> means that if the HWRNG has any defects (either accidentally or
> maliciously introduced), this will be mitigated via the non-linear
> transform of the SHA-1 hash function before we hand out generated
> output.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


This doesn't mix in across the entire width of the hash (my original
motivation for putting this at the end was to do it after the hash is
folded in half -- which is still believe is cryptographically dubious,
but please don't take my word for it, as I'm not a professional
cryptographer.)  As such, this change should *probably* have
EXTRACT_SIZE changed to 2*EXTRACT_SIZE (or simply "20") both in the for
loop and in the declaration of the union.

	-hpa

>  drivers/char/random.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index ba23d5c..6d5e8e6 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -993,6 +993,17 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
>  		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
>  
>  	/*
> +	 * If we have a architectural hardware random number
> +	 * generator, mix that in, too.
> +	 */
> +	for (i = 0; i < LONGS(EXTRACT_SIZE); i++) {
> +		unsigned long v;
> +		if (!arch_get_random_long(&v))
> +			break;
> +		hash.l[i] ^= v;
> +	}
> +
> +	/*
>  	 * We mix the hash back into the pool to prevent backtracking
>  	 * attacks (where the attacker knows the state of the pool
>  	 * plus the current outputs, and attempts to find previous
> @@ -1021,17 +1032,6 @@ static void extract_buf(struct entropy_store *r, __u8 *out)
>  	hash.w[1] ^= hash.w[4];
>  	hash.w[2] ^= rol32(hash.w[2], 16);
>  
> -	/*
> -	 * If we have a architectural hardware random number
> -	 * generator, mix that in, too.
> -	 */
> -	for (i = 0; i < LONGS(EXTRACT_SIZE); i++) {
> -		unsigned long v;
> -		if (!arch_get_random_long(&v))
> -			break;
> -		hash.l[i] ^= v;
> -	}
> -
>  	memcpy(out, &hash, EXTRACT_SIZE);
>  	memset(&hash, 0, sizeof(hash));
>  }
> 

