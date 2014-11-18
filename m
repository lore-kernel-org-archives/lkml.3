Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbaKRVag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:30:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbaKRVa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:30:29 -0500
Date: Tue, 18 Nov 2014 22:30:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] exit: reparent: introduce find_alive_thread()
Message-ID: <20141118213029.GA5037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212952.GA4754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new simple helper to factor out the for_each_thread() code
in find_child_reaper() and find_new_reaper(). It can also simplify
the potential PF_EXITING -> exit_state change, plus perhaps we can
change this code to take SIGNAL_GROUP_EXIT into account.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 00c6139..4e3475d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -459,6 +459,17 @@ static void exit_mm(struct task_struct *tsk)
 	clear_thread_flag(TIF_MEMDIE);
 }
 
+static struct task_struct *find_alive_thread(struct task_struct *p)
+{
+	struct task_struct *t;
+
+	for_each_thread(p, t) {
+		if (!(t->flags & PF_EXITING))
+			return t;
+	}
+	return NULL;
+}
+
 static struct task_struct *find_child_reaper(struct task_struct *father)
 	__releases(&tasklist_lock)
 	__acquires(&tasklist_lock)
@@ -469,9 +480,8 @@ static struct task_struct *find_child_reaper(struct task_struct *father)
 	if (likely(reaper != father))
 		return reaper;
 
-	for_each_thread(father, reaper) {
-		if (reaper->flags & PF_EXITING)
-			continue;
+	reaper = find_alive_thread(father);
+	if (reaper) {
 		pid_ns->child_reaper = reaper;
 		return reaper;
 	}
@@ -497,16 +507,13 @@ static struct task_struct *find_child_reaper(struct task_struct *father)
 static struct task_struct *find_new_reaper(struct task_struct *father,
 					   struct task_struct *child_reaper)
 {
-	struct task_struct *thread;
+	struct task_struct *thread, *reaper;
 
-	for_each_thread(father, thread) {
-		if (thread->flags & PF_EXITING)
-			continue;
+	thread = find_alive_thread(father);
+	if (thread)
 		return thread;
-	}
 
 	if (father->signal->has_child_subreaper) {
-		struct task_struct *reaper;
 		/*
 		 * Find the first ->is_child_subreaper ancestor in our pid_ns.
 		 * We start from father to ensure we can not look into another
@@ -520,10 +527,9 @@ static struct task_struct *find_new_reaper(struct task_struct *father,
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
-			for_each_thread(reaper, thread) {
-				if (!(thread->flags & PF_EXITING))
-					return thread;
-			}
+			thread = find_alive_thread(reaper);
+			if (thread)
+				return thread;
 		}
 	}
 
-- 
1.5.5.1

