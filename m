Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaCXMU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:20:28 -0400
Received: from hofr.at ([212.69.189.236]:59853 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbaCXMU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:20:26 -0400
Date: Mon, 24 Mar 2014 13:20:25 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RT] drop migrate_disabled section in _cpu_down
Message-ID: <20140324122025.GB18300@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI !


Minor cleanup: drop unnecessary migrate_disable in _cpu_down

in kernel/cpu.c:_cpu_down
    ...
    cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
    set_cpus_allowed_ptr(current, cpumask);
    ...
    migrate_disable();
    mycpu = smp_processor_id();
    if (mycpu == cpu) {
            printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
            migrate_enable();
            err = -EBUSY;
            goto restore_cpus;
    }
    migrate_enable();

If we got migrated off "cpu" then we can not get migrate
back as the cpus_allowed was updated. so if smp_processor_id(); returns
anything != cpu we are fine even if migrated off to a third cpu between
the mycpu = smp_processor_id() and the if (mycpu == cpu). No need for
migration protection here.

Further the migrate disable is effectively only needed for the condition
check in the if statement - so I think it could be replaced by:

    if (cpu==smp_processor_id()) {
            pr_err("Yuck! Still on unplug CPU\n!");
            err = -EBUSY;
            goto restore_cpus;
    }

even in the case that the cpus_allowed had not been updated.

Patch is against 3.12.13-rt21

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 kernel/cpu.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index ba7416b..fc5566a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -565,7 +565,7 @@ static int __ref take_cpu_down(void *_param)
 /* Requires cpu_add_remove_lock to be held */
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
-	int mycpu, err, nr_calls = 0;
+	int err, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
@@ -593,15 +593,11 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
 	set_cpus_allowed_ptr(current, cpumask);
 	free_cpumask_var(cpumask);
-	migrate_disable();
-	mycpu = smp_processor_id();
-	if (mycpu == cpu) {
+	if (cpu == smp_processor_id()) {
 		printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
-		migrate_enable();
 		err = -EBUSY;
 		goto restore_cpus;
 	}
-	migrate_enable();
 
 	cpu_hotplug_begin();
 	err = cpu_unplug_begin(cpu);
-- 
1.7.10.4

