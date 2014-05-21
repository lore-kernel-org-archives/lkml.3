Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaEUXWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:22:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaEUXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:22:20 -0400
Date: Wed, 21 May 2014 16:22:09 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-ac49b9a9f26b6c42585f87857722085ef4b19c13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <e681cb56096eee5b8b8767093a4f6fb82839f0a4.1400538962.git.luto@amacapital.net>
References: <e681cb56096eee5b8b8767093a4f6fb82839f0a4.1400538962.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, mm: Replace arch_vma_name with vm_ops->
 name for vsyscalls
Git-Commit-ID: ac49b9a9f26b6c42585f87857722085ef4b19c13
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

Commit-ID:  ac49b9a9f26b6c42585f87857722085ef4b19c13
Gitweb:     http://git.kernel.org/tip/ac49b9a9f26b6c42585f87857722085ef4b19c13
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 19 May 2014 15:58:34 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 May 2014 11:39:31 -0700

x86, mm: Replace arch_vma_name with vm_ops->name for vsyscalls

This removes the last vestiges of arch_vma_name from x86, replacing it
with vm_ops->name.  Good riddance.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/e681cb56096eee5b8b8767093a4f6fb82839f0a4.1400538962.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_64.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9deb59b..bdcde58 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1185,11 +1185,19 @@ int kern_addr_valid(unsigned long addr)
  * covers the 64bit vsyscall page now. 32bit has a real VMA now and does
  * not need special handling anymore:
  */
+static const char *gate_vma_name(struct vm_area_struct *vma)
+{
+	return "[vsyscall]";
+}
+static struct vm_operations_struct gate_vma_ops = {
+	.name = gate_vma_name,
+};
 static struct vm_area_struct gate_vma = {
 	.vm_start	= VSYSCALL_ADDR,
 	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
 	.vm_page_prot	= PAGE_READONLY_EXEC,
-	.vm_flags	= VM_READ | VM_EXEC
+	.vm_flags	= VM_READ | VM_EXEC,
+	.vm_ops		= &gate_vma_ops,
 };
 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
@@ -1221,13 +1229,6 @@ int in_gate_area_no_mm(unsigned long addr)
 	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
 }
 
-const char *arch_vma_name(struct vm_area_struct *vma)
-{
-	if (vma == &gate_vma)
-		return "[vsyscall]";
-	return NULL;
-}
-
 #ifdef CONFIG_X86_UV
 unsigned long memory_block_size_bytes(void)
 {
