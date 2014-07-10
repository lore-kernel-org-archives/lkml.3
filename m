Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaGJN2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:28:51 -0400
Received: from 8bytes.org ([85.214.48.195]:52065 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbaGJN0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:14 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5/9] iommu/amd: Drop pasid_state reference in ppr_notifer error path
Date: Thu, 10 Jul 2014 15:25:46 +0200
Message-Id: <1404998750-15536-6-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:25:59 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946720861614934472
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

In case we are not able to allocate a fault structure a
reference to the pasid_state will be leaked. Fix that by
dropping the reference in the error path in case we hold
one.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Oded Gabbay <Oded.Gabbay@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 574c71b..6ba707b 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -607,6 +607,10 @@ static int ppr_notifier(struct notifier_block *nb, unsigned long e, void *data)
 	ret = NOTIFY_OK;
 
 out_drop_state:
+
+	if (ret != NOTIFY_OK && pasid_state)
+		put_pasid_state(pasid_state);
+
 	put_device_state(dev_state);
 
 out:
-- 
1.7.9.5


