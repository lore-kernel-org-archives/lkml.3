Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbaAaRLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:11:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:35957 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932492AbaAaRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:11:06 -0500
Date: Fri, 31 Jan 2014 12:11:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work to
 do
Message-ID: <20140131121104.382942cc@gandalf.local.home>
In-Reply-To: <20140131120757.594e24d6@gandalf.local.home>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
	<1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
	<20140131120757.594e24d6@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 12:07:57 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 106968f..426d114 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1461,18 +1461,20 @@ void run_local_timers(void)
>  	 * the timer softirq.
>  	 */
>  #ifdef CONFIG_PREEMPT_RT_FULL
> +	/* On RT, irq work runs from softirq */
> +	if (irq_work_needs_cpu()) {
> +		raise_softirq(TIMER_SOFTIRQ);
> +		return;
> +	}
> +
>  	if (!spin_do_trylock(&base->lock)) {
>  		raise_softirq(TIMER_SOFTIRQ);
>  		return;
>  	}
>  #endif

Note, I debated about doing:

	if (irq_work_needs_cpu() ||
	    !spin_do_trylock(&base->lock)) {
		raise_softirq(TIMER_SOFTIRQ);
		return;
	}

instead, which is pretty much the same code. But I find it rather ugly,
and does not read as well. I haven't looked at the disassembly, but I
would hope that gcc would make my original version have the same result
as this one.

-- Steve
