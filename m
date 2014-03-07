Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaCGPML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:12:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:48460 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752204AbaCGPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:03 -0500
Message-Id: <20140307151201.132403717@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [for-next][PATCH 01/20] ftrace/x86: Run a sync after fixup on failure
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ftrace-x86-Run-a-sync-after-fixup-on-failure.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If a failure occurs while enabling a trace, it bails out and will remove
the tracepoints to be back to what the code originally was. But the fix
up had some bugs in it. By injecting a failure in the code, the fix up
ran to completion, but shortly afterward the system rebooted.

There was two bugs here.

The first was that there was no final sync run across the CPUs after the
fix up was done, and before the ftrace int3 handler flag was reset. That
means that other CPUs could still see the breakpoint and trigger on it
long after the flag was cleared, and the int3 handler would think it was
a spurious interrupt. Worse yet, the int3 handler could hit other breakpoints
because the ftrace int3 handler flag would have prevented the int3 handler
from going further.

Here's a description of the issue:

	CPU0				CPU1
	----				----
  remove_breakpoint();
  modifying_ftrace_code = 0;

				[still sees breakpoint]
				<takes trap>
				[sees modifying_ftrace_code as zero]
				[no breakpoint handler]
				[goto failed case]
				[trap exception - kernel breakpoint, no
				 handler]
				BUG()

The second bug was that the removal of the breakpoints required the
"within()" logic updates instead of accessing the ip address directly.
As the kernel text is mapped read-only when CONFIG_DEBUG_RODATA is set, and
the removal of the breakpoint is a modification of the kernel text.
The ftrace_write() includes the "within()" logic, where as, the
probe_kernel_write() does not. This prevented the breakpoint from being
removed at all.

Link: http://lkml.kernel.org/r/1392650573-3390-1-git-send-email-pmladek@suse.cz

Reported-by: Petr Mladek <pmladek@suse.cz>
Tested-by: Petr Mladek <pmladek@suse.cz>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e625319..6b566c8 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -455,7 +455,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 	}
 
  update:
-	return probe_kernel_write((void *)ip, &nop[0], 1);
+	return ftrace_write(ip, nop, 1);
 }
 
 static int add_update_code(unsigned long ip, unsigned const char *new)
@@ -634,6 +634,7 @@ void ftrace_replace_code(int enable)
 		rec = ftrace_rec_iter_record(iter);
 		remove_breakpoint(rec);
 	}
+	run_sync();
 }
 
 static int
@@ -664,7 +665,7 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 	return ret;
 
  fail_update:
-	probe_kernel_write((void *)ip, &old_code[0], 1);
+	ftrace_write(ip, old_code, 1);
 	goto out;
 }
 
-- 
1.8.5.3


