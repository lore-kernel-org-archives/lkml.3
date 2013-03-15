Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3COSVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:21:08 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:37492 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3COSVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:21:06 -0400
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: zbr@ioremap.net, olivier@okprods.com,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: [PATCH 1/2] w1: ds2408: make value read-back check a Kconfig option
Date: Fri, 15 Mar 2013 14:20:25 -0400
Message-Id: <1363371626-3624-1-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <20130315001550.GA3144@ioremap.net>
References: <20130315001550.GA3144@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

De-activating this reading back will effectively half the time required
for a write to the output register.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
---
 drivers/w1/slaves/Kconfig     | 10 ++++++++++
 drivers/w1/slaves/w1_ds2408.c | 18 ++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index 762561f..5e6a3c9 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -22,6 +22,16 @@ config W1_SLAVE_DS2408
 	  Say Y here if you want to use a 1-wire
 	  DS2408 8-Channel Addressable Switch device support
 
+config W1_SLAVE_DS2408_READBACK
+	bool "Read-back values written to DS2408's output register"
+	depends on W1_SLAVE_DS2408
+	default y
+	help
+	  Enabling this will cause the driver to read back the values written
+	  to the chip's output register in order to detect errors.
+
+	  This is slower but useful when debugging chips and/or busses.
+
 config W1_SLAVE_DS2413
 	tristate "Dual Channel Addressable Switch 0x3a family support (DS2413)"
 	help
diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index 441ad3a..25a5168 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -178,6 +178,15 @@ static ssize_t w1_f29_write_output(
 		w1_write_block(sl->master, w1_buf, 3);
 
 		readBack = w1_read_8(sl->master);
+
+		if (readBack != W1_F29_SUCCESS_CONFIRM_BYTE) {
+			if (w1_reset_resume_command(sl->master))
+				goto error;
+			/* try again, the slave is ready for a command */
+			continue;
+		}
+
+#ifdef CONFIG_W1_SLAVE_DS2408_READBACK
 		/* here the master could read another byte which
 		   would be the PIO reg (the actual pin logic state)
 		   since in this driver we don't know which pins are
@@ -186,11 +195,6 @@ static ssize_t w1_f29_write_output(
 		if (w1_reset_resume_command(sl->master))
 			goto error;
 
-		if (readBack != 0xAA) {
-			/* try again, the slave is ready for a command */
-			continue;
-		}
-
 		/* go read back the output latches */
 		/* (the direct effect of the write above) */
 		w1_buf[0] = W1_F29_FUNC_READ_PIO_REGS;
@@ -198,7 +202,9 @@ static ssize_t w1_f29_write_output(
 		w1_buf[2] = 0;
 		w1_write_block(sl->master, w1_buf, 3);
 		/* read the result of the READ_PIO_REGS command */
-		if (w1_read_8(sl->master) == *buf) {
+		if (w1_read_8(sl->master) == *buf)
+#endif
+		{
 			/* success! */
 			mutex_unlock(&sl->master->bus_mutex);
 			dev_dbg(&sl->dev,
-- 
1.8.1.1

