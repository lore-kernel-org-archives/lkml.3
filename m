Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaAJDvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:51:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaAJDvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:51:20 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 1/6] x86/mm: sparse warning fix for early_memremap
Date: Thu,  9 Jan 2014 22:50:28 -0500
Message-Id: <1389325833-16535-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1389325833-16535-1-git-send-email-msalter@redhat.com>
References: <1389325833-16535-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <dyoung@redhat.com>

There's a lot of sparse warnings for code like below:
void *a = early_memremap(phys_addr, size);

early_memremap intend to map kernel memory with ioremap facility, the return
pointer should be a kernel ram pointer instead of iomem one.

For making the function clearer and supressing sparse warnings this patch
do below two things:
1. cast to (__force void *) for the return value of early_memremap
2. add early_memunmap function and pass (__force void __iomem *) to iounmap

>From Boris:
> Ingo told me yesterday, it makes sense too. I'd guess we can try it.
> FWIW, all callers of early_memremap use the memory they get remapped as
> normal memory so we should be safe.

Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/x86/include/asm/io.h |  3 ++-
 arch/x86/mm/ioremap.c     | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb..1db414f 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -325,9 +325,10 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(resource_size_t phys_addr,
 				   unsigned long size);
-extern void __iomem *early_memremap(resource_size_t phys_addr,
+extern void *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void early_memunmap(void *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 799580c..bbb4504 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -562,10 +562,9 @@ early_ioremap(resource_size_t phys_addr, unsigned long size)
 }
 
 /* Remap memory */
-void __init __iomem *
-early_memremap(resource_size_t phys_addr, unsigned long size)
+void __init *early_memremap(resource_size_t phys_addr, unsigned long size)
 {
-	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
+	return (__force void *)__early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void __iomem *addr, unsigned long size)
@@ -620,3 +619,8 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 	}
 	prev_map[slot] = NULL;
 }
+
+void __init early_memunmap(void *addr, unsigned long size)
+{
+	early_iounmap((__force void __iomem *)addr, size);
+}
-- 
1.8.3.1

