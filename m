Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaCGPMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:12:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:56534 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752049AbaCGPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:03 -0500
Message-Id: <20140307151201.278437431@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 02/20] ftrace/x86: One more missing sync after fixup of function
 modification failure
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-ftrace-x86-One-more-missing-sync-after-fixup-of-func.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Mladek <pmladek@suse.cz>

If a failure occurs while modifying ftrace function, it bails out and will
remove the tracepoints to be back to what the code originally was.

There is missing the final sync run across the CPUs after the fix up is done
and before the ftrace int3 handler flag is reset.

Here's the description of the problem:

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

Link: http://lkml.kernel.org/r/1393258342-29978-2-git-send-email-pmladek@suse.cz

Fixes: 8a4d0a687a5 "ftrace: Use breakpoint method to update ftrace caller"
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 6b566c8..69885e2 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -660,8 +660,8 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 		ret = -EPERM;
 		goto out;
 	}
-	run_sync();
  out:
+	run_sync();
 	return ret;
 
  fail_update:
-- 
1.8.5.3


