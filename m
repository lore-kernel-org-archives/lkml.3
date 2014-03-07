Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaCGGKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:10:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:51678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaCGGKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:10:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="scan'208";a="493970252"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and SDA hold time value
Date: Fri,  7 Mar 2014 22:12:51 +0800
Message-Id: <1394201571-11681-3-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

On Intel BayTrail, there was case whereby the resulting fast mode
bus speed becomes slower (~20% slower compared to expected speed)
if using the HCNT/LCNT calculated in the core layer. Thus, this
patch is added to allow pci glue layer to pass in optimal
HCNT/LCNT/SDA hold time values to core layer since the core
layer supports cofigurable HCNT/LCNT/SDA hold time values now.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |   34 ++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 87f2fc4..96417ca 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -58,6 +58,14 @@ enum dw_pci_ctl_id_t {
 	baytrail,
 };
 
+struct scl_sda_cfg {
+	u32 ss_hcnt;
+	u32 fs_hcnt;
+	u32 ss_lcnt;
+	u32 fs_lcnt;
+	u32 sda_hold;
+};
+
 struct dw_pci_controller {
 	u32 bus_num;
 	u32 bus_cfg;
@@ -65,6 +73,7 @@ struct dw_pci_controller {
 	u32 rx_fifo_depth;
 	u32 clk_khz;
 	u32 functionality;
+	struct scl_sda_cfg *scl_sda_cfg;
 };
 
 #define INTEL_MID_STD_CFG  (DW_IC_CON_MASTER |			\
@@ -77,6 +86,21 @@ struct dw_pci_controller {
 					I2C_FUNC_SMBUS_WORD_DATA |	\
 					I2C_FUNC_SMBUS_I2C_BLOCK)
 
+/* BayTrail HCNT/LCNT/SDA_HOLD */
+#define BYT_STD_MODE_HCNT	0x200
+#define BYT_STD_MODE_LCNT	BYT_STD_MODE_HCNT
+#define BYT_FAST_MODE_HCNT	0x55
+#define BYT_FAST_MODE_LCNT	0x99
+#define BYT_SDA_HOLD		0x6
+
+static struct scl_sda_cfg byt_config = {
+	.ss_hcnt	= BYT_STD_MODE_HCNT,
+	.fs_hcnt	= BYT_FAST_MODE_HCNT,
+	.ss_lcnt	= BYT_STD_MODE_LCNT,
+	.fs_lcnt	= BYT_FAST_MODE_LCNT,
+	.sda_hold	= BYT_SDA_HOLD,
+};
+
 static struct  dw_pci_controller  dw_pci_controllers[] = {
 	[moorestown_0] = {
 		.bus_num     = 0,
@@ -148,6 +172,7 @@ static struct  dw_pci_controller  dw_pci_controllers[] = {
 		.rx_fifo_depth = 32,
 		.clk_khz = 100000,
 		.functionality = I2C_FUNC_10BIT_ADDR,
+		.scl_sda_cfg = &byt_config,
 	},
 };
 static struct i2c_algorithm i2c_dw_algo = {
@@ -231,6 +256,7 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	struct i2c_adapter *adap;
 	int r;
 	struct  dw_pci_controller *controller;
+	struct scl_sda_cfg *cfg;
 
 	if (id->driver_data >= ARRAY_SIZE(dw_pci_controllers)) {
 		dev_err(&pdev->dev, "%s: invalid driver data %ld\n", __func__,
@@ -268,6 +294,14 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 				DW_DEFAULT_FUNCTIONALITY;
 
 	dev->master_cfg =  controller->bus_cfg;
+	if (controller->scl_sda_cfg) {
+		cfg = controller->scl_sda_cfg;
+		dev->ss_hcnt = cfg->ss_hcnt;
+		dev->fs_hcnt = cfg->fs_hcnt;
+		dev->ss_lcnt = cfg->ss_lcnt;
+		dev->fs_lcnt = cfg->fs_lcnt;
+		dev->sda_hold_time = cfg->sda_hold;
+	}
 
 	pci_set_drvdata(pdev, dev);
 
-- 
1.7.4.4

