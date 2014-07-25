Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542AbaGYOGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:06:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:2696 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760509AbaGYOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:06:13 -0400
Message-Id: <20140725140612.791645875@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 25 Jul 2014 10:05:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 3/4] ftrace: Fix trampoline hash update check on rec->flags
References: <20140725140514.377803118@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftrace-Fix-trampoline-hash-update-check-on-rec-flags.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In the loop of ftrace_save_ops_tramp_hash(), it adds all the recs
to the ops hash if the rec has only one callback attached and the
ops is connected to the rec. It gives a nasty warning and shuts down
ftrace if the rec doesn't have a trampoline set for it. But this
can happen with the following scenario:

  # cd /sys/kernel/debug/tracing
  # echo schedule do_IRQ > set_ftrace_filter
  # mkdir instances/foo
  # echo schedule > instances/foo/set_ftrace_filter
  # echo function_graph > current_function
  # echo function > instances/foo/current_function
  # echo nop > instances/foo/current_function

The above would then trigger the following warning and disable
ftrace:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 3145 at kernel/trace/ftrace.c:2212 ftrace_run_update_code+0xe4/0x15b()
 Modules linked in: ipt_MASQUERADE sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ip [...]
 CPU: 1 PID: 3145 Comm: bash Not tainted 3.16.0-rc3-test+ #136
 Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
  0000000000000000 ffffffff81808a88 ffffffff81502130 0000000000000000
  ffffffff81040ca1 ffff880077c08000 ffffffff810bd286 0000000000000001
  ffffffff81a56830 ffff88007a041be0 ffff88007a872d60 00000000000001be
 Call Trace:
  [<ffffffff81502130>] ? dump_stack+0x4a/0x75
  [<ffffffff81040ca1>] ? warn_slowpath_common+0x7e/0x97
  [<ffffffff810bd286>] ? ftrace_run_update_code+0xe4/0x15b
  [<ffffffff810bd286>] ? ftrace_run_update_code+0xe4/0x15b
  [<ffffffff810bda1a>] ? ftrace_shutdown+0x11c/0x16b
  [<ffffffff810bda87>] ? unregister_ftrace_function+0x1e/0x38
  [<ffffffff810cc7e1>] ? function_trace_reset+0x1a/0x28
  [<ffffffff810c924f>] ? tracing_set_tracer+0xc1/0x276
  [<ffffffff810c9477>] ? tracing_set_trace_write+0x73/0x91
  [<ffffffff81132383>] ? __sb_start_write+0x9a/0xcc
  [<ffffffff8120478f>] ? security_file_permission+0x1b/0x31
  [<ffffffff81130e49>] ? vfs_write+0xac/0x11c
  [<ffffffff8113115d>] ? SyS_write+0x60/0x8e
  [<ffffffff81508112>] ? system_call_fastpath+0x16/0x1b
 ---[ end trace 938c4415cbc7dc96 ]---
 ------------[ cut here ]------------

Link: http://lkml.kernel.org/r/20140723120805.GB21376@redhat.com

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index eda69c9f78d0..6ef1989c2b2e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2208,6 +2208,14 @@ static int ftrace_save_ops_tramp_hash(struct ftrace_ops *ops)
 		if (ftrace_rec_count(rec) == 1 &&
 		    ftrace_ops_test(ops, rec->ip, rec)) {
 
+			/*
+			 * If another ops adds to a rec, the rec will
+			 * lose its trampoline and never get it back
+			 * until all ops are off of it.
+			 */
+			if (!(rec->flags & FTRACE_FL_TRAMP))
+				continue;
+
 			/* This record had better have a trampoline */
 			if (FTRACE_WARN_ON(!(rec->flags & FTRACE_FL_TRAMP_EN)))
 				return -1;
-- 
2.0.1


