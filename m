Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaFHMLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaFHMLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:11:15 -0400
Message-ID: <539452DA.7060005@redhat.com>
Date: Sun, 08 Jun 2014 14:11:06 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, shemminger@osdl.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH 2/7] lib/random32.c: Remove excess calls to prandom_u32_state
 in initialization
References: <20140607082056.9751.qmail@ns.horizon.com>
In-Reply-To: <20140607082056.9751.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 10:20 AM, George Spelvin wrote:
> Unrolling code in single-use code paths is just silly.  There are two
> instances:
>
> 1) prandom_warmup() calls 10 times.
> 2) prandom_state_selftest() can avoid one call and simplify the
>     loop logic by repeating an assignment to a local variable
>     (that probably adds zero code anyway)
>
> Signed-off-by: George Spelvin <linux@horizon.com>

Fine by me although we simply resembled initialization code from
GSL here. I think that your subject line is a bit misleading though.

> ---
>   lib/random32.c | 21 ++++++++-------------
>   1 file changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/lib/random32.c b/lib/random32.c
> index 4da5d281..2e7c15c0 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -134,17 +134,11 @@ EXPORT_SYMBOL(prandom_bytes);
>
>   static void prandom_warmup(struct rnd_state *state)
>   {
> +	int i;
> +
>   	/* Calling RNG ten times to satify recurrence condition */
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> -	prandom_u32_state(state);
> +	for (i = 0; i < 10; i++)
> +		prandom_u32_state(state);
>   }
>
>   static void prandom_seed_very_weak(struct rnd_state *state, u32 seed)
> @@ -433,14 +427,15 @@ static void __init prandom_state_selftest(void)
>
>   	for (i = 0; i < ARRAY_SIZE(test2); i++) {
>   		struct rnd_state state;
> +		u32 result;
>
>   		prandom_seed_very_weak(&state, test2[i].seed);
>   		prandom_warmup(&state);
>
> -		for (j = 0; j < test2[i].iteration - 1; j++)
> -			prandom_u32_state(&state);
> +		for (j = 0; j < test2[i].iteration; j++)
> +			result = prandom_u32_state(&state);
>
> -		if (test2[i].result != prandom_u32_state(&state))
> +		if (test2[i].result != result)
>   			errors++;
>
>   		runs++;
>
