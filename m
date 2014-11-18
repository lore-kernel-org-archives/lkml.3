Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbaKRVAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:00:53 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56894 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbaKRU7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:59:11 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] staging: panel: Make two more module params read-only
Date: Tue, 18 Nov 2014 21:56:11 +0100
Message-Id: <1416344174-9155-7-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make keypad_type and lcd_type module params read-only.
This step also starts making it more clear what is
the precedence of device params coming from different
sources (device profile, runtime module param values etc).

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 71 ++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 7f2f5f8..5b4f0a4 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -229,6 +229,9 @@ static struct {
 	bool enabled;
 } lcd;
 
+/* Needed only for init */
+static int selected_lcd_type = NOT_SET;
+
 /* contains the LCD config state */
 static unsigned long int lcd_flags;
 /* contains the LCD X offset */
@@ -1417,7 +1420,7 @@ static void panel_lcd_print(const char *s)
 /* initialize the LCD driver */
 static void lcd_init(void)
 {
-	switch (lcd_type) {
+	switch (selected_lcd_type) {
 	case LCD_TYPE_OLD:
 		/* parallel mode, 8 bits */
 		if (IS_NOT_SET(lcd_proto))
@@ -2235,28 +2238,21 @@ static struct parport_driver panel_driver = {
 /* init function */
 static int __init panel_init_module(void)
 {
-	/* for backwards compatibility */
-	if (IS_NOT_SET(keypad_type))
-		keypad_type = keypad_enabled;
-
-	if (IS_NOT_SET(lcd_type))
-		lcd_type = lcd_enabled;
+	int selected_keypad_type = NOT_SET;
 
 	/* take care of an eventual profile */
 	switch (profile) {
 	case PANEL_PROFILE_CUSTOM:
 		/* custom profile */
-		if (IS_NOT_SET(keypad_type))
-			keypad_type = DEFAULT_KEYPAD_TYPE;
-		if (IS_NOT_SET(lcd_type))
-			lcd_type = DEFAULT_LCD_TYPE;
+		selected_keypad_type = DEFAULT_KEYPAD_TYPE;
+		selected_lcd_type = DEFAULT_LCD_TYPE;
 		break;
 	case PANEL_PROFILE_OLD:
 		/* 8 bits, 2*16, old keypad */
-		if (IS_NOT_SET(keypad_type))
-			keypad_type = KEYPAD_TYPE_OLD;
-		if (IS_NOT_SET(lcd_type))
-			lcd_type = LCD_TYPE_OLD;
+		selected_keypad_type = KEYPAD_TYPE_OLD;
+		selected_lcd_type = LCD_TYPE_OLD;
+
+		/* TODO: This two are a little hacky, sort it out later */
 		if (IS_NOT_SET(lcd_width))
 			lcd_width = 16;
 		if (IS_NOT_SET(lcd_hwidth))
@@ -2264,38 +2260,45 @@ static int __init panel_init_module(void)
 		break;
 	case PANEL_PROFILE_NEW:
 		/* serial, 2*16, new keypad */
-		if (IS_NOT_SET(keypad_type))
-			keypad_type = KEYPAD_TYPE_NEW;
-		if (IS_NOT_SET(lcd_type))
-			lcd_type = LCD_TYPE_KS0074;
+		selected_keypad_type = KEYPAD_TYPE_NEW;
+		selected_lcd_type = LCD_TYPE_KS0074;
 		break;
 	case PANEL_PROFILE_HANTRONIX:
 		/* 8 bits, 2*16 hantronix-like, no keypad */
-		if (IS_NOT_SET(keypad_type))
-			keypad_type = KEYPAD_TYPE_NONE;
-		if (IS_NOT_SET(lcd_type))
-			lcd_type = LCD_TYPE_HANTRONIX;
+		selected_keypad_type = KEYPAD_TYPE_NONE;
+		selected_lcd_type = LCD_TYPE_HANTRONIX;
 		break;
 	case PANEL_PROFILE_NEXCOM:
 		/* generic 8 bits, 2*16, nexcom keypad, eg. Nexcom. */
-		if (IS_NOT_SET(keypad_type))
-			keypad_type = KEYPAD_TYPE_NEXCOM;
-		if (IS_NOT_SET(lcd_type))
-			lcd_type = LCD_TYPE_NEXCOM;
+		selected_keypad_type = KEYPAD_TYPE_NEXCOM;
+		selected_lcd_type = LCD_TYPE_NEXCOM;
 		break;
 	case PANEL_PROFILE_LARGE:
 		/* 8 bits, 2*40, old keypad */
-		if (IS_NOT_SET(keypad_type))
-			keypad_type = KEYPAD_TYPE_OLD;
-		if (IS_NOT_SET(lcd_type))
-			lcd_type = LCD_TYPE_OLD;
+		selected_keypad_type = KEYPAD_TYPE_OLD;
+		selected_lcd_type = LCD_TYPE_OLD;
 		break;
 	}
 
-	lcd.enabled = (lcd_type > 0);
-	keypad.enabled = (keypad_type > 0);
+	/*
+	 * Overwrite selection with module param values (both keypad and lcd),
+	 * where the deprecated params have lower prio.
+	 */
+	if (keypad_enabled > -1)
+		selected_keypad_type = keypad_enabled;
+	if (keypad_type > -1)
+		selected_keypad_type = keypad_type;
+
+	keypad.enabled = (selected_keypad_type > 0);
+
+	if (lcd_enabled > -1)
+		selected_lcd_type = lcd_enabled;
+	if (lcd_type > -1)
+		selected_lcd_type = lcd_type;
+
+	lcd.enabled = (selected_lcd_type > 0);
 
-	switch (keypad_type) {
+	switch (selected_keypad_type) {
 	case KEYPAD_TYPE_OLD:
 		keypad_profile = old_keypad_profile;
 		break;
-- 
2.1.3

