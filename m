Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3KLOzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:55:55 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51911 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab3KLOyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:24 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCH v4 14/15] usb: phy: msm: Handle disconnect events
Date: Tue, 12 Nov 2013 16:51:49 +0200
Message-Id: <1384267910-32066-15-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Put the transceiver in non-driving mode. Otherwise host
may not detect soft-disconnection.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
 drivers/usb/phy/phy-msm-usb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 1d88ff8..970f96b 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -260,6 +260,23 @@ static void ulpi_init(struct msm_otg *motg)
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
@@ -1597,6 +1614,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 
 	phy->init = msm_phy_init;
 	phy->set_power = msm_otg_set_power;
+	phy->notify_disconnect = msm_phy_notify_disconnect;
 
 	phy->io_ops = &msm_otg_io_ops;
 
-- 
1.7.9.5

