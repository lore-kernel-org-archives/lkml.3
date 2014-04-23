Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaDWHOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:14:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:53355 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbaDWHOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:14:44 -0400
Message-ID: <53576859.8060706@linutronix.de>
Date: Wed, 23 Apr 2014 09:14:33 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
References: <534C3606.7010206@meduna.org>	<534C731F.1050406@meduna.org>	<534DADF1.6060608@meduna.org>	<20140422115439.GA20669@linutronix.de>	<20140422094657.5b6ca1e2@gandalf.local.home>	<53569E05.8010600@linutronix.de>	<20140422134802.73fc1fa4@gandalf.local.home> <20140422141650.7f43d5ba@gandalf.local.home>
In-Reply-To: <20140422141650.7f43d5ba@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 08:16 PM, Steven Rostedt wrote:
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1447,6 +1447,12 @@ static void run_timer_softirq(struct softirq_action *h)
>  		__run_timers(base);
>  }
>  
> +#ifdef CONFIG_SMP
> +#define timer_should_raise_softirq(lock)	!spin_do_trylock(lock)
> +#else
> +#define timer_should_raise_softirq(lock)	1
> +#endif
> +

No. The lock may be taken but it also may be available no matter if UP
or not. With this patch applied the lockdep splat will go away but the
FULL_NO_HZ people will come back because the timer softirq is scheduled
even if no timer has expired.

Sebastian
