Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbaEKTXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:23:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212AbaEKTX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        David Milburn <dmilburn@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH 3.14 37/83] ahci: Do not receive interrupts sent by dummy ports
Date: Sun, 11 May 2014 21:19:38 +0200
Message-Id: <20140511191912.077347671@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1242,12 +1242,16 @@ int ahci_host_activate(struct ata_host *
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


