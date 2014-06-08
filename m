Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaFHMDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:03:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaFHMDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:03:46 -0400
Message-ID: <53945115.7060600@redhat.com>
Date: Sun, 08 Jun 2014 14:03:33 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, shemminger@osdl.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH 5/7] lib/random32.c: Make prandom_u32_max efficient for
 powers of 2
References: <20140607082805.10120.qmail@ns.horizon.com>
In-Reply-To: <20140607082805.10120.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 10:28 AM, George Spelvin wrote:
> The multiply-and-shift is efficient in the general case, but slower than
> a simple bitwise AND if the range is a power of 2.  Make the function
> handle this case so callers don't have to worry about micro-optimizing it.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>   include/linux/random.h | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/random.h b/include/linux/random.h
> index 57fbbffd..e1f3ec9a 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -47,11 +47,23 @@ void prandom_bytes_state(struct rnd_state *state, void *buf, int nbytes);
>    * generator, that is, prandom_u32(). This is useful when requesting a
>    * random index of an array containing ep_ro elements, for example.
>    *
> + * If ep_ro is a power of 2 known at compile time, a modulo operation
> + * reduces to a simple mask to extract the low order bits.  Otherwise,
> + * it uses a multiply and shift, which is faster than a general modulus.
> + *
>    * Returns: pseudo-random number in interval [0, ep_ro)
>    */
>   static inline u32 prandom_u32_max(u32 ep_ro)
>   {
> -	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
> +	/*
> +	 * Instead of just __builtin_constant_p(ep_ro), this test is
> +	 * "is it known at compile time that ep_ro is a power of 2?", and
> +	 * can in theory handle the case that it's an unknown power of 2.
> +	 */
> +	if (__builtin_constant_p(ep_ro & (ep_ro-1)) && !(ep_ro & (ep_ro-1)))
> +		return prandom_u32() & (ep_ro-1);
> +	else
> +		return (u32)((u64)prandom_u32() * ep_ro >> 32);

Okay, I guess it's fine since we expect a random number here anyway, so
it doesn't matter much how we get to the result; otherwise I'd have
complained as both function don't do the same thing. Please leave some
whitespace, i.e. I mean "ep_ro-1" -> "ep_ro - 1".

Btw, there are many other users which hard code prandom_u32_max() resp.
reciprocal_scale() function in the source tree. If you have some cycles,
feel free to migrate them and let them use these functions.

>   }
>
>   /*
>
