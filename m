Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbaDRGBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:01:33 -0400
Received: from smtpout2.laposte.net ([193.253.67.227]:29800 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRGBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:01:30 -0400
Date: Fri, 18 Apr 2014 08:01:22 +0200
From: Bastien Armand <armand.bastien@laposte.net>
To: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: panel: fix sparse warnings
Message-ID: <20140418060122.GA477@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sparse warnings in panel.c.


Signed-off-by: Bastien Armand <armand.bastien@laposte.net>
---
 drivers/staging/panel/panel.c |  209 ++++++++++++++++++++++-------------------
 1 file changed, 111 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 08f9a48..dc34254 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1217,111 +1217,113 @@ static inline int handle_lcd_special_code(void)
 	return processed;
 }

+static void lcd_write_char(char c)
+{
+	/* first, we'll test if we're in escape mode */
+	if ((c != '\n') && lcd_escape_len >= 0) {
+		/* yes, let's add this char to the buffer */
+		lcd_escape[lcd_escape_len++] = c;
+		lcd_escape[lcd_escape_len] = 0;
+	} else {
+		/* aborts any previous escape sequence */
+		lcd_escape_len = -1;
+
+		switch (c) {
+		case LCD_ESCAPE_CHAR:
+			/* start of an escape sequence */
+			lcd_escape_len = 0;
+			lcd_escape[lcd_escape_len] = 0;
+			break;
+		case '\b':
+			/* go back one char and clear it */
+			if (lcd_addr_x > 0) {
+				/* check if we're not at the
+				   end of the line */
+				if (lcd_addr_x < lcd_bwidth)
+					/* back one char */
+					lcd_write_cmd(0x10);
+				lcd_addr_x--;
+			}
+			/* replace with a space */
+			lcd_write_data(' ');
+			/* back one char again */
+			lcd_write_cmd(0x10);
+			break;
+		case '\014':
+			/* quickly clear the display */
+			lcd_clear_fast();
+			break;
+		case '\n':
+			/* flush the remainder of the current line and
+			   go to the beginning of the next line */
+			for (; lcd_addr_x < lcd_bwidth; lcd_addr_x++)
+				lcd_write_data(' ');
+			lcd_addr_x = 0;
+			lcd_addr_y = (lcd_addr_y + 1) % lcd_height;
+			lcd_gotoxy();
+			break;
+		case '\r':
+			/* go to the beginning of the same line */
+			lcd_addr_x = 0;
+			lcd_gotoxy();
+			break;
+		case '\t':
+			/* print a space instead of the tab */
+			lcd_print(' ');
+			break;
+		default:
+			/* simply print this char */
+			lcd_print(c);
+			break;
+		}
+	}
+
+	/* now we'll see if we're in an escape mode and if the current
+	   escape sequence can be understood. */
+	if (lcd_escape_len >= 2) {
+		int processed = 0;
+
+		if (!strcmp(lcd_escape, "[2J")) {
+			/* clear the display */
+			lcd_clear_fast();
+			processed = 1;
+		} else if (!strcmp(lcd_escape, "[H")) {
+			/* cursor to home */
+			lcd_addr_x = lcd_addr_y = 0;
+			lcd_gotoxy();
+			processed = 1;
+		}
+		/* codes starting with ^[[L */
+		else if ((lcd_escape_len >= 3) &&
+			 (lcd_escape[0] == '[') &&
+			 (lcd_escape[1] == 'L')) {
+			processed = handle_lcd_special_code();
+		}
+
+		/* LCD special escape codes */
+		/* flush the escape sequence if it's been processed
+		   or if it is getting too long. */
+		if (processed || (lcd_escape_len >= LCD_ESCAPE_LEN))
+			lcd_escape_len = -1;
+	} /* escape codes */
+}
+
 static ssize_t lcd_write(struct file *file,
-			 const char *buf, size_t count, loff_t *ppos)
+	const char __user *buf, size_t count, loff_t *ppos)
 {
-	const char *tmp = buf;
+	const char __user *tmp = buf;
 	char c;

-	for (; count-- > 0; (ppos ? (*ppos)++ : 0), ++tmp) {
+	for (; count-- > 0; (*ppos)++, tmp++) {
 		if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
 			/* let's be a little nice with other processes
 			   that need some CPU */
 			schedule();

-		if (ppos == NULL && file == NULL)
-			/* let's not use get_user() from the kernel ! */
-			c = *tmp;
-		else if (get_user(c, tmp))
+		if (get_user(c, buf))
 			return -EFAULT;

-		/* first, we'll test if we're in escape mode */
-		if ((c != '\n') && lcd_escape_len >= 0) {
-			/* yes, let's add this char to the buffer */
-			lcd_escape[lcd_escape_len++] = c;
-			lcd_escape[lcd_escape_len] = 0;
-		} else {
-			/* aborts any previous escape sequence */
-			lcd_escape_len = -1;
-
-			switch (c) {
-			case LCD_ESCAPE_CHAR:
-				/* start of an escape sequence */
-				lcd_escape_len = 0;
-				lcd_escape[lcd_escape_len] = 0;
-				break;
-			case '\b':
-				/* go back one char and clear it */
-				if (lcd_addr_x > 0) {
-					/* check if we're not at the
-					   end of the line */
-					if (lcd_addr_x < lcd_bwidth)
-						/* back one char */
-						lcd_write_cmd(0x10);
-					lcd_addr_x--;
-				}
-				/* replace with a space */
-				lcd_write_data(' ');
-				/* back one char again */
-				lcd_write_cmd(0x10);
-				break;
-			case '\014':
-				/* quickly clear the display */
-				lcd_clear_fast();
-				break;
-			case '\n':
-				/* flush the remainder of the current line and
-				   go to the beginning of the next line */
-				for (; lcd_addr_x < lcd_bwidth; lcd_addr_x++)
-					lcd_write_data(' ');
-				lcd_addr_x = 0;
-				lcd_addr_y = (lcd_addr_y + 1) % lcd_height;
-				lcd_gotoxy();
-				break;
-			case '\r':
-				/* go to the beginning of the same line */
-				lcd_addr_x = 0;
-				lcd_gotoxy();
-				break;
-			case '\t':
-				/* print a space instead of the tab */
-				lcd_print(' ');
-				break;
-			default:
-				/* simply print this char */
-				lcd_print(c);
-				break;
-			}
-		}
-
-		/* now we'll see if we're in an escape mode and if the current
-		   escape sequence can be understood. */
-		if (lcd_escape_len >= 2) {
-			int processed = 0;
-
-			if (!strcmp(lcd_escape, "[2J")) {
-				/* clear the display */
-				lcd_clear_fast();
-				processed = 1;
-			} else if (!strcmp(lcd_escape, "[H")) {
-				/* cursor to home */
-				lcd_addr_x = lcd_addr_y = 0;
-				lcd_gotoxy();
-				processed = 1;
-			}
-			/* codes starting with ^[[L */
-			else if ((lcd_escape_len >= 3) &&
-				 (lcd_escape[0] == '[') &&
-				 (lcd_escape[1] == 'L')) {
-				processed = handle_lcd_special_code();
-			}
-
-			/* LCD special escape codes */
-			/* flush the escape sequence if it's been processed
-			   or if it is getting too long. */
-			if (processed || (lcd_escape_len >= LCD_ESCAPE_LEN))
-				lcd_escape_len = -1;
-		} /* escape codes */
+		lcd_write_char(c);
 	}

 	return tmp - buf;
@@ -1365,8 +1367,19 @@ static struct miscdevice lcd_dev = {
 /* public function usable from the kernel for any purpose */
 static void panel_lcd_print(const char *s)
 {
-	if (lcd_enabled && lcd_initialized)
-		lcd_write(NULL, s, strlen(s), NULL);
+	const char *tmp = s;
+	int count = strlen(s);
+
+	if (lcd_enabled && lcd_initialized) {
+		for (; count-- > 0; tmp++) {
+			if (!in_interrupt() && (((count + 1) & 0x1f) == 0))
+				/* let's be a little nice with other processes
+				   that need some CPU */
+				schedule();
+
+			lcd_write_char(*tmp);
+		}
+	}
 }

 /* initialize the LCD driver */
@@ -1571,11 +1584,11 @@ static void lcd_init(void)
  */

 static ssize_t keypad_read(struct file *file,
-			   char *buf, size_t count, loff_t *ppos)
+			   char __user *buf, size_t count, loff_t *ppos)
 {

 	unsigned i = *ppos;
-	char *tmp = buf;
+	char __user *tmp = buf;

 	if (keypad_buflen == 0) {
 		if (file->f_flags & O_NONBLOCK)
