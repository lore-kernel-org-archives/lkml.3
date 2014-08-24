Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaHXRJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:09:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:54846 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752841AbaHXRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:08:54 -0400
Message-Id: <20140824170850.349336650@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 24 Aug 2014 13:08:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] ftrace: Use current addr when converting to nop in
 __ftrace_replace_code()
References: <20140824170808.753599145@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-ftrace-Use-current-addr-when-converting-to-nop-in-__.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In __ftrace_replace_code(), when converting the call to a nop in a function
it needs to compare against the "curr" (current) value of the ftrace ops, and
not the "new" one. It currently does not affect x86 which is the only arch
to do the trampolines with function graph tracer, but when other archs that do
depend on this code implement the function graph trampoline, it can crash.

Here's an example when ARM uses the trampolines (in the future):

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 9 at kernel/trace/ftrace.c:1716 ftrace_bug+0x17c/0x1f4()
 Modules linked in: omap_rng rng_core ipv6
 CPU: 0 PID: 9 Comm: migration/0 Not tainted 3.16.0-test-10959-gf0094b28f303-dirty #52
 [<c02188f4>] (unwind_backtrace) from [<c021343c>] (show_stack+0x20/0x24)
 [<c021343c>] (show_stack) from [<c095a674>] (dump_stack+0x78/0x94)
 [<c095a674>] (dump_stack) from [<c02532a0>] (warn_slowpath_common+0x7c/0x9c)
 [<c02532a0>] (warn_slowpath_common) from [<c02532ec>] (warn_slowpath_null+0x2c/0x34)
 [<c02532ec>] (warn_slowpath_null) from [<c02cbac4>] (ftrace_bug+0x17c/0x1f4)
 [<c02cbac4>] (ftrace_bug) from [<c02cc44c>] (ftrace_replace_code+0x80/0x9c)
 [<c02cc44c>] (ftrace_replace_code) from [<c02cc658>] (ftrace_modify_all_code+0xb8/0x164)
 [<c02cc658>] (ftrace_modify_all_code) from [<c02cc718>] (__ftrace_modify_code+0x14/0x1c)
 [<c02cc718>] (__ftrace_modify_code) from [<c02c7244>] (multi_cpu_stop+0xf4/0x134)
 [<c02c7244>] (multi_cpu_stop) from [<c02c6e90>] (cpu_stopper_thread+0x54/0x130)
 [<c02c6e90>] (cpu_stopper_thread) from [<c0271cd4>] (smpboot_thread_fn+0x1ac/0x1bc)
 [<c0271cd4>] (smpboot_thread_fn) from [<c026ddf0>] (kthread+0xe0/0xfc)
 [<c026ddf0>] (kthread) from [<c020f318>] (ret_from_fork+0x14/0x20)
 ---[ end trace dc9ce72c5b617d8f ]---
[   65.047264] ftrace failed to modify [<c0208580>] asm_do_IRQ+0x10/0x1c
[   65.054070]  actual: 85:1b:00:eb

Fixes: 7413af1fb70e7 "ftrace: Make get_ftrace_addr() and get_ftrace_addr_old() global"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 08aca65d709a..5916a8e59e87 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2017,7 +2017,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 		return ftrace_make_call(rec, ftrace_addr);
 
 	case FTRACE_UPDATE_MAKE_NOP:
-		return ftrace_make_nop(NULL, rec, ftrace_addr);
+		return ftrace_make_nop(NULL, rec, ftrace_old_addr);
 
 	case FTRACE_UPDATE_MODIFY_CALL:
 		return ftrace_modify_call(rec, ftrace_old_addr, ftrace_addr);
-- 
2.0.1


