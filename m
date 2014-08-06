Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaHFBDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:03:12 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:49922 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaHFBDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:03:09 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: dianders@chromium.org, Heiko Stuebner <heiko@sntech.de>,
        addy.ke@rock-chips.com, cf@rock-chips.com, xjq@rock-chips.com,
        olof@lixom.net, sonnyrao@chromium.org, wulf@rock-chips.com,
        lyz@rock-chips.com, jg1.han@samsung.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] usb: dwc2: add 'mode' which based on Kconfig select or dts setting
Date: Wed,  6 Aug 2014 09:01:50 +0800
Message-Id: <1407286910-30906-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407286910-30906-1-git-send-email-kever.yang@rock-chips.com>
References: <1407286910-30906-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the "dr_mode", the otg controller can work as
device role and host role. Some boards always want to use host mode
and some other boards want to use gadget mode. We use the dts setting
to set dwc2's mode, rather than fixing it to whatever hardware says.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---

Changes in v4:
- From Doug's suggestion:
 -- remove dr_mode init from Kconfig code
 -- change the commit meesage

Changes in v3:
- fix the odd spacing in dwc2_hsotg struct
- From Jingoo's suggestion:
    change the commit message
- add dr_mode init from Kconfig

Changes in v2:
- put spaces around '+' operator
- expand the comment for dr_mode
- handle dr_mode is USB_DR_MODE_OTG

 drivers/usb/dwc2/core.c     | 18 ++++++++++++++++++
 drivers/usb/dwc2/core.h     |  5 +++++
 drivers/usb/dwc2/platform.c |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index 27d2c9b..738bec2 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -118,6 +118,7 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
 {
 	u32 greset;
 	int count = 0;
+	u32 gusbcfg;
 
 	dev_vdbg(hsotg->dev, "%s()\n", __func__);
 
@@ -148,6 +149,23 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
 		}
 	} while (greset & GRSTCTL_CSFTRST);
 
+	if (hsotg->dr_mode == USB_DR_MODE_HOST) {
+		gusbcfg = readl(hsotg->regs + GUSBCFG);
+		gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
+		gusbcfg |= GUSBCFG_FORCEHOSTMODE;
+		writel(gusbcfg, hsotg->regs + GUSBCFG);
+	} else if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
+		gusbcfg = readl(hsotg->regs + GUSBCFG);
+		gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
+		gusbcfg |= GUSBCFG_FORCEDEVMODE;
+		writel(gusbcfg, hsotg->regs + GUSBCFG);
+	} else if (hsotg->dr_mode == USB_DR_MODE_OTG) {
+		gusbcfg = readl(hsotg->regs + GUSBCFG);
+		gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
+		gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
+		writel(gusbcfg, hsotg->regs + GUSBCFG);
+	}
+
 	/*
 	 * NOTE: This long sleep is _very_ important, otherwise the core will
 	 * not stay in host mode after a connector ID change!
diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 1efd10c..52a4fd2 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -501,6 +501,10 @@ struct dwc2_hw_params {
  *                      a_peripheral and b_device=>b_host) this may not match
  *                      the core, but allows the software to determine
  *                      transitions
+ * @dr_mode:            Requested mode of operation, one of following:
+ *                      - USB_DR_MODE_PERIPHERAL
+ *                      - USB_DR_MODE_HOST
+ *                      - USB_DR_MODE_OTG
  * @queuing_high_bandwidth: True if multiple packets of a high-bandwidth
  *                      transfer are in process of being queued
  * @srp_success:        Stores status of SRP request in the case of a FS PHY
@@ -592,6 +596,7 @@ struct dwc2_hsotg {
 	/** Params to actually use */
 	struct dwc2_core_params *core_params;
 	enum usb_otg_state op_state;
+	enum usb_dr_mode dr_mode;
 
 	unsigned int queuing_high_bandwidth:1;
 	unsigned int srp_success:1;
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index a10e7a3..5f0c4bb 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -42,6 +42,8 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 
+#include <linux/usb/of.h>
+
 #include "core.h"
 #include "hcd.h"
 
@@ -171,6 +173,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	dev_dbg(&dev->dev, "mapped PA %08lx to VA %p\n",
 		(unsigned long)res->start, hsotg->regs);
 
+	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
+
 	retval = dwc2_hcd_init(hsotg, irq, params);
 	if (retval)
 		return retval;
-- 
1.9.1

