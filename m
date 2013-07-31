Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab3GaKXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:23:15 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:23290
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397Ab3GaKXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:23:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ruchika Gupta <ruchika.gupta@freescale.com>,
        Vakul Garg <vakul@freescale.com>,
        Alex Porosanu <alexandru.porosanu@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Horia Geanta <horia.geanta@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: caam - Remove unused functions from Job Ring
Date: Wed, 31 Jul 2013 15:48:56 +0530
Message-ID: <1375265936-30844-1-git-send-email-ruchika.gupta@freescale.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/ctrl.c   |  3 --
 drivers/crypto/caam/intern.h |  5 ----
 drivers/crypto/caam/jr.c     | 67 --------------------------------------------
 drivers/crypto/caam/jr.h     |  2 --
 4 files changed, 77 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 86c9600..b010d42 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -313,9 +313,6 @@ static int caam_probe(struct platform_device *pdev)
 
 	/* NOTE: RTIC detection ought to go here, around Si time */
 
-	/* Initialize queue allocator lock */
-	spin_lock_init(&ctrlpriv->jr_alloc_lock);
-
 	caam_id = rd_reg64(&topregs->ctrl.perfmon.caam_id);
 
 	/* Report "alive" for developer to see */
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index e4a16b7..34c4b9f 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -9,9 +9,6 @@
 #ifndef INTERN_H
 #define INTERN_H
 
-#define JOBR_UNASSIGNED 0
-#define JOBR_ASSIGNED 1
-
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
 
@@ -46,7 +43,6 @@ struct caam_drv_private_jr {
 	struct caam_job_ring __iomem *rregs;	/* JobR's register space */
 	struct tasklet_struct irqtask;
 	int irq;			/* One per queue */
-	int assign;			/* busy/free */
 
 	/* Job ring info */
 	int ringsize;	/* Size of rings (assume input = output) */
@@ -68,7 +64,6 @@ struct caam_drv_private {
 
 	struct device *dev;
 	struct device **jrdev; /* Alloc'ed array per sub-device */
-	spinlock_t jr_alloc_lock;
 	struct platform_device *pdev;
 
 	/* Physical-presence section */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index b4aa773e..105ba4d 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -126,72 +126,6 @@ static void caam_jr_dequeue(unsigned long devarg)
 }
 
 /**
- * caam_jr_register() - Alloc a ring for someone to use as needed. Returns
- * an ordinal of the rings allocated, else returns -ENODEV if no rings
- * are available.
- * @ctrldev: points to the controller level dev (parent) that
- *           owns rings available for use.
- * @dev:     points to where a pointer to the newly allocated queue's
- *           dev can be written to if successful.
- **/
-int caam_jr_register(struct device *ctrldev, struct device **rdev)
-{
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
-	struct caam_drv_private_jr *jrpriv = NULL;
-	int ring;
-
-	/* Lock, if free ring - assign, unlock */
-	spin_lock(&ctrlpriv->jr_alloc_lock);
-	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
-		jrpriv = dev_get_drvdata(ctrlpriv->jrdev[ring]);
-		if (jrpriv->assign == JOBR_UNASSIGNED) {
-			jrpriv->assign = JOBR_ASSIGNED;
-			*rdev = ctrlpriv->jrdev[ring];
-			spin_unlock(&ctrlpriv->jr_alloc_lock);
-			return ring;
-		}
-	}
-
-	/* If assigned, write dev where caller needs it */
-	spin_unlock(&ctrlpriv->jr_alloc_lock);
-	*rdev = NULL;
-
-	return -ENODEV;
-}
-EXPORT_SYMBOL(caam_jr_register);
-
-/**
- * caam_jr_deregister() - Deregister an API and release the queue.
- * Returns 0 if OK, -EBUSY if queue still contains pending entries
- * or unprocessed results at the time of the call
- * @dev     - points to the dev that identifies the queue to
- *            be released.
- **/
-int caam_jr_deregister(struct device *rdev)
-{
-	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(rdev);
-	struct caam_drv_private *ctrlpriv;
-
-	/* Get the owning controller's private space */
-	ctrlpriv = dev_get_drvdata(jrpriv->parentdev);
-
-	/*
-	 * Make sure ring empty before release
-	 */
-	if (rd_reg32(&jrpriv->rregs->outring_used) ||
-	    (rd_reg32(&jrpriv->rregs->inpring_avail) != JOBR_DEPTH))
-		return -EBUSY;
-
-	/* Release ring */
-	spin_lock(&ctrlpriv->jr_alloc_lock);
-	jrpriv->assign = JOBR_UNASSIGNED;
-	spin_unlock(&ctrlpriv->jr_alloc_lock);
-
-	return 0;
-}
-EXPORT_SYMBOL(caam_jr_deregister);
-
-/**
  * caam_jr_enqueue() - Enqueue a job descriptor head. Returns 0 if OK,
  * -EBUSY if the queue is full, -EIO if it cannot map the caller's
  * descriptor.
@@ -379,7 +313,6 @@ static int caam_jr_init(struct device *dev)
 		  (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
 		  (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
-	jrp->assign = JOBR_UNASSIGNED;
 	return 0;
 }
 
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index c23df39..9d8741a 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -8,8 +8,6 @@
 #define JR_H
 
 /* Prototypes for backend-level services exposed to APIs */
-int caam_jr_register(struct device *ctrldev, struct device **rdev);
-int caam_jr_deregister(struct device *rdev);
 int caam_jr_enqueue(struct device *dev, u32 *desc,
 		    void (*cbk)(struct device *dev, u32 *desc, u32 status,
 				void *areq),
-- 
1.8.1.4


