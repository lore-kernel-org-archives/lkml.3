Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899AbaGXJt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:49:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934856AbaGXJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 121/128] powerpc/perf: Never program book3s PMCs with values >= 0x80000000
Date: Thu, 24 Jul 2014 10:46:10 +0100
Message-Id: <1406195177-8656-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit f56029410a13cae3652d1f34788045c40a13ffc7 upstream.

We are seeing a lot of PMU warnings on POWER8:

    Can't find PMC that caused IRQ

Looking closer, the active PMC is 0 at this point and we took a PMU
exception on the transition from negative to 0. Some versions of POWER8
have an issue where they edge detect and not level detect PMC overflows.

A number of places program the PMC with (0x80000000 - period_left),
where period_left can be negative. We can either fix all of these or
just ensure that period_left is always >= 1.

This patch takes the second option.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/perf/core-book3s.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 8b9b9ac6005d..c05f10e95a9e 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -851,7 +851,22 @@ static void power_pmu_read(struct perf_event *event)
 	} while (local64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
 
 	local64_add(delta, &event->count);
-	local64_sub(delta, &event->hw.period_left);
+
+	/*
+	 * A number of places program the PMC with (0x80000000 - period_left).
+	 * We never want period_left to be less than 1 because we will program
+	 * the PMC with a value >= 0x800000000 and an edge detected PMC will
+	 * roll around to 0 before taking an exception. We have seen this
+	 * on POWER8.
+	 *
+	 * To fix this, clamp the minimum value of period_left to 1.
+	 */
+	do {
+		prev = local64_read(&event->hw.period_left);
+		val = prev - delta;
+		if (val < 1)
+			val = 1;
+	} while (local64_cmpxchg(&event->hw.period_left, prev, val) != prev);
 }
 
 /*
-- 
1.9.1

