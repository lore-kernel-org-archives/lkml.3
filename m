Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3CDENf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:13:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60846 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab3CDDm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:56 -0500
Message-Id: <20130304033721.802296788@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:32 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 145/153] usermodehelper: implement UMH_KILLABLE
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit d0bd587a80960d7ba7e0c8396e154028c9045c54 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/kmod.h |    2 ++
 kernel/kmod.c        |   27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -54,6 +54,8 @@ enum umh_wait {
 	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
 };
 
+#define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
+
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -199,7 +199,15 @@ EXPORT_SYMBOL(call_usermodehelper_freein
 
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
@@ -250,6 +258,9 @@ static void __call_usermodehelper(struct
 	enum umh_wait wait = sub_info->wait;
 	pid_t pid;
 
+	if (wait != UMH_NO_WAIT)
+		wait &= ~UMH_KILLABLE;
+
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -440,9 +451,21 @@ int call_usermodehelper_exec(struct subp
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


