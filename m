Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaE1Goh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:44:37 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56840 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaE1Gog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:44:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff tracers
Date: Wed, 28 May 2014 08:44:28 +0200
Message-ID: <5032273.VViPdgvF2W@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140527193050.4606a014@gandalf.local.home>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org> <53850FF3.8050107@codeaurora.org> <20140527193050.4606a014@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bgX/q4+8rbHOFzmZG9fGH0SOz4dI28fuUzEfqy7+6NJ
 VFa0UWMA5uyRjJSYR4pZrFQnDECLe/3G7Z50dwVhj4CBjgjiB7
 rw3AAt8TyVvnR2oYkIUE1PH5bH82Xt/Z47RyCaNr0/YSGM/nsb
 vh9IaR7ogntGhD8szyELlRThlBm1qsrrFEbAVY2E/Ipcg2sUuC
 b+bKdP3veOkYRfj+2n2n+9BnfQ0GYHUG/mXb0fY9eE5+Vv6ToK
 qUCowkXjuzLsu/bZHIfbSWwwKUIR24mDpSOS04gBZ6P5DG3zV3
 PEv4WijA5kAudPLDlO9WGu+3LA6rkaYsL5d9wqzHpBJV5Nm7cX
 gSQSjoc2+Bm+293KgLUk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 19:30:50 Steven Rostedt wrote:
> @@ -144,6 +138,12 @@ static int cpuidle_idle_call(void)
>                                 trace_cpu_idle_rcuidle(next_state, dev->cpu);
>  
>                                 /*
> +                                * During the idle period, stop measuring the
> +                                * disabled irqs critical sections latencies
> +                                */
> +                               stop_critical_timings();
> +
> +                               /*
>                                  * Enter the idle state previously
>                                  * returned by the governor
>                                  * decision. This function will block
> @@ -154,6 +154,8 @@ static int cpuidle_idle_call(void)
>                                 entered_state = cpuidle_enter(drv, dev,
>                                                               next_state);
>  
> +                               start_critical_timings();
> +
>                                 trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
>                                                        dev->cpu);
>  

cpuidle_enter() can have quite complex implementations in drivers/cpuidle/,
it's quite possible we have to push down the
stop_critical_timings/start_critical_timings further down here into
the individual drivers.

> @@ -175,8 +177,11 @@ static int cpuidle_idle_call(void)
>          * We can't use the cpuidle framework, let's use the default
>          * idle routine
>          */
> -       if (ret)
> +       if (ret) {
> +               stop_critical_timings();
>                 arch_cpu_idle();
> +               start_critical_timings();
> +       }
>  
>         __current_set_polling();
>  
> 

This one seems fine on all architectures I've looked at.

	Arnd
