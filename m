Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaDUPEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:04:12 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:40569 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaDUPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:04:10 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: swise@chelsio.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] RDMA/cxgb4: Fix memory leaks in c4iw_alloc() error paths
Date: Mon, 21 Apr 2014 17:02:42 +0200
Message-Id: <1398092562-11116-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c4iw_alloc() bails out without freeing the storage that 'devp' points to.

Picked up by Coverity - CID 1204241.

Fixes: fa658a98a2 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices")
Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/infiniband/hw/cxgb4/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index f4fa50a..8914ea9 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -736,6 +736,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 			pci_resource_len(devp->rdev.lldi.pdev, 2));
 		if (!devp->rdev.bar2_kva) {
 			pr_err(MOD "Unable to ioremap BAR2\n");
+			ib_dealloc_device(&devp->ibdev);
 			return ERR_PTR(-EINVAL);
 		}
 	} else if (ocqp_supported(infop)) {
@@ -747,6 +748,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 			devp->rdev.lldi.vr->ocq.size);
 		if (!devp->rdev.oc_mw_kva) {
 			pr_err(MOD "Unable to ioremap onchip mem\n");
+			ib_dealloc_device(&devp->ibdev);
 			return ERR_PTR(-EINVAL);
 		}
 	}
-- 
1.9.0

