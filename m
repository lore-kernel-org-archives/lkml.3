Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbbA2Cs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:48:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759895AbbA2Cie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 092/139] powerpc: Secondary CPUs must set cpu_callin_map after setting active and online
Date: Wed, 28 Jan 2015 14:20:35 -0800
Message-Id: <1422483682-15393-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 7c5c92ed56d932b2c19c3f8aea86369509407d33 upstream.

I have a busy ppc64le KVM box where guests sometimes hit the infamous
"kernel BUG at kernel/smpboot.c:134!" issue during boot:

  BUG_ON(td->cpu != smp_processor_id());

Basically a per CPU hotplug thread scheduled on the wrong CPU. The oops
output confirms it:

  CPU: 0
  Comm: watchdog/130

The problem is that we aren't ensuring the CPU active and online bits are set
before allowing the master to continue on. The master unparks the secondary
CPUs kthreads and the scheduler looks for a CPU to run on. It calls
select_task_rq and realises the suggested CPU is not in the cpus_allowed
mask. It then ends up in select_fallback_rq, and since the active and
online bits aren't set we choose some other CPU to run on.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/smp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index c1cf4a1..a2802c1 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -712,7 +712,6 @@ void start_secondary(void *unused)
 	smp_store_cpu_info(cpu);
 	set_dec(tb_ticks_per_jiffy);
 	preempt_disable();
-	cpu_callin_map[cpu] = 1;
 
 	if (smp_ops->setup_cpu)
 		smp_ops->setup_cpu(cpu);
@@ -748,6 +747,14 @@ void start_secondary(void *unused)
 	notify_cpu_starting(cpu);
 	set_cpu_online(cpu, true);
 
+	/*
+	 * CPU must be marked active and online before we signal back to the
+	 * master, because the scheduler needs to see the cpu_online and
+	 * cpu_active bits set.
+	 */
+	smp_wmb();
+	cpu_callin_map[cpu] = 1;
+
 	local_irq_enable();
 
 	cpu_startup_entry(CPUHP_ONLINE);
-- 
1.9.1

