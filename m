Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3CGCtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:49:15 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49716 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3CGCtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:49:14 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [RFC PATCH] ARM: keep __my_cpu_offset consistent with generic one
Date: Thu,  7 Mar 2013 10:47:48 +0800
Message-Id: <1362624468-5451-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 14318efb(ARM: 7587/1: implement optimized percpu variable access)
introduces arm's __my_cpu_offset to optimize percpu vaiable access,
which really works well on hackbench test, but may cause __my_cpu_offset
to return garbage value before it is initialized in cpu_init() called
by setup_arch, so accessing a percpu variable before setup_arch may cause
kernel hang. But the generic__my_cpu_offset always returns zero before
percpu area is brought up.

So the patch tries to clear __my_cpu_offset on boot CPU early
to avoid boot hang.

At least now percpu variable is accessed by lockdep before
setup_arch(), and enabling CONFIG_LOCK_STAT or CONFIG_DEBUG_LOCKDEP
can trigger kernel hang.

Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/kernel/setup.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..bc7ee4b 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -439,6 +439,13 @@ void __init smp_setup_processor_id(void)
 	for (i = 1; i < nr_cpu_ids; ++i)
 		cpu_logical_map(i) = i == cpu ? 0 : i;
 
+	/*
+	 * clear __my_cpu_offset on boot CPU early to avoid hang
+	 * caused by accessing percpu variable before percpu area is
+	 * brought up
+	 */
+	set_my_cpu_offset(0);
+
 	printk(KERN_INFO "Booting Linux on physical CPU 0x%x\n", mpidr);
 }
 
-- 
1.7.9.5

