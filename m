Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaHHU43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:56:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229AbaHHUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 099/259] powerpc/perf: Never program book3s PMCs with values >= 0x80000000
Date: Fri,  8 Aug 2014 13:38:42 -0700
Message-Id: <1407530482-4483-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/perf/core-book3s.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index d23b01c..57a8ff9 100644
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

