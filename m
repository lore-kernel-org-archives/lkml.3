Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaFDOEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:04:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:56724 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbaFDOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:04:14 -0400
Message-ID: <1401890647.4484.7.camel@tkhai>
Subject: [PATCH RESEND 2/2] sched/rt: Fix rt_prio()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>, <tkhai@yandex.ru>
Date: Wed, 4 Jun 2014 18:04:07 +0400
In-Reply-To: <20140604124735.3951.61242.stgit@tkhai>
References: <20140604124735.3951.61242.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The set of rt_prio() contains dl_prio() subset. Fix that.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/deadline.h |    8 +-------
 include/linux/sched/prio.h     |    8 +++++---
 include/linux/sched/rt.h       |    2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 9d303b8..e529305 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -1,13 +1,7 @@
 #ifndef _SCHED_DEADLINE_H
 #define _SCHED_DEADLINE_H
 
-/*
- * SCHED_DEADLINE tasks has negative priorities, reflecting
- * the fact that any of them has higher prio than RT and
- * NORMAL/BATCH tasks.
- */
-
-#define MAX_DL_PRIO		0
+#include <linux/sched/prio.h>
 
 static inline int dl_prio(int prio)
 {
diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index d9cf5a5..0d6c552 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -6,18 +6,20 @@
 #define NICE_WIDTH	(MAX_NICE - MIN_NICE + 1)
 
 /*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * Priority of a process goes from MAX_DL_PRIO-1..MAX_PRIO-1,
+ * SCHED_DEADLINE tasks have negative priorities, valid RT
+ * value is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
  * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
  * values are inverted: lower p->prio value means higher priority.
  *
  * The MAX_USER_RT_PRIO value allows the actual maximum
  * RT priority to be separate from the value exported to
  * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
+ * priority to a value higher than any user RT task. Note:
  * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
  */
 
+#define MAX_DL_PRIO		0
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
 
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 6341f5b..dca43ed 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -5,7 +5,7 @@
 
 static inline int rt_prio(int prio)
 {
-	if (unlikely(prio < MAX_RT_PRIO))
+	if (unlikely(prio < MAX_RT_PRIO && prio >= MAX_DL_PRIO))
 		return 1;
 	return 0;
 }





