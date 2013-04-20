Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3DTG6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 02:58:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34723 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3DTG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 02:58:08 -0400
From: Wei Hu <wei@aristanetworks.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Wei Hu <wei@aristanetworks.com>
Subject: [PATCH 1/1] intel-iommu: Disable DMA Remapping when intel_iommu=off
Date: Fri, 19 Apr 2013 23:58:00 -0700
Message-Id: <1366441080-5937-1-git-send-email-wei@aristanetworks.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a VT-d capable machine Linux will enable IOMMU by default. If it
then kexec's a second kernel with intel_iommu=off, this second kernel
will leave the DMA remapping engine on with no code handling it. The
symptom is at least USB and SATA drives stop working. This patch fixes
the problem by always disabling DMA remapping when intel_iommu=off.

Signed-off-by: Wei Hu <wei@aristanetworks.com>
---
 drivers/iommu/intel-iommu.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0099667..0b8f8bb 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3681,8 +3681,12 @@ int __init intel_iommu_init(void)
 		return 	-ENODEV;
 	}
 
-	if (no_iommu || dmar_disabled)
+	if (no_iommu || dmar_disabled) {
+		struct dmar_drhd_unit *drhd;
+		for_each_drhd_unit(drhd)
+			iommu_disable_translation(drhd->iommu);
 		return -ENODEV;
+	}
 
 	if (iommu_init_mempool()) {
 		if (force_on)
-- 
1.7.4.4

