Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3LDJAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:00:33 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62821 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3LDJA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:00:28 -0500
Date: Wed, 4 Dec 2013 10:00:28 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: [PATCH] perf/x86: fix bug in event constraint end marker macro
Message-ID: <20131204090028.GA9724@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[repost because typo in Ingo's email address]

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

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fd00bb2..7c900c9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -263,10 +263,16 @@ struct cpu_hw_events {
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
 
 #define EVENT_CONSTRAINT_END		\
-	EVENT_CONSTRAINT(0, 0, 0)
+	{ .idxmsk64 = 0,		\
+	  .code = 0,			\
+	  .cmask = 0,			\
+	  .weight = -1,			\
+	  .overlap = 0,			\
+	  .flags = 0,			\
+}
 
 #define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->weight; (e)++)
+	for ((e) = (c); (e)->weight != -1; (e)++)
 
 /*
  * Extra registers for specific events.
-- 
1.8.1.2

