Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbaELPNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:13:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51633 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758798AbaELPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:08 -0400
Message-Id: <20140512151204.308501183@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 11/13] ftrace: Use the ftrace_addr helper functions to find the ftrace_addr
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0011-ftrace-Use-the-ftrace_addr-helper-functions-to-find-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

With the moving of the functions that determine what the mcount call site
should be replaced with into the generic code, there is a few places
in the generic code that can use them instead of hard coding it as it
does.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e825fde..52c2b53 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1798,12 +1798,12 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	unsigned long ftrace_addr;
 	int ret;
 
-	ret = ftrace_update_record(rec, enable);
+	ftrace_addr = ftrace_get_addr_new(rec);
 
-	if (rec->flags & FTRACE_FL_REGS)
-		ftrace_addr = (unsigned long)FTRACE_REGS_ADDR;
-	else
-		ftrace_addr = (unsigned long)FTRACE_ADDR;
+	/* This needs to be done before we call ftrace_update_record */
+	ftrace_old_addr = ftrace_get_addr_curr(rec);
+
+	ret = ftrace_update_record(rec, enable);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
@@ -1817,11 +1817,6 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 
 	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
-		if (rec->flags & FTRACE_FL_REGS)
-			ftrace_old_addr = (unsigned long)FTRACE_ADDR;
-		else
-			ftrace_old_addr = (unsigned long)FTRACE_REGS_ADDR;
-
 		return ftrace_modify_call(rec, ftrace_old_addr, ftrace_addr);
 	}
 
-- 
1.8.5.3


