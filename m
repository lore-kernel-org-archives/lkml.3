Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaFCL45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:56:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaFCLmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 093/138] ARM: perf: hook up perf_sample_event_took around pmu irq handling
Date: Tue,  3 Jun 2014 12:38:59 +0100
Message-Id: <1401795584-22664-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 5f5092e72cc25a6a5785308270e0085b2b2772cc upstream.

Since we indirect all of our PMU IRQ handling through a dispatcher, it's
trivial to hook up perf_sample_event_took to prevent applications such
as oprofile from generating interrupt storms due to an unrealisticly
low sample period.

Reported-by: Robert Richter <rric@kernel.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

