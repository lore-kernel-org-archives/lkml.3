Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab3IGHps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 03:45:48 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35705 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3IGHpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 03:45:46 -0400
From: Andrey Moiseev <o2g.org.ru@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Moiseev <o2g.org.ru@gmail.com>
Subject: [PATCH] Input: i8042 - i8042_flush fix for a full 8042 buffer
Date: Sat,  7 Sep 2013 11:45:08 +0400
Message-Id: <1378539908-9431-1-git-send-email-o2g.org.ru@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 8042 internal data buffer is full, the driver
erroneously decides that the controller is not present.

i8042_flush returns the number of flushed bytes, which is
in 0 - I8042_BUFFER_SIZE range inclusive. Therefore, i8042_flush
has no way to indicate an error. Moreover i8042_controller_check
takes initially full buffer (i8042_flush returned
I8042_BUFFER_SIZE) as a sign of absence of the controller.

The fix:
i8042_flush should perform one more status check after
I8042_BUFFER_SIZE bytes have been read, and, if it succeeds,
indicate the error by returning -1. i8042_controller_check
should be changed appropriately.

Signed-off-by: Andrey Moiseev <o2g.org.ru@gmail.com>
---
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 78e4de4..cdda786 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -222,29 +222,32 @@ static int i8042_wait_write(void)
 static int i8042_flush(void)
 {
 	unsigned long flags;
 	unsigned char data, str;
 	int i = 0;
 
 	spin_lock_irqsave(&i8042_lock, flags);
 
-	while (((str = i8042_read_status()) & I8042_STR_OBF) && (i < I8042_BUFFER_SIZE)) {
+	while (((str = i8042_read_status()) & I8042_STR_OBF) && (i <= I8042_BUFFER_SIZE)) {
 		udelay(50);
 		data = i8042_read_data();
 		i++;
 		dbg("%02x <- i8042 (flush, %s)\n",
 		    data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
 	}
 
 	spin_unlock_irqrestore(&i8042_lock, flags);
 
+	if (i == I8042_BUFFER_SIZE + 1)
+		return -1;
+
 	return i;
 }
 
 /*
  * i8042_command() executes a command on the i8042. It also sends the input
  * parameter(s) of the commands to it, and receives the output value(s). The
  * parameters are to be stored in the param array, and the output is placed
  * into the same array. The number of the parameters and output values is
  * encoded in bits 8-11 of the command number.
  */
 
@@ -849,11 +852,11 @@ static int __init i8042_check_aux(void)
 
 static int i8042_controller_check(void)
 {
-	if (i8042_flush() == I8042_BUFFER_SIZE) {
+	if (i8042_flush() == -1) {
 		pr_err("No controller found\n");
 		return -ENODEV;
 	}
 
 	return 0;
 }
 
-- 
1.8.4

