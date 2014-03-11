Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaCKDbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:31:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:38030 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbaCKDbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:31:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,628,1389772800"; 
   d="scan'208";a="497413308"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lim Lee Booi <lee.booi.lim@intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 RESEND] i2c: designware-pci: set ideal HCNT, LCNT and SDA hold time value
Date: Tue, 11 Mar 2014 19:33:45 +0800
Message-Id: <1394537625-27205-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
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
v2 changelog:
* Add 'dw_' prefix to struct scl_sda_cfg
* Add Baytrail HCNT/LCNT/SDA hold time values directly in the
  struct instead of using macro definition
* Replace tab before "=" with space in struct

 drivers/i2c/busses/i2c-designware-pcidrv.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 094509bc..91d468f 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -58,6 +58,14 @@ enum dw_pci_ctl_id_t {
 	baytrail,
 };
 
+struct dw_scl_sda_cfg {
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
+	struct dw_scl_sda_cfg *scl_sda_cfg;
 };
 
 #define INTEL_MID_STD_CFG  (DW_IC_CON_MASTER |			\
@@ -77,6 +86,15 @@ struct dw_pci_controller {
 					I2C_FUNC_SMBUS_WORD_DATA |	\
 					I2C_FUNC_SMBUS_I2C_BLOCK)
 
+/* BayTrail HCNT/LCNT/SDA hold time */
+static struct dw_scl_sda_cfg byt_config = {
+	.ss_hcnt = 0x200,
+	.fs_hcnt = 0x55,
+	.ss_lcnt = 0x200,
+	.fs_lcnt = 0x99,
+	.sda_hold = 0x6,
+};
+
 static struct  dw_pci_controller  dw_pci_controllers[] = {
 	[moorestown_0] = {
 		.bus_num     = 0,
@@ -148,6 +166,7 @@ static struct  dw_pci_controller  dw_pci_controllers[] = {
 		.rx_fifo_depth = 32,
 		.clk_khz = 100000,
 		.functionality = I2C_FUNC_10BIT_ADDR,
+		.scl_sda_cfg = &byt_config,
 	},
 };
 static struct i2c_algorithm i2c_dw_algo = {
@@ -187,6 +206,7 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	struct i2c_adapter *adap;
 	int r;
 	struct  dw_pci_controller *controller;
+	struct dw_scl_sda_cfg *cfg;
 
 	if (id->driver_data >= ARRAY_SIZE(dw_pci_controllers)) {
 		dev_err(&pdev->dev, "%s: invalid driver data %ld\n", __func__,
@@ -224,6 +244,14 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
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

