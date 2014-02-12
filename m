Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaBLXn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:43:59 -0500
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:34800 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751269AbaBLXn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:43:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blade51_5c887313deb56
X-Filterd-Recvd-Size: 2100
Message-ID: <1392248633.2214.6.camel@joe-AO722>
Subject: Re: [PATCH akpm-next] random32: minor cleanups and kdoc fix
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 15:43:53 -0800
In-Reply-To: <1392244982-20450-1-git-send-email-dborkman@redhat.com>
References: <1392244982-20450-1-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 23:43 +0100, Daniel Borkmann wrote:
> These are just some very minor and misc cleanups in the PRNG.

trivia:

> diff --git a/lib/random32.c b/lib/random32.c
[]
> @@ -30,7 +30,6 @@
>  
>     This affects the seeding procedure by imposing the requirement
>     s1 > 1, s2 > 7, s3 > 15, s4 > 127.
> -
>  */

Using normal comment block style

	/*
	 *
	 */

might be nicer
 
>  #include <linux/types.h>
> @@ -75,15 +74,17 @@ EXPORT_SYMBOL(prandom_u32_state);
>   */
>  u32 prandom_u32(void)
>  {
> -	unsigned long r;
>  	struct rnd_state *state = &get_cpu_var(net_rand_state);
> -	r = prandom_u32_state(state);
> +	u32 res;
> +
> +	res = prandom_u32_state(state);

Maybe:

	u32 res = prandom_u32_state(state);

> @@ -201,9 +202,10 @@ static int __init prandom_init(void)
>  	for_each_possible_cpu(i) {
>  		struct rnd_state *state = &per_cpu(net_rand_state,i);
>  
> -		prandom_seed_very_weak(state, (i + jiffies) ^ random_get_entropy());
> +		prandom_seed_very_weak(state, (i + jiffies) ^ (u32)random_get_entropy());

This (u32) cast is not necessary.

On 64 bit machines, the high 32 bits of random_get_entropy
are unnecessarily dropped/masked.

The compiler will cast the unsigned long result of the xor
back to u32 anyway.


