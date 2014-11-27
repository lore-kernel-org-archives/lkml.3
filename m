Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaK0Vhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:37:39 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34097 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaK0Vhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:36 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 9/9] staging: panel: Move LCD-related state into struct lcd
Date: Thu, 27 Nov 2014 22:36:53 +0100
Message-Id: <1417124213-23409-10-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
References: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move more or less all LCD-related state into struct lcd
in order to get better cohesion; use bool instead of int
where it makes sense.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/panel/panel.c | 255 ++++++++++++++++++++++--------------------
 1 file changed, 134 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 19f6767..98325b7 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -225,12 +225,20 @@ static wait_queue_head_t keypad_read_wait;
 /* lcd-specific variables */
 static struct {
 	bool enabled;
+	bool initialized;
+	bool must_clear;
+
+	/* TODO: use bool here? */
+	char left_shift;
+
 	int height;
 	int width;
 	int bwidth;
 	int hwidth;
 	int charset;
 	int proto;
+	int light_tempo;
+
 	/* TODO: use union here? */
 	struct {
 		int e;
@@ -240,22 +248,26 @@ static struct {
 		int da;
 		int bl;
 	} pins;
+
+	/* contains the LCD config state */
+	unsigned long int flags;
+
+	/* Contains the LCD X and Y offset */
+	struct {
+		unsigned long int x;
+		unsigned long int y;
+	} addr;
+
+	/* Current escape sequence and it's length or -1 if outside */
+	struct {
+		char buf[LCD_ESCAPE_LEN + 1];
+		int len;
+	} esc_seq;
 } lcd;
 
 /* Needed only for init */
 static int selected_lcd_type = NOT_SET;
 
-/* contains the LCD config state */
-static unsigned long int lcd_flags;
-/* contains the LCD X offset */
-static unsigned long int lcd_addr_x;
-/* contains the LCD Y offset */
-static unsigned long int lcd_addr_y;
-/* current escape sequence, 0 terminated */
-static char lcd_escape[LCD_ESCAPE_LEN + 1];
-/* not in escape state. >=0 = escape cmd len */
-static int lcd_escape_len = -1;
-
 /*
  * Bit masks to convert LCD signals to parallel port outputs.
  * _d_ are values for data port, _c_ are for control port.
@@ -438,13 +450,8 @@ static atomic_t keypad_available = ATOMIC_INIT(1);
 
 static struct pardevice *pprt;
 
-static int lcd_initialized;
 static int keypad_initialized;
 
-static int light_tempo;
-
-static char lcd_must_clear;
-static char lcd_left_shift;
 static char init_in_progress;
 
 static void (*lcd_write_cmd)(int);
@@ -880,23 +887,23 @@ static void lcd_write_data_tilcd(int data)
 static void lcd_gotoxy(void)
 {
 	lcd_write_cmd(0x80	/* set DDRAM address */
-		      | (lcd_addr_y ? lcd.hwidth : 0)
+		      | (lcd.addr.y ? lcd.hwidth : 0)
 		      /* we force the cursor to stay at the end of the
 			 line if it wants to go farther */
-		      | ((lcd_addr_x < lcd.bwidth) ? lcd_addr_x &
+		      | ((lcd.addr.x < lcd.bwidth) ? lcd.addr.x &
 			 (lcd.hwidth - 1) : lcd.bwidth - 1));
 }
 
 static void lcd_print(char c)
 {
-	if (lcd_addr_x < lcd.bwidth) {
+	if (lcd.addr.x < lcd.bwidth) {
 		if (lcd_char_conv != NULL)
 			c = lcd_char_conv[(unsigned char)c];
 		lcd_write_data(c);
-		lcd_addr_x++;
+		lcd.addr.x++;
 	}
 	/* prevents the cursor from wrapping onto the next line */
-	if (lcd_addr_x == lcd.bwidth)
+	if (lcd.addr.x == lcd.bwidth)
 		lcd_gotoxy();
 }
 
@@ -905,8 +912,8 @@ static void lcd_clear_fast_s(void)
 {
 	int pos;
 
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
@@ -918,8 +925,8 @@ static void lcd_clear_fast_s(void)
 	}
 	spin_unlock_irq(&pprt_lock);
 
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	lcd_gotoxy();
 }
 
