Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaFHReP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:34:15 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45694 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbaFHReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:34:14 -0400
Message-Id: <1402248852.14095.126480525.5C81F8C6@webmail.messagingengine.com>
X-Sasl-Enc: pLQvp1uiOVnAkCYb+NA8vJdLoZw6ZGKITBUdTpd38LBD 1402248852
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>, davem@davemloft.net,
        dborkman@redhat.com, shemminger@osdl.org, tytso@mit.edu
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-037d6a32
In-Reply-To: <20140607082805.10120.qmail@ns.horizon.com>
References: <20140607082805.10120.qmail@ns.horizon.com>
Subject: Re: [PATCH 5/7] lib/random32.c: Make prandom_u32_max efficient for
 powers of 2
Date: Sun, 08 Jun 2014 10:34:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2014, at 1:28, George Spelvin wrote:
> diff --git a/include/linux/random.h b/include/linux/random.h
> index 57fbbffd..e1f3ec9a 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -47,11 +47,23 @@ void prandom_bytes_state(struct rnd_state *state, void *buf, int nbytes);
>   * generator, that is, prandom_u32(). This is useful when requesting a
>   * random index of an array containing ep_ro elements, for example.
>   *
> + * If ep_ro is a power of 2 known at compile time, a modulo operation
> + * reduces to a simple mask to extract the low order bits.  Otherwise,
> + * it uses a multiply and shift, which is faster than a general modulus.
> + *
>   * Returns: pseudo-random number in interval [0, ep_ro)
>   */
>  static inline u32 prandom_u32_max(u32 ep_ro)
>  {
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
>  }

Have you checked assembler output if this helps anything at all? Constant propagation in the compiler should be able to figure that out all by itself. The only places I use __builtin_constant_p today are where I also make use of inline assembler.

Please check this as it makes the code more complicated and I doubt it is worth it.

Btw, IIRC there is a function is_power_of_2 somewhere. ;)

Thanks,

  Hannes
