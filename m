Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3CISQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:16:57 -0500
Received: from smtp-out-195.synserver.de ([212.40.185.195]:1131 "EHLO
	smtp-out-193.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880Ab3CISPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:15:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31737
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jean Delvare <khali@linux-fr.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Shawn Guo <shawn.guo@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Lars Poeschel <poeschel@lemonage.de>
Subject: [PATCH 3/6] i2c: Ignore return value of i2c_del_adapter()
Date: Sat,  9 Mar 2013 19:16:46 +0100
Message-Id: <1362853009-20789-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362853009-20789-1-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_del_adapter() always returns 0. So all checks testing whether it will be
non zero will always evaluate to false and the conditional code is dead code.
This patch updates all callers of i2c_del_mux_adapter() to ignore the return
value and assume that it will always succeed (which it will). In a subsequent
patch the return type of i2c_del_adapter() will be made void.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Marek Vasut <marex@denx.de> (commit_signer:11/20=55%)
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Lars Poeschel <poeschel@lemonage.de>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c   |  3 +--
 drivers/i2c/busses/i2c-amd756-s4882.c        |  6 +-----
 drivers/i2c/busses/i2c-at91.c                |  5 ++---
 drivers/i2c/busses/i2c-cbus-gpio.c           |  4 +++-
 drivers/i2c/busses/i2c-intel-mid.c           |  3 +--
 drivers/i2c/busses/i2c-mv64xxx.c             |  5 ++---
 drivers/i2c/busses/i2c-mxs.c                 |  5 +----
 drivers/i2c/busses/i2c-nforce2-s4985.c       |  6 +-----
 drivers/i2c/busses/i2c-powermac.c            | 10 ++--------
 drivers/i2c/busses/i2c-puv3.c                | 10 ++--------
 drivers/i2c/busses/i2c-viperboard.c          |  5 ++---
 drivers/i2c/i2c-mux.c                        |  5 +----
 drivers/media/pci/bt8xx/bttv-input.c         |  6 +++---
 drivers/media/pci/mantis/mantis_i2c.c        |  4 +++-
 drivers/net/ethernet/sfc/falcon.c            |  6 ++----
 drivers/staging/media/go7007/go7007-driver.c |  7 ++-----
 16 files changed, 29 insertions(+), 61 deletions(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
index 88627e3..1eb86c7 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
@@ -319,8 +319,7 @@ void oaktrail_hdmi_i2c_exit(struct pci_dev *dev)
 	struct hdmi_i2c_dev *i2c_dev;
 
 	hdmi_dev = pci_get_drvdata(dev);
-	if (i2c_del_adapter(&oaktrail_hdmi_i2c_adapter))
-		DRM_DEBUG_DRIVER("Failed to delete hdmi-i2c adapter\n");
+	i2c_del_adapter(&oaktrail_hdmi_i2c_adapter);
 
 	i2c_dev = hdmi_dev->i2c_dev;
 	kfree(i2c_dev);
diff --git a/drivers/i2c/busses/i2c-amd756-s4882.c b/drivers/i2c/busses/i2c-amd756-s4882.c
index 378fcb5..07f01ac 100644
--- a/drivers/i2c/busses/i2c-amd756-s4882.c
+++ b/drivers/i2c/busses/i2c-amd756-s4882.c
@@ -169,11 +169,7 @@ static int __init amd756_s4882_init(void)
 	}
 
 	/* Unregister physical bus */
-	error = i2c_del_adapter(&amd756_smbus);
-	if (error) {
-		dev_err(&amd756_smbus.dev, "Physical bus removal failed\n");
-		goto ERROR0;
-	}
+	i2c_del_adapter(&amd756_smbus);
 
 	printk(KERN_INFO "Enabling SMBus multiplexing for Tyan S4882\n");
 	/* Define the 5 virtual adapters and algorithms structures */
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 75195e3..6604587 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -785,12 +785,11 @@ static int at91_twi_probe(struct platform_device *pdev)
 static int at91_twi_remove(struct platform_device *pdev)
 {
 	struct at91_twi_dev *dev = platform_get_drvdata(pdev);
-	int rc;
 
-	rc = i2c_del_adapter(&dev->adapter);
+	i2c_del_adapter(&dev->adapter);
 	clk_disable_unprepare(dev->clk);
 
-	return rc;
+	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/i2c/busses/i2c-cbus-gpio.c b/drivers/i2c/busses/i2c-cbus-gpio.c
index 98386d6..1be13ac 100644
--- a/drivers/i2c/busses/i2c-cbus-gpio.c
+++ b/drivers/i2c/busses/i2c-cbus-gpio.c
@@ -206,7 +206,9 @@ static int cbus_i2c_remove(struct platform_device *pdev)
 {
 	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
 
-	return i2c_del_adapter(adapter);
+	i2c_del_adapter(adapter);
+
+	return 0;
 }
 
 static int cbus_i2c_probe(struct platform_device *pdev)
diff --git a/drivers/i2c/busses/i2c-intel-mid.c b/drivers/i2c/busses/i2c-intel-mid.c
index 323fa01..0fb6597 100644
--- a/drivers/i2c/busses/i2c-intel-mid.c
+++ b/drivers/i2c/busses/i2c-intel-mid.c
@@ -1082,8 +1082,7 @@ static void intel_mid_i2c_remove(struct pci_dev *dev)
 {
 	struct intel_mid_i2c_private *mrst = pci_get_drvdata(dev);
 	intel_mid_i2c_disable(&mrst->adap);
-	if (i2c_del_adapter(&mrst->adap))
-		dev_err(&dev->dev, "Failed to delete i2c adapter");
+	i2c_del_adapter(&mrst->adap);
 
 	free_irq(dev->irq, mrst);
 	iounmap(mrst->base);
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 8b20ef8..3bbd65d 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -701,9 +701,8 @@ static int
 mv64xxx_i2c_remove(struct platform_device *dev)
 {
 	struct mv64xxx_i2c_data		*drv_data = platform_get_drvdata(dev);
-	int	rc;
 
-	rc = i2c_del_adapter(&drv_data->adapter);
+	i2c_del_adapter(&drv_data->adapter);
 	free_irq(drv_data->irq, drv_data);
 	mv64xxx_i2c_unmap_regs(drv_data);
 #if defined(CONFIG_HAVE_CLK)
@@ -715,7 +714,7 @@ mv64xxx_i2c_remove(struct platform_device *dev)
 #endif
 	kfree(drv_data);
 
-	return rc;
+	return 0;
 }
 
 static const struct of_device_id mv64xxx_i2c_of_match_table[] = {
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 120f246..804eb6b 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -686,11 +686,8 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 static int mxs_i2c_remove(struct platform_device *pdev)
 {
 	struct mxs_i2c_dev *i2c = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = i2c_del_adapter(&i2c->adapter);
-	if (ret)
-		return -EBUSY;
+	i2c_del_adapter(&i2c->adapter);
 
 	if (i2c->dmach)
 		dma_release_channel(i2c->dmach);
diff --git a/drivers/i2c/busses/i2c-nforce2-s4985.c b/drivers/i2c/busses/i2c-nforce2-s4985.c
index 29015eb..2ca268d 100644
--- a/drivers/i2c/busses/i2c-nforce2-s4985.c
+++ b/drivers/i2c/busses/i2c-nforce2-s4985.c
@@ -164,11 +164,7 @@ static int __init nforce2_s4985_init(void)
 	}
 
 	/* Unregister physical bus */
-	error = i2c_del_adapter(nforce2_smbus);
-	if (error) {
-		dev_err(&nforce2_smbus->dev, "Physical bus removal failed\n");
-		goto ERROR0;
-	}
+	i2c_del_adapter(nforce2_smbus);
 
 	printk(KERN_INFO "Enabling SMBus multiplexing for Tyan S4985\n");
 	/* Define the 5 virtual adapters and algorithms structures */
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index da54e67..8dc90da 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -213,14 +213,8 @@ static const struct i2c_algorithm i2c_powermac_algorithm = {
 static int i2c_powermac_remove(struct platform_device *dev)
 {
 	struct i2c_adapter	*adapter = platform_get_drvdata(dev);
-	int			rc;
-
-	rc = i2c_del_adapter(adapter);
-	/* We aren't that prepared to deal with this... */
-	if (rc)
-		printk(KERN_WARNING
-		       "i2c-powermac.c: Failed to remove bus %s !\n",
-		       adapter->name);
+
+	i2c_del_adapter(adapter);
 	memset(adapter, 0, sizeof(*adapter));
 
 	return 0;
diff --git a/drivers/i2c/busses/i2c-puv3.c b/drivers/i2c/busses/i2c-puv3.c
index 261d7db..4fd47bc 100644
--- a/drivers/i2c/busses/i2c-puv3.c
+++ b/drivers/i2c/busses/i2c-puv3.c
@@ -234,21 +234,15 @@ static int puv3_i2c_remove(struct platform_device *pdev)
 {
 	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
 	struct resource *mem;
-	int rc;
 
-	rc = i2c_del_adapter(adapter);
-	if (rc) {
-		dev_err(&pdev->dev, "Adapter '%s' delete fail\n",
-				adapter->name);
-		return rc;
-	}
+	i2c_del_adapter(adapter);
 
 	put_device(&pdev->dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
 
-	return rc;
+	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/i2c/busses/i2c-viperboard.c b/drivers/i2c/busses/i2c-viperboard.c
index f45c32c..c68450c 100644
--- a/drivers/i2c/busses/i2c-viperboard.c
+++ b/drivers/i2c/busses/i2c-viperboard.c
@@ -421,11 +421,10 @@ error:
 static int vprbrd_i2c_remove(struct platform_device *pdev)
 {
 	struct vprbrd_i2c *vb_i2c = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = i2c_del_adapter(&vb_i2c->i2c);
+	i2c_del_adapter(&vb_i2c->i2c);
 
-	return ret;
+	return 0;
 }
 
 static struct platform_driver vprbrd_i2c_driver = {
diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index d94e0ce..361b78d 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -194,11 +194,8 @@ EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
 int i2c_del_mux_adapter(struct i2c_adapter *adap)
 {
 	struct i2c_mux_priv *priv = adap->algo_data;
-	int ret;
 
-	ret = i2c_del_adapter(adap);
-	if (ret < 0)
-		return ret;
+	i2c_del_adapter(adap);
 	kfree(priv);
 
 	return 0;
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 04207a7..f42d26d 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -413,10 +413,10 @@ void init_bttv_i2c_ir(struct bttv *btv)
 
 int fini_bttv_i2c(struct bttv *btv)
 {
-	if (0 != btv->i2c_rc)
-		return 0;
+	if (btv->i2c_rc == 0)
+		i2c_del_adapter(&btv->c.i2c_adap);
 
-	return i2c_del_adapter(&btv->c.i2c_adap);
+	return 0;
 }
 
 int bttv_input_init(struct bttv *btv)
diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
index 937fb9d..895ddba 100644
--- a/drivers/media/pci/mantis/mantis_i2c.c
+++ b/drivers/media/pci/mantis/mantis_i2c.c
@@ -261,6 +261,8 @@ int mantis_i2c_exit(struct mantis_pci *mantis)
 	mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
 
 	dprintk(MANTIS_DEBUG, 1, "Removing I2C adapter");
-	return i2c_del_adapter(&mantis->adapter);
+	i2c_del_adapter(&mantis->adapter);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mantis_i2c_exit);
diff --git a/drivers/net/ethernet/sfc/falcon.c b/drivers/net/ethernet/sfc/falcon.c
index 49bcd19..defed0e 100644
--- a/drivers/net/ethernet/sfc/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon.c
@@ -1528,7 +1528,7 @@ static int falcon_probe_nic(struct efx_nic *efx)
 	return 0;
 
  fail6:
-	BUG_ON(i2c_del_adapter(&board->i2c_adap));
+	i2c_del_adapter(&board->i2c_adap);
 	memset(&board->i2c_adap, 0, sizeof(board->i2c_adap));
  fail5:
 	efx_nic_free_buffer(efx, &efx->irq_status);
@@ -1665,13 +1665,11 @@ static void falcon_remove_nic(struct efx_nic *efx)
 {
 	struct falcon_nic_data *nic_data = efx->nic_data;
 	struct falcon_board *board = falcon_board(efx);
-	int rc;
 
 	board->type->fini(efx);
 
 	/* Remove I2C adapter and clear it in preparation for a retry */
-	rc = i2c_del_adapter(&board->i2c_adap);
-	BUG_ON(rc);
+	i2c_del_adapter(&board->i2c_adap);
 	memset(&board->i2c_adap, 0, sizeof(board->i2c_adap));
 
 	efx_nic_free_buffer(efx, &efx->irq_status);
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 6695091..6f83c52 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -647,11 +647,8 @@ EXPORT_SYMBOL(go7007_alloc);
 void go7007_remove(struct go7007 *go)
 {
 	if (go->i2c_adapter_online) {
-		if (i2c_del_adapter(&go->i2c_adapter) == 0)
-			go->i2c_adapter_online = 0;
-		else
-			v4l2_err(&go->v4l2_dev,
-				"error removing I2C adapter!\n");
+		i2c_del_adapter(&go->i2c_adapter);
+		go->i2c_adapter_online = 0;
 	}
 
 	if (go->audio_enabled)
-- 
1.8.0

