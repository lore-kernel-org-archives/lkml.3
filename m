Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3FGQev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:34:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab3FGQet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:34:49 -0400
Subject: [PATCH v2 2/2] pci: Differentiate ACS controllable from enabled
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Jun 2013 10:34:47 -0600
Message-ID: <20130607163447.7733.70375.stgit@bling.home>
In-Reply-To: <20130607162732.7733.17758.stgit@bling.home>
References: <20130607162732.7733.17758.stgit@bling.home>
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
index 457ae51..8b8504c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2357,12 +2357,20 @@ void pci_enable_acs(struct pci_dev *dev)
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
@@ -2412,9 +2420,6 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
 		if (!pdev->multifunction)
 			break;
 
-		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
-			      PCI_ACS_EC | PCI_ACS_DT);
-
 		return pci_acs_flags_enabled(pdev, acs_flags);
 	}
 

