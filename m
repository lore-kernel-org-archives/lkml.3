Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaCWQjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 12:39:10 -0400
Received: from www84.your-server.de ([213.133.104.84]:48610 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaCWQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 12:39:08 -0400
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] x86, vdso: fix size of get_unmapped_area()
Date: Sun, 23 Mar 2014 17:38:14 +0100
Message-Id: <1395592694-20571-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.1
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the reserved memory for a 32 bit vdso must be the size of the
32 bit vDSO in pages + HPET page + VVAR page.

One page is not enough for this. Grrrr.... silly copy and paste bug,
was right in previous patch.

The patch is against 3c1b63b9e4862fb16352a0646439c2dd6d9e0e5c

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vdso32-setup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 791c1cb..0034898 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -165,12 +165,14 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	down_write(&mm->mmap_sem);
 
-	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+	addr = get_unmapped_area(NULL, 0, vdso32_size + VDSO_OFFSET(VDSO_PREV_PAGES), 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 
+	addr += VDSO_OFFSET(VDSO_PREV_PAGES);
+
 	current->mm->context.vdso = (void *)addr;
 
 	/*
-- 
1.9.1

