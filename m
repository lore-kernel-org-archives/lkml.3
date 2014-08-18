Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaHRWuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:50:44 -0400
Received: from 8bytes.org ([81.169.241.247]:40685 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbaHRWuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:50:40 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, Joerg Roedel <jroedel@suse.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org
Subject: [PATCH 1/3] iommu/vt-d: Defer domain removal if device is assigned to a driver
Date: Tue, 19 Aug 2014 00:49:57 +0200
Message-Id: <1408402199-15178-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408402199-15178-1-git-send-email-joro@8bytes.org>
References: <1408402199-15178-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When the BUS_NOTIFY_DEL_DEVICE event is received the device
might still be attached to a driver. In this case the domain
can't be released as the mappings might still be in use.

Defer the domain removal in this case until we receivce the
BUS_NOTIFY_UNBOUND_DRIVER event.

Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org   # v3.15, v3.16
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d1f5caa..5619f26 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3869,6 +3869,14 @@ static int device_notifier(struct notifier_block *nb,
 	    action != BUS_NOTIFY_DEL_DEVICE)
 		return 0;
 
+	/*
+	 * If the device is still attached to a device driver we can't
+	 * tear down the domain yet as DMA mappings may still be in use.
+	 * Wait for the BUS_NOTIFY_UNBOUND_DRIVER event to do that.
+	 */
+	if (action == BUS_NOTIFY_DEL_DEVICE && dev->driver != NULL)
+		return 0;
+
 	domain = find_domain(dev);
 	if (!domain)
 		return 0;
-- 
1.9.1

