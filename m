Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaBZUOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:14:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44121 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaBZULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:11:41 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 04/12] x86: Lock down IO port access when trusted_kernel is true
Date: Wed, 26 Feb 2014 15:11:05 -0500
Message-Id: <1393445473-15068-5-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO port access would permit users to gain access to PCI configuration
registers, which in turn (on a lot of hardware) give access to MMIO register
space. This would potentially permit root to trigger arbitrary DMA, so lock
it down when trusted_kernel is true

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/kernel/ioport.c | 5 +++--
 drivers/char/mem.c       | 7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 4ddaf66..3121541 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -15,6 +15,7 @@
 #include <linux/thread_info.h>
 #include <linux/syscalls.h>
 #include <linux/bitmap.h>
+#include <linux/security.h>
 #include <asm/syscalls.h>
 
 /*
@@ -28,7 +29,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
+	if (turn_on && (!capable(CAP_SYS_RAWIO) || (get_trusted_kernel())))
 		return -EPERM;
 
 	/*
@@ -103,7 +104,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
 	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
+		if (!capable(CAP_SYS_RAWIO) || (get_trusted_kernel()))
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 92c5937..15331a8 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -27,6 +27,7 @@
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/aio.h>
+#include <linux/security.h>
 
 #include <asm/uaccess.h>
 
@@ -544,6 +545,9 @@ static ssize_t read_port(struct file *file, char __user *buf,
 	unsigned long i = *ppos;
 	char __user *tmp = buf;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	if (!access_ok(VERIFY_WRITE, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
@@ -562,6 +566,9 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	unsigned long i = *ppos;
 	const char __user *tmp = buf;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-- 
1.8.5.3

