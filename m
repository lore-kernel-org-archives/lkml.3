Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3FDXMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:12:38 -0400
Received: from 1wt.eu ([62.212.114.60]:35449 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab3FDWmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:20 -0400
Message-Id: <20130604172130.760364569@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 011/184] usermodehelper: implement UMH_KILLABLE
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit d0bd587a80960d7ba7e0c8396e154028c9045c54 upstream

Implement UMH_KILLABLE, should be used along with UMH_WAIT_EXEC/PROC.
The caller must ensure that subprocess_info->path/etc can not go away
until call_usermodehelper_freeinfo().

call_usermodehelper_exec(UMH_KILLABLE) does
wait_for_completion_killable.  If it fails, it uses
xchg(&sub_info->complete, NULL) to serialize with umh_complete() which
does the same xhcg() to access sub_info->complete.

If call_usermodehelper_exec wins, it can safely return.  umh_complete()
should get NULL and call call_usermodehelper_freeinfo().

Otherwise we know that umh_complete() was already called, in this case
call_usermodehelper_exec() falls back to wait_for_completion() which
should succeed "very soon".

Note: UMH_NO_WAIT == -1 but it obviously should not be used with
UMH_KILLABLE.  We delay the neccessary cleanup to simplify the back
porting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/kmod.h |  2 ++
 kernel/kmod.c        | 27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 0546fe7..93e732e 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -64,6 +64,8 @@ enum umh_wait {
 	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
 };
 
+#define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
+
 /* Actually execute the sub-process */
 int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2a27d17..2c2a020 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -208,7 +208,15 @@ EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
 static void umh_complete(struct subprocess_info *sub_info)
 {
-	complete(sub_info->complete);
+	struct completion *comp = xchg(&sub_info->complete, NULL);
+	/*
+	 * See call_usermodehelper_exec(). If xchg() returns NULL
+	 * we own sub_info, the UMH_KILLABLE caller has gone away.
+	 */
+	if (comp)
+		complete(comp);
+	else
+		call_usermodehelper_freeinfo(sub_info);
 }
 
 /* Keventd can't block, but this (a child) can. */
@@ -264,6 +272,9 @@ static void __call_usermodehelper(struct work_struct *work)
 
 	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
 
+	if (wait != UMH_NO_WAIT)
+		wait &= ~UMH_KILLABLE;
+
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -525,9 +536,21 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
 	queue_work(khelper_wq, &sub_info->work);
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
+
+	if (wait & UMH_KILLABLE) {
+		retval = wait_for_completion_killable(&done);
+		if (!retval)
+			goto wait_done;
+
+		/* umh_complete() will see NULL and free sub_info */
+		if (xchg(&sub_info->complete, NULL))
+			goto unlock;
+		/* fallthrough, umh_complete() was already called */
+	}
+
 	wait_for_completion(&done);
+wait_done:
 	retval = sub_info->retval;
-
 out:
 	call_usermodehelper_freeinfo(sub_info);
 unlock:
-- 
1.7.12.2.21.g234cd45.dirty



