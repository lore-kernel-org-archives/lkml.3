Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaFQCXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:23:39 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51590 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaFQCX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:23:27 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/8] x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
Date: Mon, 16 Jun 2014 19:23:10 -0700
Message-Id: <2b605c4fcc249bd8d3298863e24d1cf94aed6e90.1402971639.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1402971639.git.luto@amacapital.net>
References: <cover.1402971639.git.luto@amacapital.net>
In-Reply-To: <cover.1402971639.git.luto@amacapital.net>
References: <cover.1402971639.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see no point in having an unusable read-only page sitting at
0xffffffffff600000 when vsyscall=none.  Instead, skip mapping it and
remove it from /proc/PID/maps.

I kept the ratelimited warning when programs try to use a vsyscall
in this mode, since it may help admins avoid confusion.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 420c468..6463f9e 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -309,6 +309,8 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 	if (!mm || mm->context.ia32_compat)
 		return NULL;
 #endif
+	if (vsyscall_mode == NONE)
+		return NULL;
 	return &gate_vma;
 }
 
@@ -329,7 +331,7 @@ int in_gate_area(struct mm_struct *mm, unsigned long addr)
  */
 int in_gate_area_no_mm(unsigned long addr)
 {
-	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
+	return vsyscall_mode != NONE && (addr & PAGE_MASK) == VSYSCALL_ADDR;
 }
 
 /*
@@ -380,10 +382,12 @@ void __init map_vsyscall(void)
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
-- 
1.9.3

