Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaKRBVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:21:40 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48344 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaKRBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:21:39 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>, romain.perier@gmail.com,
        Heiko Stuebner <heiko@sntech.de>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        wulf@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>, Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] usb: dwc2: resume root hub when device detect with suspend state
Date: Tue, 18 Nov 2014 09:21:24 +0800
Message-Id: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we implement the bus_suspend/resume, auto suspend id enabled.
The root hub will be auto suspend if there is no device connected,
we need to resume the root hub when a device connect detect.

This patch tested on rk3288.

Signed-off-by: Roy Li <roy.li@rock-chips.com>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v2:
- add definition for hcd structure
- remove check for bus->root_hub

 drivers/usb/dwc2/hcd_intr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
index 551ba87..680206f 100644
--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -329,6 +329,7 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
 {
 	u32 hprt0;
 	u32 hprt0_modify;
+	struct usb_hcd *hcd = (struct usb_hcd *)hsotg->priv;
 
 	dev_vdbg(hsotg->dev, "--Port Interrupt--\n");
 
@@ -354,6 +355,10 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
 		hsotg->flags.b.port_connect_status = 1;
 		hprt0_modify |= HPRT0_CONNDET;
 
+		/* resume root hub? */
+		if (hcd->state == HC_STATE_SUSPENDED)
+			usb_hcd_resume_root_hub(hcd);
+
 		/*
 		 * The Hub driver asserts a reset when it sees port connect
 		 * status change flag
-- 
1.9.1

