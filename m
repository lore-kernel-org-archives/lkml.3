Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3C0JuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:50:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:46198 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3C0JuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:50:12 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 14/14] tracing: fix regression of perf function tracing
Date: Wed, 27 Mar 2013 17:48:56 +0800
Message-ID: <1364377737-10540-16-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Using perf command: perf stat -e ftrace:function ls

this will cause kernel warning and oops.

[  797.828904] ------------[ cut here ]------------
[  797.828946] WARNING: at include/linux/ftrace.h:209 ftrace_ops_control_func+0xb1/0xc0()
[  797.829065] Pid: 6086, comm: perf Not tainted 3.8.0-rc4+ #88
[  797.829066] Call Trace:
[  797.829078]  [<c0447a42>] warn_slowpath_common+0x72/0xa0
[  797.829080]  [<c04bd6d1>] ? ftrace_ops_control_func+0xb1/0xc0
[  797.829082]  [<c04bd6d1>] ? ftrace_ops_control_func+0xb1/0xc0
[  797.829083]  [<c04b7453>] ? synchronize_sched+0x3/0x50
[  797.829085]  [<c04be50f>] ? __unregister_ftrace_function+0x8f/0x170
[  797.829087]  [<c0447a92>] warn_slowpath_null+0x22/0x30
[  797.829089]  [<c04bd6d1>] ftrace_ops_control_func+0xb1/0xc0
[  797.829099]  [<c08eba6b>] ftrace_call+0x5/0xb
[  797.829100]  [<c04b7458>] ? synchronize_sched+0x8/0x50
[  797.829102]  [<c04be50f>] __unregister_ftrace_function+0x8f/0x170
[  797.829104]  [<c04c00cf>] unregister_ftrace_function+0x1f/0x50
[  797.829109]  [<c04d31bd>] perf_ftrace_event_register+0x9d/0x140
[  797.829111]  [<c04d304b>] perf_trace_destroy+0x2b/0x50
[  797.829117]  [<c04db3c8>] tp_perf_event_destroy+0x8/0x10
[  797.829119]  [<c04dd672>] free_event+0x42/0x110
[  797.829121]  [<c04de446>] perf_event_release_kernel+0x56/0x90
[  797.829122]  [<c04de4fc>] put_event+0x7c/0xa0
[  797.829124]  [<c04de5cb>] perf_release+0xb/0x10
[  797.829128]  [<c0532ae6>] __fput+0xc6/0x1f0
[  797.829130]  [<c0532c1d>] ____fput+0xd/0x10
[  797.829134]  [<c04645b1>] task_work_run+0x81/0xa0
[  797.829142]  [<c0412819>] do_notify_resume+0x59/0x90
[  797.829150]  [<c08e4745>] work_notifysig+0x30/0x37
[  797.829152] ---[ end trace 4dbd63f12b55163f ]---

This bug was introduced by below commit(in 3.8-rc4):
        commit 0a016409e42f273415f8225ddf2c58eb2df88034
        Author: Steven Rostedt <srostedt@redhat.com>
        Date:   Fri Nov 2 17:03:03 2012 -0400

        ftrace: Optimize the function tracer list loop

When variable op is ftrace_list_end, it cannot pass control ops checking,
so that loop optimize is not suit for ftrace_control_list, change it back.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/ftrace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2577082..2899974 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4185,11 +4185,14 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	trace_recursion_set(TRACE_CONTROL_BIT);
-	do_for_each_ftrace_op(op, ftrace_control_list) {
+	op = rcu_dereference_raw(ftrace_control_list);
+	while (op != &ftrace_list_end) {
 		if (!ftrace_function_local_disabled(op) &&
 		    ftrace_ops_test(op, ip))
 			op->func(ip, parent_ip, op, regs);
-	} while_for_each_ftrace_op(op);
+
+		op = rcu_dereference_raw(op->next);
+	}
 	trace_recursion_clear(TRACE_CONTROL_BIT);
 	preempt_enable_notrace();
 }
-- 
1.7.9.7


