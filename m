Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab3HSQLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:11:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50000 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3HSQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:11:13 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 09/10] x86: Restrict MSR access when module loading is restricted
Date: Mon, 19 Aug 2013 12:10:18 -0400
Message-Id: <1376928619-3775-9-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing to MSRs should not be allowed if module loading is restricted,
since it could lead to execution of arbitrary code in kernel mode. Based
on a patch by Kees Cook.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/kernel/msr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 88458fa..d08f7e3 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -103,6 +103,9 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	int err = 0;
 	ssize_t bytes = 0;
 
+	if (secure_modules())
+		return -EPERM;
+
 	if (count % 8)
 		return -EINVAL;	/* Invalid chunk size */
 
@@ -150,6 +153,10 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 			err = -EBADF;
 			break;
 		}
+		if (secure_modules()) {
+			err = -EPERM;
+			break;
+		}
 		if (copy_from_user(&regs, uregs, sizeof regs)) {
 			err = -EFAULT;
 			break;
-- 
1.8.3.1

