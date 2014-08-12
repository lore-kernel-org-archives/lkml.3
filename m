Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaHLQWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:22:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26865 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaHLQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:22:31 -0400
X-AuditID: cbfee61a-f79e46d00000134f-7c-53ea3f45ced7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: remove deprecated struct ahci_platform_data
Date: Tue, 12 Aug 2014 18:22:27 +0200
Message-id: <4376282.p3rdI3v8uT@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAV1X+1fBBnvnSlm8OT6dyeLYjkdM
	Fpd3zWGz+LX8KKMDi8emVZ1sHu/3XWXz+LxJLoA5issmJTUnsyy1SN8ugStj9/+pbAXNKhUH
	et6wNTA+le1i5OCQEDCR2PlQsouRE8gUk7hwbz1bFyMXh5DAIkaJhbcvMkI4LUwS05p3soBU
	sQlYSUxsX8UIYosIyEpcmfYQzGYWSJJo61vFCjJUWMBR4uabeJAwi4CqROeeOUwgNq+ApsTz
	n12sILaogKfEju0r2SDighI/Jt9jgRgjL7Fv/1RWCFtLYv3O40wTGPlmISmbhaRsFpKyBYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCA/CZ1A7GlQ0WhxgFOBiVeHgreF8FC7EmlhVX
	5h5ilOBgVhLhXawHFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbL
	xMEp1cA4l3mx2EOmDzGX/ObmVkx+9/cp24H8vTvvzec4vDRyV6qSypbjbi+ff3yyp/XIwZIg
	I2WFYp8liTk83oIPauZM8vvobxo/xeu3Ucobp/+azMyf1MNTVeaUnXun8Drx6P/4Hady1zsE
	bgqMueTbYyaTtO9jRQyP2OVSm47VL49YNYl5HZn/OuCvEktxRqKhFnNRcSIAIuT7/jwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of the deprecated struct ahci_platform_data has been
cleaned up recently (SPEAr1340 got a proper PHY driver).

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/ahci_platform.c    | 18 +-----------------
 drivers/ata/libahci_platform.c | 23 -----------------------
 include/linux/ahci_platform.h  | 13 -------------
 3 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index f61ddb9..06f1d59 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -32,7 +32,6 @@ static const struct ata_port_info ahci_port_info = {
 static int ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ahci_host_priv *hpriv;
 	int rc;
 
@@ -44,29 +43,14 @@ static int ahci_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
-	/*
-	 * Some platforms might need to prepare for mmio region access,
-	 * which could be done in the following init call. So, the mmio
-	 * region shouldn't be accessed before init (if provided) has
-	 * returned successfully.
-	 */
-	if (pdata && pdata->init) {
-		rc = pdata->init(dev, hpriv->mmio);
-		if (rc)
-			goto disable_resources;
-	}
-
 	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
 		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
 
 	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info);
 	if (rc)
-		goto pdata_exit;
+		goto disable_resources;
 
 	return 0;
-pdata_exit:
-	if (pdata && pdata->exit)
-		pdata->exit(dev);
 disable_resources:
 	ahci_platform_disable_resources(hpriv);
 	return rc;
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 5b92c29..c0510de 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -502,13 +502,8 @@ EXPORT_SYMBOL_GPL(ahci_platform_init_host);
 
 static void ahci_host_stop(struct ata_host *host)
 {
-	struct device *dev = host->dev;
-	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;
 
-	if (pdata && pdata->exit)
-		pdata->exit(dev);
-
 	ahci_platform_disable_resources(hpriv);
 }
 
@@ -592,7 +587,6 @@ EXPORT_SYMBOL_GPL(ahci_platform_resume_host);
  */
 int ahci_platform_suspend(struct device *dev)
 {
-	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ata_host *host = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;
 	int rc;
@@ -601,19 +595,9 @@ int ahci_platform_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (pdata && pdata->suspend) {
-		rc = pdata->suspend(dev);
-		if (rc)
-			goto resume_host;
-	}
-
 	ahci_platform_disable_resources(hpriv);
 
 	return 0;
-
-resume_host:
-	ahci_platform_resume_host(dev);
-	return rc;
 }
 EXPORT_SYMBOL_GPL(ahci_platform_suspend);
 
@@ -629,7 +613,6 @@ EXPORT_SYMBOL_GPL(ahci_platform_suspend);
  */
 int ahci_platform_resume(struct device *dev)
 {
-	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ata_host *host = dev_get_drvdata(dev);
 	struct ahci_host_priv *hpriv = host->private_data;
 	int rc;
@@ -638,12 +621,6 @@ int ahci_platform_resume(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (pdata && pdata->resume) {
-		rc = pdata->resume(dev);
-		if (rc)
-			goto disable_resources;
-	}
-
 	rc = ahci_platform_resume_host(dev);
 	if (rc)
 		goto disable_resources;
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index 09a947e..642d6ae 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -22,19 +22,6 @@ struct ata_port_info;
 struct ahci_host_priv;
 struct platform_device;
 
-/*
- * Note ahci_platform_data is deprecated, it is only kept around for use
- * by the old da850 and spear13xx ahci code.
- * New drivers should instead declare their own platform_driver struct, and
- * use ahci_platform* functions in their own probe, suspend and resume methods.
- */
-struct ahci_platform_data {
-	int (*init)(struct device *dev, void __iomem *addr);
-	void (*exit)(struct device *dev);
-	int (*suspend)(struct device *dev);
-	int (*resume)(struct device *dev);
-};
-
 int ahci_platform_enable_clks(struct ahci_host_priv *hpriv);
 void ahci_platform_disable_clks(struct ahci_host_priv *hpriv);
 int ahci_platform_enable_resources(struct ahci_host_priv *hpriv);
-- 
1.8.2.3


