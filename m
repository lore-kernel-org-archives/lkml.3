Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaCQW1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:27:11 -0400
Received: from www84.your-server.de ([213.133.104.84]:39085 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaCQW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:27:09 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v23 13/13] x86, vdso32: handle 32 bit vDSO larger one page
Date: Mon, 17 Mar 2014 23:22:13 +0100
Message-Id: <1395094933-14252-14-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395094933-14252-1-git-send-email-stefani@seibold.net>
References: <1395094933-14252-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables 32 bit vDSO which are larger than a page.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vdso32-setup.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e10abdf..0bc363a 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -69,7 +70,8 @@ __setup_param("vdso=", vdso32_setup, vdso_setup, 0);
 EXPORT_SYMBOL_GPL(vdso_enabled);
 #endif
 
-static struct page *vdso32_pages[1];
+static struct page **vdso32_pages;
+static unsigned int vdso32_size;
 
 #ifdef CONFIG_X86_64
 
@@ -115,11 +117,10 @@ void enable_sep_cpu(void)
 
 int __init sysenter_setup(void)
 {
-	void *vdso_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	void *vdso_pages;
 	const void *vdso;
 	size_t vdso_len;
-
-	vdso32_pages[0] = virt_to_page(vdso_page);
+	unsigned int i;
 
 	if (vdso32_syscall()) {
 		vdso = &vdso32_syscall_start;
@@ -132,8 +133,15 @@ int __init sysenter_setup(void)
 		vdso_len = &vdso32_int80_end - &vdso32_int80_start;
 	}
 
-	memcpy(vdso_page, vdso, vdso_len);
-	patch_vdso32(vdso_page, vdso_len);
+	vdso32_size = (vdso_len + PAGE_SIZE - 1) / PAGE_SIZE;
+	vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC); 
+	vdso_pages = kmalloc(VDSO_OFFSET(vdso32_size), GFP_ATOMIC);
+
+	for(i = 0; i != vdso32_size; ++i)
+		vdso32_pages[i] = virt_to_page(vdso_pages + VDSO_OFFSET(i));
+
+	memcpy(vdso_pages, vdso, vdso_len);
+	patch_vdso32(vdso_pages, vdso_len);
 
 	return 0;
 }
@@ -169,7 +177,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	 */
 	ret = install_special_mapping(mm,
 			addr,
-			VDSO_OFFSET(VDSO_PAGES - VDSO_PREV_PAGES),
+			VDSO_OFFSET(vdso32_size),
 			VM_READ|VM_EXEC|
 			VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 			vdso32_pages);
-- 
1.9.0

