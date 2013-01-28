Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3A1QoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:44:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34038 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab3A1Qmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:42:53 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 06/15] x86: Lock down IO port access in secure boot environments
Date: Mon, 28 Jan 2013 11:42:30 -0500
Message-Id: <1359391359-25783-7-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO port access would permit users to gain access to PCI configuration
registers, which in turn (on a lot of hardware) give access to MMIO register
space. This would potentially permit root to trigger arbitrary DMA, so lock
it down by default.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/kernel/ioport.c | 4 ++--
 drivers/char/mem.c       | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 8c96897..a2578c4 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -28,7 +28,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
+	if (turn_on && (!capable(CAP_SYS_RAWIO) || !capable(CAP_COMPROMISE_KERNEL)))
 		return -EPERM;
 
 	/*
@@ -102,7 +102,7 @@ long sys_iopl(unsigned int level, struct pt_regs *regs)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
 	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
+		if (!capable(CAP_SYS_RAWIO) || !capable(CAP_COMPROMISE_KERNEL))
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index c6fa3bc..fc28099 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -597,6 +597,9 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	unsigned long i = *ppos;
 	const char __user * tmp = buf;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
-- 
1.8.0.2

