Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbaAaWjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:39:53 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56265 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbaAaWjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:39:51 -0500
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Julius Werner <jwerner@chromium.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Matthias Beyer <mail@beyermatthias.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] usb: move hub init and LED blink work to power efficient workqueue
Date: Fri, 31 Jan 2014 14:39:08 -0800
Message-Id: <1391207948-17063-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@broadcom.com>

Allow the scheduler to select the best CPU to handle hub initalization
and LED blinking work. This extends idle residency times on idle CPUs
and conserves power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Xenia Ragiadakou <burzalodowa@gmail.com>
Cc: Julius Werner <jwerner@chromium.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Matthias Beyer <mail@beyermatthias.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Rebased to latest kernel. Added commit message.
Changed reference from system to power efficient workqueue for LEDs in
check_highspeed() and hub_port_connect_change().]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 drivers/usb/core/hub.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index babba88..ae07ffe 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -504,7 +504,8 @@ static void led_work (struct work_struct *work)
 		changed++;
 	}
 	if (changed)
-		schedule_delayed_work(&hub->leds, LED_CYCLE_PERIOD);
+		queue_delayed_work(system_power_efficient_wq,
+				   &hub->leds, LED_CYCLE_PERIOD);
 }
 
 /* use a short timeout for hub/port status fetches */
@@ -1046,8 +1047,9 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 		if (type == HUB_INIT) {
 			delay = hub_power_on(hub, false);
 			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func2);
-			schedule_delayed_work(&hub->init_work,
-					msecs_to_jiffies(delay));
+			queue_delayed_work(system_power_efficient_wq,
+					   &hub->init_work,
+					   msecs_to_jiffies(delay));
 
 			/* Suppress autosuspend until init is done */
 			usb_autopm_get_interface_no_resume(
@@ -1200,8 +1202,9 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 		/* Don't do a long sleep inside a workqueue routine */
 		if (type == HUB_INIT2) {
 			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func3);
-			schedule_delayed_work(&hub->init_work,
-					msecs_to_jiffies(delay));
+			queue_delayed_work(system_power_efficient_wq,
+					   &hub->init_work,
+					   msecs_to_jiffies(delay));
 			return;		/* Continues at init3: below */
 		} else {
 			msleep(delay);
@@ -1214,7 +1217,8 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 	if (status < 0)
 		dev_err(hub->intfdev, "activate --> %d\n", status);
 	if (hub->has_indicators && blinkenlights)
-		schedule_delayed_work(&hub->leds, LED_CYCLE_PERIOD);
+		queue_delayed_work(system_power_efficient_wq,
+				   &hub->leds, LED_CYCLE_PERIOD);
 
 	/* Scan all ports that need attention */
 	kick_khubd(hub);
@@ -4316,7 +4320,8 @@ check_highspeed (struct usb_hub *hub, struct usb_device *udev, int port1)
 		/* hub LEDs are probably harder to miss than syslog */
 		if (hub->has_indicators) {
 			hub->indicator[port1-1] = INDICATOR_GREEN_BLINK;
-			schedule_delayed_work (&hub->leds, 0);
+			queue_delayed_work(system_power_efficient_wq,
+					   &hub->leds, 0);
 		}
 	}
 	kfree(qual);
@@ -4545,7 +4550,9 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 				if (hub->has_indicators) {
 					hub->indicator[port1-1] =
 						INDICATOR_AMBER_BLINK;
-					schedule_delayed_work (&hub->leds, 0);
+					queue_delayed_work(
+						system_power_efficient_wq,
+						&hub->leds, 0);
 				}
 				status = -ENOTCONN;	/* Don't retry */
 				goto loop_disable;
-- 
1.7.9.5

