Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3IHIvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 04:51:16 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37634 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3IHIvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 04:51:12 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when status is changed
Date: Sun,  8 Sep 2013 10:50:36 +0200
Message-Id: <1378630239-10006-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More power supply drivers depends on vbus events and without it they not
working. Power supply drivers using usb_register_notifier, so to deliver
events it is needed to call atomic_notifier_call_chain.

So without atomic notifier power supply driver isp1704 not retrieving
vbus status and reporting bogus values to userspace and also to board
platform data functions. Without proper data charger drivers trying to
charge battery also when charger is disconnected or do not start charging
when wallcharger connects.

Atomic notifier in musb driver was used before v3.5 and was replaced with
omap mailbox. This patch adding atomic_notifier_call_chain call from
function omap_musb_set_mailbox.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/usb/musb/omap2430.c       |    3 +++
 drivers/usb/phy/phy-twl4030-usb.c |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index f44e8b5..5c40252 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -305,6 +305,9 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 	default:
 		dev_dbg(dev, "ID float\n");
 	}
+
+	atomic_notifier_call_chain(&musb->xceiv->notifier,
+			musb->xceiv->last_event, NULL);
 }
 
 
diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
index 8f78d2d..efe6155 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/usb/phy/phy-twl4030-usb.c
@@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
 
+	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
+
 	/* Our job is to use irqs and status from the power module
 	 * to keep the transceiver disabled when nothing's connected.
 	 *
-- 
1.7.10.4

