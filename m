Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaH1Uxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:53:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:55048 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaH1Uxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:53:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473593640"
Subject: [PATCH 3/6] ntb: conslidate reading of PPD to move platform
 detection earlier
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@kudzu.us
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 13:53:13 -0700
Message-ID: <20140828205313.165750.64519.stgit@djiang5-desk2.amr.corp.intel.com>
In-Reply-To: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
References: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simplify some of the platform detection code. Move the platform detection
to a function to be called earlier.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/ntb/ntb_hw.c |  130 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 100 insertions(+), 30 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 64ef836..d6f4268 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -702,24 +702,8 @@ static void bwd_link_poll(struct work_struct *work)
 
 static int ntb_xeon_setup(struct ntb_device *ndev)
 {
-	int rc;
-	u8 val;
-
-	ndev->hw_type = SNB_HW;
-
-	rc = pci_read_config_byte(ndev->pdev, NTB_PPD_OFFSET, &val);
-	if (rc)
-		return rc;
-
-	if (val & SNB_PPD_DEV_TYPE)
-		ndev->dev_type = NTB_DEV_USD;
-	else
-		ndev->dev_type = NTB_DEV_DSD;
-
-	switch (val & SNB_PPD_CONN_TYPE) {
+	switch (ndev->conn_type) {
 	case NTB_CONN_B2B:
-		dev_info(&ndev->pdev->dev, "Conn Type = B2B\n");
-		ndev->conn_type = NTB_CONN_B2B;
 		ndev->reg_ofs.ldb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
 		ndev->reg_ofs.ldb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
 		ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
@@ -835,9 +819,6 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		}
 		break;
 	case NTB_CONN_RP:
-		dev_info(&ndev->pdev->dev, "Conn Type = RP\n");
-		ndev->conn_type = NTB_CONN_RP;
-
 		if (xeon_errata_workaround) {
 			dev_err(&ndev->pdev->dev,
 				"NTB-RP disabled due to hardware errata.  To disregard this warning and potentially lock-up the system, add the parameter 'xeon_errata_workaround=0'.\n");
@@ -867,8 +848,6 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->limits.max_mw = SNB_MAX_MW;
 		break;
 	case NTB_CONN_TRANSPARENT:
-		dev_info(&ndev->pdev->dev, "Conn Type = TRANSPARENT\n");
-		ndev->conn_type = NTB_CONN_TRANSPARENT;
 		/* Scratch pads need to have exclusive access from the primary
 		 * or secondary side.  Halve the num spads so that each side can
 		 * have an equal amount.
@@ -890,10 +869,10 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->limits.max_mw = SNB_MAX_MW;
 		break;
 	default:
-		/* Most likely caused by the remote NTB-RP device not being
-		 * configured
+		/*
+		 * we should never hit this. the detect function should've
+		 * take cared of everything.
 		 */
-		dev_err(&ndev->pdev->dev, "Unknown PPD %x\n", val);
 		return -EINVAL;
 	}
 
@@ -967,9 +946,9 @@ static int ntb_device_setup(struct ntb_device *ndev)
 {
 	int rc;
 
-	if (is_ntb_xeon(ndev))
+	if (ndev->hw_type == SNB_HW)
 		rc = ntb_xeon_setup(ndev);
-	else if (is_ntb_atom(ndev))
+	else if (ndev->hw_type == BWD_HW)
 		rc = ntb_bwd_setup(ndev);
 	else
 		rc = -ENODEV;
@@ -977,9 +956,6 @@ static int ntb_device_setup(struct ntb_device *ndev)
 	if (rc)
 		return rc;
 
-	dev_info(&ndev->pdev->dev, "Device Type = %s\n",
-		 ndev->dev_type == NTB_DEV_USD ? "USD/DSP" : "DSD/USP");
-
 	if (ndev->conn_type == NTB_CONN_B2B)
 		/* Enable Bus Master and Memory Space on the secondary side */
 		writew(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER,
@@ -1519,6 +1495,96 @@ static void ntb_hw_link_down(struct ntb_device *ndev)
 	writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
 }
 
+static int ntb_xeon_detect(struct ntb_device *ndev)
+{
+	int rc;
+	u8 ppd;
+
+	ndev->hw_type = SNB_HW;
+
+	rc = pci_read_config_byte(ndev->pdev, NTB_PPD_OFFSET, &ppd);
+	if (rc)
+		return -EIO;
+
+	if (ppd & SNB_PPD_DEV_TYPE)
+		ndev->dev_type = NTB_DEV_USD;
+	else
+		ndev->dev_type = NTB_DEV_DSD;
+
+	switch (ppd & SNB_PPD_CONN_TYPE) {
+	case NTB_CONN_B2B:
+		dev_info(&ndev->pdev->dev, "Conn Type = B2B\n");
+		ndev->conn_type = NTB_CONN_B2B;
+		break;
+	case NTB_CONN_RP:
+		dev_info(&ndev->pdev->dev, "Conn Type = RP\n");
+		ndev->conn_type = NTB_CONN_RP;
+		break;
+	case NTB_CONN_TRANSPARENT:
+		dev_info(&ndev->pdev->dev, "Conn Type = TRANSPARENT\n");
+		ndev->conn_type = NTB_CONN_TRANSPARENT;
+		/*
+		 * This mode is default to USD/DSP. HW does not report
+		 * properly in transparent mode as it has no knowledge of
+		 * NTB. We will just force correct here.
+		 */
+		ndev->dev_type = NTB_DEV_USD;
+		break;
+	default:
+		dev_err(&ndev->pdev->dev, "Unknown PPD %x\n", ppd);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int ntb_atom_detect(struct ntb_device *ndev)
+{
+	int rc;
+	u32 ppd;
+
+	ndev->hw_type = BWD_HW;
+
+	rc = pci_read_config_dword(ndev->pdev, NTB_PPD_OFFSET, &ppd);
+	if (rc)
+		return rc;
+
+	switch ((ppd & BWD_PPD_CONN_TYPE) >> 8) {
+	case NTB_CONN_B2B:
+		dev_info(&ndev->pdev->dev, "Conn Type = B2B\n");
+		ndev->conn_type = NTB_CONN_B2B;
+		break;
+	case NTB_CONN_RP:
+	default:
+		dev_err(&ndev->pdev->dev, "Unsupported NTB configuration\n");
+		return -EINVAL;
+	}
+
+	if (ppd & BWD_PPD_DEV_TYPE)
+		ndev->dev_type = NTB_DEV_DSD;
+	else
+		ndev->dev_type = NTB_DEV_USD;
+
+	return 0;
+}
+
+static int ntb_device_detect(struct ntb_device *ndev)
+{
+	int rc;
+
+	if (is_ntb_xeon(ndev))
+		rc = ntb_xeon_detect(ndev);
+	else if (is_ntb_atom(ndev))
+		rc = ntb_atom_detect(ndev);
+	else
+		rc = -ENODEV;
+
+	dev_info(&ndev->pdev->dev, "Device Type = %s\n",
+		 ndev->dev_type == NTB_DEV_USD ? "USD/DSP" : "DSD/USP");
+
+	return 0;
+}
+
 static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ntb_device *ndev;
@@ -1539,6 +1605,10 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(ndev->pdev);
 
+	rc = ntb_device_detect(ndev);
+	if (rc)
+		goto err;
+
 	rc = pci_request_selected_regions(pdev, NTB_BAR_MASK, KBUILD_MODNAME);
 	if (rc)
 		goto err1;

