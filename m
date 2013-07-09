Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3GIPvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3GIPvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:51:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: [PATCH 1/2] perf: Clone child context from parent context pmu
Date: Tue,  9 Jul 2013 17:44:10 +0200
Message-Id: <1373384651-6109-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when the child context for inherited events is
created, it's based on the pmu object of the first event
of the parent context.

This is wrong for following scenario:
  - HW context having HW and SW event
  - HW event got removed (closed)
  - SW event stays in HW context as the only event
    and its pmu is used to clone the child context

The issue starts when the cpu context object is touched
based on the pmu context object (__get_cpu_context). In
this case the HW context will work with SW cpu context
ending up with following WARN below.

Fixing this by using parent context pmu object to clone
from child context.

[ 2716.472065] ------------[ cut here ]------------
[ 2716.476035] WARNING: at kernel/events/core.c:2122 task_ctx_sched_out+0x3c/0x)
[ 2716.476035] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs locn
[ 2716.476035] CPU: 0 PID: 3164 Comm: perf_fuzzer Not tainted 3.10.0-rc4 #2
[ 2716.476035] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2716.476035]  0000000000000000 ffffffff8102e215 0000000000000000 ffff88011fc18
[ 2716.476035]  ffff8801175557f0 0000000000000000 ffff880119fda88c ffffffff810ad
[ 2716.476035]  ffff880119fda880 ffffffff810af02a 0000000000000009 ffff880117550
[ 2716.476035] Call Trace:
[ 2716.476035]  [<ffffffff8102e215>] ? warn_slowpath_common+0x5b/0x70
[ 2716.476035]  [<ffffffff810ab2bd>] ? task_ctx_sched_out+0x3c/0x5f
[ 2716.476035]  [<ffffffff810af02a>] ? perf_event_exit_task+0xbf/0x194
[ 2716.476035]  [<ffffffff81032a37>] ? do_exit+0x3e7/0x90c
[ 2716.476035]  [<ffffffff810cd5ab>] ? __do_fault+0x359/0x394
[ 2716.476035]  [<ffffffff81032fe6>] ? do_group_exit+0x66/0x98
[ 2716.476035]  [<ffffffff8103dbcd>] ? get_signal_to_deliver+0x479/0x4ad
[ 2716.476035]  [<ffffffff810ac05c>] ? __perf_event_task_sched_out+0x230/0x2d1
[ 2716.476035]  [<ffffffff8100205d>] ? do_signal+0x3c/0x432
[ 2716.476035]  [<ffffffff810abbf9>] ? ctx_sched_in+0x43/0x141
[ 2716.476035]  [<ffffffff810ac2ca>] ? perf_event_context_sched_in+0x7a/0x90
[ 2716.476035]  [<ffffffff810ac311>] ? __perf_event_task_sched_in+0x31/0x118
[ 2716.476035]  [<ffffffff81050dd9>] ? mmdrop+0xd/0x1c
[ 2716.476035]  [<ffffffff81051a39>] ? finish_task_switch+0x7d/0xa6
[ 2716.476035]  [<ffffffff81002473>] ? do_notify_resume+0x20/0x5d
[ 2716.476035]  [<ffffffff813654f5>] ? retint_signal+0x3d/0x78
[ 2716.476035] ---[ end trace 827178d8a5966c3d ]---

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 20b3dad..446ec3d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7478,7 +7478,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
+		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
 		if (!child_ctx)
 			return -ENOMEM;
 
-- 
1.7.11.7

