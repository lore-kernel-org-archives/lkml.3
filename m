Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaK0Vhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:37:33 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33495 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaK0Vha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:30 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/9] staging: panel: Start making module params read-only
Date: Thu, 27 Nov 2014 22:36:49 +0100
Message-Id: <1417124213-23409-6-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
References: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start decoupling module params from the actual device state,
both for lcd and keypad, by keeping the params read-only
and moving the device state to related structs.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/panel/panel.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 5288990..7e5bb53 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -212,6 +212,10 @@ static pmask_t phys_prev;
 static char inputs_stable;
 
 /* these variables are specific to the keypad */
+static struct {
+	bool enabled;
+} keypad;
+
 static char keypad_buffer[KEYPAD_BUFFER];
 static int keypad_buflen;
 static int keypad_start;
@@ -219,6 +223,9 @@ static char keypressed;
 static wait_queue_head_t keypad_read_wait;
 
 /* lcd-specific variables */
+static struct {
+	bool enabled;
+} lcd;
 
 /* contains the LCD config state */
 static unsigned long int lcd_flags;
@@ -1393,7 +1400,7 @@ static void panel_lcd_print(const char *s)
 	const char *tmp = s;
 	int count = strlen(s);
 
-	if (lcd_enabled && lcd_initialized) {
+	if (lcd.enabled && lcd_initialized) {
 		for (; count-- > 0; tmp++) {
 			if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
 				/* let's be a little nice with other processes
@@ -1923,7 +1930,7 @@ static void panel_process_inputs(void)
 
 static void panel_scan_timer(void)
 {
-	if (keypad_enabled && keypad_initialized) {
+	if (keypad.enabled && keypad_initialized) {
 		if (spin_trylock_irq(&pprt_lock)) {
 			phys_scan_contacts();
 
@@ -1935,7 +1942,7 @@ static void panel_scan_timer(void)
 			panel_process_inputs();
 	}
 
-	if (lcd_enabled && lcd_initialized) {
+	if (lcd.enabled && lcd_initialized) {
 		if (keypressed) {
 			if (light_tempo == 0 && ((lcd_flags & LCD_FLAG_L) == 0))
 				lcd_backlight(1);
@@ -2114,7 +2121,7 @@ static void keypad_init(void)
 static int panel_notify_sys(struct notifier_block *this, unsigned long code,
 			    void *unused)
 {
-	if (lcd_enabled && lcd_initialized) {
+	if (lcd.enabled && lcd_initialized) {
 		switch (code) {
 		case SYS_DOWN:
 			panel_lcd_print
@@ -2170,13 +2177,13 @@ static void panel_attach(struct parport *port)
 	/* must init LCD first, just in case an IRQ from the keypad is
 	 * generated at keypad init
 	 */
-	if (lcd_enabled) {
+	if (lcd.enabled) {
 		lcd_init();
 		if (misc_register(&lcd_dev))
 			goto err_unreg_device;
 	}
 
-	if (keypad_enabled) {
+	if (keypad.enabled) {
 		keypad_init();
 		if (misc_register(&keypad_dev))
 			goto err_lcd_unreg;
@@ -2184,7 +2191,7 @@ static void panel_attach(struct parport *port)
 	return;
 
 err_lcd_unreg:
-	if (lcd_enabled)
+	if (lcd.enabled)
 		misc_deregister(&lcd_dev);
 err_unreg_device:
 	parport_unregister_device(pprt);
@@ -2202,12 +2209,12 @@ static void panel_detach(struct parport *port)
 		return;
 	}
 
-	if (keypad_enabled && keypad_initialized) {
+	if (keypad.enabled && keypad_initialized) {
 		misc_deregister(&keypad_dev);
 		keypad_initialized = 0;
 	}
 
-	if (lcd_enabled && lcd_initialized) {
+	if (lcd.enabled && lcd_initialized) {
 		misc_deregister(&lcd_dev);
 		lcd_initialized = 0;
 	}
@@ -2283,8 +2290,8 @@ static int __init panel_init_module(void)
 		break;
 	}
 
-	lcd_enabled = (lcd_type > 0);
-	keypad_enabled = (keypad_type > 0);
+	lcd.enabled = (lcd_type > 0);
+	keypad.enabled = (keypad_type > 0);
 
 	switch (keypad_type) {
 	case KEYPAD_TYPE_OLD:
@@ -2309,7 +2316,7 @@ static int __init panel_init_module(void)
 		return -EIO;
 	}
 
-	if (!lcd_enabled && !keypad_enabled) {
+	if (!lcd.enabled && !keypad.enabled) {
 		/* no device enabled, let's release the parport */
 		if (pprt) {
 			parport_release(pprt);
@@ -2344,12 +2351,12 @@ static void __exit panel_cleanup_module(void)
 		del_timer_sync(&scan_timer);
 
 	if (pprt != NULL) {
-		if (keypad_enabled) {
+		if (keypad.enabled) {
 			misc_deregister(&keypad_dev);
 			keypad_initialized = 0;
 		}
 
-		if (lcd_enabled) {
+		if (lcd.enabled) {
 			panel_lcd_print("\x0cLCD driver " PANEL_VERSION
 					"\nunloaded.\x1b[Lc\x1b[Lb\x1b[L-");
 			misc_deregister(&lcd_dev);
-- 
2.1.3

