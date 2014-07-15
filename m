Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614AbaGOVed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:34:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbaGOVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:34:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/198] kthread: fix return value of kthread_create() upon SIGKILL.
Date: Tue, 15 Jul 2014 14:29:20 -0700
Message-Id: <1405459868-15089-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 8fe6929cfd43c44834858a53e129ffdc7c166298 upstream.

Commit 786235eeba0e ("kthread: make kthread_create() killable") meant
for allowing kthread_create() to abort as soon as killed by the
OOM-killer.  But returning -ENOMEM is wrong if killed by SIGKILL from
userspace.  Change kthread_create() to return -EINTR upon SIGKILL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/kthread.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b5ae3ee..f6249f9 100644
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
1.9.1

