Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaJPJJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:09:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36420 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947AbaJPJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:09 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 09/11] dmaengine: sh: Remove chancnt affectations
Date: Thu, 16 Oct 2014 11:01:01 +0200
Message-Id: <1413450063-23829-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chanctnt is already filled by dma_async_device_register, which uses the channel
list to know how much channels there is.

Since it's already filled, we can safely remove it from the drivers' probe
function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/sh/rcar-audmapp.c | 2 --
 drivers/dma/sh/rcar-hpbdma.c  | 2 --
 drivers/dma/sh/shdma-base.c   | 2 +-
 drivers/dma/sh/shdmac.c       | 2 --
 drivers/dma/sh/sudmac.c       | 2 --
 5 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/dma/sh/rcar-audmapp.c b/drivers/dma/sh/rcar-audmapp.c
index dabbf0aba2e9..fd1005e58551 100644
--- a/drivers/dma/sh/rcar-audmapp.c
+++ b/drivers/dma/sh/rcar-audmapp.c
@@ -248,7 +248,6 @@ static int audmapp_chan_probe(struct platform_device *pdev,
 
 static void audmapp_chan_remove(struct audmapp_device *audev)
 {
-	struct dma_device *dma_dev = &audev->shdma_dev.dma_dev;
 	struct shdma_chan *schan;
 	int i;
 
@@ -256,7 +255,6 @@ static void audmapp_chan_remove(struct audmapp_device *audev)
 		BUG_ON(!schan);
 		shdma_chan_remove(schan);
 	}
-	dma_dev->chancnt = 0;
 }
 
 static struct dma_chan *audmapp_of_xlate(struct of_phandle_args *dma_spec,
diff --git a/drivers/dma/sh/rcar-hpbdma.c b/drivers/dma/sh/rcar-hpbdma.c
index b212d9471ab5..5ab921865ffe 100644
--- a/drivers/dma/sh/rcar-hpbdma.c
+++ b/drivers/dma/sh/rcar-hpbdma.c
@@ -619,7 +619,6 @@ error:
 
 static void hpb_dmae_chan_remove(struct hpb_dmae_device *hpbdev)
 {
-	struct dma_device *dma_dev = &hpbdev->shdma_dev.dma_dev;
 	struct shdma_chan *schan;
 	int i;
 
@@ -628,7 +627,6 @@ static void hpb_dmae_chan_remove(struct hpb_dmae_device *hpbdev)
 
 		shdma_chan_remove(schan);
 	}
-	dma_dev->chancnt = 0;
 }
 
 static int hpb_dmae_remove(struct platform_device *pdev)
diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 42d497416196..ed5b0993edfa 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -951,7 +951,7 @@ void shdma_chan_probe(struct shdma_dev *sdev,
 	/* Add the channel to DMA device channel list */
 	list_add_tail(&schan->dma_chan.device_node,
 			&sdev->dma_dev.channels);
-	sdev->schan[sdev->dma_dev.chancnt++] = schan;
+	sdev->schan[id] = schan;
 }
 EXPORT_SYMBOL(shdma_chan_probe);
 
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 58eb85770eba..b65317c6ea4e 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -572,7 +572,6 @@ err_no_irq:
 
 static void sh_dmae_chan_remove(struct sh_dmae_device *shdev)
 {
-	struct dma_device *dma_dev = &shdev->shdma_dev.dma_dev;
 	struct shdma_chan *schan;
 	int i;
 
@@ -581,7 +580,6 @@ static void sh_dmae_chan_remove(struct sh_dmae_device *shdev)
 
 		shdma_chan_remove(schan);
 	}
-	dma_dev->chancnt = 0;
 }
 
 static void sh_dmae_shutdown(struct platform_device *pdev)
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index 3ce103909896..69a5c7b87ee0 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -295,7 +295,6 @@ err_no_irq:
 
 static void sudmac_chan_remove(struct sudmac_device *su_dev)
 {
-	struct dma_device *dma_dev = &su_dev->shdma_dev.dma_dev;
 	struct shdma_chan *schan;
 	int i;
 
@@ -304,7 +303,6 @@ static void sudmac_chan_remove(struct sudmac_device *su_dev)
 
 		shdma_chan_remove(schan);
 	}
-	dma_dev->chancnt = 0;
 }
 
 static dma_addr_t sudmac_slave_addr(struct shdma_chan *schan)
-- 
2.1.1

