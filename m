Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3GZEtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:49:03 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54022 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3GZEsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:48:43 -0400
From: Andreas Platschek <andi.platschek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Platschek <andi.platschek@gmail.com>
Subject: [PATCH] tty: Remove dead code
Date: Fri, 26 Jul 2013 06:46:37 +0200
Message-Id: <1374813997-24671-1-git-send-email-andi.platschek@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-> The ledptrs[] array is never initialized.
-> There is no place where kbd->ledmode is set to LED_SHOW_MEM therefore the if
   statement does not make much sense.
-> Since LED_SHOW_MEM is not used, it can be removed from the header file as well.

Signed-off-by: Andreas Platschek <andi.platschek@gmail.com>
---
 drivers/tty/vt/keyboard.c |   21 +--------------------
 include/linux/kbd_kern.h  |    3 +--
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index a9af1b9a..d0e3a44 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -132,12 +132,6 @@ static int shift_state = 0;
 static unsigned char ledstate = 0xff;			/* undefined */
 static unsigned char ledioctl;
 
-static struct ledptr {
-	unsigned int *addr;
-	unsigned int mask;
-	unsigned char valid:1;
-} ledptrs[3];
-
 /*
  * Notifier list for console keyboard events
  */
@@ -994,24 +988,11 @@ void setledstate(struct kbd_struct *kbd, unsigned int led)
 static inline unsigned char getleds(void)
 {
 	struct kbd_struct *kbd = kbd_table + fg_console;
-	unsigned char leds;
-	int i;
 
 	if (kbd->ledmode == LED_SHOW_IOCTL)
 		return ledioctl;
 
-	leds = kbd->ledflagstate;
-
-	if (kbd->ledmode == LED_SHOW_MEM) {
-		for (i = 0; i < 3; i++)
-			if (ledptrs[i].valid) {
-				if (*ledptrs[i].addr & ledptrs[i].mask)
-					leds |= (1 << i);
-				else
-					leds &= ~(1 << i);
-			}
-	}
-	return leds;
+	return kbd->ledflagstate;
 }
 
 static int kbd_update_leds_helper(struct input_handle *handle, void *data)
diff --git a/include/linux/kbd_kern.h b/include/linux/kbd_kern.h
index b7c8cdc..c164c04 100644
--- a/include/linux/kbd_kern.h
+++ b/include/linux/kbd_kern.h
@@ -36,10 +36,9 @@ struct kbd_struct {
 #define VC_CTRLRLOCK	KG_CTRLR 	/* ctrlr lock mode */
 	unsigned char slockstate; 	/* for `sticky' Shift, Ctrl, etc. */
 
-	unsigned char ledmode:2; 	/* one 2-bit value */
+	unsigned char ledmode:1;
 #define LED_SHOW_FLAGS 0        /* traditional state */
 #define LED_SHOW_IOCTL 1        /* only change leds upon ioctl */
-#define LED_SHOW_MEM 2          /* `heartbeat': peek into memory */
 
 	unsigned char ledflagstate:4;	/* flags, not lights */
 	unsigned char default_ledflagstate:4;
-- 
1.7.10.4

