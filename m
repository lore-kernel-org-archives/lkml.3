Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3EHX5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:57:43 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58803 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755969Ab3EHX5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:57:42 -0400
Date: Wed, 8 May 2013 18:57:36 -0500
From: Robin Holt <holt@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Full dynticks needs evtdesc set before marking cpu online.
Message-ID: <20130508235736.GT3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

We are seeing failures booting medium sized machines which I think is
a change in expectations that dyntick put on x86's start_secondary.

During boot of cpus, we see an occassional panic in tick_do_broadcast at

195         if (!cpumask_empty(mask)) {
196                 /*
197                  * It might be necessary to actually check whether the devices
198                  * have different broadcast functions. For now, just use the
199                  * one of the first device. This works as long as we have this
200                  * misfeature only on x86 (lapic)
201                  */
202                 td = &per_cpu(tick_cpu_device, cpumask_first(mask));
203                 td->evtdev->broadcast(mask);
		        ^^^^^^
             NULL  --------+


This is called from:
211 static void tick_do_periodic_broadcast(void)
212 {
213         raw_spin_lock(&tick_broadcast_lock);
214 
215         cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
216         tick_do_broadcast(tmpmask);


Now the problem.  In start_secondary, we have:
 272         lock_vector_lock();
 273         set_cpu_online(smp_processor_id(), true);
 274         unlock_vector_lock();
 275         per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 276         x86_platform.nmi_init();
 277 
 278         /* enable local interrupts */
 279         local_irq_enable();
 280 
 281         /* to prevent fake stack check failure in clock setup */
 282         boot_init_stack_canary();
 283 
 284         x86_cpuinit.setup_percpu_clockev();

So we have the cpu marked online on line 273, but evtdesc is not set
until line 284.  This code has been in start_secondary for a considerable
period of time.  I think it is just being revealed now.

It does not show up with a normal config, but taking a 'make
x86_64_defconfig' kernel and changing CONFIG_MAXSMP seems to change boot
timing enouogh to make it reproducible on 4 socket and above machines.

The following makes it boot, but I am not sure if this is the right
thing to do.

$ git diff
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9c73b51..8456432 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -264,6 +264,8 @@ notrace static void __cpuinit start_secondary(void *unused)
         */
        check_tsc_sync_target();
 
+       x86_cpuinit.setup_percpu_clockev();
+
        /*
         * We need to hold vector_lock so there the set of online cpus
         * does not change while we are assigning vectors to cpus.  Holding
@@ -281,8 +283,6 @@ notrace static void __cpuinit start_secondary(void *unused)
        /* to prevent fake stack check failure in clock setup */
        boot_init_stack_canary();
 
-       x86_cpuinit.setup_percpu_clockev();
-
        wmb();
        cpu_startup_entry(CPUHP_ONLINE);
 }


Thanks,
Robin Holt
