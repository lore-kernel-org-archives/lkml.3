Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaILURe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:17:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46236 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaILURd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:17:33 -0400
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: kvm@vger.kernel.org, pbonzini@redhat.com, christoffer.dall@linaro.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] mm: export symbol dependencies of is_zero_pfn()
Date: Fri, 12 Sep 2014 22:17:23 +0200
Message-Id: <1410553043-575-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make the static inline function is_zero_pfn() callable by
modules, export its symbol dependencies 'zero_pfn' and (for s390 and
mips) 'zero_page_mask'.

We need this for KVM, as CONFIG_KVM is a tristate for all supported
architectures except ARM and arm64, and testing a pfn whether it refers
to the zero page is required to correctly distinguish the zero page
from other special RAM ranges that may also have the PG_reserved bit
set, but need to be treated as MMIO memory.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/mips/mm/init.c | 1 +
 arch/s390/mm/init.c | 1 +
 mm/memory.c         | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 571aab064936..f42e35e42790 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -53,6 +53,7 @@
  */
 unsigned long empty_zero_page, zero_page_mask;
 EXPORT_SYMBOL_GPL(empty_zero_page);
+EXPORT_SYMBOL(zero_page_mask);
 
 /*
  * Not static inline because used by IP27 special magic initialization code
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 0c1073ed1e84..c7235e01fd67 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -43,6 +43,7 @@ pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
 
 unsigned long empty_zero_page, zero_page_mask;
 EXPORT_SYMBOL(empty_zero_page);
+EXPORT_SYMBOL(zero_page_mask);
 
 static void __init setup_zero_pages(void)
 {
diff --git a/mm/memory.c b/mm/memory.c
index adeac306610f..d17f1bcd2a91 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -118,6 +118,8 @@ __setup("norandmaps", disable_randmaps);
 unsigned long zero_pfn __read_mostly;
 unsigned long highest_memmap_pfn __read_mostly;
 
+EXPORT_SYMBOL(zero_pfn);
+
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
  */
-- 
1.8.3.2

