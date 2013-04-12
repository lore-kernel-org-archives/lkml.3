Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3DLJb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:31:56 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52053 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753405Ab3DLJbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:31:53 -0400
Date: Fri, 12 Apr 2013 04:31:49 -0500
From: Robin Holt <holt@sgi.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
 to boot cpu.)
Message-ID: <20130412093149.GT3658@sgi.com>
References: <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130411053106.GA9042@drongo>
 <5166B05E.8010904@linux.vnet.ibm.com>
 <20130411134837.GE3672@sgi.com>
 <20130412053718.GC3887@gmail.com>
 <5167A52F.6020503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5167A52F.6020503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 11:39:51AM +0530, Srivatsa S. Bhat wrote:
> On 04/12/2013 11:07 AM, Ingo Molnar wrote:
> > 
> > * Robin Holt <holt@sgi.com> wrote:
> > 
> >> For the v3.9 release, can we consider my awful patch?
> > 
> > How about trying what I suggested, to make reboot affine to the boot CPU 
> > explicitly, not by shutting down all the other CPUs, but by set_cpus_allowed() or 
> > so?
> > 
> 
> I agree, that sounds like the right thing to do for 3.9. Of course, it would be
> nice if Shawn could verify that doing that doesn't break his platform due to
> some unknown corner case.
> 
> > That should solve the regression, without the ugly special-casing - while giving 
> > time to address the hot-unplug performance bottleneck.
> > 
> > Once that is done disable_nonboot_cpus() can be used again for reboot.
> > 
> > (But no strong feelings either way - both solutions are a workaround in a sense.)


>From 1767003c943325e52ac78cac6fdbaf2ab638888d Mon Sep 17 00:00:00 2001
From: Robin Holt <holt@sgi.com>
Date: Wed, 3 Apr 2013 13:52:00 -0500
Subject: [PATCH] Migrate shutdown/reboot to boot cpu.

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f.

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
boot cpu and then calling continuing with shutdown/reboot.

This also has the effect of not breaking x86's command line parameter for
specifying the reboot cpu.  Note, this code was shamelessly copied from
arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
command line parameter.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Shawn Guo <shawn.guo@linaro.org>
To: Ingo Molnar <mingo@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Holt <holt@sgi.com>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
---
 kernel/sys.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 0da73cf..4d1047d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -357,6 +357,19 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+void migrate_to_boot_cpu(void)
+{
+	/* The boot cpu is always logical cpu 0 */
+	int reboot_cpu_id = 0;
+
+	/* Make certain the cpu I'm about to reboot on is online */
+	if (!cpu_online(reboot_cpu_id))
+		reboot_cpu_id = smp_processor_id();
+
+	/* Make certain I only run on the appropriate processor */
+	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -368,7 +381,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_boot_cpu();
 	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
@@ -414,7 +427,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-	disable_nonboot_cpus();
+	migrate_to_boot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
-- 
1.8.1.2

