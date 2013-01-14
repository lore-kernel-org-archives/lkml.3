Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3ANRZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:25:04 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37793 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab3ANRZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:25:03 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] arm: kernel/perf_event_cpu.c: fix error null pointer dereference check
Date: Mon, 14 Jan 2013 17:18:53 +0000
Message-Id: <1358183933-29160-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the pointer cpu_pmu is used without null pointer dereference check, and is
checked after the using of it, so we move the null pointer check to before the
first use.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/arm/kernel/perf_event_cpu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index efa5295..16aa979 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -142,13 +142,15 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
 		raw_spin_lock_init(&events->pmu_lock);
 	}
 
-	cpu_pmu->get_hw_events	= cpu_pmu_get_cpu_events;
-	cpu_pmu->request_irq	= cpu_pmu_request_irq;
-	cpu_pmu->free_irq	= cpu_pmu_free_irq;
+	if (cpu_pmu) {
+		cpu_pmu->get_hw_events	= cpu_pmu_get_cpu_events;
+		cpu_pmu->request_irq	= cpu_pmu_request_irq;
+		cpu_pmu->free_irq	= cpu_pmu_free_irq;
 
-	/* Ensure the PMU has sane values out of reset. */
-	if (cpu_pmu && cpu_pmu->reset)
-		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
+		/* Ensure the PMU has sane values out of reset. */
+		if (cpu_pmu->reset)
+			on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
+	}
 }
 
 /*
-- 
1.7.9.5

