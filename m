Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3CNGYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:24:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40616 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab3CNGYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:24:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v2 4/4] usb: otg: twl4030: fix cold plug on OMAP3
Date: Thu, 14 Mar 2013 11:53:59 +0530
Message-ID: <1363242239-1061-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363242239-1061-1-git-send-email-kishon@ti.com>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having twl4030_usb_phy_init() (detects if a cable is connected before
twl4030 is probed) in twl4030 probe makes cable connect events to be
missed by musb glue, since it gets loaded after twl4030. Having
twl4030_usb_phy_init as a usb_phy ops lets twl4030_usb_phy_init to be
called when glue is ready.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/twl4030-usb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 5b20bb4..4040124 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -565,8 +565,9 @@ static void twl4030_id_workaround_work(struct work_struct *work)
 	}
 }
 
-static void twl4030_usb_phy_init(struct twl4030_usb *twl)
+static int twl4030_usb_phy_init(struct usb_phy *phy)
 {
+	struct twl4030_usb *twl = phy_to_twl(phy);
 	enum omap_musb_vbus_id_status status;
 
 	/*
@@ -581,6 +582,7 @@ static void twl4030_usb_phy_init(struct twl4030_usb *twl)
 		omap_musb_mailbox(twl->linkstat);
 
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
+	return 0;
 }
 
 static int twl4030_set_suspend(struct usb_phy *x, int suspend)
@@ -657,6 +659,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->phy.otg		= otg;
 	twl->phy.type		= USB_PHY_TYPE_USB2;
 	twl->phy.set_suspend	= twl4030_set_suspend;
+	twl->phy.init		= twl4030_usb_phy_init;
 
 	otg->phy		= &twl->phy;
 	otg->set_host		= twl4030_set_host;
@@ -696,8 +699,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 		return status;
 	}
 
-	twl4030_usb_phy_init(twl);
-
 	dev_info(&pdev->dev, "Initialized TWL4030 USB module\n");
 	return 0;
 }
-- 
1.7.10.4

