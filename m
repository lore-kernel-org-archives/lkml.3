Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaKCUtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:49:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaKCUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:49:09 -0500
Date: Mon, 3 Nov 2014 12:48:33 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-87983c66bc02c9cd8e4a42e7924435145d52bb13@git.kernel.org>
Cc: konrad.wilk@oracle.com, hpa@zytor.com, luto@amacapital.net,
        mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Reply-To: linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        mingo@kernel.org, konrad.wilk@oracle.com, luto@amacapital.net,
        hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <0dddbadc1d4e3bfbaf887938ff42afc97a7cc1f2.1414618407.git.luto@amacapital.net>
References: <0dddbadc1d4e3bfbaf887938ff42afc97a7cc1f2.1414618407.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64, vsyscall:
  Turn vsyscalls all the way off when vsyscall==none
Git-Commit-ID: 87983c66bc02c9cd8e4a42e7924435145d52bb13
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

Commit-ID:  87983c66bc02c9cd8e4a42e7924435145d52bb13
Gitweb:     http://git.kernel.org/tip/87983c66bc02c9cd8e4a42e7924435145d52bb13
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 29 Oct 2014 14:33:45 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 21:44:57 +0100

x86_64, vsyscall: Turn vsyscalls all the way off when vsyscall==none

I see no point in having an unusable read-only page sitting at
0xffffffffff600000 when vsyscall=none. Instead, skip mapping it and
remove it from /proc/PID/maps.

I kept the ratelimited warning when programs try to use a vsyscall
in this mode, since it may help admins avoid confusion.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/0dddbadc1d4e3bfbaf887938ff42afc97a7cc1f2.1414618407.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/vsyscall_64.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 419e83b..2d91262 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -307,6 +307,8 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 	if (!mm || mm->context.ia32_compat)
 		return NULL;
 #endif
+	if (vsyscall_mode == NONE)
+		return NULL;
 	return &gate_vma;
 }
 
@@ -327,7 +329,7 @@ int in_gate_area(struct mm_struct *mm, unsigned long addr)
  */
 int in_gate_area_no_mm(unsigned long addr)
 {
-	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
+	return vsyscall_mode != NONE && (addr & PAGE_MASK) == VSYSCALL_ADDR;
 }
 
 void __init map_vsyscall(void)
@@ -335,10 +337,12 @@ void __init map_vsyscall(void)
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
 
-	__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
-		     vsyscall_mode == NATIVE
-		     ? PAGE_KERNEL_VSYSCALL
-		     : PAGE_KERNEL_VVAR);
+	if (vsyscall_mode != NONE)
+		__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
+			     vsyscall_mode == NATIVE
+			     ? PAGE_KERNEL_VSYSCALL
+			     : PAGE_KERNEL_VVAR);
+
 	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_PAGE) !=
 		     (unsigned long)VSYSCALL_ADDR);
 }
