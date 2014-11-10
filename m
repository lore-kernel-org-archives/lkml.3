Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaKJWAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:00:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaKJWAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:00:44 -0500
Date: Mon, 10 Nov 2014 23:00:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] exit: reparent: cleanup the usage of reparent_leader()
Message-ID: <20141110220035.GA31242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110215959.GA31106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Now that reparent_leader() doesn't abuse ->sibling we can shift
   list_move_tail() from reparent_leader() to forget_original_parent()
   and turn it into a single list_splice_tail_init(). This also makes
   BUG_ON(!list_empty()) and list_for_each_entry_safe() unnecessary.

2. This also allows to shift the same_thread_group() check, it looks
   a bit more clear in the caller.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 939e9fc..e3e7379 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -529,15 +529,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 static void reparent_leader(struct task_struct *father, struct task_struct *p,
 				struct list_head *dead)
 {
-	list_move_tail(&p->sibling, &p->real_parent->children);
-
-	if (p->exit_state == EXIT_DEAD)
-		return;
-	/*
-	 * If this is a threaded reparent there is no need to
-	 * notify anyone anything has happened.
-	 */
-	if (same_thread_group(p->real_parent, father))
+	if (unlikely(p->exit_state == EXIT_DEAD))
 		return;
 
 	/* We don't want people slaying init. */
@@ -568,7 +560,7 @@ static void forget_original_parent(struct task_struct *father)
 	exit_ptrace(father);
 	reaper = find_new_reaper(father);
 
-	list_for_each_entry_safe(p, n, &father->children, sibling) {
+	list_for_each_entry(p, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
 			BUG_ON(!t->ptrace != (t->parent == father));
@@ -578,12 +570,16 @@ static void forget_original_parent(struct task_struct *father)
 				group_send_sig_info(t->pdeath_signal,
 						    SEND_SIG_NOINFO, t);
 		}
-		reparent_leader(father, p, &dead_children);
+		/*
+		 * If this is a threaded reparent there is no need to
+		 * notify anyone anything has happened.
+		 */
+		if (!same_thread_group(reaper, father))
+			reparent_leader(father, p, &dead_children);
 	}
+	list_splice_tail_init(&father->children, &reaper->children);
 	write_unlock_irq(&tasklist_lock);
 
-	BUG_ON(!list_empty(&father->children));
-
 	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
 		list_del_init(&p->ptrace_entry);
 		release_task(p);
-- 
1.5.5.1

