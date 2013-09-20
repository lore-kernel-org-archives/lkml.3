Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3ITUXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:23:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3ITUO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Chris Ball <cjb@laptop.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 30/93] mmc: tmio_mmc_dma: fix PIO fallback on SDHI
Date: Fri, 20 Sep 2013 13:08:25 -0700
Message-Id: <1379707768-1804-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit f936f9b67b7f8c2eae01dd303a0e90bd777c4679 upstream.

I'm testing SH-Mobile SDHI driver in DMA mode with  a new DMA controller  using
'bonnie++' and getting DMA error after which the tmio_mmc_dma.c code falls back
to PIO but all commands time out after that.  It turned out that the fallback
code calls tmio_mmc_enable_dma() with RX/TX channels already freed and pointers
to them cleared, so that the function bails out early instead  of clearing the
DMA bit in the CTL_DMA_ENABLE register. The regression was introduced by commit
162f43e31c5a376ec16336e5d0ac973373d54c89 (mmc: tmio: fix a deadlock).
Moving tmio_mmc_enable_dma() calls to the top of the PIO fallback code in
tmio_mmc_start_dma_{rx|tx}() helps.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mmc/host/tmio_mmc_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_dma.c b/drivers/mmc/host/tmio_mmc_dma.c
index fff9286..491e9ec 100644
--- a/drivers/mmc/host/tmio_mmc_dma.c
+++ b/drivers/mmc/host/tmio_mmc_dma.c
@@ -104,6 +104,7 @@ static void tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
 pio:
 	if (!desc) {
 		/* DMA failed, fall back to PIO */
+		tmio_mmc_enable_dma(host, false);
 		if (ret >= 0)
 			ret = -EIO;
 		host->chan_rx = NULL;
@@ -116,7 +117,6 @@ pio:
 		}
 		dev_warn(&host->pdev->dev,
 			 "DMA failed: %d, falling back to PIO\n", ret);
-		tmio_mmc_enable_dma(host, false);
 	}
 
 	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d, sg[%d]\n", __func__,
@@ -185,6 +185,7 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
 pio:
 	if (!desc) {
 		/* DMA failed, fall back to PIO */
+		tmio_mmc_enable_dma(host, false);
 		if (ret >= 0)
 			ret = -EIO;
 		host->chan_tx = NULL;
@@ -197,7 +198,6 @@ pio:
 		}
 		dev_warn(&host->pdev->dev,
 			 "DMA failed: %d, falling back to PIO\n", ret);
-		tmio_mmc_enable_dma(host, false);
 	}
 
 	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d\n", __func__,
-- 
1.8.1.2

