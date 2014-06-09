Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461AbaFIWrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:47:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934332AbaFIWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Richter <rric@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.10 39/40] ARM: perf: hook up perf_sample_event_took around pmu irq handling
Date: Mon,  9 Jun 2014 15:49:10 -0700
Message-Id: <20140609224840.483198765@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -303,11 +303,18 @@ static irqreturn_t armpmu_dispatch_irq(i
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


