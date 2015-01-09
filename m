Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbbAIVW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:22:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55904 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbbAIVW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:22:26 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Dave Gerlach <d-gerlach@ti.com>, Robert Tivy <rtivy@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 1/2] remoteproc: use a flag to detect the presence of IOMMU
Date: Fri, 9 Jan 2015 15:21:58 -0600
Message-ID: <1420838519-15669-2-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420838519-15669-1-git-send-email-s-anna@ti.com>
References: <1420838519-15669-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remoteproc driver core currently relies on iommu_present() on
the bus the device is on, to perform MMU management. However, this
logic doesn't scale for multi-arch, especially for processors that
do not have an IOMMU. Replace this logic instead by using a h/w
capability flag for the presence of IOMMU in the rproc structure.

This issue is seen on OMAP platforms when trying to add a remoteproc
driver for a small Cortex M3 called the WkupM3 used for suspend /
resume management on TI AM335/AM437x SoCs. This processor does not
have an MMU. Same is the case with another processor subsystem
PRU-ICSS on AM335/AM437x. All these are platform devices, and the
current iommu_present check will not scale for the same kernel image
to support OMAP4/OMAP5 and AM335/AM437x.

The existing platform implementation drivers - OMAP remoteproc, STE
Modem remoteproc and DA8xx remoteproc, are updated as well to properly
configure the newly added rproc field.

Cc: Robert Tivy <rtivy@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
v3:
- no changes w.r.t v2

 drivers/remoteproc/da8xx_remoteproc.c |  1 +
 drivers/remoteproc/omap_remoteproc.c  |  5 +++++
 drivers/remoteproc/remoteproc_core.c  | 15 ++-------------
 drivers/remoteproc/ste_modem_rproc.c  |  1 +
 include/linux/remoteproc.h            |  2 ++
 5 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/remoteproc/da8xx_remoteproc.c b/drivers/remoteproc/da8xx_remoteproc.c
index 89fd057e5f1d..f8d6a0661c14 100644
--- a/drivers/remoteproc/da8xx_remoteproc.c
+++ b/drivers/remoteproc/da8xx_remoteproc.c
@@ -224,6 +224,7 @@ static int da8xx_rproc_probe(struct platform_device *pdev)
 
 	drproc = rproc->priv;
 	drproc->rproc = rproc;
+	rproc->has_iommu = false;
 
 	platform_set_drvdata(pdev, rproc);
 
diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index e85f30370760..4be005b272a7 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -202,6 +202,11 @@ static int omap_rproc_probe(struct platform_device *pdev)
 
 	oproc = rproc->priv;
 	oproc->rproc = rproc;
+	/*
+	 * All existing OMAP IPU and DSP processors do have an MMU, and
+	 * are expected to use MMU, so this statement suffices.
+	 */
+	rproc->has_iommu = true;
 
 	platform_set_drvdata(pdev, rproc);
 
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 3cd85a638afa..11cdb119e4f3 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -94,19 +94,8 @@ static int rproc_enable_iommu(struct rproc *rproc)
 	struct device *dev = rproc->dev.parent;
 	int ret;
 
-	/*
-	 * We currently use iommu_present() to decide if an IOMMU
-	 * setup is needed.
-	 *
-	 * This works for simple cases, but will easily fail with
-	 * platforms that do have an IOMMU, but not for this specific
-	 * rproc.
-	 *
-	 * This will be easily solved by introducing hw capabilities
-	 * that will be set by the remoteproc driver.
-	 */
-	if (!iommu_present(dev->bus)) {
-		dev_dbg(dev, "iommu not found\n");
+	if (!rproc->has_iommu) {
+		dev_dbg(dev, "iommu not present\n");
 		return 0;
 	}
 
diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
index 16b7b7bd805b..dd193f35a1ff 100644
--- a/drivers/remoteproc/ste_modem_rproc.c
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -289,6 +289,7 @@ static int sproc_probe(struct platform_device *pdev)
 	sproc = rproc->priv;
 	sproc->mdev = mdev;
 	sproc->rproc = rproc;
+	rproc->has_iommu = false;
 	mdev->drv_data = sproc;
 
 	/* Provide callback functions to modem device */
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 9e7e745dac55..78b8a9b9d40a 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -404,6 +404,7 @@ enum rproc_crash_type {
  * @table_ptr: pointer to the resource table in effect
  * @cached_table: copy of the resource table
  * @table_csum: checksum of the resource table
+ * @has_iommu: flag to indicate if remote processor is behind an MMU
  */
 struct rproc {
 	struct klist_node node;
@@ -435,6 +436,7 @@ struct rproc {
 	struct resource_table *table_ptr;
 	struct resource_table *cached_table;
 	u32 table_csum;
+	bool has_iommu;
 };
 
 /* we currently support only two vrings per rvdev */
-- 
2.2.1

