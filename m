Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaDQREv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaDQREf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:04:35 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        David Milburn <dmilburn@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH 1/1] ahci: Do not receive interrupts sent by dummy ports
Date: Thu, 17 Apr 2014 18:06:15 +0200
Message-Id: <dbaed51ffe73dec1966eba256c3b42ed22ed58f3.1397750166.git.agordeev@redhat.com>
In-Reply-To: <cover.1397750166.git.agordeev@redhat.com>
References: <cover.1397750166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multiple MSI mode all AHCI ports (including dummy) get
assigned separate MSI vectors and (as result of execution
pci_enable_msi_exact() function) separate IRQ numbers,
(mapped to the MSI vectors).

Therefore, although interrupts from dummy ports are not
desired they are still enabled. We do not request IRQs
for dummy ports, but that only means we do not assign
AHCI-specific ISRs to corresponding IRQ numbers.

As result, dummy port interrupts still could come and
traverse all the way from the PCI device to the kernel,
causing unnecessary overhead.

This update disables IRQs for dummy ports and prevents
the described issue.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Milburn <dmilburn@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 44d40c7..71e15b7 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1241,12 +1241,16 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ahci_port_priv *pp = host->ports[i]->private_data;
 
-		/* pp is NULL for dummy ports */
-		if (pp)
-			rc = devm_request_threaded_irq(host->dev,
-						       irq + i, ahci_hw_interrupt,
-						       ahci_thread_fn, IRQF_SHARED,
-						       pp->irq_desc, host->ports[i]);
+		/* Do not receive interrupts sent by dummy ports */
+		if (!pp) {
+			disable_irq(irq + i);
+			continue;
+		}
+
+		rc = devm_request_threaded_irq(host->dev, irq + i,
+					       ahci_hw_interrupt,
+					       ahci_thread_fn, IRQF_SHARED,
+					       pp->irq_desc, host->ports[i]);
 		if (rc)
 			goto out_free_irqs;
 	}
-- 
1.7.7.6

