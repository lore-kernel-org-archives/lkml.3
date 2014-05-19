Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaESW7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:59:02 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51120 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaESW6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:58:48 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/4] x86,mm: Replace arch_vma_name with vm_ops->name for vsyscalls
Date: Mon, 19 May 2014 15:58:34 -0700
Message-Id: <e681cb56096eee5b8b8767093a4f6fb82839f0a4.1400538962.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1400538962.git.luto@amacapital.net>
References: <cover.1400538962.git.luto@amacapital.net>
In-Reply-To: <cover.1400538962.git.luto@amacapital.net>
References: <cover.1400538962.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_vma_name is now completely gone from x86.  Good riddance.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
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
-- 
1.9.0

