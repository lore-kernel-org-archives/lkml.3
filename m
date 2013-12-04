Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3LDXYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:24:44 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64914 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3LDXYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:24:41 -0500
Date: Thu, 5 Dec 2013 01:24:37 +0200
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, jolsa@redhat.com, zheng.z.yan@intel.com
Subject: [PATCH v2] perf/x86: fix constraint table end marker issue
Message-ID: <20131204232437.GA10689@starlight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EVENT_CONSTRAINT_END macro defines the end marker as
a constraint with a weight of zero. This was all fine
until we blacklisted the corrupting memory events on
Intel IvyBridge. These events are blacklisted by using
a counter bitmask of zero. Thus, they also get a constraint
weight of zero.

The iteration macro: for_each_constraint tests the weight==0.
Therefore, it was stopping at the first blacklisted event, i.e.,
0xd0. The corrupting events were therefore considered as
unconstrained and were scheduled on any of the generic counters.

This patch fixes the end marker to have a weight of -1. With this,
the blacklisted events get an empty constraint and cannot be
scheduled which is what we want for now.

Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fd00bb2..53b0b71 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -262,11 +262,20 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
-#define EVENT_CONSTRAINT_END		\
-	EVENT_CONSTRAINT(0, 0, 0)
+/*
+ * we define the end marker as having a weight of -1
+ * to enable blacklisting of events using a counter bitmask
+ * of zero and thus a weight of zero.
+ * The end marker has a weight that cannot possibly be
+ * obtained from counting the bits in the bitmask.
+ */
+#define EVENT_CONSTRAINT_END { .weight = -1 }
 
+/*
+ * check for end marker with weight == -1
+ */
 #define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->weight; (e)++)
+	for ((e) = (c); (e)->weight != -1; (e)++)
 
 /*
  * Extra registers for specific events.
-- 
1.8.1.2

