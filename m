Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbaCDIXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:23:38 -0500
Received: from asav21.altibox.net ([109.247.116.8]:39764 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaCDIXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:23:37 -0500
From: Henrik Austad <henrik@austad.us>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <henrik@austad.us>,
        John Stultz <johnstul@us.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Salman Qazi <sqazi@google.com>
Subject: [PATCH] tile: avoid overflow in ns2cycles
Date: Tue,  4 Mar 2014 09:20:53 +0100
Message-Id: <1393921253-23396-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 4cecf6d401a ("sched, x86: Avoid unnecessary overflow in
sched_clock") and in recent patch "clocksource: avoid unnecessary
overflow in cyclecounter_cyc2ns()" https://lkml.org/lkml/2014/3/4/17,
the mult-shift approach is replaced by 2 steps to avoid storing a large,
intermediate value that could overflow.

arch/tile/kernel/time.c has a similar pattern in cycles2ns, and this
copies the same pattern in this function

CC: John Stultz <johnstul@us.ibm.com>
CC: Mike Galbraith <bitbucket@online.de>
CC: Salman Qazi <sqazi@google.com>
Signed-off-by: Henrik Austad <henrik@austad.us>
---
 arch/tile/kernel/time.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 5d10642..9e74733 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -236,7 +236,15 @@ cycles_t ns2cycles(unsigned long nsecs)
 	 * clock frequency.
 	 */
 	struct clock_event_device *dev = &__raw_get_cpu_var(tile_timer);
-	return ((u64)nsecs * dev->mult) >> dev->shift;
+
+	/*
+	 * as in clocksource.h and x86's timer.h, we split the calculation into  2
+	 * parts to avoid unecessary overflow of the intermediate value. This will
+	 * not lead to any loss of precision.
+	 */
+	u64 quot = (u64)nsecs >> dev->shift;
+	u64 rem  = (u64)nsecs & ((1ULL << dev->shift)-1);
+	return quot * dev->mult + ((rem * dev->mult) >> dev->shift);
 }
 
 void update_vsyscall_tz(void)
-- 
1.7.10.4

