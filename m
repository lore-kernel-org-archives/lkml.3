Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaIGS6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:58:30 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:43366 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752183AbaIGS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:58:28 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-pci@vger.kernel.org
Subject: [PATCH v2 2/3] PCI/MSI/Armada-370-xp: Remove arch_msi_check_device()
Date: Sun,  7 Sep 2014 20:57:54 +0200
Message-Id: <9f3497a0f478f3ee7d4a16b9a4221d4377e5863d.1410078503.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410078503.git.agordeev@redhat.com>
References: <cover.1410078503.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving MSI checks from arch_msi_check_device() function to
arch_setup_msi_irqs() function makes code more compact and
allows removing unnecessary hook arch_msi_check_device()
from generic MSI code.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 574aba0..df60eab 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -136,6 +136,10 @@ static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
 	struct msi_msg msg;
 	int virq, hwirq;
 
+	/* We support MSI, but not MSI-X */
+	if (desc->msi_attrib.is_msix)
+		return -EINVAL;
+
 	hwirq = armada_370_xp_alloc_msi();
 	if (hwirq < 0)
 		return hwirq;
@@ -166,15 +170,6 @@ static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
 	armada_370_xp_free_msi(hwirq);
 }
 
-static int armada_370_xp_check_msi_device(struct msi_chip *chip, struct pci_dev *dev,
-					  int nvec, int type)
-{
-	/* We support MSI, but not MSI-X */
-	if (type == PCI_CAP_ID_MSI)
-		return 0;
-	return -EINVAL;
-}
-
 static struct irq_chip armada_370_xp_msi_irq_chip = {
 	.name = "armada_370_xp_msi_irq",
 	.irq_enable = unmask_msi_irq,
@@ -213,7 +208,6 @@ static int armada_370_xp_msi_init(struct device_node *node,
 
 	msi_chip->setup_irq = armada_370_xp_setup_msi_irq;
 	msi_chip->teardown_irq = armada_370_xp_teardown_msi_irq;
-	msi_chip->check_device = armada_370_xp_check_msi_device;
 	msi_chip->of_node = node;
 
 	armada_370_xp_msi_domain =
-- 
1.9.3

