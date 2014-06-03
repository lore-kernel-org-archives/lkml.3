Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaFCNDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:03:19 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:20527 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaFCNDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:03:18 -0400
X-Nat-Received: from [202.181.97.72]:46786 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1401800596.23326
To: oleg@redhat.com, akpm@linux-foundation.org
Cc: joseph.salisbury@canonical.com, rientjes@google.com,
        torvalds@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: [PATCH] kthread: Fix return value of kthread_create() upon SIGKILL.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <53236AA2.7030105@canonical.com>
	<20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
	<20140317201919.GA28997@redhat.com>
In-Reply-To: <20140317201919.GA28997@redhat.com>
Message-Id: <201406032203.ECD00030.OOHFSQtVFLOFMJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 3 Jun 2014 22:03:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03062014 #8117452, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c41fa0b9294900a86167d6c8db392d99dde09774 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 3 Jun 2014 21:46:24 +0900
Subject: [PATCH] kthread: Fix return value of kthread_create() upon SIGKILL.

Commit 786235eeb "kthread: make kthread_create() killable" meant for
allowing kthread_create() to abort as soon as killed by the OOM-killer.
But returning -ENOMEM is wrong if killed by SIGKILL from userspace.
Change kthread_create() to return -EINTR upon SIGKILL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: stable <stable@kernel.org> [3.13+]
---
 kernel/kthread.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9a130ec..c2390f4 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -262,7 +262,7 @@ static void create_kthread(struct kthread_create_info *create)
  * kthread_stop() has been called).  The return value should be zero
  * or a negative error number; it will be passed to kthread_stop().
  *
- * Returns a task_struct or ERR_PTR(-ENOMEM).
+ * Returns a task_struct or ERR_PTR(-ENOMEM) or ERR_PTR(-EINTR).
  */
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 					   void *data, int node,
@@ -298,7 +298,7 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 		 * that thread.
 		 */
 		if (xchg(&create->done, NULL))
-			return ERR_PTR(-ENOMEM);
+			return ERR_PTR(-EINTR);
 		/*
 		 * kthreadd (or new kernel thread) will call complete()
 		 * shortly.
-- 
1.7.1
