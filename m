Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaCTHqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:46:20 -0400
Received: from www84.your-server.de ([213.133.104.84]:38577 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaCTHqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:46:18 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] x86, vdso32: fix out of memory handling setup vDSO
Date: Thu, 20 Mar 2014 08:45:11 +0100
Message-Id: <1395301511-5908-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a correct out of memory handling for setup a 32 bit vDSO.

The patch is against tip commit 4e40112c4ff6a577dd06d92b2a54cdf06265bf74

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vdso32-setup.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0bc363a..e1171c2 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -134,8 +134,14 @@ int __init sysenter_setup(void)
 	}
 
 	vdso32_size = (vdso_len + PAGE_SIZE - 1) / PAGE_SIZE;
-	vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC); 
+
+	vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC);
+	if (!vdso32_pages)
+		goto fail;
+
 	vdso_pages = kmalloc(VDSO_OFFSET(vdso32_size), GFP_ATOMIC);
+	if (!vdso_pages)
+		goto fail;
 
 	for(i = 0; i != vdso32_size; ++i)
 		vdso32_pages[i] = virt_to_page(vdso_pages + VDSO_OFFSET(i));
@@ -144,6 +150,12 @@ int __init sysenter_setup(void)
 	patch_vdso32(vdso_pages, vdso_len);
 
 	return 0;
+fail:
+	kfree(vdso32_pages);
+	kfree(vdso_pages);
+	vdso32_size = 0;
+
+	return -ENOMEM;
 }
 
 /* Setup a VMA at program startup for the vsyscall page */
@@ -162,6 +174,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	if (vdso_enabled != 1)  /* Other values all mean "disabled" */
 		return 0;
 
+	if (!vdso32_size)
+		return 0;
+
 	down_write(&mm->mmap_sem);
 
 	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
-- 
1.9.0

