Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3C1PoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:44:07 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33694 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3C1PoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:44:05 -0400
Message-ID: <515464B0.8080704@linux.vnet.ibm.com>
Date: Thu, 28 Mar 2013 21:11:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [patch 31/34] tile: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215235.348460344@linutronix.de>
In-Reply-To: <20130321215235.348460344@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032815-9574-0000-0000-0000073E16F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 03:23 AM, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/kernel/process.c |   61 ++++-----------------------------------------
>  arch/tile/kernel/smpboot.c |    2 -
>  2 files changed, 7 insertions(+), 56 deletions(-)
> 
> Index: linux-2.6/arch/tile/kernel/process.c
> ===================================================================
> --- linux-2.6.orig/arch/tile/kernel/process.c
> +++ linux-2.6/arch/tile/kernel/process.c
> @@ -40,13 +40,11 @@
>  #include <arch/abi.h>
>  #include <arch/sim_def.h>
> 
> -
>  /*
>   * Use the (x86) "idle=poll" option to prefer low latency when leaving the
>   * idle loop over low power while in the idle loop, e.g. if we have
>   * one thread per core and we want to get threads out of futex waits fast.
>   */
> -static int no_idle_nap;
>  static int __init idle_setup(char *str)
>  {
>  	if (!str)
> @@ -54,64 +52,17 @@ static int __init idle_setup(char *str)
> 
>  	if (!strcmp(str, "poll")) {
>  		pr_info("using polling idle threads.\n");
> -		no_idle_nap = 1;
> +		cpu_idle_poll_ctrl(true);
>  	} else if (!strcmp(str, "halt"))
> -		no_idle_nap = 0;
> -	else
> -		return -1;
> -
> -	return 0;
> +		return 0;
> +	return -1;
>  }
>  early_param("idle", idle_setup);
>

That doesn't look quite right, since it returns -1 (instead of 0) when
str == poll.

Regards,
Srivatsa S. Bhat

