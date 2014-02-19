Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBSGHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:07:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:18482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbaBSGHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:07:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="485626390"
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
Subject: [Patch Part2 V2 01/17] iommu/vt-d: avoid double free of g_iommus on error recovery path
Date: Wed, 19 Feb 2014 14:07:21 +0800
Message-Id: <1392790057-32434-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array 'g_iommus' may be freed twice on error recovery path in function
init_dmars() and free_dmar_iommu(), thus cause random system crash as
below.

[    6.774301] IOMMU: dmar init failed
[    6.778310] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    6.785615] software IO TLB [mem 0x76bcf000-0x7abcf000] (64MB) mapped at [ffff880076bcf000-ffff88007abcefff]
[    6.796887] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[    6.804173] Modules linked in:
[    6.807731] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1+ #108
[    6.815122] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRIVTIN1.86B.0047.R00.1402050741 02/05/2014
[    6.836000] task: ffff880455a80000 ti: ffff880455a88000 task.ti: ffff880455a88000
[    6.844487] RIP: 0010:[<ffffffff8143eea6>]  [<ffffffff8143eea6>] memcpy+0x6/0x110
[    6.853039] RSP: 0000:ffff880455a89cc8  EFLAGS: 00010293
[    6.859064] RAX: ffff006568636163 RBX: ffff00656863616a RCX: 0000000000000005
[    6.867134] RDX: 0000000000000005 RSI: ffffffff81cdc439 RDI: ffff006568636163
[    6.875205] RBP: ffff880455a89d30 R08: 000000000001bc3b R09: 0000000000000000
[    6.883275] R10: 0000000000000000 R11: ffffffff81cdc43e R12: ffff880455a89da8
[    6.891338] R13: ffff006568636163 R14: 0000000000000005 R15: ffffffff81cdc439
[    6.899408] FS:  0000000000000000(0000) GS:ffff88045b800000(0000) knlGS:0000000000000000
[    6.908575] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.915088] CR2: ffff88047e1ff000 CR3: 0000000001e0e000 CR4: 00000000001407f0
[    6.923160] Stack:
[    6.925487]  ffffffff8143c904 ffff88045b407e00 ffff006568636163 ffff006568636163
[    6.934113]  ffffffff8120a1a9 ffffffff81cdc43e 0000000000000007 0000000000000000
[    6.942747]  ffff880455a89da8 ffff006568636163 0000000000000007 ffffffff81cdc439
[    6.951382] Call Trace:
[    6.954197]  [<ffffffff8143c904>] ? vsnprintf+0x124/0x6f0
[    6.960323]  [<ffffffff8120a1a9>] ? __kmalloc_track_caller+0x169/0x360
[    6.967716]  [<ffffffff81440e1b>] kvasprintf+0x6b/0x80
[    6.973552]  [<ffffffff81432bf1>] kobject_set_name_vargs+0x21/0x70
[    6.980552]  [<ffffffff8143393d>] kobject_init_and_add+0x4d/0x90
[    6.987364]  [<ffffffff812067c9>] ? __kmalloc+0x169/0x370
[    6.993492]  [<ffffffff8102dbbc>] ? cache_add_dev+0x17c/0x4f0
[    7.000005]  [<ffffffff8102ddfa>] cache_add_dev+0x3ba/0x4f0
[    7.006327]  [<ffffffff821a87ca>] ? i8237A_init_ops+0x14/0x14
[    7.012842]  [<ffffffff821a87f8>] cache_sysfs_init+0x2e/0x61
[    7.019260]  [<ffffffff81002162>] do_one_initcall+0xf2/0x220
[    7.025679]  [<ffffffff810a4a29>] ? parse_args+0x2c9/0x450
[    7.031903]  [<ffffffff8219d1b1>] kernel_init_freeable+0x1c9/0x25b
[    7.038904]  [<ffffffff8219c8d2>] ? do_early_param+0x8a/0x8a
[    7.045322]  [<ffffffff8184d5e0>] ? rest_init+0x150/0x150
[    7.051447]  [<ffffffff8184d5ee>] kernel_init+0xe/0x100
[    7.057380]  [<ffffffff8187b87c>] ret_from_fork+0x7c/0xb0
[    7.063503]  [<ffffffff8184d5e0>] ? rest_init+0x150/0x150
[    7.069628] Code: 89 e5 53 48 89 fb 75 16 80 7f 3c 00 75 05 e8 d2 f9 ff ff 48 8b 43 58 48 2b 43 50 88 43 4e 5b 5d c3 90 90 90 90 48 89 f8 48 89 d1 <f3> a4 c3 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b
[    7.094960] RIP  [<ffffffff8143eea6>] memcpy+0x6/0x110
[    7.100856]  RSP <ffff880455a89cc8>
[    7.104864] ---[ end trace b5d3fdc6c6c28083 ]---
[    7.110142] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    7.110142]
[    7.120540] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a22c86c..52be755 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1298,15 +1298,6 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 
 	g_iommus[iommu->seq_id] = NULL;
 
-	/* if all iommus are freed, free g_iommus */
-	for (i = 0; i < g_num_of_iommus; i++) {
-		if (g_iommus[i])
-			break;
-	}
-
-	if (i == g_num_of_iommus)
-		kfree(g_iommus);
-
 	/* free context mapping */
 	free_context_table(iommu);
 }
@@ -2461,7 +2452,7 @@ static int __init init_dmars(void)
 		sizeof(struct deferred_flush_tables), GFP_KERNEL);
 	if (!deferred_flush) {
 		ret = -ENOMEM;
-		goto error;
+		goto free_g_iommus;
 	}
 
 	for_each_active_iommu(iommu, drhd) {
@@ -2469,7 +2460,7 @@ static int __init init_dmars(void)
 
 		ret = iommu_init_domains(iommu);
 		if (ret)
-			goto error;
+			goto free_iommu;
 
 		/*
 		 * TBD:
@@ -2479,7 +2470,7 @@ static int __init init_dmars(void)
 		ret = iommu_alloc_root_entry(iommu);
 		if (ret) {
 			printk(KERN_ERR "IOMMU: allocate root entry failed\n");
-			goto error;
+			goto free_iommu;
 		}
 		if (!ecap_pass_through(iommu->ecap))
 			hw_pass_through = 0;
@@ -2548,7 +2539,7 @@ static int __init init_dmars(void)
 		ret = iommu_prepare_static_identity_mapping(hw_pass_through);
 		if (ret) {
 			printk(KERN_CRIT "Failed to setup IOMMU pass-through\n");
-			goto error;
+			goto free_iommu;
 		}
 	}
 	/*
@@ -2606,7 +2597,7 @@ static int __init init_dmars(void)
 
 		ret = dmar_set_interrupt(iommu);
 		if (ret)
-			goto error;
+			goto free_iommu;
 
 		iommu_set_root_entry(iommu);
 
@@ -2615,17 +2606,20 @@ static int __init init_dmars(void)
 
 		ret = iommu_enable_translation(iommu);
 		if (ret)
-			goto error;
+			goto free_iommu;
 
 		iommu_disable_protect_mem_regions(iommu);
 	}
 
 	return 0;
-error:
+
+free_iommu:
 	for_each_active_iommu(iommu, drhd)
 		free_dmar_iommu(iommu);
 	kfree(deferred_flush);
+free_g_iommus:
 	kfree(g_iommus);
+error:
 	return ret;
 }
 
-- 
1.7.10.4