@@ -928,8 +935,8 @@ static void lcd_clear_fast_p8(void)
 {
 	int pos;
 
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
@@ -956,8 +963,8 @@ static void lcd_clear_fast_p8(void)
 	}
 	spin_unlock_irq(&pprt_lock);
 
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	lcd_gotoxy();
 }
 
@@ -966,8 +973,8 @@ static void lcd_clear_fast_tilcd(void)
 {
 	int pos;
 
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
@@ -979,8 +986,8 @@ static void lcd_clear_fast_tilcd(void)
 
 	spin_unlock_irq(&pprt_lock);
 
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	lcd_gotoxy();
 }
 
@@ -988,15 +995,15 @@ static void lcd_clear_fast_tilcd(void)
 static void lcd_clear_display(void)
 {
 	lcd_write_cmd(0x01);	/* clear display */
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	/* we must wait a few milliseconds (15) */
 	long_sleep(15);
 }
 
 static void lcd_init_display(void)
 {
-	lcd_flags = ((lcd.height > 1) ? LCD_FLAG_N : 0)
+	lcd.flags = ((lcd.height > 1) ? LCD_FLAG_N : 0)
 	    | LCD_FLAG_D | LCD_FLAG_C | LCD_FLAG_B;
 
 	long_sleep(20);		/* wait 20 ms after power-up for the paranoid */
@@ -1009,8 +1016,8 @@ static void lcd_init_display(void)
 	long_sleep(10);
 
 	lcd_write_cmd(0x30	/* set font height and lines number */
-		      | ((lcd_flags & LCD_FLAG_F) ? 4 : 0)
-		      | ((lcd_flags & LCD_FLAG_N) ? 8 : 0)
+		      | ((lcd.flags & LCD_FLAG_F) ? 4 : 0)
+		      | ((lcd.flags & LCD_FLAG_N) ? 8 : 0)
 	    );
 	long_sleep(10);
 
@@ -1018,12 +1025,12 @@ static void lcd_init_display(void)
 	long_sleep(10);
 
 	lcd_write_cmd(0x08	/* set display mode */
-		      | ((lcd_flags & LCD_FLAG_D) ? 4 : 0)
-		      | ((lcd_flags & LCD_FLAG_C) ? 2 : 0)
-		      | ((lcd_flags & LCD_FLAG_B) ? 1 : 0)
+		      | ((lcd.flags & LCD_FLAG_D) ? 4 : 0)
+		      | ((lcd.flags & LCD_FLAG_C) ? 2 : 0)
+		      | ((lcd.flags & LCD_FLAG_B) ? 1 : 0)
 	    );
 
-	lcd_backlight((lcd_flags & LCD_FLAG_L) ? 1 : 0);
+	lcd_backlight((lcd.flags & LCD_FLAG_L) ? 1 : 0);
 
 	long_sleep(10);
 
@@ -1046,100 +1053,101 @@ static inline int handle_lcd_special_code(void)
 
 	int processed = 0;
 
-	char *esc = lcd_escape + 2;
-	int oldflags = lcd_flags;
+	char *esc = lcd.esc_seq.buf + 2;
+	int oldflags = lcd.flags;
 
 	/* check for display mode flags */
 	switch (*esc) {
 	case 'D':	/* Display ON */
-		lcd_flags |= LCD_FLAG_D;
+		lcd.flags |= LCD_FLAG_D;
 		processed = 1;
 		break;
 	case 'd':	/* Display OFF */
-		lcd_flags &= ~LCD_FLAG_D;
+		lcd.flags &= ~LCD_FLAG_D;
 		processed = 1;
 		break;
 	case 'C':	/* Cursor ON */
-		lcd_flags |= LCD_FLAG_C;
+		lcd.flags |= LCD_FLAG_C;
 		processed = 1;
 		break;
 	case 'c':	/* Cursor OFF */
-		lcd_flags &= ~LCD_FLAG_C;
+		lcd.flags &= ~LCD_FLAG_C;
 		processed = 1;
 		break;
 	case 'B':	/* Blink ON */
-		lcd_flags |= LCD_FLAG_B;
+		lcd.flags |= LCD_FLAG_B;
 		processed = 1;
 		break;
 	case 'b':	/* Blink OFF */
-		lcd_flags &= ~LCD_FLAG_B;
+		lcd.flags &= ~LCD_FLAG_B;
 		processed = 1;
 		break;
 	case '+':	/* Back light ON */
-		lcd_flags |= LCD_FLAG_L;
+		lcd.flags |= LCD_FLAG_L;
 		processed = 1;
 		break;
 	case '-':	/* Back light OFF */
-		lcd_flags &= ~LCD_FLAG_L;
+		lcd.flags &= ~LCD_FLAG_L;
 		processed = 1;
 		break;
 	case '*':
 		/* flash back light using the keypad timer */
 		if (scan_timer.function != NULL) {
-			if (light_tempo == 0 && ((lcd_flags & LCD_FLAG_L) == 0))
+			if (lcd.light_tempo == 0
+					&& ((lcd.flags & LCD_FLAG_L) == 0))
 				lcd_backlight(1);
-			light_tempo = FLASH_LIGHT_TEMPO;
+			lcd.light_tempo = FLASH_LIGHT_TEMPO;
 		}
 		processed = 1;
 		break;
 	case 'f':	/* Small Font */
-		lcd_flags &= ~LCD_FLAG_F;
+		lcd.flags &= ~LCD_FLAG_F;
 		processed = 1;
 		break;
 	case 'F':	/* Large Font */
-		lcd_flags |= LCD_FLAG_F;
+		lcd.flags |= LCD_FLAG_F;
 		processed = 1;
 		break;
 	case 'n':	/* One Line */
-		lcd_flags &= ~LCD_FLAG_N;
+		lcd.flags &= ~LCD_FLAG_N;
 		processed = 1;
 		break;
 	case 'N':	/* Two Lines */
-		lcd_flags |= LCD_FLAG_N;
+		lcd.flags |= LCD_FLAG_N;
 		break;
 	case 'l':	/* Shift Cursor Left */
-		if (lcd_addr_x > 0) {
+		if (lcd.addr.x > 0) {
 			/* back one char if not at end of line */
-			if (lcd_addr_x < lcd.bwidth)
+			if (lcd.addr.x < lcd.bwidth)
 				lcd_write_cmd(0x10);
-			lcd_addr_x--;
+			lcd.addr.x--;
 		}
 		processed = 1;
 		break;
 	case 'r':	/* shift cursor right */
-		if (lcd_addr_x < lcd.width) {
+		if (lcd.addr.x < lcd.width) {
 			/* allow the cursor to pass the end of the line */
-			if (lcd_addr_x <
+			if (lcd.addr.x <
 			    (lcd.bwidth - 1))
 				lcd_write_cmd(0x14);
-			lcd_addr_x++;
+			lcd.addr.x++;
 		}
 		processed = 1;
 		break;
 	case 'L':	/* shift display left */
-		lcd_left_shift++;
+		lcd.left_shift++;
 		lcd_write_cmd(0x18);
 		processed = 1;
 		break;
 	case 'R':	/* shift display right */
-		lcd_left_shift--;
+		lcd.left_shift--;
 		lcd_write_cmd(0x1C);
 		processed = 1;
 		break;
 	case 'k': {	/* kill end of line */
 		int x;
 
-		for (x = lcd_addr_x; x < lcd.bwidth; x++)
+		for (x = lcd.addr.x; x < lcd.bwidth; x++)
 			lcd_write_data(' ');
 
 		/* restore cursor position */
@@ -1149,7 +1157,7 @@ static inline int handle_lcd_special_code(void)
 	}
 	case 'I':	/* reinitialize display */
 		lcd_init_display();
-		lcd_left_shift = 0;
+		lcd.left_shift = 0;
 		processed = 1;
 		break;
 	case 'G': {
@@ -1220,11 +1228,11 @@ static inline int handle_lcd_special_code(void)
 		while (*esc) {
 			if (*esc == 'x') {
 				esc++;
-				if (kstrtoul(esc, 10, &lcd_addr_x) < 0)
+				if (kstrtoul(esc, 10, &lcd.addr.x) < 0)
 					break;
 			} else if (*esc == 'y') {
 				esc++;
-				if (kstrtoul(esc, 10, &lcd_addr_y) < 0)
+				if (kstrtoul(esc, 10, &lcd.addr.y) < 0)
 					break;
 			} else {
 				break;
@@ -1237,25 +1245,25 @@ static inline int handle_lcd_special_code(void)
 	}
 
 	/* Check whether one flag was changed */
-	if (oldflags != lcd_flags) {
+	if (oldflags != lcd.flags) {
 		/* check whether one of B,C,D flags were changed */
-		if ((oldflags ^ lcd_flags) &
+		if ((oldflags ^ lcd.flags) &
 		    (LCD_FLAG_B | LCD_FLAG_C | LCD_FLAG_D))
 			/* set display mode */
 			lcd_write_cmd(0x08
-				      | ((lcd_flags & LCD_FLAG_D) ? 4 : 0)
-				      | ((lcd_flags & LCD_FLAG_C) ? 2 : 0)
-				      | ((lcd_flags & LCD_FLAG_B) ? 1 : 0));
+				      | ((lcd.flags & LCD_FLAG_D) ? 4 : 0)
+				      | ((lcd.flags & LCD_FLAG_C) ? 2 : 0)
+				      | ((lcd.flags & LCD_FLAG_B) ? 1 : 0));
 		/* check whether one of F,N flags was changed */
-		else if ((oldflags ^ lcd_flags) & (LCD_FLAG_F | LCD_FLAG_N))
+		else if ((oldflags ^ lcd.flags) & (LCD_FLAG_F | LCD_FLAG_N))
 			lcd_write_cmd(0x30
-				      | ((lcd_flags & LCD_FLAG_F) ? 4 : 0)
-				      | ((lcd_flags & LCD_FLAG_N) ? 8 : 0));
+				      | ((lcd.flags & LCD_FLAG_F) ? 4 : 0)
+				      | ((lcd.flags & LCD_FLAG_N) ? 8 : 0));
 		/* check whether L flag was changed */
-		else if ((oldflags ^ lcd_flags) & (LCD_FLAG_L)) {
-			if (lcd_flags & (LCD_FLAG_L))
+		else if ((oldflags ^ lcd.flags) & (LCD_FLAG_L)) {
+			if (lcd.flags & (LCD_FLAG_L))
 				lcd_backlight(1);
-			else if (light_tempo == 0)
+			else if (lcd.light_tempo == 0)
 				/* switch off the light only when the tempo
 				   lighting is gone */
 				lcd_backlight(0);
@@ -1268,29 +1276,29 @@ static inline int handle_lcd_special_code(void)
 static void lcd_write_char(char c)
 {
 	/* first, we'll test if we're in escape mode */
-	if ((c != '\n') && lcd_escape_len >= 0) {
+	if ((c != '\n') && lcd.esc_seq.len >= 0) {
 		/* yes, let's add this char to the buffer */
-		lcd_escape[lcd_escape_len++] = c;
-		lcd_escape[lcd_escape_len] = 0;
+		lcd.esc_seq.buf[lcd.esc_seq.len++] = c;
+		lcd.esc_seq.buf[lcd.esc_seq.len] = 0;
 	} else {
 		/* aborts any previous escape sequence */
-		lcd_escape_len = -1;
+		lcd.esc_seq.len = -1;
 
 		switch (c) {
 		case LCD_ESCAPE_CHAR:
 			/* start of an escape sequence */
-			lcd_escape_len = 0;
-			lcd_escape[lcd_escape_len] = 0;
+			lcd.esc_seq.len = 0;
+			lcd.esc_seq.buf[lcd.esc_seq.len] = 0;
 			break;
 		case '\b':
 			/* go back one char and clear it */
-			if (lcd_addr_x > 0) {
+			if (lcd.addr.x > 0) {
 				/* check if we're not at the
 				   end of the line */
-				if (lcd_addr_x < lcd.bwidth)
+				if (lcd.addr.x < lcd.bwidth)
 					/* back one char */
 					lcd_write_cmd(0x10);
-				lcd_addr_x--;
+				lcd.addr.x--;
 			}
 			/* replace with a space */
 			lcd_write_data(' ');
@@ -1304,15 +1312,15 @@ static void lcd_write_char(char c)
 		case '\n':
 			/* flush the remainder of the current line and
 			   go to the beginning of the next line */
-			for (; lcd_addr_x < lcd.bwidth; lcd_addr_x++)
+			for (; lcd.addr.x < lcd.bwidth; lcd.addr.x++)
 				lcd_write_data(' ');
-			lcd_addr_x = 0;
-			lcd_addr_y = (lcd_addr_y + 1) % lcd.height;
+			lcd.addr.x = 0;
+			lcd.addr.y = (lcd.addr.y + 1) % lcd.height;
 			lcd_gotoxy();
 			break;
 		case '\r':
 			/* go to the beginning of the same line */
-			lcd_addr_x = 0;
+			lcd.addr.x = 0;
 			lcd_gotoxy();
 			break;
 		case '\t':
@@ -1328,32 +1336,32 @@ static void lcd_write_char(char c)
 
 	/* now we'll see if we're in an escape mode and if the current
 	   escape sequence can be understood. */
-	if (lcd_escape_len >= 2) {
+	if (lcd.esc_seq.len >= 2) {
 		int processed = 0;
 
-		if (!strcmp(lcd_escape, "[2J")) {
+		if (!strcmp(lcd.esc_seq.buf, "[2J")) {
 			/* clear the display */
 			lcd_clear_fast();
 			processed = 1;
-		} else if (!strcmp(lcd_escape, "[H")) {
+		} else if (!strcmp(lcd.esc_seq.buf, "[H")) {
 			/* cursor to home */
-			lcd_addr_x = 0;
-			lcd_addr_y = 0;
+			lcd.addr.x = 0;
+			lcd.addr.y = 0;
 			lcd_gotoxy();
 			processed = 1;
 		}
 		/* codes starting with ^[[L */
-		else if ((lcd_escape_len >= 3) &&
-			 (lcd_escape[0] == '[') &&
-			 (lcd_escape[1] == 'L')) {
+		else if ((lcd.esc_seq.len >= 3) &&
+			 (lcd.esc_seq.buf[0] == '[') &&
+			 (lcd.esc_seq.buf[1] == 'L')) {
 			processed = handle_lcd_special_code();
 		}
 
 		/* LCD special escape codes */
 		/* flush the escape sequence if it's been processed
 		   or if it is getting too long. */
-		if (processed || (lcd_escape_len >= LCD_ESCAPE_LEN))
-			lcd_escape_len = -1;
+		if (processed || (lcd.esc_seq.len >= LCD_ESCAPE_LEN))
+			lcd.esc_seq.len = -1;
 	} /* escape codes */
 }
 
@@ -1386,9 +1394,9 @@ static int lcd_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_READ)	/* device is write-only */
 		return -EPERM;
 
-	if (lcd_must_clear) {
+	if (lcd.must_clear) {
 		lcd_clear_display();
-		lcd_must_clear = 0;
+		lcd.must_clear = false;
 	}
 	return nonseekable_open(inode, file);
 }
@@ -1418,7 +1426,7 @@ static void panel_lcd_print(const char *s)
 	const char *tmp = s;
 	int count = strlen(s);
 
-	if (lcd.enabled && lcd_initialized) {
+	if (lcd.enabled && lcd.initialized) {
 		for (; count-- > 0; tmp++) {
 			if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
 				/* let's be a little nice with other processes
@@ -1599,7 +1607,7 @@ static void lcd_init(void)
 	/* before this line, we must NOT send anything to the display.
 	 * Since lcd_init_display() needs to write data, we have to
 	 * enable mark the LCD initialized just before. */
-	lcd_initialized = 1;
+	lcd.initialized = true;
 	lcd_init_display();
 
 	/* display a short message */
@@ -1611,10 +1619,10 @@ static void lcd_init(void)
 	panel_lcd_print("\x1b[Lc\x1b[Lb\x1b[L*Linux-" UTS_RELEASE "\nPanel-"
 			PANEL_VERSION);
 #endif
-	lcd_addr_x = 0;
-	lcd_addr_y = 0;
+	lcd.addr.x = 0;
+	lcd.addr.y = 0;
 	/* clear the display on the next device opening */
-	lcd_must_clear = 1;
+	lcd.must_clear = true;
 	lcd_gotoxy();
 }
 
@@ -1950,14 +1958,16 @@ static void panel_scan_timer(void)
 			panel_process_inputs();
 	}
 
-	if (lcd.enabled && lcd_initialized) {
+	if (lcd.enabled && lcd.initialized) {
 		if (keypressed) {
-			if (light_tempo == 0 && ((lcd_flags & LCD_FLAG_L) == 0))
+			if (lcd.light_tempo == 0
+					&& ((lcd.flags & LCD_FLAG_L) == 0))
 				lcd_backlight(1);
-			light_tempo = FLASH_LIGHT_TEMPO;
-		} else if (light_tempo > 0) {
-			light_tempo--;
-			if (light_tempo == 0 && ((lcd_flags & LCD_FLAG_L) == 0))
+			lcd.light_tempo = FLASH_LIGHT_TEMPO;
+		} else if (lcd.light_tempo > 0) {
+			lcd.light_tempo--;
+			if (lcd.light_tempo == 0
+					&& ((lcd.flags & LCD_FLAG_L) == 0))
 				lcd_backlight(0);
 		}
 	}
@@ -2129,7 +2139,7 @@ static void keypad_init(void)
 static int panel_notify_sys(struct notifier_block *this, unsigned long code,
 			    void *unused)
 {
-	if (lcd.enabled && lcd_initialized) {
+	if (lcd.enabled && lcd.initialized) {
 		switch (code) {
 		case SYS_DOWN:
 			panel_lcd_print
@@ -2222,9 +2232,9 @@ static void panel_detach(struct parport *port)
 		keypad_initialized = 0;
 	}
 
-	if (lcd.enabled && lcd_initialized) {
+	if (lcd.enabled && lcd.initialized) {
 		misc_deregister(&lcd_dev);
-		lcd_initialized = 0;
+		lcd.initialized = false;
 	}
 
 	parport_release(pprt);
@@ -2300,6 +2310,9 @@ static int __init panel_init_module(void)
 	lcd.pins.da = lcd_da_pin;
 	lcd.pins.bl = lcd_bl_pin;
 
+	/* Leave it for now, just in case */
+	lcd.esc_seq.len = -1;
+
 	/*
 	 * Overwrite selection with module param values (both keypad and lcd),
 	 * where the deprecated params have lower prio.
@@ -2385,7 +2398,7 @@ static void __exit panel_cleanup_module(void)
 			panel_lcd_print("\x0cLCD driver " PANEL_VERSION
 					"\nunloaded.\x1b[Lc\x1b[Lb\x1b[L-");
 			misc_deregister(&lcd_dev);
-			lcd_initialized = 0;
+			lcd.initialized = false;
 		}
 
 		/* TODO: free all input signals */
-- 
2.1.3

