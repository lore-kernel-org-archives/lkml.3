Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaFWNuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:50:19 -0400
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:38884 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753996AbaFWNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1535:1606:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2729:2899:3138:3139:3140:3141:3142:3355:3865:3867:3871:4117:4225:4321:4384:4385:4395:4419:4605:5007:6119:6261:7903:10004:10026:10848:11026:11232:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555:12683:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chain56_87492f528bd5d
X-Filterd-Recvd-Size: 6251
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 02/22] atm: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:30 -0700
Message-Id: <4053865301d0b0bb3a5c0c47698506ccc3c34169.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/atm/he.c       | 31 +++++++++++++++----------------
 drivers/atm/idt77252.c | 15 ++++++---------
 2 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index aa6be26..c39702b 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -533,14 +533,13 @@ static void he_init_tx_lbfp(struct he_dev *he_dev)
 
 static int he_init_tpdrq(struct he_dev *he_dev)
 {
-	he_dev->tpdrq_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq), &he_dev->tpdrq_phys);
+	he_dev->tpdrq_base = pci_zalloc_consistent(he_dev->pci_dev,
+						   CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq),
+						   &he_dev->tpdrq_phys);
 	if (he_dev->tpdrq_base == NULL) {
 		hprintk("failed to alloc tpdrq\n");
 		return -ENOMEM;
 	}
-	memset(he_dev->tpdrq_base, 0,
-				CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq));
 
 	he_dev->tpdrq_tail = he_dev->tpdrq_base;
 	he_dev->tpdrq_head = he_dev->tpdrq_base;
@@ -804,13 +803,13 @@ static int he_init_group(struct he_dev *he_dev, int group)
 		goto out_free_rbpl_virt;
 	}
 
-	he_dev->rbpl_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_RBPL_SIZE * sizeof(struct he_rbp), &he_dev->rbpl_phys);
+	he_dev->rbpl_base = pci_zalloc_consistent(he_dev->pci_dev,
+						  CONFIG_RBPL_SIZE * sizeof(struct he_rbp),
+						  &he_dev->rbpl_phys);
 	if (he_dev->rbpl_base == NULL) {
 		hprintk("failed to alloc rbpl_base\n");
 		goto out_destroy_rbpl_pool;
 	}
-	memset(he_dev->rbpl_base, 0, CONFIG_RBPL_SIZE * sizeof(struct he_rbp));
 
 	INIT_LIST_HEAD(&he_dev->rbpl_outstanding);
 
@@ -843,13 +842,13 @@ static int he_init_group(struct he_dev *he_dev, int group)
 
 	/* rx buffer ready queue */
 
-	he_dev->rbrq_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_RBRQ_SIZE * sizeof(struct he_rbrq), &he_dev->rbrq_phys);
+	he_dev->rbrq_base = pci_zalloc_consistent(he_dev->pci_dev,
+						  CONFIG_RBRQ_SIZE * sizeof(struct he_rbrq),
+						  &he_dev->rbrq_phys);
 	if (he_dev->rbrq_base == NULL) {
 		hprintk("failed to allocate rbrq\n");
 		goto out_free_rbpl;
 	}
-	memset(he_dev->rbrq_base, 0, CONFIG_RBRQ_SIZE * sizeof(struct he_rbrq));
 
 	he_dev->rbrq_head = he_dev->rbrq_base;
 	he_writel(he_dev, he_dev->rbrq_phys, G0_RBRQ_ST + (group * 16));
@@ -867,13 +866,13 @@ static int he_init_group(struct he_dev *he_dev, int group)
 
 	/* tx buffer ready queue */
 
-	he_dev->tbrq_base = pci_alloc_consistent(he_dev->pci_dev,
-		CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq), &he_dev->tbrq_phys);
+	he_dev->tbrq_base = pci_zalloc_consistent(he_dev->pci_dev,
+						  CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq),
+						  &he_dev->tbrq_phys);
 	if (he_dev->tbrq_base == NULL) {
 		hprintk("failed to allocate tbrq\n");
 		goto out_free_rbpq_base;
 	}
-	memset(he_dev->tbrq_base, 0, CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq));
 
 	he_dev->tbrq_head = he_dev->tbrq_base;
 
@@ -1460,13 +1459,13 @@ static int he_start(struct atm_dev *dev)
 
 	/* host status page */
 
-	he_dev->hsp = pci_alloc_consistent(he_dev->pci_dev,
-				sizeof(struct he_hsp), &he_dev->hsp_phys);
+	he_dev->hsp = pci_zalloc_consistent(he_dev->pci_dev,
+					    sizeof(struct he_hsp),
+					    &he_dev->hsp_phys);
 	if (he_dev->hsp == NULL) {
 		hprintk("failed to allocate host status page\n");
 		return -ENOMEM;
 	}
-	memset(he_dev->hsp, 0, sizeof(struct he_hsp));
 	he_writel(he_dev, he_dev->hsp_phys, HSP_BA);
 
 	/* initialize framer */
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index b621f56..2b24ed0 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -641,13 +641,11 @@ alloc_scq(struct idt77252_dev *card, int class)
 	scq = kzalloc(sizeof(struct scq_info), GFP_KERNEL);
 	if (!scq)
 		return NULL;
-	scq->base = pci_alloc_consistent(card->pcidev, SCQ_SIZE,
-					 &scq->paddr);
+	scq->base = pci_zalloc_consistent(card->pcidev, SCQ_SIZE, &scq->paddr);
 	if (scq->base == NULL) {
 		kfree(scq);
 		return NULL;
 	}
-	memset(scq->base, 0, SCQ_SIZE);
 
 	scq->next = scq->base;
 	scq->last = scq->base + (SCQ_ENTRIES - 1);
@@ -972,13 +970,12 @@ init_rsq(struct idt77252_dev *card)
 {
 	struct rsq_entry *rsqe;
 
-	card->rsq.base = pci_alloc_consistent(card->pcidev, RSQSIZE,
-					      &card->rsq.paddr);
+	card->rsq.base = pci_zalloc_consistent(card->pcidev, RSQSIZE,
+					       &card->rsq.paddr);
 	if (card->rsq.base == NULL) {
 		printk("%s: can't allocate RSQ.\n", card->name);
 		return -1;
 	}
-	memset(card->rsq.base, 0, RSQSIZE);
 
 	card->rsq.last = card->rsq.base + RSQ_NUM_ENTRIES - 1;
 	card->rsq.next = card->rsq.last;
@@ -3400,14 +3397,14 @@ static int init_card(struct atm_dev *dev)
 	writel(0, SAR_REG_GP);
 
 	/* Initialize RAW Cell Handle Register  */
-	card->raw_cell_hnd = pci_alloc_consistent(card->pcidev, 2 * sizeof(u32),
-						  &card->raw_cell_paddr);
+	card->raw_cell_hnd = pci_zalloc_consistent(card->pcidev,
+						   2 * sizeof(u32),
+						   &card->raw_cell_paddr);
 	if (!card->raw_cell_hnd) {
 		printk("%s: memory allocation failure.\n", card->name);
 		deinit_card(card);
 		return -1;
 	}
-	memset(card->raw_cell_hnd, 0, 2 * sizeof(u32));
 	writel(card->raw_cell_paddr, SAR_REG_RAWHND);
 	IPRINTK("%s: raw cell handle is at 0x%p.\n", card->name,
 		card->raw_cell_hnd);
-- 
1.8.1.2.459.gbcd45b4.dirty

