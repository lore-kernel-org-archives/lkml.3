Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3A3BtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:49:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3A3BtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:49:17 -0500
Date: Tue, 29 Jan 2013 17:49:06 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-f8fff5398fbc6a3b041876114794966652fefe3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-29-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-29-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] memblock: Add memblock_mem_size()
Git-Commit-ID: f8fff5398fbc6a3b041876114794966652fefe3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:49:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8fff5398fbc6a3b041876114794966652fefe3e
Gitweb:     http://git.kernel.org/tip/f8fff5398fbc6a3b041876114794966652fefe3e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:09 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:31:54 -0800

memblock: Add memblock_mem_size()

Use it to get mem size under the limit_pfn.
to replace local version in x86 reserved_initrd.

-v2: remove not needed cast that is pointed out by HPA.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-29-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c  | 16 +---------------
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 17 +++++++++++++++++
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b80bee1..bbe8cdf 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -363,20 +363,6 @@ static void __init relocate_initrd(void)
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
 
-static u64 __init get_mem_size(unsigned long limit_pfn)
-{
-	int i;
-	u64 mapped_pages = 0;
-	unsigned long start_pfn, end_pfn;
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
-		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
-		mapped_pages += end_pfn - start_pfn;
-	}
-
-	return mapped_pages << PAGE_SHIFT;
-}
 static void __init early_reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
@@ -404,7 +390,7 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	mapped_size = get_mem_size(max_pfn_mapped);
+	mapped_size = memblock_mem_size(max_pfn_mapped);
 	if (ramdisk_size >= (mapped_size>>1))
 		panic("initrd too large to handle, "
 		       "disabling initrd (%lld needed, %lld available)\n",
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d452ee1..f388203 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -155,6 +155,7 @@ phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				  phys_addr_t max_addr);
 phys_addr_t memblock_phys_mem_size(void);
+phys_addr_t memblock_mem_size(unsigned long limit_pfn);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
 void memblock_enforce_memory_limit(phys_addr_t memory_limit);
diff --git a/mm/memblock.c b/mm/memblock.c
index 88adc8a..b8d9147 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -828,6 +828,23 @@ phys_addr_t __init memblock_phys_mem_size(void)
 	return memblock.memory.total_size;
 }
 
+phys_addr_t __init memblock_mem_size(unsigned long limit_pfn)
+{
+	unsigned long pages = 0;
+	struct memblock_region *r;
+	unsigned long start_pfn, end_pfn;
+
+	for_each_memblock(memory, r) {
+		start_pfn = memblock_region_memory_base_pfn(r);
+		end_pfn = memblock_region_memory_end_pfn(r);
+		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
+		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
+		pages += end_pfn - start_pfn;
+	}
+
+	return (phys_addr_t)pages << PAGE_SHIFT;
+}
+
 /* lowest address */
 phys_addr_t __init_memblock memblock_start_of_DRAM(void)
 {
