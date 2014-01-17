Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaAQBHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:07:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55543 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751609AbaAQBHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:07:16 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] speedstep: clean up interrupt disabling (was: linux-next: build failure after merge of the tip tree)
Date: Fri, 17 Jan 2014 02:21:18 +0100
Message-ID: <5695714.71aNYAnsh1@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <alpine.LRH.2.02.1401161238270.16143@file01.intranet.prod.int.rdu2.redhat.com>
References: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au> <20140116121415.GP31570@twins.programming.kicks-ass.net> <alpine.LRH.2.02.1401161238270.16143@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 16, 2014 02:33:02 PM Mikulas Patocka wrote:
> 
> On Thu, 16 Jan 2014, Peter Zijlstra wrote:
> 
> > > >  		retry++;
> > > >  		__asm__ __volatile__(
> > > > @@ -217,6 +220,7 @@ static void speedstep_set_state(unsigned int state)
> > > >  
> > > >  	/* enable IRQs */
> > > >  	local_irq_restore(flags);
> > > > +	preempt_enable();
> > > >  
> > > >  	if (new_state == state)
> > > >  		pr_debug("change to %u MHz succeeded after %u tries "
> > > 
> > > You need also preempt_disable/enable in speedstep_get_freqs.
> > 
> > Argh I see, this is really horrid.
> > 
> > 
> > Anyway, its Rafael's call, its his subsystem he gets to fix it when it
> > explodes.
> > 
> > /me shudders
> 
> speedstep_get_freqs disables the interrupts to measure the transition 
> latency. It is called from speedstep-ich.c (that requires the latency) and 
> from speedstep-smi.c (that passes NULL as a pointer to latency, because it 
> doesn't need it).
> 
> So, you could disable interrupts in speedstep_get_freqs only when the 
> transition_latency pointer is non-NULL.
> 
> I think speedstep_set_state doesn't need to disable interrupts at all - 
> all that it does is one "out" instruction, you don't need to synchronize 
> that "out" instruction with anything, so there is no need to disable 
> interrupts. Or - does some specification say that interrupts must be 
> disabled there?
> 
> I am sending this patch to clean up the mess to be applied on the top of 
> my previous patch.

Well, I really don't appreciate sending me stuff like this two days before a
merge window.  So I've dropped the speedstep_smi patch and please send me
something I can queue up for 3.15 without making Peter shudder.

Thanks!


> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: speedstep: clean up interrupt disabling
> 
> This patch cleans up interrupt disabling in speedstep-smi and
> speedstep-lib.
> 
> speedstep_get_freqs in speedstep-lib may be called from speedstep-smi or
> speedstep-ich. When it is called from speedstep-ich, it needs to calculate
> transition latency. When it is called from speedstep-smi, transition
> latency doesn't have to be calculated.
> 
> The function speedstep_set_state in speedstep-smi needs to enable
> interrupts. Previously it enabled interrupts even if it was called with
> disabled interrupts, but it is dirty.
> 
> This patch changes speedstep_get_freqs so that it disables interrupts only
> when it is called from speedstep-ich and when it is measuring the
> transition latency. This avoids much of the code dirtiness.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/cpufreq/speedstep-lib.c |   13 ++++++-------
>  drivers/cpufreq/speedstep-smi.c |   11 ++++-------
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> Index: linux-3.4.75/drivers/cpufreq/speedstep-lib.c
> ===================================================================
> --- linux-3.4.75.orig/drivers/cpufreq/speedstep-lib.c	2014-01-16 18:51:16.000000000 +0100
> +++ linux-3.4.75/drivers/cpufreq/speedstep-lib.c	2014-01-16 18:51:22.000000000 +0100
> @@ -400,9 +400,6 @@ unsigned int speedstep_get_freqs(enum sp
>  
>  	pr_debug("previous speed is %u\n", prev_speed);
>  
> -	preempt_disable();
> -	local_irq_save(flags);
> -
>  	/* switch to low state */
>  	set_state(SPEEDSTEP_LOW);
>  	*low_speed = speedstep_get_frequency(processor);
> @@ -414,15 +411,19 @@ unsigned int speedstep_get_freqs(enum sp
>  	pr_debug("low speed is %u\n", *low_speed);
>  
>  	/* start latency measurement */
> -	if (transition_latency)
> +	if (transition_latency) {
> +		local_irq_save(flags);
>  		do_gettimeofday(&tv1);
> +	}
>  
>  	/* switch to high state */
>  	set_state(SPEEDSTEP_HIGH);
>  
>  	/* end latency measurement */
> -	if (transition_latency)
> +	if (transition_latency) {
>  		do_gettimeofday(&tv2);
> +		local_irq_restore(flags);
> +	}
>  
>  	*high_speed = speedstep_get_frequency(processor);
>  	if (!*high_speed) {
> @@ -464,8 +465,6 @@ unsigned int speedstep_get_freqs(enum sp
>  	}
>  
>  out:
> -	local_irq_restore(flags);
> -	preempt_enable();
>  
>  	return ret;
>  }
> Index: linux-3.4.75/drivers/cpufreq/speedstep-smi.c
> ===================================================================
> --- linux-3.4.75.orig/drivers/cpufreq/speedstep-smi.c	2014-01-16 18:51:16.000000000 +0100
> +++ linux-3.4.75/drivers/cpufreq/speedstep-smi.c	2014-01-16 18:51:22.000000000 +0100
> @@ -180,16 +180,16 @@ static int speedstep_get_state(void)
>  static void speedstep_set_state(unsigned int state)
>  {
>  	unsigned int result = 0, command, new_state, dummy;
> -	unsigned long flags;
>  	unsigned int function = SET_SPEEDSTEP_STATE;
>  	unsigned int retry = 0;
>  
>  	if (state > 0x1)
>  		return;
>  
> -	/* Disable IRQs */
> +	WARN_ON_ONCE(irqs_disabled());
> +
> +	/* Disable preemption so that other processes don't run */
>  	preempt_disable();
> -	local_irq_save(flags);
>  
>  	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
>  
> @@ -209,9 +209,7 @@ static void speedstep_set_state(unsigned
>  			 */
>  			pr_debug("retry %u, previous result %u, waiting...\n",
>  					retry, result);
> -			local_irq_enable();
>  			mdelay(retry * 50);
> -			local_irq_disable();
>  		}
>  		retry++;
>  		__asm__ __volatile__(
> @@ -226,8 +224,7 @@ static void speedstep_set_state(unsigned
>  			);
>  	} while ((new_state != state) && (retry <= SMI_TRIES));
>  
> -	/* enable IRQs */
> -	local_irq_restore(flags);
> +	/* enable preemption */
>  	preempt_enable();
>  
>  	if (new_state == state)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
