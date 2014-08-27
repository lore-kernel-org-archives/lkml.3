Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaH0Jah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:30:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52581 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaH0Jaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:30:35 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: will.deacon@arm.com
Cc: sudeep.holla@arm.com, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH 2/2] arm64: take onlined cpus into account when setting irq affinity in migrate_one_irq
Date: Wed, 27 Aug 2014 18:30:32 +0900
Message-Id: <1409131832-11317-1-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

This patch ensures that the cpu being offlined is not present in the affinity mask.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 arch/arm64/kernel/irq.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 473e5db..0c7b79e 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -87,6 +87,7 @@ static bool migrate_one_irq(struct irq_desc *desc)
 {
 	struct irq_data *d = irq_desc_get_irq_data(desc);
 	const struct cpumask *affinity = d->affinity;
+	struct cpumask tmp_affinity;
 	struct irq_chip *c;
 	bool ret = false;
 
@@ -100,6 +101,14 @@ static bool migrate_one_irq(struct irq_desc *desc)
 	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 		affinity = cpu_online_mask;
 		ret = true;
+	} else {
+		/*
+		 * when using forced irq_set_affinity we must ensure that the cpu
+		 * being offlined is not present in the affinity mask, it may be
+		 * selected as the target CPU otherwise
+		 */
+		cpumask_and(&tmp_affinity, affinity, cpu_online_mask);
+		affinity = &tmp_affinity;
 	}
 
 	c = irq_data_get_irq_chip(d);
-- 
1.7.9.5

