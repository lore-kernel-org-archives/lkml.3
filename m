Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbaFJUbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:31:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaFJTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 071/160] ahci: Do not receive interrupts sent by dummy ports
Date: Tue, 10 Jun 2014 12:45:11 -0700
Message-Id: <1402429600-20477-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@redhat.com>

commit 2cf532f5e67c0cfe38c8c100e49280cdadacd2be upstream.

In multiple MSI mode all AHCI ports (including dummy) get assigned
separate MSI vectors and (as result of execution
pci_enable_msi_exact() function) separate IRQ numbers, (mapped to the
MSI vectors).

Therefore, although interrupts from dummy ports are not desired they
are still enabled. We do not request IRQs for dummy ports, but that
only means we do not assign AHCI-specific ISRs to corresponding IRQ
numbers.

As result, dummy port interrupts still could come and traverse all the
way from the PCI device to the kernel, causing unnecessary overhead.

This update disables IRQs for dummy ports and prevents the described
issue.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: David Milburn <dmilburn@redhat.com>
Cc: linux-ide@vger.kernel.org
Fixes: 5ca72c4f7c41 ("AHCI: Support multiple MSIs")
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/ahci.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 337d126..bc5579e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1171,12 +1171,16 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
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
1.9.1

