Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbaEPPXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:23:03 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:47640 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbaEPPXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:23:00 -0400
X-Greylist: delayed 3818 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 11:22:55 EDT
Date: Fri, 16 May 2014 18:20:52 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: balbi@ti.com
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Use musb->tusb_revision instead of tusb_get_revision
 call.
Message-ID: <alpine.LRH.2.00.1405161819550.23182@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e24375ea6aefe2ad1ee72b8facab91abd1be190a Mon Sep 17 00:00:00 2001
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Fri, 9 May 2014 16:10:16 +0400
Subject: [PATCH 2/2] Use musb->tusb_revision instead of tusb_get_revision call.

The value of the revision is stored in musb->tusb_revision,
so don't re-read it every time.
Exporting tusb_get_revision is not needed anymore,
so the dependency loop between tusb6010 and tusb6010_omap is resolved.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
  drivers/usb/musb/tusb6010.c      | 19 ++++++++-----------
  drivers/usb/musb/tusb6010.h      |  2 --
  drivers/usb/musb/tusb6010_omap.c |  2 +-
  3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 81fa8fd..d49415c 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -42,7 +42,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on);
   * Checks the revision. We need to use the DMA register as 3.0 does not
   * have correct versions for TUSB_PRCM_REV or TUSB_INT_CTRL_REV.
   */
-u8 tusb_get_revision(struct musb *musb)
+static u8 tusb_get_revision(struct musb *musb)
  {
  	void __iomem	*tbase = musb->ctrl_base;
  	u32		die_id;
@@ -58,14 +58,13 @@ u8 tusb_get_revision(struct musb *musb)

  	return rev;
  }
-EXPORT_SYMBOL_GPL(tusb_get_revision);

-static int tusb_print_revision(struct musb *musb)
+static void tusb_print_revision(struct musb *musb)
  {
  	void __iomem	*tbase = musb->ctrl_base;
  	u8		rev;

-	rev = tusb_get_revision(musb);
+	rev = musb->tusb_revision;

  	pr_info("tusb: %s%i.%i %s%i.%i %s%i.%i %s%i.%i %s%i %s%i.%i\n",
  		"prcm",
@@ -84,8 +83,6 @@ static int tusb_print_revision(struct musb *musb)
  		TUSB_DIDR1_HI_CHIP_REV(musb_readl(tbase, TUSB_DIDR1_HI)),
  		"rev",
  		TUSB_REV_MAJOR(rev), TUSB_REV_MINOR(rev));
-
-	return tusb_get_revision(musb);
  }

  #define WBUS_QUIRK_MASK	(TUSB_PHY_OTG_CTRL_TESTM2 | TUSB_PHY_OTG_CTRL_TESTM1 \
@@ -349,7 +346,7 @@ static void tusb_allow_idle(struct musb *musb, u32 wakeup_enables)
  	u32		reg;

  	if ((wakeup_enables & TUSB_PRCM_WBUS)
-			&& (tusb_get_revision(musb) == TUSB_REV_30))
+			&& (musb->tusb_revision == TUSB_REV_30))
  		tusb_wbus_quirk(musb, 1);

  	tusb_set_clock_source(musb, 0);
@@ -797,7 +794,7 @@ static irqreturn_t tusb_musb_interrupt(int irq, void *__hci)
  		u32	reg;
  		u32	i;

-		if (tusb_get_revision(musb) == TUSB_REV_30)
+		if (musb->tusb_revision == TUSB_REV_30)
  			tusb_wbus_quirk(musb, 0);

  		/* there are issues re-locking the PLL on wakeup ... */
@@ -1012,10 +1009,10 @@ static int tusb_musb_start(struct musb *musb)
  	}

  	musb->tusb_revision = tusb_get_revision(musb);
-	ret = tusb_print_revision(musb);
-	if (ret < 2) {
+	tusb_print_revision(musb);
+	if (musb->tusb_revision < 2) {
  		printk(KERN_ERR "tusb: Unsupported TUSB6010 revision %i\n",
-				ret);
+				musb->tusb_revision);
  		goto err;
  	}

diff --git a/drivers/usb/musb/tusb6010.h b/drivers/usb/musb/tusb6010.h
index 35c933a..3d40c63 100644
--- a/drivers/usb/musb/tusb6010.h
+++ b/drivers/usb/musb/tusb6010.h
@@ -12,8 +12,6 @@
  #ifndef __TUSB6010_H__
  #define __TUSB6010_H__

-extern u8 tusb_get_revision(struct musb *musb);
-
  #ifdef CONFIG_USB_TUSB6010
  #define musb_in_tusb()			1
  #else
diff --git a/drivers/usb/musb/tusb6010_omap.c b/drivers/usb/musb/tusb6010_omap.c
index e33b6b2..3ce152c 100644
--- a/drivers/usb/musb/tusb6010_omap.c
+++ b/drivers/usb/musb/tusb6010_omap.c
@@ -677,7 +677,7 @@ struct dma_controller *dma_controller_create(struct musb *musb, void __iomem *ba
  	tusb_dma->controller.channel_program = tusb_omap_dma_program;
  	tusb_dma->controller.channel_abort = tusb_omap_dma_abort;

-	if (tusb_get_revision(musb) >= TUSB_REV_30)
+	if (musb->tusb_revision >= TUSB_REV_30)
  		tusb_dma->multichannel = 1;

  	for (i = 0; i < MAX_DMAREQ; i++) {
-- 
1.8.1.4

