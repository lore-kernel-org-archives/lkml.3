Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbaEMKLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933513AbaEMKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 150/182] ahci: Do not receive interrupts sent by dummy ports
Date: Tue, 13 May 2014 11:28:22 +0200
Message-Id: <b0a1984d4612c164d429adec3150bf2e342fd13d.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/ahci.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 11d34d10f233..b4bdb8859485 100644
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
1.9.3

