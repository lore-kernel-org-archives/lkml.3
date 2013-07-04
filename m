Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3GDJ5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:57:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:40247 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3GDJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:57:39 -0400
Date: Thu, 4 Jul 2013 11:57:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Shi <alex.shi@intel.com>
cc: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 1/3] clocksource: clean up clocksource_select
In-Reply-To: <1372916056-24301-2-git-send-email-alex.shi@intel.com>
Message-ID: <alpine.DEB.2.02.1307041151170.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-2-git-send-email-alex.shi@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Alex Shi wrote:

> After clocksource_find_best() introduced, it is impossible to get into
> some code path. so clean them up.

That's wrong.
 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/time/clocksource.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index e713ef7..021c159 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -582,26 +582,12 @@ static void __clocksource_select(bool skipcur)
>  	if (!best)
>  		return;
>  
> -	/* Check for the override clocksource. */
>  	list_for_each_entry(cs, &clocksource_list, list) {
>  		if (skipcur && cs == curr_clocksource)
>  			continue;
>  		if (strcmp(cs->name, override_name) != 0)
>  			continue;

We need this check and it is completely unrelated to the problem
you're trying to solve.

Assume the following:

       System boots with clocksource A and switches into highres mode.
       Now clocksource B gets registered and B is not highres capable.

       clocksource_find_best() selects again A, but we have
       clocksource=B on the kernel command line to override the kernel
       decision.

By removing the check, you install he non highres capable clocksource
B and kill the machine.

> -		/*
> -		 * Check to make sure we don't switch to a non-highres
> -		 * capable clocksource if the tick code is in oneshot
> -		 * mode (highres or nohz)
> -		 */
> -		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) && oneshot) {
> -			/* Override clocksource cannot be used. */
> -			printk(KERN_WARNING "Override clocksource %s is not "
> -			       "HRT compatible. Cannot switch while in "
> -			       "HRT/NOHZ mode\n", cs->name);
> -			override_name[0] = 0;
> -		} else
> -			/* Override clocksource can be used. */
> -			best = cs;
> +		best = cs;
>  		break;
>  	}

Thanks,

	tglx
