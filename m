Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab3BFT7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:59:17 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42729 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab3BFTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:46 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 49/77] mfd: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:21 -0800
Message-Id: <1360179649-22465-50-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/rtsx_pcr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 9016932..81d8b14 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1056,15 +1056,14 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
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

