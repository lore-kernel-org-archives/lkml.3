Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab3FEVfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab3FEVft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 075/127] sata_rcar: fix interrupt handling
Date: Wed,  5 Jun 2013 14:34:02 -0700
Message-Id: <20130605213226.451713988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit 52a2a1087b5924de00484f35ef5e2a73f61dbd22 upstream.

The driver's interrupt handling code is too picky in deciding whether it should
handle an interrupt or not which causes completely unneeded spurious interrupts.
Thus make sata_rcar_{ata|serr}_interrupt() *void*; add ATA status register read
to sata_rcar_ata_interrupt() to clear an unexpected ATA interrupt -- it doesn't
get cleared by writing to the SATAINTSTAT register in the interrupt mode we use.

Also, in sata_rcar_ata_interrupt() we should check SATAINTSTAT register only for
enabled interrupts and we should clear  only those interrupts  that we have read
as active first time around, because else we have  a  race and risk clearing  an
interrupt that  can  occur between read  and write of the  SATAINTSTAT  register
and never registering it...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_rcar.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -618,17 +618,16 @@ static struct ata_port_operations sata_r
 	.bmdma_status		= sata_rcar_bmdma_status,
 };
 
-static int sata_rcar_serr_interrupt(struct ata_port *ap)
+static void sata_rcar_serr_interrupt(struct ata_port *ap)
 {
 	struct sata_rcar_priv *priv = ap->host->private_data;
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	int freeze = 0;
-	int handled = 0;
 	u32 serror;
 
 	serror = ioread32(priv->base + SCRSERR_REG);
 	if (!serror)
-		return 0;
+		return;
 
 	DPRINTK("SError @host_intr: 0x%x\n", serror);
 
@@ -641,7 +640,6 @@ static int sata_rcar_serr_interrupt(stru
 		ata_ehi_push_desc(ehi, "%s", "hotplug");
 
 		freeze = serror & SERR_COMM_WAKE ? 0 : 1;
-		handled = 1;
 	}
 
 	/* freeze or abort */
@@ -649,11 +647,9 @@ static int sata_rcar_serr_interrupt(stru
 		ata_port_freeze(ap);
 	else
 		ata_port_abort(ap);
-
-	return handled;
 }
 
-static int sata_rcar_ata_interrupt(struct ata_port *ap)
+static void sata_rcar_ata_interrupt(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc;
 	int handled = 0;
@@ -662,7 +658,9 @@ static int sata_rcar_ata_interrupt(struc
 	if (qc)
 		handled |= ata_bmdma_port_intr(ap, qc);
 
-	return handled;
+	/* be sure to clear ATA interrupt */
+	if (!handled)
+		sata_rcar_check_status(ap);
 }
 
 static irqreturn_t sata_rcar_interrupt(int irq, void *dev_instance)
@@ -677,20 +675,21 @@ static irqreturn_t sata_rcar_interrupt(i
 	spin_lock_irqsave(&host->lock, flags);
 
 	sataintstat = ioread32(priv->base + SATAINTSTAT_REG);
+	sataintstat &= SATA_RCAR_INT_MASK;
 	if (!sataintstat)
 		goto done;
 	/* ack */
-	iowrite32(sataintstat & ~SATA_RCAR_INT_MASK,
-		 priv->base + SATAINTSTAT_REG);
+	iowrite32(~sataintstat & 0x7ff, priv->base + SATAINTSTAT_REG);
 
 	ap = host->ports[0];
 
 	if (sataintstat & SATAINTSTAT_ATA)
-		handled |= sata_rcar_ata_interrupt(ap);
+		sata_rcar_ata_interrupt(ap);
 
 	if (sataintstat & SATAINTSTAT_SERR)
-		handled |= sata_rcar_serr_interrupt(ap);
+		sata_rcar_serr_interrupt(ap);
 
+	handled = 1;
 done:
 	spin_unlock_irqrestore(&host->lock, flags);
 


