Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaEGNOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:14:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbaEGNOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Petr Mladek <pmladek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 41/70] ftrace/x86: One more missing sync after fixup of function modification failure
Date: Wed,  7 May 2014 14:12:44 +0100
Message-Id: <1399468393-10140-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Mladek <pmladek@suse.cz>

commit 12729f14d8357fb845d75155228b21e76360272d upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e625319..1ffc32d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -659,8 +659,8 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 		ret = -EPERM;
 		goto out;
 	}
-	run_sync();
  out:
+	run_sync();
 	return ret;
 
  fail_update:
-- 
1.9.1

