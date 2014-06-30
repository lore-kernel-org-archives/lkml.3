Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaF3MDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:03:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52044 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/181] ftrace/x86: Call text_ip_addr() instead of the duplicated code
Date: Mon, 30 Jun 2014 13:50:31 +0200
Message-Id: <38a572d05464baa6f1d12cd351c4e7f1ec7055aa.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Mladek <pmladek@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 964f7b6b785651a75ef1cbad43a393ca52d4b4f7 upstream.

I just went over this when looking at some Xen-related ftrace initialization
problems. They were related to Xen code that is not upstream but this clean up
would make sense here.

I think that this was already the intention when text_ip_addr() was introduced
in the commit 87fbb2ac6073a703930 (ftrace/x86: Use breakpoints for converting
function graph caller). Anyway, better do it now before it shots people into
their leg ;-)

Link: http://lkml.kernel.org/p/1401812601-2359-1-git-send-email-pmladek@suse.cz

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/ftrace.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1ffc32dbe450..f8ab203fb676 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -297,16 +297,7 @@ int ftrace_int3_handler(struct pt_regs *regs)
 
 static int ftrace_write(unsigned long ip, const char *val, int size)
 {
-	/*
-	 * On x86_64, kernel text mappings are mapped read-only with
-	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
-	 * of the kernel text mapping to modify the kernel text.
-	 *
-	 * For 32bit kernels, these mappings are same and we can use
-	 * kernel identity mapping to modify code.
-	 */
-	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa_symbol(ip));
+	ip = text_ip_addr(ip);
 
 	return probe_kernel_write((void *)ip, val, size);
 }
-- 
2.0.0

