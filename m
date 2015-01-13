Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbbAMOZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:25:47 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55401 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbAMOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:25:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Peter Chen <peter.chen@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] usb: phy: mv-usb: fix usb_phy build errors
Date: Tue, 13 Jan 2015 15:25:11 +0100
Message-ID: <1707713.rDByqtApOc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:n0yXRWI5wBfTsZ5PZHGuVg7a8QsZuWHRDX/5+rjnY+lAk7k0WsV
 X2RAlpMZfVtzC/VM8dne6lO1qUVtyXOAZrZ4Rd4oyFwwp49p6fbYUrFndg1zGbDg/yq7vy2
 bN3NeO+V4rgXBdYxY+18a62WKKqooIWsf0rHU6Pcvf4tdukwxERKduvzPQkgFuXWLsYxDpQ
 SUzLQiBKVGHPqa/wSDUDw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was recently adapted to a core API change, but the
change was incomplete, missing out the suspend helper and
leaving an extraneous local variable around:

usb/phy/phy-mv-usb.c: In function 'mv_otg_update_state':
usb/phy/phy-mv-usb.c:341:18: warning: unused variable 'phy' [-Wunused-variable]

usb/phy/phy-mv-usb.c: In function 'mv_otg_suspend':
usb/phy/phy-mv-usb.c:861:16: error: 'struct usb_phy' has no member named 'state'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: e47d92545c297 ("usb: move the OTG state from the USB PHY to the OTG structure")
---
diff --git a/drivers/usb/phy/phy-mv-usb.c b/drivers/usb/phy/phy-mv-usb.c
index 699e38c73d82..697a741a0cb1 100644
--- a/drivers/usb/phy/phy-mv-usb.c
+++ b/drivers/usb/phy/phy-mv-usb.c
@@ -338,7 +338,6 @@ static void mv_otg_update_inputs(struct mv_otg *mvotg)
 static void mv_otg_update_state(struct mv_otg *mvotg)
 {
 	struct mv_otg_ctrl *otg_ctrl = &mvotg->otg_ctrl;
-	struct usb_phy *phy = &mvotg->phy;
 	int old_state = mvotg->phy.otg->state;
 
 	switch (old_state) {
@@ -858,10 +857,10 @@ static int mv_otg_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct mv_otg *mvotg = platform_get_drvdata(pdev);
 
-	if (mvotg->phy.state != OTG_STATE_B_IDLE) {
+	if (mvotg->phy.otg->state != OTG_STATE_B_IDLE) {
 		dev_info(&pdev->dev,
 			 "OTG state is not B_IDLE, it is %d!\n",
-			 mvotg->phy.state);
+			 mvotg->phy.otg->state);
 		return -EAGAIN;
 	}
 

