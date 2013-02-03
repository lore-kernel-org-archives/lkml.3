Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3BCBWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:25 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42373 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3BCBWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:20 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 33/62] mfd: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:34 -0800
Message-Id: <1359854463-2538-34-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/mfd/rtsx_pcr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 7a7b0bd..76172d8 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1032,15 +1032,14 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	}
 	handle->pcr = pcr;
 
-	if (!idr_pre_get(&rtsx_pci_idr, GFP_KERNEL)) {
-		ret = -ENOMEM;
-		goto free_handle;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&rtsx_pci_lock);
-	ret = idr_get_new(&rtsx_pci_idr, pcr, &pcr->id);
+	ret = idr_alloc(&rtsx_pci_idr, pcr, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		pcr->id = ret;
 	spin_unlock(&rtsx_pci_lock);
-	if (ret)
+	idr_preload_end();
+	if (ret < 0)
 		goto free_handle;
 
 	pcr->pci = pcidev;
-- 
1.8.1

