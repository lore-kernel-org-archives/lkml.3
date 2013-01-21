Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3AUURf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:17:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3AUURe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:17:34 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5B2ETZHoICIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BdiIx2x5CoQA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=xDtP2ajPAAAA:8 a=ZDtDiuhwN1nBtWzPNgkA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=XyVaWbAntQPuEHfq:21 a=px7xojXzNPQtI0kG:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358799451.21576.31.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] ftrace: Be first to run code modification on
 modules
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Date: Mon, 21 Jan 2013 15:17:31 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

I was going to wait off on pushing this to you, but it's the first in
my series and it fixes a real bug. It also is just a one liner and is
Cc'd to stable. If it's good enough for stable it should be good enough
for an -rc release.

I rebased it on 3.8-rc4 (shortly after rc4 came out) and ran it through
all my tests.

Please pull trace-3.8-rc4-fix:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.8-rc4-fix

Head SHA1: 514aae880fbda6cbe343c97cd2c24c5e925291f3


Steven Rostedt (1):
      ftrace: Be first to run code modification on modules

----
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit c1bf08ac26e92122faab9f6c32ea8aba94612dae
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Dec 14 09:48:15 2012 -0500

    ftrace: Be first to run code modification on modules
    
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
    
    Cc: stable@vger.kernel.org
    Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Reported-by: Frank Ch. Eigler <fche@redhat.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3ffe4c5..41473b4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3998,7 +3998,7 @@ static int ftrace_module_notify(struct notifier_block *self,
 
 struct notifier_block ftrace_module_nb = {
 	.notifier_call = ftrace_module_notify,
-	.priority = 0,
+	.priority = INT_MAX,	/* Run before anything that can use kprobes */
 };
 
 extern unsigned long __start_mcount_loc[];


