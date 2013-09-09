Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3IINel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:34:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12599 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3IIN0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:48 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=7c2KRQoVX2MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=SUI-plciMJgA:10 a=VwQbUJbxAAAA:8 a=JMmVheP2ipgur9K0H9QA:9 a=Zh68SRI7RUMA:10 a=IZwFEM60SIV5pQIB:21 a=AiCmVL-B0SwChzcK:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909124800.162897167@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 08:47:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 08/16] kernel/hotplug: restore original cpu mask oncpu/down
References: <20130909124745.590777496@goodmis.org>
Content-Disposition: inline; filename=0008-kernel-hotplug-restore-original-cpu-mask-oncpu-down.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

If a task which is allowed to run only on CPU X puts CPU Y down then it
will be allowed on all CPUs but the on CPU Y after it comes back from
kernel. This patch ensures that we don't lose the initial setting unless
the CPU the task is running is going down.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/cpu.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index f56a8ec..063c2bb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -518,6 +518,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		.hcpu = hcpu,
 	};
 	cpumask_var_t cpumask;
+	cpumask_var_t cpumask_org;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -528,6 +529,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	/* Move the downtaker off the unplug cpu */
 	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
 		return -ENOMEM;
+	if (!alloc_cpumask_var(&cpumask_org, GFP_KERNEL))  {
+		free_cpumask_var(cpumask);
+		return -ENOMEM;
+	}
+
+	cpumask_copy(cpumask_org, tsk_cpus_allowed(current));
 	cpumask_andnot(cpumask, cpu_online_mask, cpumask_of(cpu));
 	set_cpus_allowed_ptr(current, cpumask);
 	free_cpumask_var(cpumask);
@@ -536,7 +543,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (mycpu == cpu) {
 		printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
 		migrate_enable();
-		return -EBUSY;
+		err = -EBUSY;
+		goto restore_cpus;
 	}
 
 	cpu_hotplug_begin();
@@ -594,6 +602,9 @@ out_cancel:
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+restore_cpus:
+	set_cpus_allowed_ptr(current, cpumask_org);
+	free_cpumask_var(cpumask_org);
 	return err;
 }
 
-- 
1.7.10.4


