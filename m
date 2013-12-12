Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LLH6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:58:23 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15463 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LLH6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:00:57 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>,
        <gregkh@linuxfoundation.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 04/12] driver/core: populate devices in order for IOMMUs
Date: Thu, 12 Dec 2013 09:57:05 +0200
Message-ID: <1386835033-4701-5-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU devices on the bus need to be poplulated first, then iommu
master devices are done later.

With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
whether a device can be an iommu msater or not. If a device can, we'll
defer to populate that device till an iommu device is populated. Then,
those deferred iommu master devices are populated and configured with
help of the already populated iommu device.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This is related to the following discussion:
  [RFC PATCH] Documentation: devicetree: add description for generic bus properties
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/215042.html

v6:
Spinned off only driver core part from:
  [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs

v5:
Use "iommus=" binding instread of arm,smmu's "#stream-id-cells".

v4:
This is newly added, and the successor of the following RFC:
  [RFC][PATCHv3+ 1/2] driver/core: Add of_iommu_attach()
  http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006914.html

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/base/dd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..0605f52 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
+#include <linux/of_iommu.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -273,6 +274,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	dev->driver = drv;
 
+	ret = of_iommu_attach(dev);
+	if (ret)
+		goto probe_failed;
+
 	/* If using pinctrl, bind pins now before probing */
 	ret = pinctrl_bind_pins(dev);
 	if (ret)
-- 
1.8.1.5

