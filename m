Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaJFPR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbaJFPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:17:54 -0400
Date: Mon, 6 Oct 2014 16:26:35 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Subject: [PATCH 7/5] AHCI: Do not acquire ata_host::lock from single IRQ
 handler
Message-ID: <20141006152635.GB18209@agordeev.usersys.redhat.com>
References: <cover.1412007152.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1412007152.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to acquire ata_host::lock spinlock from
hardware context single IRQ interrupt handler since the
handler does not access host data that could be altered
by concurrent processors.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/libahci.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 3ce3d23..5eb61c9 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1875,8 +1875,6 @@ static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 
 	irq_masked = irq_stat & hpriv->port_map;
 
-	spin_lock(&host->lock);
-
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap;
 
@@ -1908,8 +1906,6 @@ static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 	 */
 	writel(irq_stat, mmio + HOST_IRQ_STAT);
 
-	spin_unlock(&host->lock);
-
 	VPRINTK("EXIT\n");
 
 	return handled ? IRQ_WAKE_THREAD : IRQ_NONE;
-- 
1.8.3.1

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
