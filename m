Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3IKF3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:29:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3IKE5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:24 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0yG17XBjxDgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0uUWFsrF_t0A:10 a=drOt6m5kAAAA:8 a=rOZy-w5a2GWlp-KOJYsA:9 a=jeBq3FmKZ4MA:10 a=fjmxQhJhPmMA:10 a=HZu-ZW16r_oM0FjT:21 a=LZzpSwfLUtYp1P1c:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042913.035142627@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [125/251] ARM: make vectors page inaccessible from userspace
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0125-ARM-make-vectors-page-inaccessible-from-userspace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit a5463cd3435475386cbbe7b06e01292ac169d36f ]

If kuser helpers are not provided by the kernel, disable user access to
the vectors page.  With the kuser helpers gone, there is no reason for
this page to be visible to userspace.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/include/asm/page.h |    2 ++
 arch/arm/kernel/process.c   |    7 ++++++-
 arch/arm/mm/mmu.c           |    4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index ecf9019..5c35852 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -142,7 +142,9 @@ extern void __cpu_copy_user_highpage(struct page *to, struct page *from,
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 extern void copy_page(void *to, const void *from);
 
+#ifdef CONFIG_KUSER_HELPERS
 #define __HAVE_ARCH_GATE_AREA 1
+#endif
 
 #ifdef CONFIG_ARM_LPAE
 #include <asm/pgtable-3level-types.h>
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 693b744..427ddbc 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -508,6 +508,7 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 }
 
 #ifdef CONFIG_MMU
+#ifdef CONFIG_KUSER_HELPERS
 /*
  * The vectors page is always readable from user space for the
  * atomic helpers and the signal restart code. Insert it into the
@@ -540,9 +541,13 @@ int in_gate_area_no_mm(unsigned long addr)
 {
 	return in_gate_area(NULL, addr);
 }
+#define is_gate_vma(vma)	((vma) = &gate_vma)
+#else
+#define is_gate_vma(vma)	0
+#endif
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
-	return (vma == &gate_vma) ? "[vectors]" : NULL;
+	return is_gate_vma(vma) ? "[vectors]" : NULL;
 }
 #endif
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 889f3de..50d4aff 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1125,7 +1125,11 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
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
-- 
1.7.10.4


