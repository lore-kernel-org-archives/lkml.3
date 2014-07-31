Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaGaBGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 21:06:34 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:52176 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGaBGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 21:06:31 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <2123890187ad87fd618b44a70cf073ea>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Kever Yang <kever.yang@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, paulz@synopsys.com, gregkh@linuxfoundation.org,
        mporter@linaro.org, kishon@ti.com
Cc: heiko@sntech.de, swarren@wwwdotorg.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kever.yang@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        cf@rock-chips.com, lyz@rock-chips.com, wulf@rock-chips.com,
        dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org
Subject: [PATCH v2 2/2] usb: dwc2: add dr_mode support for dwc2
Date: Wed, 30 Jul 2014 18:06:04 -0700
Message-Id: <1406768764-9684-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406766558-8156-1-git-send-email-kever.yang@rock-chips.com>
References: <1406766558-8156-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices with A female host port and without use of usb_id pin
will need this for the otg controller works as device role
during firmware period and works as host role in rich os.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

---

Changes in v2:
- put spaces around '+' operator
- expand the comment for dr_mode
- handle dr_mode is USB_DR_MODE_OTG

 drivers/usb/dwc2/core.c     |   18 ++++++++++++++++++
 drivers/usb/dwc2/core.h     |    5 +++++
 drivers/usb/dwc2/platform.c |    4 ++++
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
index 1efd10c..a34681c 100644
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
+	enum usb_dr_mode        dr_mode;
 
 	unsigned int queuing_high_bandwidth:1;
 	unsigned int srp_success:1;
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index b14668b..669a03a 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -42,6 +42,8 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 
+#include <linux/usb/of.h>
+
 #include "core.h"
 #include "hcd.h"
 
@@ -200,6 +202,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	dev_dbg(&dev->dev, "mapped PA %08lx to VA %p\n",
 		(unsigned long)res->start, hsotg->regs);
 
+	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
+
 	retval = dwc2_hcd_init(hsotg, irq, params);
 	if (retval)
 		return retval;
-- 
1.7.9.5


