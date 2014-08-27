Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaH0Ja1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:30:27 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34466 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302AbaH0JaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:30:25 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: will.deacon@arm.com
Cc: sudeep.holla@arm.com, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH 1/2] Revert "arm64: use cpu_online_mask when using forced irq_set_affinity"
Date: Wed, 27 Aug 2014 18:30:06 +0900
Message-Id: <1409131806-11276-1-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

This reverts commit 601c942176d8ad8334118bddb747e3720bed24f8.

This patch is designed to ensure that the cpu being offlined is not
present in the affinity mask. But it is a bad idea to overwrite the
affinity variable with cpu_online_mask, even in case that the current
affinity already includes onlined cpus.

So revert this patch to replace it with another one doing exactly
what it intends.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 arch/arm64/kernel/irq.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 0f08dfd..473e5db 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -97,15 +97,11 @@ static bool migrate_one_irq(struct irq_desc *desc)
 	if (irqd_is_per_cpu(d) || !cpumask_test_cpu(smp_processor_id(), affinity))
 		return false;
 
-	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids)
+	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
+		affinity = cpu_online_mask;
 		ret = true;
+	}
 
-	/*
-	 * when using forced irq_set_affinity we must ensure that the cpu
-	 * being offlined is not present in the affinity mask, it may be
-	 * selected as the target CPU otherwise
-	 */
-	affinity = cpu_online_mask;
 	c = irq_data_get_irq_chip(d);
 	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
-- 
1.7.9.5

