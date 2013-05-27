Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3E0Ni2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:38:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:47407 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3E0Ni0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:38:26 -0400
Date: Mon, 27 May 2013 15:38:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.10-rc3: WARNING: at kernel/time/tick-broadcast.c:578
In-Reply-To: <20130527123520.GA4806@pd.tnic>
Message-ID: <alpine.LFD.2.02.1305271456280.4220@ionos>
References: <alpine.SOC.1.00.1305271406050.2372@math.ut.ee> <20130527123520.GA4806@pd.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Borislav Petkov wrote:

> On Mon, May 27, 2013 at 02:09:33PM +0300, Meelis Roos wrote:
> > I enabled the new full dynctick on one of my test PCs - Intel 815 
> 
> Do you mean CONFIG_NO_HZ_FULL? If so, it is not enabled in the .config
> below.
> 
> > chipset single-CPU P3 1 GHz. Got a warning from tick-broadcast.c:578 but 
> > othwerise it seems to work so far. Full dmesg and config are below.
> 
> Also, there are a bunch of timers fixes from Thomas in tip - you could
> try to merge tip/master ontop of -rc3 and retest.

All related fixes are already in Linus tree.
 
> > [    3.872061] ------------[ cut here ]------------
> > [    3.872161] WARNING: at kernel/time/tick-broadcast.c:578 tick_broadcast_oneshot_control+0x181/0x190()
> > [    3.872258] Modules linked in: ac97_bus snd_pcm snd_page_alloc sg snd_seq uhci_hcd ehci_hcd usbcore microcode snd_seq_device sr_mod snd_timer parport_pc ns558 cdrom snd parport usb_common evdev i2c_i801 gameport pcspkr soundcore rng_core processor button
> > [    3.872726] CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0-rc3 #2
> > [    3.872785] Hardware name: Packard Bell NEC 00000000000000000000000/i815                            , BIOS 2.0Q                             09/27/2001
> > [    3.872892]  00000000 00000000 c1447e74 c134c98c c1447e9c c102877f c13e47ea c13e58c8
> > [    3.873063]  00000242 c1059aa1 c1059aa1 00200002 c14716a0 c145ce00 c1447eac c10287bb
> > [    3.873234]  00000009 00000000 c1447ecc c1059aa1 00000001 00200046 c14524c0 00000004
> > [    3.873405] Call Trace:
> > [    3.873467]  [<c134c98c>] dump_stack+0x16/0x18
> > [    3.873527]  [<c102877f>] warn_slowpath_common+0x5f/0x80
> > [    3.873588]  [<c1059aa1>] ? tick_broadcast_oneshot_control+0x181/0x190
> > [    3.873650]  [<c1059aa1>] ? tick_broadcast_oneshot_control+0x181/0x190
> > [    3.873713]  [<c10287bb>] warn_slowpath_null+0x1b/0x20
> > [    3.873772]  [<c1059aa1>] tick_broadcast_oneshot_control+0x181/0x190
> > [    3.873835]  [<c1059167>] tick_notify+0x287/0x3b0
> > [    3.873903]  [<c10499d0>] notifier_call_chain+0x40/0x60
> > [    3.873965]  [<c1049a89>] __raw_notifier_call_chain+0x19/0x20
> > [    3.874027]  [<c1049aaa>] raw_notifier_call_chain+0x1a/0x20
> > [    3.874089]  [<c105852a>] clockevents_notify+0x2a/0x120
> > [    3.874158]  [<c1270414>] ? menu_select+0x274/0x5d0
> > [    3.874227]  [<e0807523>] lapic_timer_state_broadcast+0x2e/0x31 [processor]
> > [    3.874293]  [<e08075d6>] acpi_idle_enter_simple+0x4a/0xb0 [processor]
> > [    3.874357]  [<c126ed85>] cpuidle_enter_state+0x35/0xc0
> > [    3.874420]  [<c126ee8c>] cpuidle_idle_call+0x7c/0x130

That brilliant cpuidle stuff calls
clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER) twice. So what happens is:

CPU0			CPU1
			cpuidle_idle_call()
			  clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER)
			    set cpu in tick_broadcast_oneshot_mask
 broadcast interrupt
  event expired for cpu1
  set pending bit
			  acpi_idle_enter_simple()
			   clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER)
			   WARN_ON(pending bit)

So we need to move the WARN_ON into the section where we actually set
the broadcast stuff up.

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 24938d5..ec21dc0 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -575,8 +575,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
+			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			/*
 			 * We only reprogram the broadcast timer if we
