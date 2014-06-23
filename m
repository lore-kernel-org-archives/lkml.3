Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaFWJEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:04:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55466 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/111] ARM: perf: hook up perf_sample_event_took around pmu irq handling
Date: Mon, 23 Jun 2014 10:30:48 +0200
Message-Id: <22259d1fa4111413d7969bae6ad425fbc7fcf3e1.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5f5092e72cc25a6a5785308270e0085b2b2772cc upstream.

Since we indirect all of our PMU IRQ handling through a dispatcher, it's
trivial to hook up perf_sample_event_took to prevent applications such
as oprofile from generating interrupt storms due to an unrealisticly
low sample period.

Reported-by: Robert Richter <rric@kernel.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/kernel/perf_event.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index e186ee1e63f6..de5cd767e4df 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -303,11 +303,18 @@ static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
 	struct arm_pmu *armpmu = (struct arm_pmu *) dev;
 	struct platform_device *plat_device = armpmu->plat_device;
 	struct arm_pmu_platdata *plat = dev_get_platdata(&plat_device->dev);
+	int ret;
+	u64 start_clock, finish_clock;
 
+	start_clock = sched_clock();
 	if (plat && plat->handle_irq)
-		return plat->handle_irq(irq, dev, armpmu->handle_irq);
+		ret = plat->handle_irq(irq, dev, armpmu->handle_irq);
 	else
-		return armpmu->handle_irq(irq, dev);
+		ret = armpmu->handle_irq(irq, dev);
+	finish_clock = sched_clock();
+
+	perf_sample_event_took(finish_clock - start_clock);
+	return ret;
 }
 
 static void
-- 
2.0.0

