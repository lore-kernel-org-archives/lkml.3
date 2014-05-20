Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaETJEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:04:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58328 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbaETJEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:04:41 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/7] ata: libahci: allow to use multiple PHYs
Date: Tue, 20 May 2014 11:04:31 +0200
Message-Id: <1400576675-25265-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of the libahci does not allow to use multiple
PHYs. This patch adds the support of multiple PHYs by the libahci while
keeping the old bindings valid for device tree compatibility.

This introduce a new way of defining SATA ports in the device tree, with
one port per sub-node. This as the advantage of allowing a per port
configuration. Because some ports may be accessible but disabled in the
device tree, the default port_map is computed automatically when using
this.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/ata/Kconfig            |   1 +
 drivers/ata/ahci.h             |   3 +-
 drivers/ata/libahci.c          |   7 ++
 drivers/ata/libahci_platform.c | 165 ++++++++++++++++++++++++++++++++---------
 4 files changed, 140 insertions(+), 36 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index c2706047337f..385c455e0aeb 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -91,6 +91,7 @@ config SATA_AHCI
 
 config SATA_AHCI_PLATFORM
 	tristate "Platform AHCI SATA support"
+	select PHY_BERLIN_SATA if ARCH_BERLIN
 	help
 	  This option enables support for Platform AHCI Serial ATA
 	  controllers.
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b5eb886da226..0c80feb84d17 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -328,7 +328,8 @@ struct ahci_host_priv {
 	bool			got_runtime_pm; /* Did we do pm_runtime_get? */
 	struct clk		*clks[AHCI_MAX_CLKS]; /* Optional */
 	struct regulator	*target_pwr;	/* Optional */
-	struct phy		*phy;		/* If platform uses phy */
+	struct phy		**phys;		/* If platform uses phys */
+	unsigned		nphys;		/* Number of phys */
 	void			*plat_data;	/* Other platform data */
 	/*
 	 * Optional ahci_start_engine override, if not set this gets set to the
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 6bd4f660b4e1..9a41fd16ecc7 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -470,6 +470,13 @@ void ahci_save_initial_config(struct device *dev,
 		port_map &= mask_port_map;
 	}
 
+	/*
+	 * If port_map was filled automatically when finding port sub-nodes,
+	 * make sure we get the right set here.
+	 */
+	if (hpriv->port_map)
+		port_map &= hpriv->port_map;
+
 	/* cross check port_map and cap.n_ports */
 	if (port_map) {
 		int map_ports = 0;
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 7cb3a85719c0..0651a902b889 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -39,6 +39,61 @@ static struct scsi_host_template ahci_platform_sht = {
 };
 
 /**
+ * ahci_platform_enable_phys - Enable PHYs
+ * @hpriv: host private area to store config values
+ *
+ * This function enables all the PHYs found in hpriv->phys, if any.
+ * If a PHY fails to be enabled, it disables all the PHYs already
+ * enabled in reverse order and returns an error.
+ *
+ * RETURNS:
+ * 0 on success otherwise a negative error code
+ */
+int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
+{
+	int i, rc = 0;
+
+	for (i = 0; i < hpriv->nphys; i++) {
+		rc = phy_init(hpriv->phys[i]);
+		if (rc)
+			goto disable_phys;
+
+		rc = phy_power_on(hpriv->phys[i]);
+		if (rc) {
+			phy_exit(hpriv->phys[i]);
+			goto disable_phys;
+		}
+	}
+
+	return 0;
+
+disable_phys:
+	while (--i >= 0) {
+		phy_power_off(hpriv->phys[i]);
+		phy_exit(hpriv->phys[i]);
+	}
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_platform_enable_phys);
+
+/**
+ * ahci_platform_disable_phys - Enable PHYs
+ * @hpriv: host private area to store config values
+ *
+ * This function disables all PHYs found in hpriv->phys.
+ */
+void ahci_platform_disable_phys(struct ahci_host_priv *hpriv)
+{
+	int i;
+
+	for (i = 0; i < hpriv->nphys; i++) {
+		phy_power_off(hpriv->phys[i]);
+		phy_exit(hpriv->phys[i]);
+	}
+}
+EXPORT_SYMBOL_GPL(ahci_platform_disable_phys);
+
+/**
  * ahci_platform_enable_clks - Enable platform clocks
  * @hpriv: host private area to store config values
  *
@@ -92,7 +147,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_disable_clks);
  * following order:
  * 1) Regulator
  * 2) Clocks (through ahci_platform_enable_clks)
- * 3) Phy
+ * 3) Phys
  *
  * If resource enabling fails at any point the previous enabled resources
  * are disabled in reverse order.
@@ -114,17 +169,9 @@ int ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 	if (rc)
 		goto disable_regulator;
 
-	if (hpriv->phy) {
-		rc = phy_init(hpriv->phy);
-		if (rc)
-			goto disable_clks;
-
-		rc = phy_power_on(hpriv->phy);
-		if (rc) {
-			phy_exit(hpriv->phy);
-			goto disable_clks;
-		}
-	}
+	rc = ahci_platform_enable_phys(hpriv);
+	if (rc)
+		goto disable_clks;
 
 	return 0;
 
@@ -144,16 +191,13 @@ EXPORT_SYMBOL_GPL(ahci_platform_enable_resources);
  *
  * This function disables all ahci_platform managed resources in the
  * following order:
- * 1) Phy
+ * 1) Phys
  * 2) Clocks (through ahci_platform_disable_clks)
  * 3) Regulator
  */
 void ahci_platform_disable_resources(struct ahci_host_priv *hpriv)
 {
-	if (hpriv->phy) {
-		phy_power_off(hpriv->phy);
-		phy_exit(hpriv->phy);
-	}
+	ahci_platform_disable_phys(hpriv);
 
 	ahci_platform_disable_clks(hpriv);
 
@@ -187,7 +231,7 @@ static void ahci_platform_put_resources(struct device *dev, void *res)
  * 2) regulator for controlling the targets power (optional)
  * 3) 0 - AHCI_MAX_CLKS clocks, as specified in the devs devicetree node,
  *    or for non devicetree enabled platforms a single clock
- *	4) phy (optional)
+ *	4) phys (optional)
  *
  * RETURNS:
  * The allocated ahci_host_priv on success, otherwise an ERR_PTR value
