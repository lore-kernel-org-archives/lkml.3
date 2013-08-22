Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3HVWT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:19:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:5623 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab3HVWT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:19:27 -0400
X-IronPort-AV: E=Sophos;i="4.89,936,1367971200"; 
   d="scan'208";a="44547722"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH] pci: avoid unnecessary writing of the command register during probe
Date: Thu, 22 Aug 2013 23:19:18 +0100
Message-ID: <1377209958-26362-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I tracked an another bug, I noticed that the PCI command register is
quite often updated here unnecessarily.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/pci/probe.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 46ada5c..54f6bec 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -178,8 +178,12 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	/* No printks while decoding is disabled! */
 	if (!dev->mmio_always_on) {
 		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
-		pci_write_config_word(dev, PCI_COMMAND,
-			orig_cmd & ~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO));
+		if (orig_cmd & (PCI_COMMAND_MEMORY | PCI_COMMAND_IO)) {
+			pci_write_config_word(dev,
+				PCI_COMMAND,
+				orig_cmd &
+				~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO));
+		}
 	}
 
 	res->name = pci_name(dev);
@@ -293,7 +297,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 fail:
 	res->flags = 0;
 out:
-	if (!dev->mmio_always_on)
+	if (!dev->mmio_always_on &&
+		(orig_cmd & (PCI_COMMAND_MEMORY | PCI_COMMAND_IO)))
 		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 
 	if (bar_too_big)
-- 
1.7.9.5

