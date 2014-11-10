Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaKJWAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:00:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaKJWAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:00:45 -0500
Date: Mon, 10 Nov 2014 23:00:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] exit: reparent: cleanup the changing of ->parent
Message-ID: <20141110220032.GA31235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110215959.GA31106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Cosmetic, but "if (t->parent == father)" looks a bit confusing.
   We need to change t->parent if and only if t is not traced.

2. If we actually want this BUG_ON() to ensure that parent/ptrace
   match each other, then we should also take ptrace_reparented()
   case into account too.

3. Change this code to use for_each_thread() instead of deprecated
   while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 4a9b4c0..939e9fc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -557,7 +557,7 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 
 static void forget_original_parent(struct task_struct *father)
 {
-	struct task_struct *p, *n, *reaper;
+	struct task_struct *p, *t, *n, *reaper;
 	LIST_HEAD(dead_children);
 
 	write_lock_irq(&tasklist_lock);
@@ -569,18 +569,15 @@ static void forget_original_parent(struct task_struct *father)
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		struct task_struct *t = p;
-
-		do {
+		for_each_thread(p, t) {
 			t->real_parent = reaper;
-			if (t->parent == father) {
-				BUG_ON(t->ptrace);
+			BUG_ON(!t->ptrace != (t->parent == father));
+			if (likely(!t->ptrace))
 				t->parent = t->real_parent;
-			}
 			if (t->pdeath_signal)
 				group_send_sig_info(t->pdeath_signal,
 						    SEND_SIG_NOINFO, t);
-		} while_each_thread(p, t);
+		}
 		reparent_leader(father, p, &dead_children);
 	}
 	write_unlock_irq(&tasklist_lock);
-- 
1.5.5.1

