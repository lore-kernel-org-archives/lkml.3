Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbaEMJ61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:58:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60833 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760078AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/182] ftrace/x86: One more missing sync after fixup of function modification failure
Date: Tue, 13 May 2014 11:26:42 +0200
Message-Id: <121986537bd1b4add6ea6dd248b84cf35addf81d.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Mladek <pmladek@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e6253195a301..1ffc32dbe450 100644
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
1.9.3

