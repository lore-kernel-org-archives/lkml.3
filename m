Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3GXOKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45831 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab3GXOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Paul Mackerras" <paulus@samba.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Namhyung Kim" <namhyung@kernel.org>, "Jiri Olsa" <jolsa@redhat.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Vince Weaver" <vincent.weaver@maine.edu>,
        "Corey Ashford" <cjashfor@linux.vnet.ibm.com>,
        "Ingo Molnar" <mingo@elte.hu>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.270241944@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [74/85] perf: Clone child context from parent context pmu
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

commit 734df5ab549ca44f40de0f07af1c8803856dfb18 upstream.

Currently when the child context for inherited events is
created, it's based on the pmu object of the first event
of the parent context.

This is wrong for the following scenario:

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

Addresses the following warning reported by Vince Weaver:

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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1373384651-6109-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6797,7 +6797,7 @@ inherit_task_group(struct perf_event *ev
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
+		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
 		if (!child_ctx)
 			return -ENOMEM;
 

