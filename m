Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaH1Uxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:53:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:55048 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaH1Uxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473593622"
Subject: [PATCH 2/6] ntb: move platform detection to separate function
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@kudzu.us
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 13:53:07 -0700
Message-ID: <20140828205307.165750.63329.stgit@djiang5-desk2.amr.corp.intel.com>
In-Reply-To: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
References: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the platform detection function to separate functions to allow
easier maintenence.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/ntb/ntb_hw.c |   56 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index ce6680a..64ef836 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -109,6 +109,41 @@ static const struct pci_device_id ntb_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, ntb_pci_tbl);
 
+static int is_ntb_xeon(struct ntb_device *ndev)
+{
+	switch (ndev->pdev->device) {
+	case PCI_DEVICE_ID_INTEL_NTB_SS_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_HSX:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_HSX:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_HSX:
+		return 1;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
+static int is_ntb_atom(struct ntb_device *ndev)
+{
+	switch (ndev->pdev->device) {
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_BWD:
+		return 1;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
 /**
  * ntb_register_event_callback() - register event callback
  * @ndev: pointer to ntb_device instance
@@ -932,27 +967,12 @@ static int ntb_device_setup(struct ntb_device *ndev)
 {
 	int rc;
 
-	switch (ndev->pdev->device) {
-	case PCI_DEVICE_ID_INTEL_NTB_SS_JSF:
-	case PCI_DEVICE_ID_INTEL_NTB_SS_SNB:
-	case PCI_DEVICE_ID_INTEL_NTB_SS_IVT:
-	case PCI_DEVICE_ID_INTEL_NTB_SS_HSX:
-	case PCI_DEVICE_ID_INTEL_NTB_PS_JSF:
-	case PCI_DEVICE_ID_INTEL_NTB_PS_SNB:
-	case PCI_DEVICE_ID_INTEL_NTB_PS_IVT:
-	case PCI_DEVICE_ID_INTEL_NTB_PS_HSX:
-	case PCI_DEVICE_ID_INTEL_NTB_B2B_JSF:
-	case PCI_DEVICE_ID_INTEL_NTB_B2B_SNB:
-	case PCI_DEVICE_ID_INTEL_NTB_B2B_IVT:
-	case PCI_DEVICE_ID_INTEL_NTB_B2B_HSX:
+	if (is_ntb_xeon(ndev))
 		rc = ntb_xeon_setup(ndev);
-		break;
-	case PCI_DEVICE_ID_INTEL_NTB_B2B_BWD:
+	else if (is_ntb_atom(ndev))
 		rc = ntb_bwd_setup(ndev);
-		break;
-	default:
+	else
 		rc = -ENODEV;
-	}
 
 	if (rc)
 		return rc;

