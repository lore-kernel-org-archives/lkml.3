Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab3LHPM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:12:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36506 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861Ab3LHPM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:12:56 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Lance Ortiz <lance.ortiz@hp.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH 1/2] PCI, AER: Add a TLP header print helper
Date: Sun,  8 Dec 2013 16:12:50 +0100
Message-Id: <1386515571-23252-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... and call it instead of duplicating the large printk format
statement.

No functionality change.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/pci/pcie/aer/aerdrv_errprint.c | 44 ++++++++++++++++------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 2c7c9f5f592c..32efc5e0d2eb 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -124,6 +124,21 @@ static const char *aer_agent_string[] = {
 	"Transmitter ID"
 };
 
+static void __print_tlp_header(struct pci_dev *dev,
+			       struct aer_header_log_regs *t)
+{
+	unsigned char *tlp = (unsigned char *)&t;
+
+	dev_err(&dev->dev, "  TLP Header:"
+		" %02x%02x%02x%02x %02x%02x%02x%02x"
+		" %02x%02x%02x%02x %02x%02x%02x%02x\n",
+		*(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
+		*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
+		*(tlp + 11), *(tlp + 10), *(tlp + 9),
+		*(tlp + 8), *(tlp + 15), *(tlp + 14),
+		*(tlp + 13), *(tlp + 12));
+}
+
 static void __aer_print_error(struct pci_dev *dev,
 			      struct aer_err_info *info)
 {
@@ -178,17 +193,8 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 
 		__aer_print_error(dev, info);
 
-		if (info->tlp_header_valid) {
-			unsigned char *tlp = (unsigned char *) &info->tlp;
-			dev_err(&dev->dev, "  TLP Header:"
-				" %02x%02x%02x%02x %02x%02x%02x%02x"
-				" %02x%02x%02x%02x %02x%02x%02x%02x\n",
-				*(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
-				*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
-				*(tlp + 11), *(tlp + 10), *(tlp + 9),
-				*(tlp + 8), *(tlp + 15), *(tlp + 14),
-				*(tlp + 13), *(tlp + 12));
-		}
+		if (info->tlp_header_valid)
+			__print_tlp_header(dev, &info->tlp);
 	}
 
 	if (info->id && info->error_dev_num > 1 && info->id == id)
@@ -250,18 +256,10 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 	if (aer_severity != AER_CORRECTABLE)
 		dev_err(&dev->dev, "aer_uncor_severity: 0x%08x\n",
 		       aer->uncor_severity);
-	if (tlp_header_valid) {
-		const unsigned char *tlp;
-		tlp = (const unsigned char *)&aer->header_log;
-		dev_err(&dev->dev, "aer_tlp_header:"
-			" %02x%02x%02x%02x %02x%02x%02x%02x"
-			" %02x%02x%02x%02x %02x%02x%02x%02x\n",
-			*(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
-			*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
-			*(tlp + 11), *(tlp + 10), *(tlp + 9),
-			*(tlp + 8), *(tlp + 15), *(tlp + 14),
-			*(tlp + 13), *(tlp + 12));
-	}
+
+	if (tlp_header_valid)
+		__print_tlp_header(dev, &aer->header_log);
+
 	trace_aer_event(dev_name(&dev->dev), (status & ~mask),
 			aer_severity);
 }
-- 
1.8.4

