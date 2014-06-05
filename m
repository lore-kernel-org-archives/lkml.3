Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaFEPVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:21:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:63168 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752451AbaFEPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:21:17 -0400
Message-Id: <20140605152113.903071335@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 11:15:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 2/5] ftrace/x86: Call text_ip_addr() instead of the duplicated code
References: <20140605151540.672365024@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ftrace-x86-Call-text_ip_addr-instead-of-the-duplicat.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Mladek <pmladek@suse.cz>

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
---
 arch/x86/kernel/ftrace.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 89de3eaf8772..cbc4a91b131e 100644
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
 
 	if (probe_kernel_write((void *)ip, val, size))
 		return -EPERM;
-- 
2.0.0.rc2


