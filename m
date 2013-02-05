Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3BEWJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3BEWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 25/93] ftrace: Be first to run code modification on modules
Date: Tue,  5 Feb 2013 20:06:14 -0200
Message-Id: <1360102042-10732-26-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit c1bf08ac26e92122faab9f6c32ea8aba94612dae upstream.

If some other kernel subsystem has a module notifier, and adds a kprobe
to a ftrace mcount point (now that kprobes work on ftrace points),
when the ftrace notifier runs it will fail and disable ftrace, as well
as kprobes that are attached to ftrace points.

Here's the error:

 WARNING: at kernel/trace/ftrace.c:1618 ftrace_bug+0x239/0x280()
 Hardware name: Bochs
 Modules linked in: fat(+) stap_56d28a51b3fe546293ca0700b10bcb29__8059(F) nfsv4 auth_rpcgss nfs dns_resolver fscache xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack lockd sunrpc ppdev parport_pc parport microcode virtio_net i2c_piix4 drm_kms_helper ttm drm i2c_core [last unloaded: bid_shared]
 Pid: 8068, comm: modprobe Tainted: GF            3.7.0-0.rc8.git0.1.fc19.x86_64 #1
 Call Trace:
  [<ffffffff8105e70f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff81134106>] ? __probe_kernel_read+0x46/0x70
  [<ffffffffa0180000>] ? 0xffffffffa017ffff
  [<ffffffffa0180000>] ? 0xffffffffa017ffff
  [<ffffffff8105e76a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff810fd189>] ftrace_bug+0x239/0x280
  [<ffffffff810fd626>] ftrace_process_locs+0x376/0x520
  [<ffffffff810fefb7>] ftrace_module_notify+0x47/0x50
  [<ffffffff8163912d>] notifier_call_chain+0x4d/0x70
  [<ffffffff810882f8>] __blocking_notifier_call_chain+0x58/0x80
  [<ffffffff81088336>] blocking_notifier_call_chain+0x16/0x20
  [<ffffffff810c2a23>] sys_init_module+0x73/0x220
  [<ffffffff8163d719>] system_call_fastpath+0x16/0x1b
 ---[ end trace 9ef46351e53bbf80 ]---
 ftrace failed to modify [<ffffffffa0180000>] init_once+0x0/0x20 [fat]
  actual: cc:bb:d2:4b:e1

A kprobe was added to the init_once() function in the fat module on load.
But this happened before ftrace could have touched the code. As ftrace
didn't run yet, the kprobe system had no idea it was a ftrace point and
simply added a breakpoint to the code (0xcc in the cc:bb:d2:4b:e1).

Then when ftrace went to modify the location from a call to mcount/fentry
into a nop, it didn't see a call op, but instead it saw the breakpoint op
and not knowing what to do with it, ftrace shut itself down.

The solution is to simply give the ftrace module notifier the max priority.
This should have been done regardless, as the core code ftrace modification
also happens very early on in boot up. This makes the module modification
closer to core modification.

Link: http://lkml.kernel.org/r/20130107140333.593683061@goodmis.org

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Frank Ch. Eigler <fche@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 97da2dc..793e367 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3863,7 +3863,7 @@ static int ftrace_module_notify(struct notifier_block *self,
 
 struct notifier_block ftrace_module_nb = {
 	.notifier_call = ftrace_module_notify,
-	.priority = 0,
+	.priority = INT_MAX,	/* Run before anything that can use kprobes */
 };
 
 extern unsigned long __start_mcount_loc[];
-- 
1.7.9.5

