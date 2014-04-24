Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaDXJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:16:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaDXI4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Hurley <peter@hurleysoftware.com>,
        Sree Harsha Totakura <sreeharsha@totakura.in>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 136/182] exit: call disassociate_ctty() before exit_task_namespaces()
Date: Thu, 24 Apr 2014 09:51:01 +0100
Message-Id: <1398329507-5911-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit c39df5fa37b0623589508c95515b4aa1531c524e upstream.

Commit 8aac62706ada ("move exit_task_namespaces() outside of
exit_notify()") breaks pppd and the exiting service crashes the kernel:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
    IP: ppp_register_channel+0x13/0x20 [ppp_generic]
    Call Trace:
      ppp_asynctty_open+0x12b/0x170 [ppp_async]
      tty_ldisc_open.isra.2+0x27/0x60
      tty_ldisc_hangup+0x1e3/0x220
      __tty_hangup+0x2c4/0x440
      disassociate_ctty+0x61/0x270
      do_exit+0x7f2/0xa50

ppp_register_channel() needs ->net_ns and current->nsproxy == NULL.

Move disassociate_ctty() before exit_task_namespaces(), it doesn't make
sense to delay it after perf_event_exit_task() or cgroup_exit().

This also allows to use task_work_add() inside the (nontrivial) code
paths in disassociate_ctty().

Investigated by Peter Hurley.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sree Harsha Totakura <sreeharsha@totakura.in>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Sree Harsha Totakura <sreeharsha@totakura.in>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/exit.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index a949819..b79d882 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -783,6 +783,8 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
+	if (group_dead)
+		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
 	check_stack_usage();
@@ -798,13 +800,9 @@ void do_exit(long code)
 
 	cgroup_exit(tsk, 1);
 
-	if (group_dead)
-		disassociate_ctty(1);
-
 	module_put(task_thread_info(tsk)->exec_domain->module);
 
 	proc_exit_connector(tsk);
-
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-- 
1.9.1

