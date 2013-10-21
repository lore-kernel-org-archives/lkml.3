Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3JUJ3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:29:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39367 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab3JUIut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "Chris Ball" <cjb@laptop.org>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.432302801@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 034/149] mmc: tmio_mmc_dma: fix PIO fallback on SDHI
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/tmio_mmc_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/tmio_mmc_dma.c
+++ b/drivers/mmc/host/tmio_mmc_dma.c
@@ -92,6 +92,7 @@ static void tmio_mmc_start_dma_rx(struct
 pio:
 	if (!desc) {
 		/* DMA failed, fall back to PIO */
+		tmio_mmc_enable_dma(host, false);
 		if (ret >= 0)
 			ret = -EIO;
 		host->chan_rx = NULL;
@@ -104,7 +105,6 @@ pio:
 		}
 		dev_warn(&host->pdev->dev,
 			 "DMA failed: %d, falling back to PIO\n", ret);
-		tmio_mmc_enable_dma(host, false);
 	}
 
 	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d, sg[%d]\n", __func__,
@@ -173,6 +173,7 @@ static void tmio_mmc_start_dma_tx(struct
 pio:
 	if (!desc) {
 		/* DMA failed, fall back to PIO */
+		tmio_mmc_enable_dma(host, false);
 		if (ret >= 0)
 			ret = -EIO;
 		host->chan_tx = NULL;
@@ -185,7 +186,6 @@ pio:
 		}
 		dev_warn(&host->pdev->dev,
 			 "DMA failed: %d, falling back to PIO\n", ret);
-		tmio_mmc_enable_dma(host, false);
 	}
 
 	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d\n", __func__,

