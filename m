Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3LFDV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:21:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab3LFDVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:21:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986971"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 15/20] iommu/vt-d: fix access after free issue in function free_dmar_iommu()
Date: Fri,  6 Dec 2013 11:21:18 +0800
Message-Id: <1386300083-6882-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function free_dmar_iommu() may access domain->iommu_lock by
	spin_unlock_irqrestore(&domain->iommu_lock, flags);
after freeing corresponding domain structure.

Sample stack dump:
[    8.912818] =========================
[    8.917072] [ BUG: held lock freed! ]
[    8.921335] 3.13.0-rc1-gerry+ #12 Not tainted
[    8.926375] -------------------------
[    8.930629] swapper/0/1 is freeing memory ffff880c23b56040-ffff880c23b5613f, with a lock still held there!
[    8.941675]  (&(&domain->iommu_lock)->rlock){......}, at: [<ffffffff81dc775c>] init_dmars+0x72c/0x95b
[    8.952582] 1 lock held by swapper/0/1:
[    8.957031]  #0:  (&(&domain->iommu_lock)->rlock){......}, at: [<ffffffff81dc775c>] init_dmars+0x72c/0x95b
[    8.968487]
[    8.968487] stack backtrace:
[    8.973602] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-gerry+ #12
[    8.981556] Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS SE5C600.86B.99.99.x059.091020121352 09/10/2012
[    8.994742]  ffff880c23b56040 ffff88042dd33c98 ffffffff815617fd ffff88042dd38b28
[    9.003566]  ffff88042dd33cd0 ffffffff810a977a ffff880c23b56040 0000000000000086
[    9.012403]  ffff88102c4923c0 ffff88042ddb4800 ffffffff81b1e8c0 ffff88042dd33d28
[    9.021240] Call Trace:
[    9.024138]  [<ffffffff815617fd>] dump_stack+0x4d/0x66
[    9.030057]  [<ffffffff810a977a>] debug_check_no_locks_freed+0x15a/0x160
[    9.037723]  [<ffffffff811aa1c2>] kmem_cache_free+0x62/0x5b0
[    9.044225]  [<ffffffff81465e27>] domain_exit+0x197/0x1c0
[    9.050418]  [<ffffffff81dc7788>] init_dmars+0x758/0x95b
[    9.056527]  [<ffffffff81dc7dfa>] intel_iommu_init+0x351/0x438
[    9.063207]  [<ffffffff81d8a711>] ? iommu_setup+0x27d/0x27d
[    9.069601]  [<ffffffff81d8a739>] pci_iommu_init+0x28/0x52
[    9.075910]  [<ffffffff81000342>] do_one_initcall+0x122/0x180
[    9.082509]  [<ffffffff81077738>] ? parse_args+0x1e8/0x320
[    9.088815]  [<ffffffff81d850e8>] kernel_init_freeable+0x1e1/0x26c
[    9.095895]  [<ffffffff81d84833>] ? do_early_param+0x88/0x88
[    9.102396]  [<ffffffff8154f580>] ? rest_init+0xd0/0xd0
[    9.108410]  [<ffffffff8154f58e>] kernel_init+0xe/0x130
[    9.114423]  [<ffffffff81574a2c>] ret_from_fork+0x7c/0xb0
[    9.120612]  [<ffffffff8154f580>] ? rest_init+0xd0/0xd0

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 1a20171..fc3473b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1266,7 +1266,7 @@ static void vm_domain_exit(struct dmar_domain *domain);
 static void free_dmar_iommu(struct intel_iommu *iommu)
 {
 	struct dmar_domain *domain;
-	int i;
+	int i, count;
 	unsigned long flags;
 
 	if ((iommu->domains) && (iommu->domain_ids)) {
@@ -1275,13 +1275,14 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 			clear_bit(i, iommu->domain_ids);
 
 			spin_lock_irqsave(&domain->iommu_lock, flags);
-			if (--domain->iommu_count == 0) {
+			count = --domain->iommu_count;
+			spin_unlock_irqrestore(&domain->iommu_lock, flags);
+			if (count == 0) {
 				if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
 					vm_domain_exit(domain);
 				else
 					domain_exit(domain);
 			}
-			spin_unlock_irqrestore(&domain->iommu_lock, flags);
 		}
 	}
 
-- 
1.7.10.4

