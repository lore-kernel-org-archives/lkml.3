Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300Ab3E3Lqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:46:40 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39643 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab3E3Lqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:46:31 -0400
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com, rob.herring@calxeda.com,
        catalin.marinas@arm.com, nico@linaro.org, r.sricharan@ti.com,
        Po-Yu Chuang <ratbert.chuang@gmail.com>
Subject: [PATCH v2] ARM: map_init_section flushes incorrect pmd
Date: Thu, 30 May 2013 19:46:00 +0800
Message-Id: <1369914361-4237-1-git-send-email-ratbert.chuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CANutaR_ZHWdXQrZNBN91K==n3taMKBptmyU0+8DT1RzBStNCyA@mail.gmail.com>
References: <CANutaR_ZHWdXQrZNBN91K==n3taMKBptmyU0+8DT1RzBStNCyA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was introduced in commit e651eab0.
Some v4/v5 platforms failed to boot due to this.

Signed-off-by: Po-Yu Chuang <ratbert.chuang@gmail.com>
---
v2:
prefix underscores to map_init_section to emphasize that it should never be
called by some random function.

 arch/arm/mm/mmu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e0d8565..4d409e6 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -616,10 +616,12 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
-static void __init map_init_section(pmd_t *pmd, unsigned long addr,
+static void __init __map_init_section(pmd_t *pmd, unsigned long addr,
 			unsigned long end, phys_addr_t phys,
 			const struct mem_type *type)
 {
+	pmd_t *p = pmd;
+
 #ifndef CONFIG_ARM_LPAE
 	/*
 	 * In classic MMU format, puds and pmds are folded in to
@@ -638,7 +640,7 @@ static void __init map_init_section(pmd_t *pmd, unsigned long addr,
 		phys += SECTION_SIZE;
 	} while (pmd++, addr += SECTION_SIZE, addr != end);
 
-	flush_pmd_entry(pmd);
+	flush_pmd_entry(p);
 }
 
 static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
@@ -661,7 +663,7 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 		 */
 		if (type->prot_sect &&
 				((addr | next | phys) & ~SECTION_MASK) == 0) {
-			map_init_section(pmd, addr, next, phys, type);
+			__map_init_section(pmd, addr, next, phys, type);
 		} else {
 			alloc_init_pte(pmd, addr, next,
 						__phys_to_pfn(phys), type);
-- 
1.7.9.5

