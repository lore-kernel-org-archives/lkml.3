Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaJUH1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:27:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbaJUH1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:27:37 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 4/4] PM: convert do_each_thread to for_each_process_thread
Date: Tue, 21 Oct 2014 09:27:15 +0200
Message-Id: <1413876435-11720-5-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as per 0c740d0afc3b (introduce for_each_thread() to replace the buggy
while_each_thread()) get rid of do_each_thread { } while_each_thread()
construct and replace it by a more error prone for_each_thread.

This patch doesn't introduce any user visible change.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/power/process.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index a397fa161d11..7fd7b72554fe 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -46,13 +46,13 @@ static int try_to_freeze_tasks(bool user_only)
 	while (true) {
 		todo = 0;
 		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
+		for_each_process_thread(g, p) {
 			if (p == current || !freeze_task(p))
 				continue;
 
 			if (!freezer_should_skip(p))
 				todo++;
-		} while_each_thread(g, p);
+		}
 		read_unlock(&tasklist_lock);
 
 		if (!user_only) {
@@ -93,11 +93,11 @@ static int try_to_freeze_tasks(bool user_only)
 
 		if (!wakeup) {
 			read_lock(&tasklist_lock);
-			do_each_thread(g, p) {
+			for_each_process_thread(g, p) {
 				if (p != current && !freezer_should_skip(p)
 				    && freezing(p) && !frozen(p))
 					sched_show_task(p);
-			} while_each_thread(g, p);
+			}
 			read_unlock(&tasklist_lock);
 		}
 	} else {
@@ -219,11 +219,11 @@ void thaw_processes(void)
 	thaw_workqueues();
 
 	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/* No other threads should have PF_SUSPEND_TASK set */
 		WARN_ON((p != curr) && (p->flags & PF_SUSPEND_TASK));
 		__thaw_task(p);
-	} while_each_thread(g, p);
+	}
 	read_unlock(&tasklist_lock);
 
 	WARN_ON(!(curr->flags & PF_SUSPEND_TASK));
@@ -246,10 +246,10 @@ void thaw_kernel_threads(void)
 	thaw_workqueues();
 
 	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
 			__thaw_task(p);
-	} while_each_thread(g, p);
+	}
 	read_unlock(&tasklist_lock);
 
 	schedule();
-- 
2.1.1

