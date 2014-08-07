Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaHGTs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:48:28 -0400
Received: from mail-pd0-f201.google.com ([209.85.192.201]:63552 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaHGTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:48:26 -0400
From: Doug Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Dinh Nguyen <dinguyen@altera.com>, Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, paulz@synopsys.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dwc2: Read GNPTXFSIZ when in forced HOST mode.
Date: Thu,  7 Aug 2014 12:48:11 -0700
Message-Id: <1407440891-29295-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for GNPTXFSIZ says that "For host mode, this field
is always valid."  Since we're already switching to host mode for
HPTXFSIZ, let's also read GNPTXFSIZ in host mode.

On an rk3288 SoC, without this change we see this at bootup:
  dwc2 ff580000.usb: gnptxfsiz=00100400
  dwc2 ff580000.usb: 128 invalid for host_nperio_tx_fifo_size. Check HW configuration.

After this change we see:
  dwc2 ff580000.usb: gnptxfsiz=04000400

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/dwc2/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index 27d2c9b..c184ed43 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -2674,23 +2674,23 @@ int dwc2_get_hwparams(struct dwc2_hsotg *hsotg)
 	hwcfg2 = readl(hsotg->regs + GHWCFG2);
 	hwcfg3 = readl(hsotg->regs + GHWCFG3);
 	hwcfg4 = readl(hsotg->regs + GHWCFG4);
-	gnptxfsiz = readl(hsotg->regs + GNPTXFSIZ);
 	grxfsiz = readl(hsotg->regs + GRXFSIZ);
 
 	dev_dbg(hsotg->dev, "hwcfg1=%08x\n", hwcfg1);
 	dev_dbg(hsotg->dev, "hwcfg2=%08x\n", hwcfg2);
 	dev_dbg(hsotg->dev, "hwcfg3=%08x\n", hwcfg3);
 	dev_dbg(hsotg->dev, "hwcfg4=%08x\n", hwcfg4);
-	dev_dbg(hsotg->dev, "gnptxfsiz=%08x\n", gnptxfsiz);
 	dev_dbg(hsotg->dev, "grxfsiz=%08x\n", grxfsiz);
 
-	/* Force host mode to get HPTXFSIZ exact power on value */
+	/* Force host mode to get HPTXFSIZ / GNPTXFSIZ exact power on value */
 	gusbcfg = readl(hsotg->regs + GUSBCFG);
 	gusbcfg |= GUSBCFG_FORCEHOSTMODE;
 	writel(gusbcfg, hsotg->regs + GUSBCFG);
 	usleep_range(100000, 150000);
 
+	gnptxfsiz = readl(hsotg->regs + GNPTXFSIZ);
 	hptxfsiz = readl(hsotg->regs + HPTXFSIZ);
+	dev_dbg(hsotg->dev, "gnptxfsiz=%08x\n", gnptxfsiz);
 	dev_dbg(hsotg->dev, "hptxfsiz=%08x\n", hptxfsiz);
 	gusbcfg = readl(hsotg->regs + GUSBCFG);
 	gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
-- 
2.0.0.526.g5318336

