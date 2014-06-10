Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaFJUWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:22:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaFJTuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 101/160] irqchip: armada-370-xp: implement the ->check_device() msi_chip operation
Date: Tue, 10 Jun 2014 12:45:41 -0700
Message-Id: <1402429600-20477-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 830cbe4b7a918613276aa3d3b28d24410623f92c upstream.

Until now, we were leaving the ->check_device() msi_chip operation
empty, which leads the PCI core to believe that we support both MSI
and MSI-X. In fact, we do not support MSI-X, so we have to tell this
to the PCI core by providing an implementation of this operation.

Fixes: 31f614edb726fcc4d5aa0f2895fbdec9b04a3ca4 ('irqchip: armada-370-xp: implement MSI support')
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-3-git-send-email-thomas.petazzoni@free-electrons.com
Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 79eb0d1..6cb87c4 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -162,6 +162,15 @@ static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
 	armada_370_xp_free_msi(d->hwirq);
 }
 
+static int armada_370_xp_check_msi_device(struct msi_chip *chip, struct pci_dev *dev,
+					  int nvec, int type)
+{
+	/* We support MSI, but not MSI-X */
+	if (type == PCI_CAP_ID_MSI)
+		return 0;
+	return -EINVAL;
+}
+
 static struct irq_chip armada_370_xp_msi_irq_chip = {
 	.name = "armada_370_xp_msi_irq",
 	.irq_enable = unmask_msi_irq,
@@ -200,6 +209,7 @@ static int armada_370_xp_msi_init(struct device_node *node,
 
 	msi_chip->setup_irq = armada_370_xp_setup_msi_irq;
 	msi_chip->teardown_irq = armada_370_xp_teardown_msi_irq;
+	msi_chip->check_device = armada_370_xp_check_msi_device;
 	msi_chip->of_node = node;
 
 	armada_370_xp_msi_domain =
-- 
1.9.1

