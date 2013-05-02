Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3EBG1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:27:51 -0400
Received: from host171.canaca.com ([67.55.55.225]:49828 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3EBG1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:27:49 -0400
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] HID: hid-steelseries fix led class build issue
Date: Thu,  2 May 2013 00:27:21 -0600
Message-Id: <1367476041-25760-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <51816271.3040400@infradead.org>
References: <51816271.3040400@infradead.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes 'undefined reference' issue when hid-steelseries is built in,
but led-class is a module.
--
drivers/built-in.o: In function `steelseries_srws1_remove':
hid-steelseries.c:(.text+0x3b97a1): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `steelseries_srws1_probe':
hid-steelseries.c:(.text+0x3b9c51): undefined reference to `led_classdev_register'
hid-steelseries.c:(.text+0x3b9ce5): undefined reference to `led_classdev_register'
hid-steelseries.c:(.text+0x3b9d4b): undefined reference to `led_classdev_unregister'
--

Patch allows LED control when led-class is built in, or both hid-steelseries
_and_ led-class are both modules.
---
 drivers/hid/hid-steelseries.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-steelseries.c b/drivers/hid/hid-steelseries.c
index 2ed995c..dbd5e2e 100644
--- a/drivers/hid/hid-steelseries.c
+++ b/drivers/hid/hid-steelseries.c
@@ -19,7 +19,8 @@
 #include "usbhid/usbhid.h"
 #include "hid-ids.h"
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#if defined(CONFIG_LEDS_CLASS) || \
+    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_HID_STEELSERIES_MODULE))
 #define SRWS1_NUMBER_LEDS 15
 struct steelseries_srws1_data {
 	__u16 led_state;
@@ -108,7 +109,8 @@ static __u8 steelseries_srws1_rdesc_fixed[] = {
 0xC0                /*  End Collection                      */
 };
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#if defined(CONFIG_LEDS_CLASS) || \
+    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_HID_STEELSERIES_MODULE))
 static void steelseries_srws1_set_leds(struct hid_device *hdev, __u16 leds)
 {
 	struct list_head *report_list = &hdev->report_enum[HID_OUTPUT_REPORT].report_list;
@@ -371,7 +373,8 @@ MODULE_DEVICE_TABLE(hid, steelseries_srws1_devices);
 static struct hid_driver steelseries_srws1_driver = {
 	.name = "steelseries_srws1",
 	.id_table = steelseries_srws1_devices,
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#if defined(CONFIG_LEDS_CLASS) || \
+    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_HID_STEELSERIES_MODULE))
 	.probe = steelseries_srws1_probe,
 	.remove = steelseries_srws1_remove,
 #endif
-- 
1.8.1.2

