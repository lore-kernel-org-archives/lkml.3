Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaCYGvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 02:51:10 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59861 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaCYGua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 02:50:30 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: [PATCH 1/1] mm: move FAULT_AROUND_ORDER to arch/
Date: Tue, 25 Mar 2014 12:20:15 +0530
Message-Id: <1395730215-11604-2-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395730215-11604-1-git-send-email-maddy@linux.vnet.ibm.com>
References: <1395730215-11604-1-git-send-email-maddy@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032506-5816-0000-0000-00000D05792B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov with the commit 96bacfe542 introduced
vm_ops->map_pages() for mapping easy accessible pages around
fault address in hope to reduce number of minor page faults.
Based on his workload runs, suggested FAULT_AROUND_ORDER
(knob to control the numbers of pages to map) is 4.

This patch moves the FAULT_AROUND_ORDER macro to arch/ for
architecture maintainers to decide on suitable FAULT_AROUND_ORDER
value based on performance data for that architecture.

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/pgtable.h |    6 ++++++
 arch/x86/include/asm/pgtable.h     |    5 +++++
 include/asm-generic/pgtable.h      |   10 ++++++++++
 mm/memory.c                        |    2 --
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 3ebb188..9fcbd48 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -19,6 +19,12 @@ struct mm_struct;
 #endif
 
 /*
+ * With a few real world workloads that were run,
+ * the performance data showed that a value of 3 is more advantageous.
+ */
+#define FAULT_AROUND_ORDER	3
+
+/*
  * We save the slot number & secondary bit in the second half of the
  * PTE page. We use the 8 bytes per each pte entry.
  */
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 938ef1d..8387a65 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -7,6 +7,11 @@
 #include <asm/pgtable_types.h>
 
 /*
+ * Based on Kirill's test results, fault around order is set to 4
+ */
+#define FAULT_AROUND_ORDER 4
+
+/*
  * Macro to mark a page protection value as UC-
  */
 #define pgprot_noncached(prot)					\
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 1ec08c1..62f7f07 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -7,6 +7,16 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 
+
+/*
+ * Fault around order is a control knob to decide the fault around pages.
+ * Default value is set to 0UL (disabled), but the arch can override it as
+ * desired.
+ */
+#ifndef FAULT_AROUND_ORDER
+#define FAULT_AROUND_ORDER	0UL
+#endif
+
 /*
  * On almost all architectures and configurations, 0 can be used as the
  * upper ceiling to free_pgtables(): on many architectures it has the same
diff --git a/mm/memory.c b/mm/memory.c
index b02c584..fd79ffc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3358,8 +3358,6 @@ void do_set_pte(struct vm_area_struct *vma, unsigned long address,
 	update_mmu_cache(vma, address, pte);
 }
 
-#define FAULT_AROUND_ORDER 4
-
 #ifdef CONFIG_DEBUG_FS
 static unsigned int fault_around_order = FAULT_AROUND_ORDER;
 
-- 
1.7.10.4

