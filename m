Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaCQSFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:05:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbaCQSFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:05:52 -0400
Date: Mon, 17 Mar 2014 19:04:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Sree Harsha Totakura <sreeharsha@totakura.in>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] exit: call disassociate_ctty() before
	exit_task_namespaces()
Message-ID: <20140317180448.GB15708@redhat.com>
References: <531DEEA6.4090808@totakura.in> <531E111A.8040207@hurleysoftware.com> <20140313170622.GA31206@redhat.com> <5321F113.7090000@hurleysoftware.com> <53230FE5.9020204@hurleysoftware.com> <20140314192346.GA14823@redhat.com> <53236662.3020707@hurleysoftware.com> <20140314210456.GA19032@redhat.com> <53244C61.5090508@hurleysoftware.com> <20140317180416.GA15708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317180416.GA15708@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8aac62706ada "move exit_task_namespaces() outside of exit_notify()"
breaks pppd and the exiting service crashes the kernel:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
    IP: [<ffffffffa06985a3>] ppp_register_channel+0x13/0x20 [ppp_generic]
    ...
    Call Trace:
     [<ffffffffa06ab2ab>] ? ppp_asynctty_open+0x12b/0x170 [ppp_async]
     [<ffffffff812ec907>] ? tty_ldisc_open.isra.2+0x27/0x60
     [<ffffffff812ed1d3>] ? tty_ldisc_hangup+0x1e3/0x220
     [<ffffffff812e4614>] ? __tty_hangup+0x2c4/0x440
     [<ffffffff812e56a1>] ? disassociate_ctty+0x61/0x270
     [<ffffffff810483c2>] ? do_exit+0x7f2/0xa50

ppp_register_channel() needs ->net_ns and current->nsproxy == NULL.

Move disassociate_ctty() before exit_task_namespaces(), it doesn't
make sense to delay it after perf_event_exit_task() or cgroup_exit().

This also allows to use task_work_add() inside the (nontrivial) code
paths in disassociate_ctty().

Cc: stable@vger.kernel.org # v3.10+
Reported-by: Sree Harsha Totakura <sreeharsha@totakura.in>
Investigated-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 790b73c..5d5b472 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -784,6 +784,8 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
+	if (group_dead)
+		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
 	check_stack_usage();
@@ -799,13 +801,9 @@ void do_exit(long code)
 
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
1.5.5.1


