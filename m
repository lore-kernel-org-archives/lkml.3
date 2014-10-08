Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaJHJVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:21:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaJHJVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:21:53 -0400
Date: Wed, 8 Oct 2014 02:21:29 -0700
From: tip-bot for Ben Hutchings <tipbot@zytor.com>
Message-ID: <tip-0e6d3112a4e95d55cf6dca88f298d5f4b8f29bd1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, ben@decadent.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, ben@decadent.org.uk
In-Reply-To: <1410120305.6822.9.camel@decadent.org.uk>
References: <1410120305.6822.9.camel@decadent.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Reject x32 executables if x32 ABI not supported
Git-Commit-ID: 0e6d3112a4e95d55cf6dca88f298d5f4b8f29bd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e6d3112a4e95d55cf6dca88f298d5f4b8f29bd1
Gitweb:     http://git.kernel.org/tip/0e6d3112a4e95d55cf6dca88f298d5f4b8f29bd1
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Sun, 7 Sep 2014 21:05:05 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 8 Oct 2014 11:17:42 +0200

x86: Reject x32 executables if x32 ABI not supported

It is currently possible to execve() an x32 executable on an x86_64
kernel that has only ia32 compat enabled.  However all its syscalls
will fail, even _exit().  This usually causes it to segfault.

Change the ELF compat architecture check so that x32 executables are
rejected if we don't support the x32 ABI.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Link: http://lkml.kernel.org/r/1410120305.6822.9.camel@decadent.org.uk
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/elf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 1a055c8..ca3347a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -160,8 +160,9 @@ do {						\
 #define elf_check_arch(x)			\
 	((x)->e_machine == EM_X86_64)
 
-#define compat_elf_check_arch(x)		\
-	(elf_check_arch_ia32(x) || (x)->e_machine == EM_X86_64)
+#define compat_elf_check_arch(x)					\
+	(elf_check_arch_ia32(x) ||					\
+	 (IS_ENABLED(CONFIG_X86_X32_ABI) && (x)->e_machine == EM_X86_64))
 
 #if __USER32_DS != __USER_DS
 # error "The following code assumes __USER32_DS == __USER_DS"
