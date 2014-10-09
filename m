Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbaJIVIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaJIVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:07:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will.deacon@arm.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/163] iommu/arm-smmu: remove pgtable_page_{c,d}tor()
Date: Thu,  9 Oct 2014 14:00:46 -0700
Message-Id: <1412888588-26755-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

commit 93b14135cf24668b45eb57348312b627a8539bc4 upstream.

If split page table lock for PTE tables is enabled (CONFIG_SPLIT_PTLOCK_CPUS
<=NR_CPUS) pgtable_page_ctor() leads to non-atomic allocation for ptlock with
a spinlock held, resulting in:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 466 at kernel/locking/lockdep.c:2742 lockdep_trace_alloc+0xd8/0xf4()
DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
Modules linked in:
CPU: 0 PID: 466 Comm: dma0chan0-copy0 Not tainted 3.16.0-3d47efb-clean-pl330-dma_test-ve-a15-a32-slr-m
c-on-3+ #55
[<80014748>] (unwind_backtrace) from [<80011640>] (show_stack+0x10/0x14)
[<80011640>] (show_stack) from [<802bf864>] (dump_stack+0x80/0xb4)
[<802bf864>] (dump_stack) from [<8002385c>] (warn_slowpath_common+0x64/0x88)
[<8002385c>] (warn_slowpath_common) from [<80023914>] (warn_slowpath_fmt+0x30/0x40)
[<80023914>] (warn_slowpath_fmt) from [<8005d818>] (lockdep_trace_alloc+0xd8/0xf4)
[<8005d818>] (lockdep_trace_alloc) from [<800d3d78>] (kmem_cache_alloc+0x24/0x144)
[<800d3d78>] (kmem_cache_alloc) from [<800bfae4>] (ptlock_alloc+0x18/0x2c)
[<800bfae4>] (ptlock_alloc) from [<802b1ec0>] (arm_smmu_handle_mapping+0x4c0/0x690)
[<802b1ec0>] (arm_smmu_handle_mapping) from [<802b0cd8>] (iommu_map+0xe0/0x148)
[<802b0cd8>] (iommu_map) from [<80019098>] (arm_coherent_iommu_map_page+0x160/0x278)
[<80019098>] (arm_coherent_iommu_map_page) from [<801f4d78>] (dmatest_func+0x60c/0x1098)
[<801f4d78>] (dmatest_func) from [<8003f8ac>] (kthread+0xcc/0xe8)
[<8003f8ac>] (kthread) from [<8000e868>] (ret_from_fork+0x14/0x2c)
---[ end trace ce0d27e6f434acf8 ]--

Split page tables lock is not used in the driver. In fact, page tables are
guarded with domain lock, so remove calls to pgtable_page_{c,d}tor().

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iommu/arm-smmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 91739bf..176c9ea 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -946,7 +946,6 @@ out_free_domain:
 static void arm_smmu_free_ptes(pmd_t *pmd)
 {
 	pgtable_t table = pmd_pgtable(*pmd);
-	pgtable_page_dtor(table);
 	__free_page(table);
 }
 
@@ -1231,10 +1230,6 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
 			return -ENOMEM;
 
 		arm_smmu_flush_pgtable(smmu, page_address(table), PAGE_SIZE);
-		if (!pgtable_page_ctor(table)) {
-			__free_page(table);
-			return -ENOMEM;
-		}
 		pmd_populate(NULL, pmd, table);
 		arm_smmu_flush_pgtable(smmu, pmd, sizeof(*pmd));
 	}
-- 
1.9.1

