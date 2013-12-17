Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3LQNAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:00:54 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:50542 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab3LQNAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:00:52 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        iommu@lists.linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/7] iommu/omap: omap_iommu_attach() should return ENODEV, not NULL
Date: Tue, 17 Dec 2013 13:53:33 +0100
Message-Id: <1387284818-28739-3-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_iommu_attach() returns NULL or ERR_PTR in case of error, but
omap_iommu_attach_dev() only checks for IS_ERR. Thus a NULL return value (in
case driver_find_device fails) will cause the kernel to panic when
omap_iommu_attach_dev() dereferences the pointer.

In such case, omap_iommu_attach() should return ENODEV, not NULL.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/iommu/omap-iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index ee83bcc..385bf5e 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -863,7 +863,7 @@ static int device_match_by_alias(struct device *dev, void *data)
  **/
 static struct omap_iommu *omap_iommu_attach(const char *name, u32 *iopgd)
 {
-	int err = -ENOMEM;
+	int err = -ENODEV;
 	struct device *dev;
 	struct omap_iommu *obj;
 
@@ -871,7 +871,7 @@ static struct omap_iommu *omap_iommu_attach(const char *name, u32 *iopgd)
 				(void *)name,
 				device_match_by_alias);
 	if (!dev)
-		return NULL;
+		return ERR_PTR(err);
 
 	obj = to_iommu(dev);
 
-- 
1.8.1.2

