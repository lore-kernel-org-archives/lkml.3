Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634AbaGRNNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:13:12 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17685 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761933AbaGRNNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:13:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 145/170] powerpc/perf: Never program book3s PMCs with values >= 0x80000000
Date: Fri, 18 Jul 2014 14:12:30 +0200
Message-Id: <c3bb7d6362eb5e8d295791ed6899f92099380a9a.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/perf/core-book3s.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 29b89e863d7c..023f5adf27b8 100644
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
2.0.0

