Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3LJJW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:22:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3LJJWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:22:21 -0500
Date: Tue, 10 Dec 2013 01:22:06 -0800
From: tip-bot for Maria Dimakopoulou <tipbot@zytor.com>
Message-ID: <tip-cf30d52e2d11523c42048ab89ed4215b5021526a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, maria.n.dimakopoulou@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        maria.n.dimakopoulou@gmail.com
In-Reply-To: <20131204232437.GA10689@starlight>
References: <20131204232437.GA10689@starlight>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix constraint table end marker bug
Git-Commit-ID: cf30d52e2d11523c42048ab89ed4215b5021526a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:22:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf30d52e2d11523c42048ab89ed4215b5021526a
Gitweb:     http://git.kernel.org/tip/cf30d52e2d11523c42048ab89ed4215b5021526a
Author:     Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
AuthorDate: Thu, 5 Dec 2013 01:24:37 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Dec 2013 10:02:30 +0100

perf/x86: Fix constraint table end marker bug

The EVENT_CONSTRAINT_END() macro defines the end marker as
a constraint with a weight of zero. This was all fine
until we blacklisted the corrupting memory events on
Intel IvyBridge. These events are blacklisted by using
a counter bitmask of zero. Thus, they also get a constraint
weight of zero.

The iteration macro: for_each_constraint tests the weight==0.
Therefore, it was stopping at the first blacklisted event, i.e.,
0xd0. The corrupting events were therefore considered as
unconstrained and were scheduled on any of the generic counters.

This patch fixes the end marker to have a weight of -1. With
this, the blacklisted events get an empty constraint and cannot
be scheduled which is what we want for now.

Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: jolsa@redhat.com
Cc: zheng.z.yan@intel.com
Link: http://lkml.kernel.org/r/20131204232437.GA10689@starlight
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fd00bb2..c1a8618 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -262,11 +262,20 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
-#define EVENT_CONSTRAINT_END		\
-	EVENT_CONSTRAINT(0, 0, 0)
+/*
+ * We define the end marker as having a weight of -1
+ * to enable blacklisting of events using a counter bitmask
+ * of zero and thus a weight of zero.
+ * The end marker has a weight that cannot possibly be
+ * obtained from counting the bits in the bitmask.
+ */
+#define EVENT_CONSTRAINT_END { .weight = -1 }
 
+/*
+ * Check for end marker with weight == -1
+ */
 #define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->weight; (e)++)
+	for ((e) = (c); (e)->weight != -1; (e)++)
 
 /*
  * Extra registers for specific events.
