Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3FNVbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:31:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3FNVbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:31:36 -0400
Date: Fri, 14 Jun 2013 14:31:14 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-b19feb388cdee35bf991e4977d1936f6d23c75a8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tangchen@cn.fujitsu.com,
        jacob.shin@amd.com, trenn@suse.de, tglx@linutronix.de,
        hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, tangchen@cn.fujitsu.com,
        jacob.shin@amd.com, tglx@linutronix.de, trenn@suse.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-4-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-4-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ACPI, mm: Kill max_low_pfn_mapped
Git-Commit-ID: b19feb388cdee35bf991e4977d1936f6d23c75a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:31:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b19feb388cdee35bf991e4977d1936f6d23c75a8
Gitweb:     http://git.kernel.org/tip/b19feb388cdee35bf991e4977d1936f6d23c75a8
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:50 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:03:37 -0700

x86, ACPI, mm: Kill max_low_pfn_mapped

Now we have pfn_mapped[] array, and max_low_pfn_mapped should not
be used anymore. Users should use pfn_mapped[] or just
1UL<<(32-PAGE_SHIFT) instead.

The only user of max_low_pfn_mapped is ACPI_INITRD_TABLE_OVERRIDE.
We could change to use 1U<<(32_PAGE_SHIFT) with it, aka under 4G.

Known problem:
There is another user of max_low_pfn_mapped: i915 device driver.
But the code is commented out by a pair of "#if 0 ... #endif".
Not sure why the driver developers want to do that.

-v2: Leave alone max_low_pfn_mapped in i915 code according to tj.

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-4-git-send-email-tangchen@cn.fujitsu.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: linux-acpi@vger.kernel.org
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_types.h | 1 -
 arch/x86/kernel/setup.c           | 4 +---
 arch/x86/mm/init.c                | 4 ----
 drivers/acpi/osl.c                | 6 +++---
 4 files changed, 4 insertions(+), 11 deletions(-)

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
index 66ab495..6ca5f2c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,13 +112,11 @@
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
index eaac174..8554656 100644
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
index e721863..93e3194 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -624,9 +624,9 @@ void __init acpi_initrd_override(void *data, size_t size)
 	if (table_nr == 0)
 		return;
 
-	acpi_tables_addr =
-		memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
-				       all_tables_size, PAGE_SIZE);
+	/* under 4G at first, then above 4G */
+	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
+					all_tables_size, PAGE_SIZE);
 	if (!acpi_tables_addr) {
 		WARN_ON(1);
 		return;
