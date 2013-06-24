Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3FXN1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:27:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53904 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FXN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:27:03 -0400
From: Christopher Covington <cov@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] ARM: Add support for LPAE style CONTEXTIDR
Date: Mon, 24 Jun 2013 09:26:45 -0400
Message-Id: <1372080405-13365-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the long-descriptor translation table format changes
the layout of the CONTEXTIDR register.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm/mm/context.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index 2ac3737..272c249 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -37,6 +37,11 @@
  *
  * In big endian operation, the two 32 bit words are swapped if accesed by
  * non 64-bit operations.
+ *
+ * The above layout is also used by ARMv7 when the short-descriptor translation
+ * table format is used, but when the long-descriptor translation table format
+ * (LPAE) is used, all 32 bits are devoted to the process identifier. (The ASID
+ * is in TTBRx.)
  */
 #define ASID_FIRST_VERSION	(1ULL << ASID_BITS)
 #define NUM_USER_ASIDS		(ASID_FIRST_VERSION - 1)
@@ -68,6 +73,13 @@ static void cpu_set_reserved_ttbr0(void)
 	: "r" (ttbl), "r" (ttbh));
 	isb();
 }
+
+static void write_contextidr(pid_t pid)
+{
+	asm volatile(
+	"	mcr	p15, 0, %0, c13, c0, 1\n"
+	: : "r" (pid));
+}
 #else
 static void cpu_set_reserved_ttbr0(void)
 {
@@ -79,20 +91,12 @@ static void cpu_set_reserved_ttbr0(void)
 	: "=r" (ttb));
 	isb();
 }
-#endif
 
-#ifdef CONFIG_PID_IN_CONTEXTIDR
-static int contextidr_notifier(struct notifier_block *unused, unsigned long cmd,
-			       void *t)
+static void write_contextidr(pid_t pid)
 {
 	u32 contextidr;
-	pid_t pid;
-	struct thread_info *thread = t;
-
-	if (cmd != THREAD_NOTIFY_SWITCH)
-		return NOTIFY_DONE;
 
-	pid = task_pid_nr(thread->task) << ASID_BITS;
+	pid <<= ASID_BITS;
 	asm volatile(
 	"	mrc	p15, 0, %0, c13, c0, 1\n"
 	"	and	%0, %0, %2\n"
@@ -100,6 +104,19 @@ static int contextidr_notifier(struct notifier_block *unused, unsigned long cmd,
 	"	mcr	p15, 0, %0, c13, c0, 1\n"
 	: "=r" (contextidr), "+r" (pid)
 	: "I" (~ASID_MASK));
+}
+#endif
+
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+static int contextidr_notifier(struct notifier_block *unused, unsigned long cmd,
+			       void *t)
+{
+	struct thread_info *thread = t;
+
+	if (cmd != THREAD_NOTIFY_SWITCH)
+		return NOTIFY_DONE;
+
+	write_contextidr(task_pid_nr(thread->task));
 	isb();
 
 	return NOTIFY_OK;
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

