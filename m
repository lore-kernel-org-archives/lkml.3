Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3LBTw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:52:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3LBTSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karol Babioch <karol@babioch.de>, Mattia Dongili <malattia@linux.it>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 122/212] sony-laptop: do not scribble keyboard backlight registers on resume
Date: Mon,  2 Dec 2013 11:15:13 -0800
Message-Id: <20131202191300.723043296@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattia Dongili <malattia@linux.it>

commit b975dc3689fc6a3718ad288ce080924f9cb7e176 upstream.

Follow-up to commit 294d31e8227c ("sony-laptop: don't change keyboard
backlight settings"): avoid messing up the state on resume.  Leave it to
what was before suspending as it's anyway likely that we still don't
know what value we should write to the EC registers.  This fix is also
required in 3.12

Tested-by: Karol Babioch <karol@babioch.de>
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/sony-laptop.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -140,7 +140,6 @@ MODULE_PARM_DESC(kbd_backlight_timeout,
 		 "on the model (default: no change from current value)");
 
 #ifdef CONFIG_PM_SLEEP
-static void sony_nc_kbd_backlight_resume(void);
 static void sony_nc_thermal_resume(void);
 #endif
 static int sony_nc_kbd_backlight_setup(struct platform_device *pd,
@@ -1486,13 +1485,6 @@ static void sony_nc_function_resume(void
 		case 0x0135:
 			sony_nc_rfkill_update();
 			break;
-		case 0x0137:
-		case 0x0143:
-		case 0x014b:
-		case 0x014c:
-		case 0x0163:
-			sony_nc_kbd_backlight_resume();
-			break;
 		default:
 			continue;
 		}
@@ -1894,25 +1886,6 @@ static void sony_nc_kbd_backlight_cleanu
 	}
 }
 
-#ifdef CONFIG_PM_SLEEP
-static void sony_nc_kbd_backlight_resume(void)
-{
-	int ignore = 0;
-
-	if (!kbdbl_ctl)
-		return;
-
-	if (kbdbl_ctl->mode == 0)
-		sony_call_snc_handle(kbdbl_ctl->handle, kbdbl_ctl->base,
-				&ignore);
-
-	if (kbdbl_ctl->timeout != 0)
-		sony_call_snc_handle(kbdbl_ctl->handle,
-				(kbdbl_ctl->base + 0x200) |
-				(kbdbl_ctl->timeout << 0x10), &ignore);
-}
-#endif
-
 struct battery_care_control {
 	struct device_attribute attrs[2];
 	unsigned int handle;


