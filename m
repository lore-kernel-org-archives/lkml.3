Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaIQO7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:59:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbaIQO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:59:41 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] pci: quirks: Add ACS quirk for Solarflare SFC9120 & SFC9140
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Robert Stonehouse <rstonehouse@solarflare.com>
Date: Wed, 17 Sep 2014 08:59:36 -0600
Message-ID: <20140917145838.19243.14630.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solarflare confirms that these devices do not allow peer-to-peer
between functions.  Quirk them to allow IOMMU grouping to expose this
isolation.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Robert Stonehouse <rstonehouse@solarflare.com>
---

 drivers/pci/quirks.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 80c2d01..78cc83f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3664,6 +3664,21 @@ static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
 	return acs_flags & ~flags ? 0 : 1;
 }
 
+static int pci_quirk_solarflare_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	/*
+	 * SV, TB, and UF are not relevant to multifunction endpoints.
+	 *
+	 * Solarflare indicates that peer-to-peer between functions is not
+	 * possible, therefore RR, CR, and DT are not implemented.  Mask
+	 * these out as if they were clear in the ACS capabilities register.
+	 */
+	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
+		       PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
+
+	return acs_flags ? 0 : 1;
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
@@ -3675,6 +3690,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_ATI, 0x439d, pci_quirk_amd_sb_acs },
 	{ PCI_VENDOR_ID_ATI, 0x4384, pci_quirk_amd_sb_acs },
 	{ PCI_VENDOR_ID_ATI, 0x4399, pci_quirk_amd_sb_acs },
+	{ PCI_VENDOR_ID_SOLARFLARE, 0x0903, pci_quirk_solarflare_acs },
+	{ PCI_VENDOR_ID_SOLARFLARE, 0x0923, pci_quirk_solarflare_acs },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_quirk_intel_pch_acs },
 	{ 0 }
 };

