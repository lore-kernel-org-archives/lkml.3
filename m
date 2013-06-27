Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3F0WkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:40:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab3F0WkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:40:01 -0400
Subject: [PATCH v2 2/3] pci: Differentiate ACS controllable from enabled
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, joro@8bytes.org, andihartmann@01019freenet.de,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 16:39:54 -0600
Message-ID: <20130627223954.16564.78400.stgit@bling.home>
In-Reply-To: <20130627222159.16564.38166.stgit@bling.home>
References: <20130627222159.16564.38166.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently misinterpret that in order for an ACS feature to be
enabled it must be set in the control field.  In reality, this means
that the feature is not only enabled, but controllable.  Many of the
ACS capability bits are not required if the device behaves by default
in the way specified when both the capability and control bit are set
and does not support or allow the alternate mode.  We therefore need
to check the capabilities and mask out flags that are enabled but not
controllable.  Egress control seems to be the only flag which is
purely optional.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d0c2b35..ae372ca 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2352,12 +2352,20 @@ void pci_enable_acs(struct pci_dev *dev)
 static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 {
 	int pos;
-	u16 ctrl;
+	u16 cap, ctrl;
 
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
 	if (!pos)
 		return false;
 
+	/*
+	 * Except for egress control, capabilities are either required
+	 * or only required if controllable.  Features missing from the
+	 * capability field can therefore be assumed as hard-wired enabled.
+	 */
+	pci_read_config_word(pdev, pos + PCI_ACS_CAP, &cap);
+	acs_flags &= (cap | PCI_ACS_EC);
+
 	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
 	return (ctrl & acs_flags) == acs_flags;
 }
@@ -2432,9 +2440,6 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
 		if (!pdev->multifunction)
 			break;
 
-		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
-			      PCI_ACS_EC | PCI_ACS_DT);
-
 		return pci_acs_flags_enabled(pdev, acs_flags);
 	}
 

