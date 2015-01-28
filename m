Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761168AbbA1ERk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:17:40 -0500
Received: from mail.kernel.org ([198.145.29.136]:38161 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761139AbbA1ERh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:17:37 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 044/177] x86: Reject x32 executables if x32 ABI not supported
Date: Wed, 28 Jan 2015 12:07:35 +0800
Message-Id: <1422418236-12852-88-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 0e6d3112a4e95d55cf6dca88f298d5f4b8f29bd1 upstream.

It is currently possible to execve() an x32 executable on an x86_64
kernel that has only ia32 compat enabled.  However all its syscalls
will fail, even _exit().  This usually causes it to segfault.

Change the ELF compat architecture check so that x32 executables are
rejected if we don't support the x32 ABI.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Link: http://lkml.kernel.org/r/1410120305.6822.9.camel@decadent.org.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/include/asm/elf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 5939f44..06ec1fe 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -155,8 +155,9 @@ do {						\
 #define elf_check_arch(x)			\
 	((x)->e_machine == EM_X86_64)
 
-#define compat_elf_check_arch(x)		\
-	(elf_check_arch_ia32(x) || (x)->e_machine == EM_X86_64)
+#define compat_elf_check_arch(x)					\
+	(elf_check_arch_ia32(x) ||					\
+	 (IS_ENABLED(CONFIG_X86_X32_ABI) && (x)->e_machine == EM_X86_64))
 
 #if __USER32_DS != __USER_DS
 # error "The following code assumes __USER32_DS == __USER_DS"
-- 
1.9.1

