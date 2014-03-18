Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbaCRVan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:30:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbaCRVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:30:38 -0400
Date: Tue, 18 Mar 2014 14:30:08 -0700
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-4e40112c4ff6a577dd06d92b2a54cdf06265bf74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1395094933-14252-14-git-send-email-stefani@seibold.net>
References: <1395094933-14252-14-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso32: handle 32 bit vDSO larger one page
Git-Commit-ID: 4e40112c4ff6a577dd06d92b2a54cdf06265bf74
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

Commit-ID:  4e40112c4ff6a577dd06d92b2a54cdf06265bf74
Gitweb:     http://git.kernel.org/tip/4e40112c4ff6a577dd06d92b2a54cdf06265bf74
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon, 17 Mar 2014 23:22:13 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Mar 2014 12:52:54 -0700

x86, vdso32: handle 32 bit vDSO larger one page

This patch enables 32 bit vDSO which are larger than a page.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1395094933-14252-14-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso32-setup.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e10abdf..5b4aaef 100644
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
