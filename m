Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab3LHPNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:13:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36509 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3LHPM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:12:56 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Lance Ortiz <lance.ortiz@hp.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/2] PCI, AER: Clean up error printing code a bit
Date: Sun,  8 Dec 2013 16:12:51 +0100
Message-Id: <1386515571-23252-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386515571-23252-1-git-send-email-bp@alien8.de>
References: <1386515571-23252-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Save one indentation level in aer_print_error for the generic case where
we have info->status of an error, disregard 80 cols rule a bit for the
sake of better readability, fix alignment.

No functionality change.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/pci/pcie/aer/aerdrv_errprint.c | 51 ++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 32efc5e0d2eb..34ff7026440c 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -168,39 +168,39 @@ static void __aer_print_error(struct pci_dev *dev,
 
 void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 {
+	int layer, agent;
 	int id = ((dev->bus->number << 8) | dev->devfn);
 
-	if (info->status == 0) {
+	if (!info->status) {
 		dev_err(&dev->dev,
 			"PCIe Bus Error: severity=%s, type=Unaccessible, "
 			"id=%04x(Unregistered Agent ID)\n",
 			aer_error_severity_string[info->severity], id);
-	} else {
-		int layer, agent;
+		goto out;
+	}
 
-		layer = AER_GET_LAYER_ERROR(info->severity, info->status);
-		agent = AER_GET_AGENT(info->severity, info->status);
+	layer = AER_GET_LAYER_ERROR(info->severity, info->status);
+	agent = AER_GET_AGENT(info->severity, info->status);
 
-		dev_err(&dev->dev,
-			"PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
-			aer_error_severity_string[info->severity],
-			aer_error_layer[layer], id, aer_agent_string[agent]);
+	dev_err(&dev->dev,
+		"PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
+		aer_error_severity_string[info->severity],
+		aer_error_layer[layer], id, aer_agent_string[agent]);
 
-		dev_err(&dev->dev,
-			"  device [%04x:%04x] error status/mask=%08x/%08x\n",
-			dev->vendor, dev->device,
-			info->status, info->mask);
+	dev_err(&dev->dev,
+		"  device [%04x:%04x] error status/mask=%08x/%08x\n",
+		dev->vendor, dev->device,
+		info->status, info->mask);
 
-		__aer_print_error(dev, info);
+	__aer_print_error(dev, info);
 
-		if (info->tlp_header_valid)
-			__print_tlp_header(dev, &info->tlp);
-	}
+	if (info->tlp_header_valid)
+		__print_tlp_header(dev, &info->tlp);
 
+out:
 	if (info->id && info->error_dev_num > 1 && info->id == id)
-		dev_err(&dev->dev,
-			   "  Error of this Agent(%04x) is reported first\n",
-			id);
+		dev_err(&dev->dev, "  Error of this Agent(%04x) is reported first\n", id);
+
 	trace_aer_event(dev_name(&dev->dev), (info->status & ~info->mask),
 			info->severity);
 }
@@ -234,6 +234,7 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 	const char **status_strs;
 
 	aer_severity = cper_severity_to_aer(cper_severity);
+
 	if (aer_severity == AER_CORRECTABLE) {
 		status = aer->cor_status;
 		mask = aer->cor_mask;
@@ -246,16 +247,18 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 		status_strs_size = ARRAY_SIZE(aer_uncorrectable_error_string);
 		tlp_header_valid = status & AER_LOG_TLP_MASKS;
 	}
+
 	layer = AER_GET_LAYER_ERROR(aer_severity, status);
 	agent = AER_GET_AGENT(aer_severity, status);
-	dev_err(&dev->dev, "aer_status: 0x%08x, aer_mask: 0x%08x\n",
-	       status, mask);
+
+	dev_err(&dev->dev, "aer_status: 0x%08x, aer_mask: 0x%08x\n", status, mask);
 	cper_print_bits("", status, status_strs, status_strs_size);
 	dev_err(&dev->dev, "aer_layer=%s, aer_agent=%s\n",
-	       aer_error_layer[layer], aer_agent_string[agent]);
+		aer_error_layer[layer], aer_agent_string[agent]);
+
 	if (aer_severity != AER_CORRECTABLE)
 		dev_err(&dev->dev, "aer_uncor_severity: 0x%08x\n",
-		       aer->uncor_severity);
+			aer->uncor_severity);
 
 	if (tlp_header_valid)
 		__print_tlp_header(dev, &aer->header_log);
-- 
1.8.4

