Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaEHKd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:33:59 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60458 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753840AbaEHKdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:33:44 -0400
X-IronPort-AV: E=Sophos;i="4.97,1010,1389715200"; 
   d="scan'208";a="30251497"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] treewide: remove all open implementation of nice_to_rlimit()/rlimit_to_nice().
Date: Thu, 8 May 2014 18:33:49 +0900
Message-ID: <a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com>
References: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there are already two inline functions in prio.h to handle the convertiion
between nice value and rlimit style value of priority, this patch remove all
open implementation of these two functions.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 drivers/staging/android/binder.c | 2 +-
 kernel/sched/core.c              | 2 +-
 kernel/sys.c                     | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 179b21b..9311bb6 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -436,7 +436,7 @@ static void binder_set_nice(long nice)
 		set_user_nice(current, nice);
 		return;
 	}
-	min_nice = 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
+	min_nice = rlimit_to_nice(current->signal->rlim[RLIMIT_NICE].rlim_cur);
 	binder_debug(BINDER_DEBUG_PRIORITY_CAP,
 		     "%d: nice value %ld not allowed use %ld instead\n",
 		      current->pid, nice, min_nice);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ea55072..ff871f5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3015,7 +3015,7 @@ EXPORT_SYMBOL(set_user_nice);
 int can_nice(const struct task_struct *p, const int nice)
 {
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
-	int nice_rlim = 20 - nice;
+	int nice_rlim = nice_to_rlimit(nice);
 
 	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
 		capable(CAP_SYS_NICE));
diff --git a/kernel/sys.c b/kernel/sys.c
index fba0f29..66a751e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -250,7 +250,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			else
 				p = current;
 			if (p) {
-				niceval = 20 - task_nice(p);
+				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			}
@@ -261,7 +261,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			else
 				pgrp = task_pgrp(current);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				niceval = 20 - task_nice(p);
+				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
@@ -277,7 +277,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 
 			do_each_thread(g, p) {
 				if (uid_eq(task_uid(p), uid)) {
-					niceval = 20 - task_nice(p);
+					niceval = nice_to_rlimit(task_nice(p));
 					if (niceval > retval)
 						retval = niceval;
 				}
-- 
1.8.2.1

