Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967427Ab3HIB6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967347Ab3HIB61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 008/102] ARM: make vectors page inaccessible from userspace
Date: Thu,  8 Aug 2013 18:56:44 -0700
Message-Id: <20130809015012.154316979@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit a5463cd3435475386cbbe7b06e01292ac169d36f upstream.

If kuser helpers are not provided by the kernel, disable user access to
the vectors page.  With the kuser helpers gone, there is no reason for
this page to be visible to userspace.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/page.h |    2 ++
 arch/arm/kernel/process.c   |    7 ++++++-
 arch/arm/mm/mmu.c           |    4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -142,7 +142,9 @@ extern void __cpu_copy_user_highpage(str
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 extern void copy_page(void *to, const void *from);
 
+#ifdef CONFIG_KUSER_HELPERS
 #define __HAVE_ARCH_GATE_AREA 1
+#endif
 
 #ifdef CONFIG_ARM_LPAE
 #include <asm/pgtable-3level-types.h>
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -433,6 +433,7 @@ unsigned long arch_randomize_brk(struct
 }
 
 #ifdef CONFIG_MMU
+#ifdef CONFIG_KUSER_HELPERS
 /*
  * The vectors page is always readable from user space for the
  * atomic helpers. Insert it into the gate_vma so that it is visible
@@ -465,10 +466,14 @@ int in_gate_area_no_mm(unsigned long add
 {
 	return in_gate_area(NULL, addr);
 }
+#define is_gate_vma(vma)	((vma) = &gate_vma)
+#else
+#define is_gate_vma(vma)	0
+#endif
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
-	return (vma == &gate_vma) ? "[vectors]" :
+	return is_gate_vma(vma) ? "[vectors]" :
 		(vma->vm_mm && vma->vm_start == vma->vm_mm->context.sigpage) ?
 		 "[sigpage]" : NULL;
 }
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1220,7 +1220,11 @@ static void __init devicemaps_init(struc
 	map.pfn = __phys_to_pfn(virt_to_phys(vectors));
 	map.virtual = 0xffff0000;
 	map.length = PAGE_SIZE;
+#ifdef CONFIG_KUSER_HELPERS
 	map.type = MT_HIGH_VECTORS;
+#else
+	map.type = MT_LOW_VECTORS;
+#endif
 	create_mapping(&map);
 
 	if (!vectors_high()) {


