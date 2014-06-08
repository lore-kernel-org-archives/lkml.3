Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaFHKnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaFHKnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:43:10 -0400
Message-ID: <53943E34.7030502@redhat.com>
Date: Sun, 08 Jun 2014 12:43:00 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, shemminger@osdl.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH 6/7] lib/random32.c: Randomize timeout to the millisecond,
 not the second
References: <20140607082859.10162.qmail@ns.horizon.com>
In-Reply-To: <20140607082859.10162.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 10:28 AM, George Spelvin wrote:
> If you're going to bother randomizing it, do it right.
> And use prandom_u32_max(), which is designed for the job, rather
> than "% 40".
>
> Signed-off-by: George Spelvin <linux@horizon.com>

Fine by me this cleanup, although not strictly needed.

> ---
>   lib/random32.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/lib/random32.c b/lib/random32.c
> index eee60100..9cc410dd 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -208,14 +208,14 @@ static DEFINE_TIMER(seed_timer, __prandom_timer, 0, 0);
>   static void __prandom_timer(unsigned long dontcare)
>   {
>   	u32 entropy;
> -	unsigned long expires;
> +	unsigned int expires;
>
>   	get_random_bytes(&entropy, sizeof(entropy));
>   	prandom_seed(entropy);
>
>   	/* reseed every ~60 seconds, in [40 .. 80) interval with slack */
> -	expires = 40 + (prandom_u32() % 40);
> -	seed_timer.expires = jiffies + msecs_to_jiffies(expires * MSEC_PER_SEC);
> +	expires = 40000 + prandom_u32_max(40000);
> +	seed_timer.expires = jiffies + msecs_to_jiffies(expires);
>
>   	add_timer(&seed_timer);
>   }
>
