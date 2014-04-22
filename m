Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaDVJXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:23:06 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53583 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaDVJVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:46 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Subject: [PATCH v6 15/19] usb: phy: msm: Fix PTS definitions for MSM USB controller
Date: Tue, 22 Apr 2014 12:20:34 +0300
Message-Id: <1398158438-21579-16-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Bird <tbird20d@gmail.com>

Fix the value used for Parallel Transceiver Select (PTS) for the MSM USB
controller.  This is a standard chipidea PORTSC definition, where
a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
Fix the definitions and use them correctly in the driver code.

Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
---
 drivers/usb/phy/phy-msm-usb.c    | 8 +++++---
 include/linux/usb/msm_hsusb_hw.h | 5 +++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index dababf9..e83d13a 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -287,8 +287,9 @@ static int msm_link_reset(struct msm_otg *motg)
 	if (motg->phy_number)
 		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);

+	/* put transciever in serial mode as part of reset */
 	val = readl(USB_PORTSC) & ~PORTSC_PTS_MASK;
-	writel(val | PORTSC_PTS_ULPI, USB_PORTSC);
+	writel(val | PORTSC_PTS_SERIAL, USB_PORTSC);

 	return 0;
 }
@@ -308,8 +309,9 @@ static int msm_otg_reset(struct usb_phy *phy)
 	if (cnt >= LINK_RESET_TIMEOUT_USEC)
 		return -ETIMEDOUT;

-	/* select ULPI phy */
-	writel(0x80000000, USB_PORTSC);
+	/* select ULPI phy and clear other status/control bits in PORTSC */
+	writel(PORTSC_PTS_ULPI, USB_PORTSC);
+
 	writel(0x0, USB_AHBBURST);
 	writel(0x08, USB_AHBMODE);

diff --git a/include/linux/usb/msm_hsusb_hw.h b/include/linux/usb/msm_hsusb_hw.h
index 575c743..98d3dd8 100644
--- a/include/linux/usb/msm_hsusb_hw.h
+++ b/include/linux/usb/msm_hsusb_hw.h
@@ -31,8 +31,9 @@
 #define USB_USBINTR          (MSM_USB_BASE + 0x0148)

 #define PORTSC_PHCD            (1 << 23) /* phy suspend mode */
-#define PORTSC_PTS_MASK         (3 << 30)
-#define PORTSC_PTS_ULPI         (3 << 30)
+#define PORTSC_PTS_MASK        (3 << 30)
+#define PORTSC_PTS_ULPI        (2 << 30)
+#define PORTSC_PTS_SERIAL      (3 << 30)

 #define USB_ULPI_VIEWPORT    (MSM_USB_BASE + 0x0170)
 #define ULPI_RUN              (1 << 30)
--
1.8.3.2

