Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaCLWwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:52:04 -0400
Received: from www84.your-server.de ([213.133.104.84]:55109 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaCLWwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:52:01 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
Date: Wed, 12 Mar 2014 23:51:20 +0100
Message-Id: <1394664680-17799-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394664680-17799-1-git-send-email-stefani@seibold.net>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables 32 bit vDSO which are larger than a page. Currently
two pages are reserved, this should be enough for future improvements.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/fixmap.h |  4 +++-
 arch/x86/vdso/vdso32-setup.c  | 29 +++++++++++++++++++----------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 094d0cc..f513f14 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -43,6 +43,8 @@ extern unsigned long __FIXADDR_TOP;
 
 #define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
 #define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
+
+#define MAX_VDSO_PAGES	2
 #else
 #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
 
@@ -74,7 +76,7 @@ extern unsigned long __FIXADDR_TOP;
 enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
-	FIX_VDSO,
+	FIX_VDSO = MAX_VDSO_PAGES,
 	VVAR_PAGE,
 	VSYSCALL_HPET,
 #else
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 1a9f8c3..aa785f0 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -190,7 +191,8 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 	}
 }
 
-static struct page *vdso32_pages[VDSO_PAGES];
+static struct page *vdso32_pages[MAX_VDSO_PAGES];
+static unsigned int vdso32_size;
 
 #ifdef CONFIG_X86_64
 
@@ -256,6 +258,7 @@ static int __init gate_vma_init(void)
 static void map_compat_vdso(int map)
 {
 	static int vdso_mapped;
+	unsigned int i;
 
 	if (map == vdso_mapped)
 		return;
@@ -267,7 +270,8 @@ static void map_compat_vdso(int map)
 
 	__set_fixmap(VVAR_PAGE, __pa_symbol(&__vvar_page), PAGE_KERNEL_VVAR);
 
-	__set_fixmap(FIX_VDSO, page_to_pfn(vdso32_pages[0]) << PAGE_SHIFT,
+	for(i = 0; i != vdso32_size; ++i)
+		__set_fixmap(FIX_VDSO, page_to_pfn(vdso32_pages[i]) << PAGE_SHIFT,
 		     map ? PAGE_READONLY_EXEC : PAGE_NONE);
 
 	/* flush stray tlbs */
@@ -278,11 +282,10 @@ static void map_compat_vdso(int map)
 
 int __init sysenter_setup(void)
 {
-	void *vdso_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	void *vdso_pages;
 	const void *vdso;
 	size_t vdso_len;
-
-	vdso32_pages[0] = virt_to_page(vdso_page);
+	unsigned int i;
 
 #ifdef CONFIG_X86_32
 	gate_vma_init();
@@ -299,9 +302,15 @@ int __init sysenter_setup(void)
 		vdso_len = &vdso32_int80_end - &vdso32_int80_start;
 	}
 
-	memcpy(vdso_page, vdso, vdso_len);
-	patch_vdso32(vdso_page, vdso_len);
-	relocate_vdso(vdso_page);
+	vdso32_size = (vdso_len + PAGE_SIZE - 1) / PAGE_SIZE;
+	vdso_pages = kmalloc(VDSO_OFFSET(vdso32_size), GFP_ATOMIC);
+
+	for(i = 0; i != vdso32_size; ++i)
+		vdso32_pages[i] = virt_to_page(vdso_pages + VDSO_OFFSET(i));
+
+	memcpy(vdso_pages, vdso, vdso_len);
+	patch_vdso32(vdso_pages, vdso_len);
+	relocate_vdso(vdso_pages);
 
 	return 0;
 }
@@ -334,7 +343,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (compat)
 		addr = VDSO_HIGH_BASE;
 	else {
-		addr = get_unmapped_area(NULL, 0, VDSO_OFFSET(VDSO_PAGES), 0, 0);
+		addr = get_unmapped_area(NULL, 0, VDSO_OFFSET(VDSO_PREV_PAGES + vdso32_size), 0, 0);
 		if (IS_ERR_VALUE(addr)) {
 			ret = addr;
 			goto up_fail;
@@ -351,7 +360,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		 */
 		ret = install_special_mapping(mm,
 				addr,
-				VDSO_OFFSET(VDSO_PAGES - VDSO_PREV_PAGES),
+				VDSO_OFFSET(vdso32_size),
 				VM_READ|VM_EXEC|
 				VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				vdso32_pages);
-- 
1.9.0

