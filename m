Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaC3Ne5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 09:34:57 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:53897 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaC3Ne3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 09:34:29 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        PaX Team <pageexec@freemail.hu>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [PATCH 1/2] pda_power: Statically initialize notifier block
Date: Sun, 30 Mar 2014 15:34:14 +0200
Message-Id: <1396186455-3276-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
References: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of initializing the notifier block in pda_power_probe(),
initialize it statically. This safes us some code.

Found in the PaX patch, written by the PaX Team.

Cc: PaX Team <pageexec@freemail.hu>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 drivers/power/pda_power.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 0c52e2a0d9..87a963d0a8 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -37,7 +37,6 @@ static int polling;
 
 #if IS_ENABLED(CONFIG_USB_PHY)
 static struct usb_phy *transceiver;
-static struct notifier_block otg_nb;
 #endif
 
 static struct regulator *ac_draw;
@@ -258,6 +257,10 @@ static int otg_handle_notification(struct notifier_block *nb,
 
 	return NOTIFY_OK;
 }
+
+static struct notifier_block otg_nb = {
+	.notifier_call = otg_handle_notification,
+};
 #endif
 
 static int pda_power_probe(struct platform_device *pdev)
@@ -369,7 +372,6 @@ static int pda_power_probe(struct platform_device *pdev)
 
 #if IS_ENABLED(CONFIG_USB_PHY)
 	if (!IS_ERR_OR_NULL(transceiver) && pdata->use_otg_notifier) {
-		otg_nb.notifier_call = otg_handle_notification;
 		ret = usb_register_notifier(transceiver, &otg_nb);
 		if (ret) {
 			dev_err(dev, "failure to register otg notifier\n");
-- 
1.7.10.4

