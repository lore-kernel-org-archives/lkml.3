Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab3CJGqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:46:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19002 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3CJGqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:46:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jacob Shin <jacob.shin@amd.com>,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH v2 03/20] x86, ACPI, mm: Kill max_low_pfn_mapped
Date: Sat,  9 Mar 2013 22:44:30 -0800
Message-Id: <1362897887-30808-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have arch_pfn_mapped array, and max_low_pfn_mapped should not
be used anymore.

User should use arch_pfn_mapped or just 1UL<<(32-PAGE_SHIFT) instead.

Only user is ACPI_INITRD_TABLE_OVERRIDE, and it should not use that,
as later accessing is using early_ioremap(). Change to try to 4G below
and then 4G above.

-v2: Leave alone max_low_pfn_mapped in i915 code according to tj.

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: linux-acpi@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
---
 arch/x86/include/asm/page_types.h |    1 -
 arch/x86/kernel/setup.c           |    4 +---
 arch/x86/mm/init.c                |    4 ----
 drivers/acpi/osl.c                |   10 +++++++---
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 54c9787..b012b82 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -43,7 +43,6 @@
 
 extern int devmem_is_allowed(unsigned long pagenr);
 
-extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
 static inline phys_addr_t get_max_mapped(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1629577..e75c6e6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,13 +113,11 @@
 #include <asm/prom.h>
 
 /*
- * max_low_pfn_mapped: highest direct mapped pfn under 4GB
- * max_pfn_mapped:     highest direct mapped pfn over 4GB
+ * max_pfn_mapped:     highest direct mapped pfn
  *
  * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
  * represented by pfn_mapped
  */
-unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
 #ifdef CONFIG_DMI
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 59b7fc4..abcc241 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -313,10 +313,6 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
 	nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
 
 	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
-
-	if (start_pfn < (1UL<<(32-PAGE_SHIFT)))
-		max_low_pfn_mapped = max(max_low_pfn_mapped,
-					 min(end_pfn, 1UL<<(32-PAGE_SHIFT)));
 }
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 586e7e9..c08cdb6 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -624,9 +624,13 @@ void __init acpi_initrd_override(void *data, size_t size)
 	if (table_nr == 0)
 		return;
 
-	acpi_tables_addr =
-		memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
-				       all_tables_size, PAGE_SIZE);
+	/* under 4G at first, then above 4G */
+	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
+					all_tables_size, PAGE_SIZE);
+	if (!acpi_tables_addr)
+		acpi_tables_addr = memblock_find_in_range(0,
+					~(phys_addr_t)0,
+					all_tables_size, PAGE_SIZE);
 	if (!acpi_tables_addr) {
 		WARN_ON(1);
 		return;
-- 
1.7.10.4

