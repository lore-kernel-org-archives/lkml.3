Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3E0PxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:53:14 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:55151 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab3E0PxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:53:13 -0400
Date: Mon, 27 May 2013 18:53:08 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.10-rc3: WARNING: at kernel/time/tick-broadcast.c:578
In-Reply-To: <alpine.LFD.2.02.1305271456280.4220@ionos>
Message-ID: <alpine.SOC.1.00.1305271849130.2372@math.ut.ee>
References: <alpine.SOC.1.00.1305271406050.2372@math.ut.ee> <20130527123520.GA4806@pd.tnic> <alpine.LFD.2.02.1305271456280.4220@ionos>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Mon, May 27, 2013 at 02:09:33PM +0300, Meelis Roos wrote:
> > > I enabled the new full dynctick on one of my test PCs - Intel 815 
> > 
> > Do you mean CONFIG_NO_HZ_FULL? If so, it is not enabled in the .config
> > below.

Yes. I meant that - but obviously I did not enable it on this machine. I 
enabled it on every machine wehere this was offered for me by make 
oldconfig.

> > Also, there are a bunch of timers fixes from Thomas in tip - you could
> > try to merge tip/master ontop of -rc3 and retest.
> 
> All related fixes are already in Linus tree.

OK, will not check tip/master.

> That brilliant cpuidle stuff calls
> clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER) twice. So what happens is:
> 
> CPU0			CPU1
> 			cpuidle_idle_call()
> 			  clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER)
> 			    set cpu in tick_broadcast_oneshot_mask
>  broadcast interrupt
>   event expired for cpu1
>   set pending bit
> 			  acpi_idle_enter_simple()
> 			   clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER)
> 			   WARN_ON(pending bit)
> 
> So we need to move the WARN_ON into the section where we actually set
> the broadcast stuff up.

Are you sure? This is a UP machine.

Tested the patch - no effect, warning is still there :(

> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 24938d5..ec21dc0 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -575,8 +575,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>  
>  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>  	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
> -		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
>  		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
> +			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
>  			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
>  			/*
>  			 * We only reprogram the broadcast timer if we
> 

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
