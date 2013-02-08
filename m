Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360Ab3BHTM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:12:26 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49396 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760349Ab3BHTMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:12:24 -0500
Date: Fri, 8 Feb 2013 11:12:13 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] x86: Lock down MSR writing in secure boot
Message-ID: <20130208191213.GA25081@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
set since it could lead to execution of arbitrary code in kernel mode.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This would be used on top of Matthew Garrett's existing "Secure boot
policy support" patch series.
---
 arch/x86/kernel/msr.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 4929502..adaab3d 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -103,6 +103,9 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	int err = 0;
 	ssize_t bytes = 0;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (count % 8)
 		return -EINVAL;	/* Invalid chunk size */
 
@@ -150,6 +153,10 @@ static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
 			err = -EBADF;
 			break;
 		}
+		if (!capable(CAP_COMPROMISE_KERNEL)) {
+			err = -EPERM;
+			break;
+		}
 		if (copy_from_user(&regs, uregs, sizeof regs)) {
 			err = -EFAULT;
 			break;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
