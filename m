Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423015AbaKNX1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:27:52 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:5309 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935316AbaKNXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:24:54 -0500
Message-Id: <20141114232452.063132042@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        lkp@01.org
Subject: [for-next][PATCH 1/9] ftrace: Have the control_ops get a trampoline
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Have-the-control_ops-get-a-trampoline.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

With the new logic, if only a single user of ftrace function hooks is
used, it will get its own trampoline assigned to it.

The problem is that the control_ops is an indirect ops that perf ops
uses. What that means is that when perf registers its ops with
register_ftrace_function(), it has the CONTROL flag set and gets added
to the control list instead of the global ftrace list. The control_ops
gets added to that instead and the mcount trampoline calls the control_ops
function. The control_ops function will iterate the control list and
call the ops functions that are attached to it.

But currently the trampoline is added to the perf ops and not the
control ops, and when ftrace tries to find a trampoline hook for it,
it fails to find one and gives the following splat:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 10133 at kernel/trace/ftrace.c:2033 ftrace_get_addr_new+0x6f/0xc0()
 Modules linked in: [...]
 CPU: 0 PID: 10133 Comm: perf Tainted: P               3.18.0-rc1-test+ #388
 Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
  00000000000007f1 ffff8800c2643bc8 ffffffff814fca6e ffff88011ea0ed01
  0000000000000000 ffff8800c2643c08 ffffffff81041ffd 0000000000000000
  ffffffff810c388c ffffffff81a5a350 ffff880119b00000 ffffffff810001c8
 Call Trace:
  [<ffffffff814fca6e>] dump_stack+0x46/0x58
  [<ffffffff81041ffd>] warn_slowpath_common+0x81/0x9b
  [<ffffffff810c388c>] ? ftrace_get_addr_new+0x6f/0xc0
  [<ffffffff810001c8>] ? 0xffffffff810001c8
  [<ffffffff81042031>] warn_slowpath_null+0x1a/0x1c
  [<ffffffff810c388c>] ftrace_get_addr_new+0x6f/0xc0
  [<ffffffff8102e938>] ftrace_replace_code+0xd6/0x334
  [<ffffffff810c4116>] ftrace_modify_all_code+0x41/0xc5
  [<ffffffff8102eba6>] arch_ftrace_update_code+0x10/0x19
  [<ffffffff810c293c>] ftrace_run_update_code+0x21/0x42
  [<ffffffff810c298f>] ftrace_startup_enable+0x32/0x34
  [<ffffffff810c3049>] ftrace_startup+0x14e/0x15a
  [<ffffffff810c307c>] register_ftrace_function+0x27/0x40
  [<ffffffff810dc118>] perf_ftrace_event_register+0x3e/0xee
  [<ffffffff810dbfbe>] perf_trace_init+0x29d/0x2a9
  [<ffffffff810eb422>] perf_tp_event_init+0x27/0x3a
  [<ffffffff810f18bc>] perf_init_event+0x9e/0xed
  [<ffffffff810f1ba4>] perf_event_alloc+0x299/0x330
  [<ffffffff810f236b>] SYSC_perf_event_open+0x3ee/0x816
  [<ffffffff8115a066>] ? mntput+0x2d/0x2f
  [<ffffffff81142b00>] ? __fput+0xa7/0x1b2
  [<ffffffff81091300>] ? do_gettimeofday+0x22/0x3a
  [<ffffffff810f279c>] SyS_perf_event_open+0x9/0xb
  [<ffffffff81502a92>] system_call_fastpath+0x12/0x17
 ---[ end trace 81a53565150e4982 ]---
 Bad trampoline accounting at: ffffffff810001c8 (run_init_process+0x0/0x2d) (10000001)

Update the control_ops trampoline instead of the perf ops one.

Reported-by: lkp@01.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4043332f6720..1a13e615a068 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -418,6 +418,8 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 		if (control_ops_alloc(ops))
 			return -ENOMEM;
 		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
+		/* The control_ops needs the trampoline update */
+		ops = &control_ops;
 	} else
 		add_ftrace_ops(&ftrace_ops_list, ops);
 
-- 
2.1.1


