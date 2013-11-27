Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab3K0BsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:48:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3K0A5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kevin Hao <haokexin@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.10 58/80] ftrace/x86: skip over the breakpoint for ftrace caller
Date: Tue, 26 Nov 2013 16:57:27 -0800
Message-Id: <20131127005644.971606212@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit ab4ead02ec235d706d0611d8741964628291237e upstream.

In commit 8a4d0a687a59 "ftrace: Use breakpoint method to update ftrace
caller", we choose to use breakpoint method to update the ftrace
caller. But we also need to skip over the breakpoint in function
ftrace_int3_handler() for them. Otherwise weird things would happen.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ftrace.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -248,6 +248,15 @@ int ftrace_update_ftrace_func(ftrace_fun
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
@@ -257,10 +266,13 @@ int ftrace_update_ftrace_func(ftrace_fun
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


