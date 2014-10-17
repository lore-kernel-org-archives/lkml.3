Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaJQTTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:19:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaJQTTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:19:34 -0400
Date: Fri, 17 Oct 2014 21:16:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 1/2] usermodehelper: don't use CLONE_VFORK for
	____call_usermodehelper()
Message-ID: <20141017191622.GB22270@redhat.com>
References: <20141016160042.7f898871@mschwide> <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp> <20141016174209.GB18318@redhat.com> <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp> <20141016215834.GA28864@redhat.com> <20141017093653.6fa60dff@mschwide> <20141017191557.GA22270@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017191557.GA22270@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous fix CLONE_VFORK in __call_usermodehelper() buys
nothing, we rely on on umh_complete() in ____call_usermodehelper()
anyway.

Remove it. This also eliminates the unnecessary sleep/wakeup in the
likely case, and this allows the next change.

While at it, kill the "int wait" locals in ____call_usermodehelper()
and __call_usermodehelper(), they can safely use sub_info->wait.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 80f7a6d..4621771 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -223,7 +223,6 @@ static void umh_complete(struct subprocess_info *sub_info)
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
-	int wait = sub_info->wait & ~UMH_KILLABLE;
 	struct cred *new;
 	int retval;
 
@@ -267,7 +266,7 @@ static int ____call_usermodehelper(void *data)
 out:
 	sub_info->retval = retval;
 	/* wait_for_helper() will call umh_complete if UHM_WAIT_PROC. */
-	if (wait != UMH_WAIT_PROC)
+	if (!(sub_info->wait & UMH_WAIT_PROC))
 		umh_complete(sub_info);
 	if (!retval)
 		return 0;
@@ -323,18 +322,13 @@ static void __call_usermodehelper(struct work_struct *work)
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	int wait = sub_info->wait & ~UMH_KILLABLE;
 	pid_t pid;
 
-	/* CLONE_VFORK: wait until the usermode helper has execve'd
-	 * successfully We need the data structures to stay around
-	 * until that is done.  */
-	if (wait == UMH_WAIT_PROC)
+	if (sub_info->wait & UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else {
-		pid = kernel_thread(call_helper, sub_info,
-				    CLONE_VFORK | SIGCHLD);
+		pid = kernel_thread(call_helper, sub_info, SIGCHLD);
 		/* Worker thread stopped blocking khelper thread. */
 		kmod_thread_locker = NULL;
 	}
-- 
1.5.5.1