@@ -197,7 +241,8 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct clk *clk;
-	int i, rc = -ENOMEM;
+	struct device_node *child;
+	int i, nports, rc = -ENOMEM;
 
 	if (!devres_open_group(dev, NULL, GFP_KERNEL))
 		return ERR_PTR(-ENOMEM);
@@ -246,22 +291,72 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev)
 		hpriv->clks[i] = clk;
 	}
 
-	hpriv->phy = devm_phy_get(dev, "sata-phy");
-	if (IS_ERR(hpriv->phy)) {
-		rc = PTR_ERR(hpriv->phy);
-		switch (rc) {
-		case -ENODEV:
-		case -ENOSYS:
-			/* continue normally */
-			hpriv->phy = NULL;
-			break;
+	nports = of_get_child_count(dev->of_node);
 
-		case -EPROBE_DEFER:
+	if (nports) {
+		hpriv->phys = devm_kzalloc(dev, nports * sizeof(*hpriv->phys),
+					   GFP_KERNEL);
+		if (!hpriv->phys) {
+			rc = -ENOMEM;
 			goto err_out;
+		}
 
-		default:
-			dev_err(dev, "couldn't get sata-phy\n");
-			goto err_out;
+		for_each_child_of_node(dev->of_node, child) {
+			u32 port;
+
+			if (!of_device_is_available(child))
+				continue;
+
+			if (of_property_read_u32(child, "reg", &port)) {
+				rc = -EINVAL;
+				goto err_out;
+			}
+
+			hpriv->port_map |= BIT(port);
+
+			hpriv->phys[hpriv->nphys] = devm_of_phy_get(dev, child,
+								    NULL);
+			if (IS_ERR(hpriv->phys[hpriv->nphys])) {
+				rc = PTR_ERR(hpriv->phys[hpriv->nphys]);
+				dev_err(dev,
+					"couldn't get PHY in node %s: %d\n",
+					child->name, rc);
+				goto err_out;
+			}
+
+			hpriv->nphys++;
+		}
+	} else {
+		/*
+		 * If no sub-node was found, keep this for device tree
+		 * compatibility
+		 */
+		struct phy *phy = devm_phy_get(dev, "sata-phy");
+		if (!IS_ERR(phy)) {
+			hpriv->phys = devm_kzalloc(dev, sizeof(*hpriv->phys),
+						   GFP_KERNEL);
+			if (!hpriv->phys) {
+				rc = -ENOMEM;
+				goto err_out;
+			}
+
+			hpriv->phys[0] = phy;
+			hpriv->nphys = 1;
+		} else {
+			rc = PTR_ERR(phy);
+			switch (rc) {
+			case -ENODEV:
+			case -ENOSYS:
+				/* continue normally */
+				break;
+
+			case -EPROBE_DEFER:
+				goto err_out;
+
+			default:
+				dev_err(dev, "couldn't get sata-phy\n");
+				goto err_out;
+			}
 		}
 	}
 
@@ -287,7 +382,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
  * @mask_port_map: param passed to ahci_save_initial_config
  *
  * This function does all the usual steps needed to bring up an
- * ahci-platform host, note any necessary resources (ie clks, phy, etc.)
+ * ahci-platform host, note any necessary resources (ie clks, phys, etc.)
  * must be initialized / enabled before calling this.
  *
  * RETURNS:
@@ -391,7 +486,7 @@ static void ahci_host_stop(struct ata_host *host)
  * @dev: device pointer for the host
  *
  * This function does all the usual steps needed to suspend an
- * ahci-platform host, note any necessary resources (ie clks, phy, etc.)
+ * ahci-platform host, note any necessary resources (ie clks, phys, etc.)
  * must be disabled after calling this.
  *
  * RETURNS:
@@ -428,7 +523,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_suspend_host);
  * @dev: device pointer for the host
  *
  * This function does all the usual steps needed to resume an ahci-platform
- * host, note any necessary resources (ie clks, phy, etc.)  must be
+ * host, note any necessary resources (ie clks, phys, etc.)  must be
  * initialized / enabled before calling this.
  *
  * RETURNS:
-- 
1.9.1

