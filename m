Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3IKEaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3IKE3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:03 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uJnpUzm3NeEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=sNWqqhjsC0oA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=hGzw-44bAAAA:8 a=JfrnYn6hAAAA:8 a=M03A6vRxAPDt-7kun5cA:9 a=92Q717GQZsEA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=dowx1zmaLagA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042857.930603374@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vince Weaver <vincent.weaver@maine.edu>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <stable@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [034/251] perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid
 scenario
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0034-perf-Remove-WARN_ON_ONCE-check-in-__perf_event_enabl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

[ Upstream commit 06f417968beac6e6b614e17b37d347aa6a6b1d30 ]

The '!ctx->is_active' check has a valid scenario, so
there's no need for the warning.

The reason is that there's a time window between the
'ctx->is_active' check in the perf_event_enable() function
and the __perf_event_enable() function having:

  - IRQs on
  - ctx->lock unlocked

where the task could be killed and 'ctx' deactivated by
perf_event_exit_task(), ending up with the warning below.

So remove the WARN_ON_ONCE() check and add comments to
explain it all.

This addresses the following warning reported by Vince Weaver:

[  324.983534] ------------[ cut here ]------------
[  324.984420] WARNING: at kernel/events/core.c:1953 __perf_event_enable+0x187/0x190()
[  324.984420] Modules linked in:
[  324.984420] CPU: 19 PID: 2715 Comm: nmi_bug_snb Not tainted 3.10.0+ #246
[  324.984420] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[  324.984420]  0000000000000009 ffff88043fce3ec8 ffffffff8160ea0b ffff88043fce3f00
[  324.984420]  ffffffff81080ff0 ffff8802314fdc00 ffff880231a8f800 ffff88043fcf7860
[  324.984420]  0000000000000286 ffff880231a8f800 ffff88043fce3f10 ffffffff8108103a
[  324.984420] Call Trace:
[  324.984420]  <IRQ>  [<ffffffff8160ea0b>] dump_stack+0x19/0x1b
[  324.984420]  [<ffffffff81080ff0>] warn_slowpath_common+0x70/0xa0
[  324.984420]  [<ffffffff8108103a>] warn_slowpath_null+0x1a/0x20
[  324.984420]  [<ffffffff81134437>] __perf_event_enable+0x187/0x190
[  324.984420]  [<ffffffff81130030>] remote_function+0x40/0x50
[  324.984420]  [<ffffffff810e51de>] generic_smp_call_function_single_interrupt+0xbe/0x130
[  324.984420]  [<ffffffff81066a47>] smp_call_function_single_interrupt+0x27/0x40
[  324.984420]  [<ffffffff8161fd2f>] call_function_single_interrupt+0x6f/0x80
[  324.984420]  <EOI>  [<ffffffff816161a1>] ? _raw_spin_unlock_irqrestore+0x41/0x70
[  324.984420]  [<ffffffff8113799d>] perf_event_exit_task+0x14d/0x210
[  324.984420]  [<ffffffff810acd04>] ? switch_task_namespaces+0x24/0x60
[  324.984420]  [<ffffffff81086946>] do_exit+0x2b6/0xa40
[  324.984420]  [<ffffffff8161615c>] ? _raw_spin_unlock_irq+0x2c/0x30
[  324.984420]  [<ffffffff81087279>] do_group_exit+0x49/0xc0
[  324.984420]  [<ffffffff81096854>] get_signal_to_deliver+0x254/0x620
[  324.984420]  [<ffffffff81043057>] do_signal+0x57/0x5a0
[  324.984420]  [<ffffffff8161a164>] ? __do_page_fault+0x2a4/0x4e0
[  324.984420]  [<ffffffff8161665c>] ? retint_restore_args+0xe/0xe
[  324.984420]  [<ffffffff816166cd>] ? retint_signal+0x11/0x84
[  324.984420]  [<ffffffff81043605>] do_notify_resume+0x65/0x80
[  324.984420]  [<ffffffff81616702>] retint_signal+0x46/0x84
[  324.984420] ---[ end trace 442ec2f04db3771a ]---

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1373384651-6109-2-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/events/core.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 073e5b9..63ffeb0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1708,7 +1708,16 @@ static int __perf_event_enable(void *info)
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 	int err;
 
-	if (WARN_ON_ONCE(!ctx->is_active))
+	/*
+	 * There's a time window between 'ctx->is_active' check
+	 * in perf_event_enable function and this place having:
+	 *   - IRQs on
+	 *   - ctx->lock unlocked
+	 *
+	 * where the task could be killed and 'ctx' deactivated
+	 * by perf_event_exit_task.
+	 */
+	if (!ctx->is_active)
 		return -EINVAL;
 
 	raw_spin_lock(&ctx->lock);
-- 
1.7.10.4


