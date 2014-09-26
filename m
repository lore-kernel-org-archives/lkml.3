Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaIZXIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbaIZXIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:08:04 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] PCI: Intel 10G NIC ACS quirks
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        John Ronciak <john.ronciak@intel.com>
Date: Fri, 26 Sep 2014 17:07:59 -0600
Message-ID: <20140926230717.17458.59969.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel has verified there is no peer-to-peer between functions for the
below selection of 82598, 82599, and X520 10G NICs.  These NICs lack
an ACS capability, so we're not able to determine this isolation
without the help of quirks.  Generalize the Solarflare quirk and add
these.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: John Ronciak <john.ronciak@intel.com>
---

 drivers/pci/quirks.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 95239e0..b6c6500 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3635,14 +3635,16 @@ static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
 	return acs_flags & ~flags ? 0 : 1;
 }
 
-static int pci_quirk_solarflare_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	/*
 	 * SV, TB, and UF are not relevant to multifunction endpoints.
 	 *
-	 * Solarflare indicates that peer-to-peer between functions is not
-	 * possible, therefore RR, CR, and DT are not implemented.  Mask
-	 * these out as if they were clear in the ACS capabilities register.
+	 * Multifunction devices are only required to implement RR, CR, and DT
+	 * in their ACS capability if they support peer-to-peer transactions.
+	 * Devices matching this quirk have been verified by the vendor to not
+	 * perform peer-to-peer with other functions, allowing us to mask out
+	 * these bits as if they were unimplemented in the ACS capability.
 	 */
 	acs_flags &= ~(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
 		       PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
@@ -3661,8 +3663,28 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_ATI, 0x439d, pci_quirk_amd_sb_acs },
 	{ PCI_VENDOR_ID_ATI, 0x4384, pci_quirk_amd_sb_acs },
 	{ PCI_VENDOR_ID_ATI, 0x4399, pci_quirk_amd_sb_acs },
-	{ PCI_VENDOR_ID_SOLARFLARE, 0x0903, pci_quirk_solarflare_acs },
-	{ PCI_VENDOR_ID_SOLARFLARE, 0x0923, pci_quirk_solarflare_acs },
+	{ PCI_VENDOR_ID_SOLARFLARE, 0x0903, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_SOLARFLARE, 0x0923, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10C6, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10DB, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10DD, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10E1, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10F1, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10F7, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10F8, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10F9, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10FA, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10FB, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x10FC, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x1507, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x1514, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x151C, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x1529, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x152A, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x154D, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x154F, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x1551, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, 0x1558, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_quirk_intel_pch_acs },
 	{ 0 }
 };

