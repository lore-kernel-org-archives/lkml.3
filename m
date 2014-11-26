Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaKZOVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:21:14 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29541 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:21:12 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-12-5475e1d68dbb
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Lukasz Pawelczyk <havner@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Sameer Nanda <snanda@chromium.org>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
        Guillaume Morin <guillaume@morinfr.org>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/exit.c: make sure current's nsproxy != NULL while
 checking caps
Date: Wed, 26 Nov 2014 15:21:01 +0100
Message-id: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xy7rXHpaGGHxdqG4xZ/0aNovdCx6y
	Wfx/rWNxZtJCJovLu+awWUzq6GW3eNX8ndVi6/5WRou2JRuZLC7+PsnuwOUxu+Eii8fOWXfZ
	PRZsKvVoOfKW1ePEjN8sHh33tzB5vN93lc2jb8sqRo8zC46we3zeJBfAFcVlk5Kak1mWWqRv
	l8CVMWHPAcaCg+IVl/bcYmpg7BDpYuTkkBAwkfiwezkjhC0mceHeerYuRi4OIYGljBLtv5tZ
	IZxeJolV99ewg1SxCRhIfL+wlxkkISLwi0mivWcxG0hCWCBSYlrfLSYQm0VAVWL+jPlAYzk4
	eAXcJZ71skBskJPo3faGeQIj1wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIaH1dQfj
	0mNWhxgFOBiVeHhvxJWECLEmlhVX5h5ilOBgVhLhTb1TGiLEm5JYWZValB9fVJqTWnyIkYmD
	U6qB8fDvplVhP4/kKswQZ+o6X9u0ekGQybxnyxc3+z/22JjIcKeiykhlj388l/+S6wLt60uW
	KP/cKFCwdhJ34ZEps7bM7Xj7K/Ulb+SdTzdecCRdZ7PcoPhA5bpIodmjIg95ZtayOzOUed6e
	eWKzq1PAtvi4wiLuwz3pX8Vy3nu6shz6ZCQzm7V3rhJLcUaioRZzUXEiANmfGOILAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a rare case where current's nsproxy might be NULL but we are
required to check for credentials and capabilities. It sometimes happens
during an exit() syscall while destroying user's session (logging out).

My understanding is that while we have to use task_nsproxy() to get
task's nsproxy and check whether it's NULL, for the 'current' we don't
have to and it's expected not to be NULL. There is a code in the kernel
currently that does current->nsproxy->user_ns without any checks.

There seem to be no crash currently because of this, but with other LSM
modules or in future there might be. This is the backtrace:

0  smk_tskacc (task=0xffff88003b0b92e0, obj_known=0x2 <irq_stack_union+2>, mode=2, a=0xffff88003be53dd8) at security/smack/smack_access.c:261
1  0xffffffff8130e2aa in smk_curacc (obj_known=<optimized out>, mode=<optimized out>, a=<optimized out>) at security/smack/smack_access.c:318
2  0xffffffff8130a50d in smack_task_kill (p=0xffff88003b0b92e0, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/smack/smack_lsm.c:2071
3  0xffffffff812ea4f6 in security_task_kill (p=<optimized out>, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/security.c:952
4  0xffffffff8109ac80 in check_kill_permission (sig=15, info=0x0 <irq_stack_union>, t=0xffff88003b0b8000) at kernel/signal.c:796
5  0xffffffff8109d3ab in group_send_sig_info (sig=15, info=0x0 <irq_stack_union>, p=0xffff88003b0b8000) at kernel/signal.c:1296
6  0xffffffff8108e527 in forget_original_parent (father=<optimized out>) at kernel/exit.c:575
7  exit_notify (group_dead=<optimized out>, tsk=<optimized out>) at kernel/exit.c:606
8  do_exit (code=<optimized out>) at kernel/exit.c:775
9  0xffffffff8108ec0f in do_group_exit (exit_code=0) at kernel/exit.c:891
10 0xffffffff8108ec84 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:902
11 SyS_exit_group (error_code=<optimized out>) at kernel/exit.c:900

LSM task_kill() hook is triggered and current->nsproxy within is NULL.

This happens during an exit() syscall because exit_task_namespaces() is
called before the exit_notify(). This patch changes their order.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 kernel/exit.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index e5c4668..ac4735c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -751,7 +751,6 @@ void do_exit(long code)
 	exit_fs(tsk);
 	if (group_dead)
 		disassociate_ctty(1);
-	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
 	exit_thread();
 
@@ -773,6 +772,13 @@ void do_exit(long code)
 	flush_ptrace_hw_breakpoint(tsk);
 
 	exit_notify(tsk, group_dead);
+
+	/*
+	 * This should be after all things that pottentially require
+	 * process's namespaces (e.g. capability checks).
+	 */
+	exit_task_namespaces(tsk);
+
 	proc_exit_connector(tsk);
 #ifdef CONFIG_NUMA
 	task_lock(tsk);
-- 
1.9.3

