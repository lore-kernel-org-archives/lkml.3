Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162133Ab3LFNFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:05:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44748 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238Ab3LFNFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kevin Hao <haokexin@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 250/272] ftrace/x86: skip over the breakpoint for ftrace caller
Date: Fri,  6 Dec 2013 12:58:59 +0000
Message-Id: <1386334761-25517-251-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit ab4ead02ec235d706d0611d8741964628291237e upstream.

In commit 8a4d0a687a59 "ftrace: Use breakpoint method to update ftrace
caller", we choose to use breakpoint method to update the ftrace
caller. But we also need to skip over the breakpoint in function
ftrace_int3_handler() for them. Otherwise weird things would happen.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/ftrace.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 42a392a..d4bdd25 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -248,6 +248,15 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
+static int is_ftrace_caller(unsigned long ip)
+{
+	if (ip == (unsigned long)(&ftrace_call) ||
+		ip == (unsigned long)(&ftrace_regs_call))
+		return 1;
+
+	return 0;
+}
+
 /*
  * A breakpoint was added to the code address we are about to
  * modify, and this is the handle that will just skip over it.
@@ -257,10 +266,13 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
  */
 int ftrace_int3_handler(struct pt_regs *regs)
 {
+	unsigned long ip;
+
 	if (WARN_ON_ONCE(!regs))
 		return 0;
 
-	if (!ftrace_location(regs->ip - 1))
+	ip = regs->ip - 1;
+	if (!ftrace_location(ip) && !is_ftrace_caller(ip))
 		return 0;
 
 	regs->ip += MCOUNT_INSN_SIZE - 1;
-- 
1.8.3.2

