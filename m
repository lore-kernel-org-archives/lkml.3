Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaFOUj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:39:27 -0400
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:56047 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858AbaFOUjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:4321:4384:4605:5007:6117:6119:6261:8603:9592:10004:10026:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:13523:13524,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: truck07_6e64288b2932f
X-Filterd-Recvd-Size: 2721
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org
Subject: [PATCH -next 26/26] sound: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:55 -0700
Message-Id: <1ee1f44142267688ea2db19c11a83596b98c4f17.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/aoa/soundbus/i2sbus/core.c | 12 ++++--------
 sound/sparc/dbri.c               |  6 ++----
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 4678360..a80d5ea 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -47,15 +47,11 @@ static int alloc_dbdma_descriptor_ring(struct i2sbus_dev *i2sdev,
 	/* We use the PCI APIs for now until the generic one gets fixed
 	 * enough or until we get some macio-specific versions
 	 */
-	r->space = dma_alloc_coherent(
-			&macio_get_pci_dev(i2sdev->macio)->dev,
-			r->size,
-			&r->bus_addr,
-			GFP_KERNEL);
+	r->space = dma_zalloc_coherent(&macio_get_pci_dev(i2sdev->macio)->dev,
+				       r->size, &r->bus_addr, GFP_KERNEL);
+	if (!r->space)
+		return -ENOMEM;
 
-	if (!r->space) return -ENOMEM;
-
-	memset(r->space, 0, r->size);
 	r->cmds = (void*)DBDMA_ALIGN(r->space);
 	r->bus_cmd_start = r->bus_addr +
 			   (dma_addr_t)((char*)r->cmds - (char*)r->space);
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index be1b1aa..b2c3d0d 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -2534,12 +2534,10 @@ static int snd_dbri_create(struct snd_card *card,
 	dbri->op = op;
 	dbri->irq = irq;
 
-	dbri->dma = dma_alloc_coherent(&op->dev,
-				       sizeof(struct dbri_dma),
-				       &dbri->dma_dvma, GFP_ATOMIC);
+	dbri->dma = dma_zalloc_coherent(&op->dev, sizeof(struct dbri_dma),
+					&dbri->dma_dvma, GFP_ATOMIC);
 	if (!dbri->dma)
 		return -ENOMEM;
-	memset((void *)dbri->dma, 0, sizeof(struct dbri_dma));
 
 	dprintk(D_GEN, "DMA Cmd Block 0x%p (0x%08x)\n",
 		dbri->dma, dbri->dma_dvma);
-- 
1.8.1.2.459.gbcd45b4.dirty

