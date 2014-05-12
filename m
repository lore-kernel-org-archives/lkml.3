Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbaELPN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:13:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:21054 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758743AbaELPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:07 -0400
Message-Id: <20140512151204.025712167@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 09/13] ftrace/x86: Get the current mcount addr for add_breakpoint()
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0009-ftrace-x86-Get-the-current-mcount-addr-for-add_break.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The add_breakpoint() code in the ftrace updating gets the address
of what the call will become, but if the mcount address is changing
from regs to non-regs ftrace_caller or vice versa, it will use what
the record currently is.

This is rather silly as the code should always use what is currently
there regardless of if it's changing the regs function or just converting
to a nop.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3d837b0..4b3c195 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -380,9 +380,9 @@ static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 	unsigned long ftrace_addr;
 	int ret;
 
-	ret = ftrace_test_record(rec, enable);
+	ftrace_addr = get_ftrace_old_addr(rec);
 
-	ftrace_addr = get_ftrace_addr(rec);
+	ret = ftrace_test_record(rec, enable);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
@@ -394,8 +394,6 @@ static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 
 	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
-		ftrace_addr = get_ftrace_old_addr(rec);
-		/* fall through */
 	case FTRACE_UPDATE_MAKE_NOP:
 		/* converting a call to a nop */
 		return add_brk_on_call(rec, ftrace_addr);
-- 
1.8.5.3


