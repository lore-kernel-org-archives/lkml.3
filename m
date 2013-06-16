Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3FPEq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:46:57 -0400
Received: from ozlabs.org ([203.10.76.45]:46302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab3FPEqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:46:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 9/9] mm/oom_kill: remove weird use of ERR_PTR()/PTR_ERR().
Date: Sun, 16 Jun 2013 14:12:48 +0930
Message-Id: <1371357768-4968-9-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
 <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The normal expectation for ERR_PTR() is to put a negative errno into a
pointer.  oom_kill puts the magic -1 in the result (and has since
pre-git), which is probably clearer with an explicit cast.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 mm/oom_kill.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 79e451a..f9b9cd7 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -288,7 +288,7 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 
 /*
  * Simple selection loop. We chose the process with the highest
- * number of 'points'.
+ * number of 'points'.  Returns -1 on scan abort.
  *
  * (not docbooked, we don't want this one cluttering up the manual)
  */
@@ -314,7 +314,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			continue;
 		case OOM_SCAN_ABORT:
 			rcu_read_unlock();
-			return ERR_PTR(-1UL);
+			return (void *)(-1UL);
 		case OOM_SCAN_OK:
 			break;
 		};
@@ -657,7 +657,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
 		panic("Out of memory and no killable processes...\n");
 	}
-	if (PTR_ERR(p) != -1UL) {
+	if (p != (void *)-1UL) {
 		oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
 				 nodemask, "Out of memory");
 		killed = 1;
-- 
1.8.1.2

