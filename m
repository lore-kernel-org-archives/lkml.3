Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3CQTWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:22:17 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53301 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab3CQTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:22:14 -0400
From: Arthur Wirski <awirski@gmail.com>
To: Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arthur Wirski <awirski@gmail.com>
Subject: [PATCH 1/1] sony-laptop: SVS151290S kbd backlight and gfx switch support
Date: Sun, 17 Mar 2013 20:21:35 +0100
Message-Id: <1363548095-3545-1-git-send-email-awirski@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SVS151290S series uses handle 0x0163 for keyboard backlight and 0x015B for the graphics switch.

Signed-off-by: Arthur Wirski <awirski@gmail.com>
---
 drivers/platform/x86/sony-laptop.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 14d4dce..997264e 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1255,6 +1255,11 @@ static void sony_nc_notify(struct acpi_device *device, u32 event)
 			real_ev = __sony_nc_gfx_switch_status_get();
 			break;
 
+		case 0x015B:
+			/* Hybrid GFX switching SVS151290S */
+			ev_type = GFX_SWITCH;
+			real_ev = __sony_nc_gfx_switch_status_get();
+			break;
 		default:
 			dprintk("Unknown event 0x%x for handle 0x%x\n",
 					event, handle);
@@ -1353,6 +1358,7 @@ static void sony_nc_function_setup(struct acpi_device *device,
 			break;
 		case 0x0128:
 		case 0x0146:
+		case 0x015B:
 			result = sony_nc_gfx_switch_setup(pf_device, handle);
 			if (result)
 				pr_err("couldn't set up GFX Switch status (%d)\n",
@@ -1375,6 +1381,7 @@ static void sony_nc_function_setup(struct acpi_device *device,
 		case 0x0143:
 		case 0x014b:
 		case 0x014c:
+		case 0x0163:
 			result = sony_nc_kbd_backlight_setup(pf_device, handle);
 			if (result)
 				pr_err("couldn't set up keyboard backlight function (%d)\n",
@@ -1426,6 +1433,7 @@ static void sony_nc_function_cleanup(struct platform_device *pd)
 			break;
 		case 0x0128:
 		case 0x0146:
+		case 0x015B:
 			sony_nc_gfx_switch_cleanup(pd);
 			break;
 		case 0x0131:
@@ -1439,6 +1447,7 @@ static void sony_nc_function_cleanup(struct platform_device *pd)
 		case 0x0143:
 		case 0x014b:
 		case 0x014c:
+		case 0x0163:
 			sony_nc_kbd_backlight_cleanup(pd);
 			break;
 		default:
@@ -1485,6 +1494,7 @@ static void sony_nc_function_resume(void)
 		case 0x0143:
 		case 0x014b:
 		case 0x014c:
+		case 0x0163:
 			sony_nc_kbd_backlight_resume();
 			break;
 		default:
@@ -2390,7 +2400,9 @@ static int __sony_nc_gfx_switch_status_get(void)
 {
 	unsigned int result;
 
-	if (sony_call_snc_handle(gfxs_ctl->handle, 0x0100, &result))
+	if (sony_call_snc_handle(gfxs_ctl->handle,
+				gfxs_ctl->handle == 0x015B ? 0x0000 : 0x0100,
+				&result))
 		return -EIO;
 
 	switch (gfxs_ctl->handle) {
@@ -2400,6 +2412,12 @@ static int __sony_nc_gfx_switch_status_get(void)
 		 */
 		return result & 0x1 ? SPEED : STAMINA;
 		break;
+	case 0x015B:
+		/* 0: discrete GFX (speed)
+		 * 1: integrated GFX (stamina)
+		 */
+		return result & 0x1 ? STAMINA : SPEED;
+		break;
 	case 0x0128:
 		/* it's a more elaborated bitmask, for now:
 		 * 2: integrated GFX (stamina)
-- 
1.7.10.4

