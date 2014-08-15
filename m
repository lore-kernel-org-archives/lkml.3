Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaHOJVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:21:40 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35687 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaHOJVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:21:38 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tim Bird <tbird20d@gmail.com>, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] usb: chipidea: msm: Use USB PHY API to control PHY state
Date: Fri, 15 Aug 2014 12:21:19 +0300
Message-Id: <1408094479-13857-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

PHY drivers keep track of the current state of the hardware,
so don't change PHY settings under it.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/chipidea/ci_hdrc_msm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index d72b9d2..81de834 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -20,13 +20,11 @@
 static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 {
 	struct device *dev = ci->gadget.dev.parent;
-	int val;
 
 	switch (event) {
 	case CI_HDRC_CONTROLLER_RESET_EVENT:
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
-		writel(0, USB_AHBBURST);
-		writel(0, USB_AHBMODE);
+		usb_phy_init(ci->transceiver);
 		break;
 	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
@@ -34,10 +32,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 		 * Put the transceiver in non-driving mode. Otherwise host
 		 * may not detect soft-disconnection.
 		 */
-		val = usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
-		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
-		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
-		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
+		usb_phy_notify_disconnect(ci->transceiver, USB_SPEED_UNKNOWN);
 		break;
 	default:
 		dev_dbg(dev, "unknown ci_hdrc event\n");
-- 
1.8.3.2

