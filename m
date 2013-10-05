Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3JEFyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 01:54:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:18949 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3JEFyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 01:54:32 -0400
X-Spam-Score: -100.9
Message-ID: <524FA956.9080100@asianux.com>
Date: Sat, 05 Oct 2013 13:53:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/exit.c: call read_unlock() when failure occurs after
 already called read_lock() in do_wait().
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If failure occurs after called read_lock(), need call read_unlock() too.

It can fail in multiple position, so add new tag 'fail_lock' for it
(also can let 'if' only content one jump statement).


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/exit.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index a949819..3da5476 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1527,11 +1527,11 @@ repeat:
 	do {
 		retval = do_wait_thread(wo, tsk);
 		if (retval)
-			goto end;
+			goto fail_lock;
 
 		retval = ptrace_do_wait(wo, tsk);
 		if (retval)
-			goto end;
+			goto fail_lock;
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
@@ -1551,6 +1551,10 @@ end:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 	return retval;
+
+fail_lock:
+	read_unlock(&tasklist_lock);
+	goto end;
 }
 
 SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
-- 
1.7.7.6
