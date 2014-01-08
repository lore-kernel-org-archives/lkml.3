Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbaAHP1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:27:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44582 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbaAHP1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:27:17 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Fengguang Wu <fengguang.wu@intel.com>, <santosh.shilimkar@ti.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/mm: memblock: switch to use NUMA_NO_NODE
Date: Wed, 8 Jan 2014 18:23:18 +0200
Message-ID: <1389198198-31027-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140107022559.GE14055@localhost>
References: <20140107022559.GE14055@localhost>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update X86 code to use NUMA_NO_NODE instead of MAX_NUMNODES while
calling memblock APIs, because memblock API is changed to use NUMA_NO_NODE and
will produce warning during boot otherwise.

See:
 https://lkml.org/lkml/2013/12/9/898

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Hi Fengguang,

This patch should fix these warnings.

Regards,
-grygorii

 arch/x86/kernel/check.c |    2 +-
 arch/x86/kernel/e820.c  |    2 +-
 arch/x86/mm/memtest.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index e2dbcb7..83a7995 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -91,7 +91,7 @@ void __init setup_bios_corruption_check(void)
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL) {
 		start = clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
 				PAGE_SIZE, corruption_check_size);
 		end = clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 174da5f..988c00a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1120,7 +1120,7 @@ void __init memblock_find_dma_reserve(void)
 		nr_pages += end_pfn - start_pfn;
 	}
 
-	for_each_free_mem_range(u, MAX_NUMNODES, &start, &end, NULL) {
+	for_each_free_mem_range(u, NUMA_NO_NODE, &start, &end, NULL) {
 		start_pfn = min_t(unsigned long, PFN_UP(start), MAX_DMA_PFN);
 		end_pfn = min_t(unsigned long, PFN_DOWN(end), MAX_DMA_PFN);
 		if (start_pfn < end_pfn)
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 8dabbed..1e9da79 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -74,7 +74,7 @@ static void __init do_one_pass(u64 pattern, u64 start, u64 end)
 	u64 i;
 	phys_addr_t this_start, this_end;
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &this_start, &this_end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, &this_start, &this_end, NULL) {
 		this_start = clamp_t(phys_addr_t, this_start, start, end);
 		this_end = clamp_t(phys_addr_t, this_end, start, end);
 		if (this_start < this_end) {
-- 
1.7.9.5

