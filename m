Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaJ0TEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:04:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52866 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaJ0TEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 082/105] x86: Reject x32 executables if x32 ABI not supported
Date: Mon, 27 Oct 2014 11:56:57 -0700
Message-Id: <1414436240-13879-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 0e6d3112a4e95d55cf6dca88f298d5f4b8f29bd1 upstream.

It is currently possible to execve() an x32 executable on an x86_64
kernel that has only ia32 compat enabled.  However all its syscalls
will fail, even _exit().  This usually causes it to segfault.

Change the ELF compat architecture check so that x32 executables are
rejected if we don't support the x32 ABI.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Link: http://lkml.kernel.org/r/1410120305.6822.9.camel@decadent.org.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/elf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 9c999c1..01f15b2 100644
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

