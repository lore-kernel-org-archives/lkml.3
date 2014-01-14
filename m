Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaANVtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:49:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56157 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752135AbaANVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:49:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Date: Tue, 14 Jan 2014 23:03:27 +0100
Message-ID: <1742600.ID61iX8uKd@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <alpine.LRH.2.02.1401141629520.19206@file01.intranet.prod.int.rdu2.redhat.com>
References: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au> <20140114200547.GM7572@laptop.programming.kicks-ass.net> <alpine.LRH.2.02.1401141629520.19206@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 14, 2014 04:43:43 PM Mikulas Patocka wrote:
> 
> On Tue, 14 Jan 2014, Peter Zijlstra wrote:
> 
> > On Tue, Jan 14, 2014 at 02:06:57PM -0500, Mikulas Patocka wrote:
> > > On Tue, 14 Jan 2014, Peter Zijlstra wrote:
> > > > > Caused by commit 62b94a08da1b ("sched/preempt: Take away
> > > > > preempt_enable_no_resched() from modules")
> > 
> > Read these two lines, then note that:
> > 
> > > Try adding #include <linux/preempt.h> to speedstep-lib.c. Does it help?
> > 
> > this obviously will not work as preempt_check_resched() and
> > preempt_enable_no_resched() are no longer available to modules.
> 
> I see, you added commit 62b94a08da1bae9d187d49dfcd6665af393750f8 to 
> linux-next, that broke my patch.
> 
> > > > I think that pm commit is a very good example of why the sched/preempt
> > > > patch is a very good idea.
> > > > 
> > > > Also that Changelog fails to explain why enabling interrupts helps. What
> > > > interrupt is required for progress, and how does it make the progress
> > > > happen.
> > > 
> > > There is no explanation. It's hardware issue and I have no documentation 
> > > for the hardware.
> > 
> > Rafael works for Intel, he ought to be able to figure out wtf the
> > hardware does/needs.
> > 
> > > The general problem is that if there are bus-master transfers running (or 
> > > possibly for other hardware reasons), the CPU refuses to change frequency. 
> > > You can wait a little bit and retry and maybe you succeed changing the 
> > > frequency next time.
> > > 
> > > If you enable interrupts, wait, disable interrupts and retry, you may 
> > > succeed. If you keep interrupts disabled and retry, you never succeed, no 
> > > matter how long do you wait. I found it experimentally, I don't know 
> > > reason for that.
> > 
> > Sounds like magic goo..
> > 
> > In any case, try the below, it does the same but is far less horrid.
> > 
> > ---
> >  drivers/cpufreq/speedstep-smi.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
> > index 0f5326d6f79f..57d31538c248 100644
> > --- a/drivers/cpufreq/speedstep-smi.c
> > +++ b/drivers/cpufreq/speedstep-smi.c
> > @@ -188,6 +188,7 @@ static void speedstep_set_state(unsigned int state)
> >  		return;
> >  
> >  	/* Disable IRQs */
> > +	preempt_disable();
> >  	local_irq_save(flags);
> >  
> >  	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
> > @@ -200,7 +201,9 @@ static void speedstep_set_state(unsigned int state)
> >  		if (retry) {
> >  			pr_debug("retry %u, previous result %u, waiting...\n",
> >  					retry, result);
> > +			local_irq_restore(flags);
> 
> ^^^ this is wrong, because the function speedstep_set_state may already be 
> called with interrupts disabled from speedstep_get_freqs. So, you need to 
> enable interrupts unconditionally, even if they were disabled at the 
> beginning of the function speedstep_set_state.
> 
> I know it's dirty to enable interrupts in a function that was called with 
> disabled interrupts, but here it must be so (you could rewrite 
> speedstep_get_freqs to not disable interrupts if you want to avoid this 
> dirtiness).
> 
> >  			mdelay(retry * 50);
> > +			local_irq_save(flags);
> >  		}
> >  		retry++;
> >  		__asm__ __volatile__(
> > @@ -217,6 +220,7 @@ static void speedstep_set_state(unsigned int state)
> >  
> >  	/* enable IRQs */
> >  	local_irq_restore(flags);
> > +	preempt_enable();
> >  
> >  	if (new_state == state)
> >  		pr_debug("change to %u MHz succeeded after %u tries "
> 
> You need also preempt_disable/enable in speedstep_get_freqs.
> 
> 
> Here I'm resending the patch, to account for 
> 62b94a08da1bae9d187d49dfcd6665af393750f8.

Do I think correctly that this should work regardless of whether or not
62b94a08da1bae9d187d49dfcd6665af393750f8 is applied?

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> speedstep-smi: enable interrupts when waiting
> 
> On Dell Latitude C600 laptop with Pentium 3 850MHz processor, the
> speedstep-smi driver sometimes loads and sometimes doesn't load with
> "change to state X failed" message.
> 
> I found out that we need to enable interrupts while waiting. When we
> enable interrupts, the blockage that prevents frequency transition
> resolves and the transition is possible. With disabled interrupts, the
> blockage doesn't resolve (no matter how long do we wait).
> 
> This patch enables interrupts in the function speedstep_set_state that can
> be called with disabled interrupts. However, this function is called with
> disabled interrupts only from speedstep_get_freqs, so it shouldn't cause
> any problem.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/cpufreq/speedstep-lib.c |    3 +++
>  drivers/cpufreq/speedstep-smi.c |   12 ++++++++++++
>  2 files changed, 15 insertions(+)
> 
> Index: linux-next/drivers/cpufreq/speedstep-smi.c
> ===================================================================
> --- linux-next.orig/drivers/cpufreq/speedstep-smi.c	2014-01-14 22:26:59.000000000 +0100
> +++ linux-next/drivers/cpufreq/speedstep-smi.c	2014-01-14 22:35:11.000000000 +0100
> @@ -156,6 +156,7 @@ static void speedstep_set_state(unsigned
>  		return;
>  
>  	/* Disable IRQs */
> +	preempt_disable();
>  	local_irq_save(flags);
>  
>  	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
> @@ -166,9 +167,19 @@ static void speedstep_set_state(unsigned
>  
>  	do {
>  		if (retry) {
> +			/*
> +			 * We need to enable interrupts, otherwise the blockage
> +			 * won't resolve.
> +			 *
> +			 * We disable preemption so that other processes don't
> +			 * run. If other processes were running, they could
> +			 * submit more DMA requests, making the blockage worse.
> +			 */
>  			pr_debug("retry %u, previous result %u, waiting...\n",
>  					retry, result);
> +			local_irq_enable();
>  			mdelay(retry * 50);
> +			local_irq_disable();
>  		}
>  		retry++;
>  		__asm__ __volatile__(
> @@ -185,6 +196,7 @@ static void speedstep_set_state(unsigned
>  
>  	/* enable IRQs */
>  	local_irq_restore(flags);
> +	preempt_enable();
>  
>  	if (new_state == state)
>  		pr_debug("change to %u MHz succeeded after %u tries "
> Index: linux-next/drivers/cpufreq/speedstep-lib.c
> ===================================================================
> --- linux-next.orig/drivers/cpufreq/speedstep-lib.c	2014-01-14 22:29:07.000000000 +0100
> +++ linux-next/drivers/cpufreq/speedstep-lib.c	2014-01-14 22:31:04.000000000 +0100
> @@ -400,6 +400,7 @@ unsigned int speedstep_get_freqs(enum sp
>  
>  	pr_debug("previous speed is %u\n", prev_speed);
>  
> +	preempt_disable();
>  	local_irq_save(flags);
>  
>  	/* switch to low state */
> @@ -464,6 +465,8 @@ unsigned int speedstep_get_freqs(enum sp
>  
>  out:
>  	local_irq_restore(flags);
> +	preempt_enable();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(speedstep_get_freqs);
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
