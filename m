Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936765Ab3DJOBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:01:45 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38816 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab3DJOBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:01:42 -0400
Date: Wed, 10 Apr 2013 09:01:39 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130410140138.GC3672@sgi.com>
References: <20130403193743.GB29151@sgi.com>
 <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410111620.GB29752@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 01:16:20PM +0200, Ingo Molnar wrote:
> 
> * Robin Holt <holt@sgi.com> wrote:
> 
> > On Mon, Apr 08, 2013 at 09:11:06AM -0700, H. Peter Anvin wrote:
> > > On 04/08/2013 08:57 AM, Ingo Molnar wrote:
> > > > 
> > > > I think the original commit:
> > > > 
> > > >   f96972f2dc63 kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
> > > > 
> > > > actually regressed your 1024 CPU systems, and should possibly be reverted or fixed 
> > > > in some other fashion - such as by migrating to the primary CPU (on architectures 
> > > > that require that), instead of hotplug offlining every secondary CPU on every 
> > > > architecture!
> > > > 
> > > > Alternatively, disable_nonboot_cpus() could perhaps be improved to down CPUs in 
> > > > parallel: issue the CPU-down requests to every CPU, then wait for them to complete 
> > > > - instead of the loop over every CPU?
> > > > 
> > > > This would be the conceptual counter part to parallel boot up of CPUs - something 
> > > > SGI might be interested in as well?
> > > > 
> > > 
> > > Migrating to the boot processor and then calling stop_machine() to
> > > defang any other processors should be sufficient, no?
> > > 
> > > I don't know if there is any reason to deschedule all tasks?
> > 
> > My reading of the original commit indicated that some architecture's
> > firmware needs the boot cpu to be the one initiating reboot.
> > 
> > If that is correct, then I can not see why a stop_machine() implementation
> > will not work.
> > 
> > Since this is in generic kernel code, how can I proceed?
> 
> I think rebooting on the same CPU where we booted up is something worth having in 
> general, as a firmware robustness feature. (assuming the CPU in question is still 
> online)
> 
> We have similar constraints in the suspend code for example - some x86 firmware 
> breaks if suspend related ACPI calls are not done on the boot CPU ...
> 
> So how about restoring the old "just reboot, don't shut down the others" behavior, 
> extended with a "reboot on the CPU that booted up" reboot affinity logic?

Just want to be sure I am going the write direction, but in the shutdown and
reboot case, you would support something like:

diff --git a/kernel/sys.c b/kernel/sys.c
index 39c9c4a..35845c5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -358,6 +358,18 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+void migrate_to_boot_cpu(void)
+{
+	cpumask_t *shutdown_cpu_mask;
+
+	shutdown_cpu_mask = kzalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (shutdown_cpu_mask) {
+		cpumask_set_cpu(0, shutdown_cpu_mask);
+		cpumask_and(shutdown_cpu_mask, shutdown_cpu_mask, cpu_online_mask);
+		set_cpus_allowed_ptr(current, shutdown_cpu_mask);
+	}
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -369,7 +381,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_boot_cpu();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
@@ -413,7 +425,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-	disable_nonboot_cpus();
+	migrate_to_boot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);

