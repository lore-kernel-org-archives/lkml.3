Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3IFSKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:10:33 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:18473 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3IFSIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:08:53 -0400
From: Linn Crosetto <linn@hp.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@amacapital.net, daniel.vetter@ffwll.ch, airlied@redhat.com,
        yinghai@kernel.org, jacob.shin@amd.com, penberg@kernel.org,
        js1304@gmail.com, akpm@linux-foundation.org, matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [PATCH 1/3] x86/mm: fix sparse warnings from early_memremap()
Date: Fri,  6 Sep 2013 12:06:55 -0600
Message-Id: <1378490817-23272-2-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1378490817-23272-1-git-send-email-linn@hp.com>
References: <5223CA9C.5020505@zytor.com>
 <1378490817-23272-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates consistent early interfaces for mapping normal memory
and eliminates some sparse warnings.

early_memremap() was created to map normal memory, as opposed to the
ioremap interfaces for actual IO mappings, so remove the __iomem
annotation from early_memremap(). In addition, early_memunmap() is added
to provide an interface analogous to early_iounmap() for normal memory.

Fixes the following warnings:

arch/x86/kernel/setup.c:353:19: warning: incorrect type in assignment (different address spaces)
arch/x86/kernel/setup.c:437:22: warning: incorrect type in assignment (different address spaces)
arch/x86/kernel/setup.c:465:22: warning: incorrect type in assignment (different address spaces)
arch/x86/kernel/setup.c:488:22: warning: incorrect type in assignment (different address spaces)
arch/x86/kernel/e820.c:667:15: warning: incorrect type in assignment (different address spaces)

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 arch/x86/include/asm/io.h | 4 ++--
 arch/x86/mm/ioremap.c     | 9 +++++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb..ae1ef3e 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -325,8 +325,8 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(resource_size_t phys_addr,
 				   unsigned long size);
-extern void __iomem *early_memremap(resource_size_t phys_addr,
-				    unsigned long size);
+extern void *early_memremap(resource_size_t phys_addr, unsigned long size);
+extern void early_memunmap(void *addr, unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 extern bool is_early_ioremap_ptep(pte_t *ptep);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 799580c..a144929 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -562,10 +562,15 @@ early_ioremap(resource_size_t phys_addr, unsigned long size)
 }
 
 /* Remap memory */
-void __init __iomem *
+void __init *
 early_memremap(resource_size_t phys_addr, unsigned long size)
 {
-	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
+	return (__force void *)__early_ioremap(phys_addr, size, PAGE_KERNEL);
+}
+
+void __init early_memunmap(void *addr, unsigned long size)
+{
+	early_iounmap((void __iomem *)addr, size);
 }
 
 void __init early_iounmap(void __iomem *addr, unsigned long size)
-- 
1.7.11.3

