Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaIUNUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:20:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaIUNTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:19:53 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH RESEND v3 4/6] AHCI: Get rid of redundant arg to ahci_handle_port_interrupt()
Date: Sun, 21 Sep 2014 15:19:27 +0200
Message-Id: <b649bc5bbd370a33c69ad2d9c85e4a68bca51f6b.1411297686.git.agordeev@redhat.com>
In-Reply-To: <cover.1411297686.git.agordeev@redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function's ahci_handle_port_interrupt() 'port_mmio'
parameter could be derived within function. No need
to pass it from outside.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/libahci.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index e6ef3d4..cbe7757 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1693,9 +1693,9 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		ata_port_abort(ap);
 }
 
-static void ahci_handle_port_interrupt(struct ata_port *ap,
-				       void __iomem *port_mmio, u32 status)
+static void ahci_handle_port_interrupt(struct ata_port *ap, u32 status)
 {
+	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1786,14 +1786,13 @@ static void ahci_port_intr(struct ata_port *ap)
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
 
-	ahci_handle_port_interrupt(ap, port_mmio, status);
+	ahci_handle_port_interrupt(ap, status);
 }
 
 irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 {
 	struct ata_port *ap = dev_instance;
 	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
 	unsigned long flags;
 	u32 status;
 
@@ -1804,7 +1803,7 @@ irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 	spin_unlock_irqrestore(&ap->host->lock, flags);
 
 	spin_lock_bh(ap->lock);
-	ahci_handle_port_interrupt(ap, port_mmio, status);
+	ahci_handle_port_interrupt(ap, status);
 	spin_unlock_bh(ap->lock);
 
 	return IRQ_HANDLED;
-- 
1.8.3.1

