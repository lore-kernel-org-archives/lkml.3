Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaBSGHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:07:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:18482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbaBSGHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:07:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="485626618"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V2 10/17] iommu/vt-d: check for NULL pointer when freeing IOMMU data structure
Date: Wed, 19 Feb 2014 14:07:30 +0800
Message-Id: <1392790057-32434-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Domain id 0 will be assigned to invalid translation without allocating
domain data structure if DMAR unit supports caching mode. So in function
free_dmar_iommu(), we should check whether the domain pointer is NULL,
otherwise it will cause system crash as below:
[    6.790519] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
[    6.799520] IP: [<ffffffff810e2dc8>] __lock_acquire+0x11f8/0x1430
[    6.806493] PGD 0
[    6.817972] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    6.823303] Modules linked in:
[    6.826862] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1+ #126
[    6.834252] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRIVTIN1.86B.0047.R00.1402050741 02/05/2014
[    6.845951] task: ffff880455a80000 ti: ffff880455a88000 task.ti: ffff880455a88000
[    6.854437] RIP: 0010:[<ffffffff810e2dc8>]  [<ffffffff810e2dc8>] __lock_acquire+0x11f8/0x1430
[    6.864154] RSP: 0000:ffff880455a89ce0  EFLAGS: 00010046
[    6.870179] RAX: 0000000000000046 RBX: 0000000000000002 RCX: 0000000000000000
[    6.878249] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000c8
[    6.886318] RBP: ffff880455a89d40 R08: 0000000000000002 R09: 0000000000000001
[    6.894387] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880455a80000
[    6.902458] R13: 0000000000000000 R14: 00000000000000c8 R15: 0000000000000000
[    6.910520] FS:  0000000000000000(0000) GS:ffff88045b800000(0000) knlGS:0000000000000000
[    6.919687] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.926198] CR2: 00000000000000c8 CR3: 0000000001e0e000 CR4: 00000000001407f0
[    6.934269] Stack:
[    6.936588]  ffffffffffffff10 ffffffff810f59db 0000000000000010 0000000000000246
[    6.945219]  ffff880455a89d10 0000000000000000 ffffffff82bcb980 0000000000000046
[    6.953850]  0000000000000000 0000000000000000 0000000000000002 0000000000000000
[    6.962482] Call Trace:
[    6.965300]  [<ffffffff810f59db>] ? vprintk_emit+0x4fb/0x5a0
[    6.971716]  [<ffffffff810e3185>] lock_acquire+0x185/0x200
[    6.977941]  [<ffffffff821fbbee>] ? init_dmars+0x839/0xa1d
[    6.984167]  [<ffffffff81870b06>] _raw_spin_lock_irqsave+0x56/0x90
[    6.991158]  [<ffffffff821fbbee>] ? init_dmars+0x839/0xa1d
[    6.997380]  [<ffffffff821fbbee>] init_dmars+0x839/0xa1d
[    7.003410]  [<ffffffff8147d575>] ? pci_get_dev_by_id+0x75/0xd0
[    7.010119]  [<ffffffff821fc146>] intel_iommu_init+0x2f0/0x502
[    7.016735]  [<ffffffff821a7947>] ? iommu_setup+0x27d/0x27d
[    7.023056]  [<ffffffff821a796f>] pci_iommu_init+0x28/0x52
[    7.029282]  [<ffffffff81002162>] do_one_initcall+0xf2/0x220
[    7.035702]  [<ffffffff810a4a29>] ? parse_args+0x2c9/0x450
[    7.041919]  [<ffffffff8219d1b1>] kernel_init_freeable+0x1c9/0x25b
[    7.048919]  [<ffffffff8219c8d2>] ? do_early_param+0x8a/0x8a
[    7.055336]  [<ffffffff8184d3f0>] ? rest_init+0x150/0x150
[    7.061461]  [<ffffffff8184d3fe>] kernel_init+0xe/0x100
[    7.067393]  [<ffffffff8187b5fc>] ret_from_fork+0x7c/0xb0
[    7.073518]  [<ffffffff8184d3f0>] ? rest_init+0x150/0x150
[    7.079642] Code: 01 76 18 89 05 46 04 36 01 41 be 01 00 00 00 e9 2f 02 00 00 0f 1f 80 00 00 00 00 41 be 01 00 00 00 e9 1d 02 00 00 0f 1f 44 00 00 <49> 81 3e c0 31 34 82 b8 01 00 00 00 0f 44 d8 41 83 ff 01 0f 87
[    7.104944] RIP  [<ffffffff810e2dc8>] __lock_acquire+0x11f8/0x1430
[    7.112008]  RSP <ffff880455a89ce0>
[    7.115988] CR2: 00000000000000c8
[    7.119784] ---[ end trace 13d756f0f462c538 ]---
[    7.125034] note: swapper/0[1] exited with preempt_count 1
[    7.131285] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    7.131285]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a27d3eb..afbc8d6 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1297,6 +1297,13 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 
 	if ((iommu->domains) && (iommu->domain_ids)) {
 		for_each_set_bit(i, iommu->domain_ids, cap_ndoms(iommu->cap)) {
+			/*
+			 * Domain id 0 is reserved for invalid translation
+			 * if hardware supports caching mode.
+			 */
+			if (cap_caching_mode(iommu->cap) && i == 0)
+				continue;
+
 			domain = iommu->domains[i];
 			clear_bit(i, iommu->domain_ids);
 
-- 
1.7.10.4

