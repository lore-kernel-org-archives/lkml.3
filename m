Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaF1Rtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:49:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaF1Rt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 022/110] kthread: fix return value of kthread_create() upon SIGKILL.
Date: Sat, 28 Jun 2014 10:46:19 -0700
Message-Id: <20140628174546.548375677@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kthread.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -262,7 +262,7 @@ static void create_kthread(struct kthrea
  * kthread_stop() has been called).  The return value should be zero
  * or a negative error number; it will be passed to kthread_stop().
  *
- * Returns a task_struct or ERR_PTR(-ENOMEM).
+ * Returns a task_struct or ERR_PTR(-ENOMEM) or ERR_PTR(-EINTR).
  */
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 					   void *data, int node,
@@ -298,7 +298,7 @@ struct task_struct *kthread_create_on_no
 		 * that thread.
 		 */
 		if (xchg(&create->done, NULL))
-			return ERR_PTR(-ENOMEM);
+			return ERR_PTR(-EINTR);
 		/*
 		 * kthreadd (or new kernel thread) will call complete()
 		 * shortly.


