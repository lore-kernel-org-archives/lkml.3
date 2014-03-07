Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaCGPRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:17:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:47773 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752133AbaCGPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:04 -0500
Message-Id: <20140307151201.587437878@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 04/20] ftrace/x86: Have ftrace_write() return -EPERM and clean up callers
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-ftrace-x86-Have-ftrace_write-return-EPERM-and-clean-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Having ftrace_write() return -EPERM on failure, as that's what the callers
return, then we can clean up the code a bit. That is, instead of:

  if (ftrace_write(...))
     return -EPERM;
  return 0;

or

  if (ftrace_write(...)) {
     ret = -EPERM;
     goto_out;
  }

We can instead have:

  return ftrace_write(...);

or

  ret = ftrace_write(...);
  if (ret)
    goto out;

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 69885e2..8cabf63 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -308,7 +308,10 @@ static int ftrace_write(unsigned long ip, const char *val, int size)
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
 		ip = (unsigned long)__va(__pa_symbol(ip));
 
-	return probe_kernel_write((void *)ip, val, size);
+	if (probe_kernel_write((void *)ip, val, size))
+		return -EPERM;
+
+	return 0;
 }
 
 static int add_break(unsigned long ip, const char *old)
@@ -323,10 +326,7 @@ static int add_break(unsigned long ip, const char *old)
 	if (memcmp(replaced, old, MCOUNT_INSN_SIZE) != 0)
 		return -EINVAL;
 
-	if (ftrace_write(ip, &brk, 1))
-		return -EPERM;
-
-	return 0;
+	return ftrace_write(ip, &brk, 1);
 }
 
 static int add_brk_on_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -463,9 +463,7 @@ static int add_update_code(unsigned long ip, unsigned const char *new)
 	/* skip breakpoint */
 	ip++;
 	new++;
-	if (ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1))
-		return -EPERM;
-	return 0;
+	return ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1);
 }
 
 static int add_update_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -520,10 +518,7 @@ static int finish_update_call(struct dyn_ftrace *rec, unsigned long addr)
 
 	new = ftrace_call_replace(ip, addr);
 
-	if (ftrace_write(ip, new, 1))
-		return -EPERM;
-
-	return 0;
+	return ftrace_write(ip, new, 1);
 }
 
 static int finish_update_nop(struct dyn_ftrace *rec)
@@ -533,9 +528,7 @@ static int finish_update_nop(struct dyn_ftrace *rec)
 
 	new = ftrace_nop_replace();
 
-	if (ftrace_write(ip, new, 1))
-		return -EPERM;
-	return 0;
+	return ftrace_write(ip, new, 1);
 }
 
 static int finish_update(struct dyn_ftrace *rec, int enable)
@@ -656,10 +649,6 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 	run_sync();
 
 	ret = ftrace_write(ip, new_code, 1);
-	if (ret) {
-		ret = -EPERM;
-		goto out;
-	}
  out:
 	run_sync();
 	return ret;
-- 
1.8.5.3


