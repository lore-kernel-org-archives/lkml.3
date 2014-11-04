Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaKDVrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:47:39 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58368 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaKDVri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:47:38 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: panel: Fix single-open policy race condition
Date: Tue,  4 Nov 2014 22:47:19 +0100
Message-Id: <1415137639-569-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the implementation of a single-open policy for both
devices (lcd and keypad) by using atomic_t instead of plain ints.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 98556ce..d30ccb5 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -404,8 +404,11 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 #endif /* DEFAULT_PROFILE == 0 */
 
 /* global variables */
-static int keypad_open_cnt;	/* #times opened */
-static int lcd_open_cnt;	/* #times opened */
+
+/* Device single-open policy control */
+static atomic_t lcd_available = ATOMIC_INIT(1);
+static atomic_t keypad_available = ATOMIC_INIT(1);
+
 static struct pardevice *pprt;
 
 static int lcd_initialized;
@@ -1347,7 +1350,7 @@ static ssize_t lcd_write(struct file *file,
 
 static int lcd_open(struct inode *inode, struct file *file)
 {
-	if (lcd_open_cnt)
+	if (!atomic_dec_and_test(&lcd_available))
 		return -EBUSY;	/* open only once at a time */
 
 	if (file->f_mode & FMODE_READ)	/* device is write-only */
@@ -1357,13 +1360,12 @@ static int lcd_open(struct inode *inode, struct file *file)
 		lcd_clear_display();
 		lcd_must_clear = 0;
 	}
-	lcd_open_cnt++;
 	return nonseekable_open(inode, file);
 }
 
 static int lcd_release(struct inode *inode, struct file *file)
 {
-	lcd_open_cnt--;
+	atomic_inc(&lcd_available);
 	return 0;
 }
 
@@ -1627,20 +1629,19 @@ static ssize_t keypad_read(struct file *file,
 
 static int keypad_open(struct inode *inode, struct file *file)
 {
-	if (keypad_open_cnt)
+	if (!atomic_dec_and_test(&keypad_available))
 		return -EBUSY;	/* open only once at a time */
 
 	if (file->f_mode & FMODE_WRITE)	/* device is read-only */
 		return -EPERM;
 
 	keypad_buflen = 0;	/* flush the buffer on opening */
-	keypad_open_cnt++;
 	return 0;
 }
 
 static int keypad_release(struct inode *inode, struct file *file)
 {
-	keypad_open_cnt--;
+	atomic_inc(&keypad_available);
 	return 0;
 }
 
@@ -1663,7 +1664,7 @@ static void keypad_send_key(const char *string, int max_len)
 		return;
 
 	/* send the key to the device only if a process is attached to it. */
-	if (keypad_open_cnt > 0) {
+	if (!atomic_read(&keypad_available)) {
 		while (max_len-- && keypad_buflen < KEYPAD_BUFFER && *string) {
 			keypad_buffer[(keypad_start + keypad_buflen++) %
 				      KEYPAD_BUFFER] = *string++;
-- 
2.1.3

