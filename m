Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaK0Vhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:37:36 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42827 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaK0Vhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:33 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/9] staging: panel: Refactor LCD init code
Date: Thu, 27 Nov 2014 22:36:51 +0100
Message-Id: <1417124213-23409-8-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
References: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework lcd_init method to make it a little bit more clear about
the precedence of the params, move LCD geometry and pins layout
to the LCD struct and thus make the LCD-related module params
effectively read-only.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/panel/panel.c | 304 ++++++++++++++++++++++--------------------
 1 file changed, 163 insertions(+), 141 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 5868a28..0bdb447 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -225,6 +225,21 @@ static wait_queue_head_t keypad_read_wait;
 /* lcd-specific variables */
 static struct {
 	bool enabled;
+	int height;
+	int width;
+	int bwidth;
+	int hwidth;
+	int charset;
+	int proto;
+	/* TODO: use union here? */
+	struct {
+		int e;
+		int rs;
+		int rw;
+		int cl;
+		int da;
+		int bl;
+	} pins;
 } lcd;
 
 /* Needed only for init */
@@ -766,7 +781,7 @@ static void lcd_send_serial(int byte)
 /* turn the backlight on or off */
 static void lcd_backlight(int on)
 {
-	if (lcd_bl_pin == PIN_NONE)
+	if (lcd.pins.bl == PIN_NONE)
 		return;
 
 	/* The backlight is activated by setting the AUTOFEED line to +5V  */
@@ -865,23 +880,23 @@ static void lcd_write_data_tilcd(int data)
 static void lcd_gotoxy(void)
 {
 	lcd_write_cmd(0x80	/* set DDRAM address */
-		      | (lcd_addr_y ? lcd_hwidth : 0)
+		      | (lcd_addr_y ? lcd.hwidth : 0)
 		      /* we force the cursor to stay at the end of the
 			 line if it wants to go farther */
-		      | ((lcd_addr_x < lcd_bwidth) ? lcd_addr_x &
-			 (lcd_hwidth - 1) : lcd_bwidth - 1));
+		      | ((lcd_addr_x < lcd.bwidth) ? lcd_addr_x &
+			 (lcd.hwidth - 1) : lcd.bwidth - 1));
 }
 
 static void lcd_print(char c)
 {
-	if (lcd_addr_x < lcd_bwidth) {
+	if (lcd_addr_x < lcd.bwidth) {
 		if (lcd_char_conv != NULL)
 			c = lcd_char_conv[(unsigned char)c];
 		lcd_write_data(c);
 		lcd_addr_x++;
 	}
 	/* prevents the cursor from wrapping onto the next line */
-	if (lcd_addr_x == lcd_bwidth)
+	if (lcd_addr_x == lcd.bwidth)
 		lcd_gotoxy();
 }
 
@@ -895,7 +910,7 @@ static void lcd_clear_fast_s(void)
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
-	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
+	for (pos = 0; pos < lcd.height * lcd.hwidth; pos++) {
 		lcd_send_serial(0x5F);	/* R/W=W, RS=1 */
 		lcd_send_serial(' ' & 0x0F);
 		lcd_send_serial((' ' >> 4) & 0x0F);
@@ -918,7 +933,7 @@ static void lcd_clear_fast_p8(void)
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
-	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
+	for (pos = 0; pos < lcd.height * lcd.hwidth; pos++) {
 		/* present the data to the data port */
 		w_dtr(pprt, ' ');
 
@@ -956,7 +971,7 @@ static void lcd_clear_fast_tilcd(void)
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
-	for (pos = 0; pos < lcd_height * lcd_hwidth; pos++) {
+	for (pos = 0; pos < lcd.height * lcd.hwidth; pos++) {
 		/* present the data to the data port */
 		w_dtr(pprt, ' ');
 		udelay(60);
@@ -981,7 +996,7 @@ static void lcd_clear_display(void)
 
 static void lcd_init_display(void)
 {
-	lcd_flags = ((lcd_height > 1) ? LCD_FLAG_N : 0)
+	lcd_flags = ((lcd.height > 1) ? LCD_FLAG_N : 0)
 	    | LCD_FLAG_D | LCD_FLAG_C | LCD_FLAG_B;
 
 	long_sleep(20);		/* wait 20 ms after power-up for the paranoid */
@@ -1095,17 +1110,17 @@ static inline int handle_lcd_special_code(void)
 	case 'l':	/* Shift Cursor Left */
 		if (lcd_addr_x > 0) {
 			/* back one char if not at end of line */
-			if (lcd_addr_x < lcd_bwidth)
+			if (lcd_addr_x < lcd.bwidth)
 				lcd_write_cmd(0x10);
 			lcd_addr_x--;
 		}
 		processed = 1;
 		break;
 	case 'r':	/* shift cursor right */
-		if (lcd_addr_x < lcd_width) {
+		if (lcd_addr_x < lcd.width) {
 			/* allow the cursor to pass the end of the line */
 			if (lcd_addr_x <
-			    (lcd_bwidth - 1))
+			    (lcd.bwidth - 1))
 				lcd_write_cmd(0x14);
 			lcd_addr_x++;
 		}
@@ -1124,7 +1139,7 @@ static inline int handle_lcd_special_code(void)
 	case 'k': {	/* kill end of line */
 		int x;
 
-		for (x = lcd_addr_x; x < lcd_bwidth; x++)
+		for (x = lcd_addr_x; x < lcd.bwidth; x++)
 			lcd_write_data(' ');
 
 		/* restore cursor position */
@@ -1272,7 +1287,7 @@ static void lcd_write_char(char c)
 			if (lcd_addr_x > 0) {
 				/* check if we're not at the
 				   end of the line */
-				if (lcd_addr_x < lcd_bwidth)
+				if (lcd_addr_x < lcd.bwidth)
 					/* back one char */
 					lcd_write_cmd(0x10);
 				lcd_addr_x--;
@@ -1289,10 +1304,10 @@ static void lcd_write_char(char c)
 		case '\n':
 			/* flush the remainder of the current line and
 			   go to the beginning of the next line */
-			for (; lcd_addr_x < lcd_bwidth; lcd_addr_x++)
+			for (; lcd_addr_x < lcd.bwidth; lcd_addr_x++)
 				lcd_write_data(' ');
 			lcd_addr_x = 0;
-			lcd_addr_y = (lcd_addr_y + 1) % lcd_height;
+			lcd_addr_y = (lcd_addr_y + 1) % lcd.height;
 			lcd_gotoxy();
 			break;
 		case '\r':
@@ -1421,174 +1436,164 @@ static void lcd_init(void)
 	switch (selected_lcd_type) {
 	case LCD_TYPE_OLD:
 		/* parallel mode, 8 bits */
-		if (lcd_proto == NOT_SET)
-			lcd_proto = LCD_PROTO_PARALLEL;
-		if (lcd_charset == NOT_SET)
-			lcd_charset = LCD_CHARSET_NORMAL;
-		if (lcd_e_pin == PIN_NOT_SET)
-			lcd_e_pin = PIN_STROBE;
-		if (lcd_rs_pin == PIN_NOT_SET)
-			lcd_rs_pin = PIN_AUTOLF;
-
-		if (lcd_width == NOT_SET)
-			lcd_width = 40;
-		if (lcd_bwidth == NOT_SET)
-			lcd_bwidth = 40;
-		if (lcd_hwidth == NOT_SET)
-			lcd_hwidth = 64;
-		if (lcd_height == NOT_SET)
-			lcd_height = 2;
+		lcd.proto = LCD_PROTO_PARALLEL;
+		lcd.charset = LCD_CHARSET_NORMAL;
+		lcd.pins.e = PIN_STROBE;
+		lcd.pins.rs = PIN_AUTOLF;
+
+		lcd.width = 40;
+		lcd.bwidth = 40;
+		lcd.hwidth = 64;
+		lcd.height = 2;
 		break;
 	case LCD_TYPE_KS0074:
 		/* serial mode, ks0074 */
-		if (lcd_proto == NOT_SET)
-			lcd_proto = LCD_PROTO_SERIAL;
-		if (lcd_charset == NOT_SET)
-			lcd_charset = LCD_CHARSET_KS0074;
-		if (lcd_bl_pin == PIN_NOT_SET)
-			lcd_bl_pin = PIN_AUTOLF;
-		if (lcd_cl_pin == PIN_NOT_SET)
-			lcd_cl_pin = PIN_STROBE;
-		if (lcd_da_pin == PIN_NOT_SET)
-			lcd_da_pin = PIN_D0;
-
-		if (lcd_width == NOT_SET)
-			lcd_width = 16;
-		if (lcd_bwidth == NOT_SET)
-			lcd_bwidth = 40;
-		if (lcd_hwidth == NOT_SET)
-			lcd_hwidth = 16;
-		if (lcd_height == NOT_SET)
-			lcd_height = 2;
+		lcd.proto = LCD_PROTO_SERIAL;
+		lcd.charset = LCD_CHARSET_KS0074;
+		lcd.pins.bl = PIN_AUTOLF;
+		lcd.pins.cl = PIN_STROBE;
+		lcd.pins.da = PIN_D0;
+
+		lcd.width = 16;
+		lcd.bwidth = 40;
+		lcd.hwidth = 16;
+		lcd.height = 2;
 		break;
 	case LCD_TYPE_NEXCOM:
 		/* parallel mode, 8 bits, generic */
-		if (lcd_proto == NOT_SET)
-			lcd_proto = LCD_PROTO_PARALLEL;
-		if (lcd_charset == NOT_SET)
-			lcd_charset = LCD_CHARSET_NORMAL;
-		if (lcd_e_pin == PIN_NOT_SET)
-			lcd_e_pin = PIN_AUTOLF;
-		if (lcd_rs_pin == PIN_NOT_SET)
-			lcd_rs_pin = PIN_SELECP;
-		if (lcd_rw_pin == PIN_NOT_SET)
-			lcd_rw_pin = PIN_INITP;
-
-		if (lcd_width == NOT_SET)
-			lcd_width = 16;
-		if (lcd_bwidth == NOT_SET)
-			lcd_bwidth = 40;
-		if (lcd_hwidth == NOT_SET)
-			lcd_hwidth = 64;
-		if (lcd_height == NOT_SET)
-			lcd_height = 2;
+		lcd.proto = LCD_PROTO_PARALLEL;
+		lcd.charset = LCD_CHARSET_NORMAL;
+		lcd.pins.e = PIN_AUTOLF;
+		lcd.pins.rs = PIN_SELECP;
+		lcd.pins.rw = PIN_INITP;
+
+		lcd.width = 16;
+		lcd.bwidth = 40;
+		lcd.hwidth = 64;
+		lcd.height = 2;
 		break;
 	case LCD_TYPE_CUSTOM:
 		/* customer-defined */
-		if (lcd_proto == NOT_SET)
-			lcd_proto = DEFAULT_LCD_PROTO;
-		if (lcd_charset == NOT_SET)
-			lcd_charset = DEFAULT_LCD_CHARSET;
+		lcd.proto = DEFAULT_LCD_PROTO;
+		lcd.charset = DEFAULT_LCD_CHARSET;
 		/* default geometry will be set later */
 		break;
 	case LCD_TYPE_HANTRONIX:
 		/* parallel mode, 8 bits, hantronix-like */
 	default:
-		if (lcd_proto == NOT_SET)
-			lcd_proto = LCD_PROTO_PARALLEL;
-		if (lcd_charset == NOT_SET)
-			lcd_charset = LCD_CHARSET_NORMAL;
-		if (lcd_e_pin == PIN_NOT_SET)
-			lcd_e_pin = PIN_STROBE;
-		if (lcd_rs_pin == PIN_NOT_SET)
-			lcd_rs_pin = PIN_SELECP;
-
-		if (lcd_width == NOT_SET)
-			lcd_width = 16;
-		if (lcd_bwidth == NOT_SET)
-			lcd_bwidth = 40;
-		if (lcd_hwidth == NOT_SET)
-			lcd_hwidth = 64;
-		if (lcd_height == NOT_SET)
-			lcd_height = 2;
+		lcd.proto = LCD_PROTO_PARALLEL;
+		lcd.charset = LCD_CHARSET_NORMAL;
+		lcd.pins.e = PIN_STROBE;
+		lcd.pins.rs = PIN_SELECP;
+
+		lcd.width = 16;
+		lcd.bwidth = 40;
+		lcd.hwidth = 64;
+		lcd.height = 2;
 		break;
 	}
 
+	/* Overwrite with module params set on loading */
+	if (lcd_height > -1)
+		lcd.height = lcd_height;
+	if (lcd_width > -1)
+		lcd.width = lcd_width;
+	if (lcd_bwidth > -1)
+		lcd.bwidth = lcd_bwidth;
+	if (lcd_hwidth > -1)
+		lcd.hwidth = lcd_hwidth;
+	if (lcd_charset > -1)
+		lcd.charset = lcd_charset;
+	if (lcd_proto > -1)
+		lcd.proto = lcd_proto;
+	if (lcd_e_pin != PIN_NOT_SET)
+		lcd.pins.e = lcd_e_pin;
+	if (lcd_rs_pin != PIN_NOT_SET)
+		lcd.pins.rs = lcd_rs_pin;
+	if (lcd_rw_pin != PIN_NOT_SET)
+		lcd.pins.rw = lcd_rw_pin;
+	if (lcd_cl_pin != PIN_NOT_SET)
+		lcd.pins.cl = lcd_cl_pin;
+	if (lcd_da_pin != PIN_NOT_SET)
+		lcd.pins.da = lcd_da_pin;
+	if (lcd_bl_pin != PIN_NOT_SET)
+		lcd.pins.bl = lcd_bl_pin;
+
 	/* this is used to catch wrong and default values */
-	if (lcd_width <= 0)
-		lcd_width = DEFAULT_LCD_WIDTH;
-	if (lcd_bwidth <= 0)
-		lcd_bwidth = DEFAULT_LCD_BWIDTH;
-	if (lcd_hwidth <= 0)
-		lcd_hwidth = DEFAULT_LCD_HWIDTH;
-	if (lcd_height <= 0)
-		lcd_height = DEFAULT_LCD_HEIGHT;
-
-	if (lcd_proto == LCD_PROTO_SERIAL) {	/* SERIAL */
+	if (lcd.width <= 0)
+		lcd.width = DEFAULT_LCD_WIDTH;
+	if (lcd.bwidth <= 0)
+		lcd.bwidth = DEFAULT_LCD_BWIDTH;
+	if (lcd.hwidth <= 0)
+		lcd.hwidth = DEFAULT_LCD_HWIDTH;
+	if (lcd.height <= 0)
+		lcd.height = DEFAULT_LCD_HEIGHT;
+
+	if (lcd.proto == LCD_PROTO_SERIAL) {	/* SERIAL */
 		lcd_write_cmd = lcd_write_cmd_s;
 		lcd_write_data = lcd_write_data_s;
 		lcd_clear_fast = lcd_clear_fast_s;
 
-		if (lcd_cl_pin == PIN_NOT_SET)
-			lcd_cl_pin = DEFAULT_LCD_PIN_SCL;
-		if (lcd_da_pin == PIN_NOT_SET)
-			lcd_da_pin = DEFAULT_LCD_PIN_SDA;
+		if (lcd.pins.cl == PIN_NOT_SET)
+			lcd.pins.cl = DEFAULT_LCD_PIN_SCL;
+		if (lcd.pins.da == PIN_NOT_SET)
+			lcd.pins.da = DEFAULT_LCD_PIN_SDA;
 
-	} else if (lcd_proto == LCD_PROTO_PARALLEL) {	/* PARALLEL */
+	} else if (lcd.proto == LCD_PROTO_PARALLEL) {	/* PARALLEL */
 		lcd_write_cmd = lcd_write_cmd_p8;
 		lcd_write_data = lcd_write_data_p8;
 		lcd_clear_fast = lcd_clear_fast_p8;
 
-		if (lcd_e_pin == PIN_NOT_SET)
-			lcd_e_pin = DEFAULT_LCD_PIN_E;
-		if (lcd_rs_pin == PIN_NOT_SET)
-			lcd_rs_pin = DEFAULT_LCD_PIN_RS;
-		if (lcd_rw_pin == PIN_NOT_SET)
-			lcd_rw_pin = DEFAULT_LCD_PIN_RW;
+		if (lcd.pins.e == PIN_NOT_SET)
+			lcd.pins.e = DEFAULT_LCD_PIN_E;
+		if (lcd.pins.rs == PIN_NOT_SET)
+			lcd.pins.rs = DEFAULT_LCD_PIN_RS;
+		if (lcd.pins.rw == PIN_NOT_SET)
+			lcd.pins.rw = DEFAULT_LCD_PIN_RW;
 	} else {
 		lcd_write_cmd = lcd_write_cmd_tilcd;
 		lcd_write_data = lcd_write_data_tilcd;
 		lcd_clear_fast = lcd_clear_fast_tilcd;
 	}
 
-	if (lcd_bl_pin == PIN_NOT_SET)
-		lcd_bl_pin = DEFAULT_LCD_PIN_BL;
-
-	if (lcd_e_pin == PIN_NOT_SET)
-		lcd_e_pin = PIN_NONE;
-	if (lcd_rs_pin == PIN_NOT_SET)
-		lcd_rs_pin = PIN_NONE;
-	if (lcd_rw_pin == PIN_NOT_SET)
-		lcd_rw_pin = PIN_NONE;
-	if (lcd_bl_pin == PIN_NOT_SET)
-		lcd_bl_pin = PIN_NONE;
-	if (lcd_cl_pin == PIN_NOT_SET)
-		lcd_cl_pin = PIN_NONE;
-	if (lcd_da_pin == PIN_NOT_SET)
-		lcd_da_pin = PIN_NONE;
-
-	if (lcd_charset == NOT_SET)
-		lcd_charset = DEFAULT_LCD_CHARSET;
-
-	if (lcd_charset == LCD_CHARSET_KS0074)
+	if (lcd.pins.bl == PIN_NOT_SET)
+		lcd.pins.bl = DEFAULT_LCD_PIN_BL;
+
+	if (lcd.pins.e == PIN_NOT_SET)
+		lcd.pins.e = PIN_NONE;
+	if (lcd.pins.rs == PIN_NOT_SET)
+		lcd.pins.rs = PIN_NONE;
+	if (lcd.pins.rw == PIN_NOT_SET)
+		lcd.pins.rw = PIN_NONE;
+	if (lcd.pins.bl == PIN_NOT_SET)
+		lcd.pins.bl = PIN_NONE;
+	if (lcd.pins.cl == PIN_NOT_SET)
+		lcd.pins.cl = PIN_NONE;
+	if (lcd.pins.da == PIN_NOT_SET)
+		lcd.pins.da = PIN_NONE;
+
+	if (lcd.charset == NOT_SET)
+		lcd.charset = DEFAULT_LCD_CHARSET;
+
+	if (lcd.charset == LCD_CHARSET_KS0074)
 		lcd_char_conv = lcd_char_conv_ks0074;
 	else
 		lcd_char_conv = NULL;
 
-	if (lcd_bl_pin != PIN_NONE)
+	if (lcd.pins.bl != PIN_NONE)
 		init_scan_timer();
 
-	pin_to_bits(lcd_e_pin, lcd_bits[LCD_PORT_D][LCD_BIT_E],
+	pin_to_bits(lcd.pins.e, lcd_bits[LCD_PORT_D][LCD_BIT_E],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_E]);
-	pin_to_bits(lcd_rs_pin, lcd_bits[LCD_PORT_D][LCD_BIT_RS],
+	pin_to_bits(lcd.pins.rs, lcd_bits[LCD_PORT_D][LCD_BIT_RS],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_RS]);
-	pin_to_bits(lcd_rw_pin, lcd_bits[LCD_PORT_D][LCD_BIT_RW],
+	pin_to_bits(lcd.pins.rw, lcd_bits[LCD_PORT_D][LCD_BIT_RW],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_RW]);
-	pin_to_bits(lcd_bl_pin, lcd_bits[LCD_PORT_D][LCD_BIT_BL],
+	pin_to_bits(lcd.pins.bl, lcd_bits[LCD_PORT_D][LCD_BIT_BL],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_BL]);
-	pin_to_bits(lcd_cl_pin, lcd_bits[LCD_PORT_D][LCD_BIT_CL],
+	pin_to_bits(lcd.pins.cl, lcd_bits[LCD_PORT_D][LCD_BIT_CL],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_CL]);
-	pin_to_bits(lcd_da_pin, lcd_bits[LCD_PORT_D][LCD_BIT_DA],
+	pin_to_bits(lcd.pins.da, lcd_bits[LCD_PORT_D][LCD_BIT_DA],
 		    lcd_bits[LCD_PORT_C][LCD_BIT_DA]);
 
 	/* before this line, we must NOT send anything to the display.
@@ -2279,6 +2284,23 @@ static int __init panel_init_module(void)
 	}
 
 	/*
+	 * Init lcd struct with load-time values to preserve exact current
+	 * functionality (at least for now).
+	 */
+	lcd.height = lcd_height;
+	lcd.width = lcd_width;
+	lcd.bwidth = lcd_bwidth;
+	lcd.hwidth = lcd_hwidth;
+	lcd.charset = lcd_charset;
+	lcd.proto = lcd_proto;
+	lcd.pins.e = lcd_e_pin;
+	lcd.pins.rs = lcd_rs_pin;
+	lcd.pins.rw = lcd_rw_pin;
+	lcd.pins.cl = lcd_cl_pin;
+	lcd.pins.da = lcd_da_pin;
+	lcd.pins.bl = lcd_bl_pin;
+
+	/*
 	 * Overwrite selection with module param values (both keypad and lcd),
 	 * where the deprecated params have lower prio.
 	 */
-- 
2.1.3

