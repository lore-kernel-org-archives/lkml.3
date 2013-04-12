Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3DLT34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:29:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42654 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab3DLT3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:29:55 -0400
From: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] kernel: move exit_task_work() past exit_notify()
Date: Fri, 12 Apr 2013 23:27:33 +0400
Message-Id: <1365794853-23912-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.1.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_task_work() must be called after exit_notify, because
exit_task_namespaces() may release a file and fput() enqueues a work.

exit_notify
  exit_task_namespaces
    free_ipc_ns
      shm_destroy
        fput
          task_work_add

so if task works don't run after exit_notify(), a few files may leak.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 60bc027..1d1129b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -795,7 +795,6 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
-	exit_task_work(tsk);
 	check_stack_usage();
 	exit_thread();
 
@@ -822,6 +821,7 @@ void do_exit(long code)
 	ptrace_put_breakpoints(tsk);
 
 	exit_notify(tsk, group_dead);
+	exit_task_work(tsk);
 #ifdef CONFIG_NUMA
 	task_lock(tsk);
 	mpol_put(tsk->mempolicy);
-- 
1.8.1.4

