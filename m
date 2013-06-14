Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3FNP3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:29:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:54992 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3FNP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:29:18 -0400
Date: Fri, 14 Jun 2013 17:29:17 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, leoli@freescale.com, scottwood@freescale.com,
        Priyanka.Jain@freescale.com
Subject: Re: [PATCH][RFC] kernel/cpu: do not change the cpus_allowed of the
 current task when unplugging cpus
Message-ID: <20130614152917.GA8597@linutronix.de>
References: <1368699439-13034-1-git-send-email-chenhui.zhao@freescale.com>
 <20130607090543.GD10280@linutronix.de>
 <20130609095942.GA8548@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130609095942.GA8548@localhost.localdomain>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao Chenhui | 2013-06-09 17:59:42 [+0800]:

>No. _cpu_down() on mainline do not change the cpus_allowed.
My bad.

>The problem is that the task which turned off cpu2 (for instance)
>can not run on cpu2 again after cpu2 is turned on, because cpu2 has been
>removed from the cpus_allowed of the task.
>
>The task can put himself back on cpu2 throuhg the system call,
>but I think applications should not do this work and do not care which cpu
>it is running on in most time.

The mask needs to be changed because you may not be on the CPU while it
is going down. What do you think about:

Subject: [PATCH] kernel/hotplug: restore original cpu mask oncpu/down

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
index 3acf17d..f5ad8e1 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -545,6 +545,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		.hcpu = hcpu,
 	};
 	cpumask_var_t cpumask;
+	cpumask_var_t cpumask_org;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -555,6 +556,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
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
@@ -563,7 +570,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (mycpu == cpu) {
 		printk(KERN_ERR "Yuck! Still on unplug CPU\n!");
 		migrate_enable();
-		return -EBUSY;
+		err = -EBUSY;
+		goto restore_cpus;
 	}
 
 	cpu_hotplug_begin();
@@ -622,6 +630,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
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


>
>-Chenhui

Sebastian
