Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3KFUAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:00:16 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34912 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3KFUAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:00:14 -0500
From: Marek Majkowski <marek@cloudflare.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH] Wrong symbol resolved for RIP on OOPS/BUG
Date: Wed,  6 Nov 2013 11:59:57 -0800
Message-Id: <1383767997-20765-1-git-send-email-marek@cloudflare.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"%pB" is intended for return addresses, and actually resolves the
address - 1.  So it should only be used for backtraces.  Plain
instruction addresses should use "%pS", which resolves the given
address.

show_regs was using "%pB" to resolve the RIP symbol. This resolved the
wrong symbol if the first instruction after a symbol created the
OOPS/BUG. For example:

0000000000000049 <before>:
  49:   90                      nop
  4a:   90                      nop
  4b:   90                      nop
  4c:   90                      nop
000000000000004d <suicide>:
  4d:   ff 14 25 00 00 00 00    callq  *0x0
  54:   c3                      retq

Will produce a message saying it's "before" that crashed, not "suicide".

This problem only happens when the crash occurs in the first instruction
after a symbol. Therefore it's unlikely to occur on kernels with frame
pointers (CONFIG_FRAME_POINTER=y).

Signed-off-by: Marek Majkowski <marek@cloudflare.com>

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index deb6421..4c90013 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -27,6 +27,12 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
+	pr_cont(" [<%p>] %s%pS\n",
+		(void *)address, reliable ? "" : "? ", (void *)address);
+}
+
+static void printk_trace_address(unsigned long address, int reliable)
+{
 	pr_cont(" [<%p>] %s%pB\n",
 		(void *)address, reliable ? "" : "? ", (void *)address);
 }
@@ -151,7 +157,7 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	touch_nmi_watchdog();
 	printk(data);
-	printk_address(addr, reliable);
+	printk_trace_address(addr, reliable);
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-- 
1.8.3.2

