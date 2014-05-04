Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaEDQLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:11:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaEDPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Petr Mladek <pmladek@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.10 35/86] ftrace/x86: One more missing sync after fixup of function modification failure
Date: Sun,  4 May 2014 11:41:10 -0400
Message-Id: <20140504154145.163583374@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -659,8 +659,8 @@ ftrace_modify_code(unsigned long ip, uns
 		ret = -EPERM;
 		goto out;
 	}
-	run_sync();
  out:
+	run_sync();
 	return ret;
 
  fail_update:


