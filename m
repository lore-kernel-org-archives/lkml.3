Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3BTIx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:53:57 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38287 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373Ab3BTIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:53:53 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] usb: musb: drop dangling CONFIG_USB_MUSB_DEBUG
Date: Wed, 20 Feb 2013 09:53:39 +0100
Message-Id: <1361350419-7678-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_USB_MUSB_DEBUG option was removed in

5c8a86e usb: musb: drop unneeded musb_debug trickery

to cleanup the code from driver specific debug facilities.  This patch
drops the last references to the musb debug config option,
unconditionally enabling all debug code paths, thus letting that code
being dropped at compile time if not needed.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hello Felipe,

this looks like a leftover from the debug code cleanup.  Some code in
cppi_dma was constantly compiled out, and that included some dead
_dbg_level() references.  All debug printks are already declared as
pr_debug or dev_dbg so it should be ok to keep the code compiled in.

Compiled tested only.

Fabio

 drivers/usb/musb/cppi_dma.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index f522000..9db211e 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -435,7 +435,6 @@ cppi_rndis_update(struct cppi_channel *c, int is_rx,
 	}
 }
 
-#ifdef CONFIG_USB_MUSB_DEBUG
 static void cppi_dump_rxbd(const char *tag, struct cppi_descriptor *bd)
 {
 	pr_debug("RXBD/%s %08x: "
@@ -444,21 +443,16 @@ static void cppi_dump_rxbd(const char *tag, struct cppi_descriptor *bd)
 			bd->hw_next, bd->hw_bufp, bd->hw_off_len,
 			bd->hw_options);
 }
-#endif
 
 static void cppi_dump_rxq(int level, const char *tag, struct cppi_channel *rx)
 {
-#ifdef CONFIG_USB_MUSB_DEBUG
 	struct cppi_descriptor	*bd;
 
-	if (!_dbg_level(level))
-		return;
 	cppi_dump_rx(level, rx, tag);
 	if (rx->last_processed)
 		cppi_dump_rxbd("last", rx->last_processed);
 	for (bd = rx->head; bd; bd = bd->next)
 		cppi_dump_rxbd("active", bd);
-#endif
 }
 
 
@@ -784,6 +778,7 @@ cppi_next_rx_segment(struct musb *musb, struct cppi_channel *rx, int onepacket)
 	void __iomem		*tibase = musb->ctrl_base;
 	int			is_rndis = 0;
 	struct cppi_rx_stateram	__iomem *rx_ram = rx->state_ram;
+	struct cppi_descriptor	*d;
 
 	if (onepacket) {
 		/* almost every USB driver, host or peripheral side */
@@ -897,14 +892,8 @@ cppi_next_rx_segment(struct musb *musb, struct cppi_channel *rx, int onepacket)
 	bd->hw_options |= CPPI_SOP_SET;
 	tail->hw_options |= CPPI_EOP_SET;
 
-#ifdef CONFIG_USB_MUSB_DEBUG
-	if (_dbg_level(5)) {
-		struct cppi_descriptor	*d;
-
-		for (d = rx->head; d; d = d->next)
-			cppi_dump_rxbd("S", d);
-	}
-#endif
+	for (d = rx->head; d; d = d->next)
+		cppi_dump_rxbd("S", d);
 
 	/* in case the preceding transfer left some state... */
 	tail = rx->last_processed;
-- 
1.7.12.1

