Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaD1NgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:36:24 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58311 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbaD1NfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:35:23 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCH v8 18/20] usb: phy: msm: Handle disconnect events
Date: Mon, 28 Apr 2014 16:34:21 +0300
Message-Id: <1398692063-11372-19-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Put the transceiver in non-driving mode. Otherwise host
may not detect soft-disconnection.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
 drivers/usb/phy/phy-msm-usb.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 9437bcf..366527e 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -235,6 +235,23 @@ static void ulpi_init(struct msm_otg *motg)
 	}
 }

+static int msm_phy_notify_disconnect(struct usb_phy *phy,
+				   enum usb_device_speed speed)
+{
+	int val;
+
+	/*
+	 * Put the transceiver in non-driving mode. Otherwise host
+	 * may not detect soft-disconnection.
+	 */
+	val = ulpi_read(phy, ULPI_FUNC_CTRL);
+	val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
+	val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
+	ulpi_write(phy, val, ULPI_FUNC_CTRL);
+
+	return 0;
+}
+
 static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
 {
 	int ret;
@@ -1626,6 +1643,7 @@ static int msm_otg_probe(struct platform_device *pdev)

 	phy->init = msm_phy_init;
 	phy->set_power = msm_otg_set_power;
+	phy->notify_disconnect = msm_phy_notify_disconnect;

 	phy->io_ops = &msm_otg_io_ops;

--
1.8.3.2

