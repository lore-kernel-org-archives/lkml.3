Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3EGMky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:40:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49073 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab3EGMkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:40:51 -0400
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
To: zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: [PATCH] w1: ds2408: add magic sequence to disable P0 test mode
Date: Tue,  7 May 2013 08:40:22 -0400
Message-Id: <1367930422-25972-2-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367930422-25972-1-git-send-email-jeff.dagenais@gmail.com>
References: <1367930422-25972-1-git-send-email-jeff.dagenais@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extract from http://datasheets.maximintegrated.com/en/ds/DS2408.pdf:

Power-up timing
The DS2408 is sensitive to the power-on slew rate and can inadvertently
power up with a test mode feature enabled. When this occurs, the P0 port
does not respond to the Channel Access Write command.
For most reliable operation, it is recommended to disable the test mode
after every power-on reset using the Disable Test Mode sequence shown
below. The 64-bit ROM code must be transmitted in the same bit sequence
as with the Match ROM command, i.e., least significant bit first. This
precaution is recommended in parasite power mode (VCC pin connected to
GND) as well as with VCC power.

Disable Test Mode:
RST,PD,96h,<64-bit DS2408 ROM Code>,3Ch,RST,PD

Signed-off-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
---
 drivers/w1/slaves/w1_ds2408.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index e45eca1..49664b1 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -301,7 +301,35 @@ error:
 	return -EIO;
 }
 
-
+/**
+ * This is a special sequence we must do to ensure the P0 output is not stuck
+ * in test mode. This is described in rev 2 of the ds2408's datasheet
+ * (http://datasheets.maximintegrated.com/en/ds/DS2408.pdf) under
+ * "APPLICATION INFORMATION/Power-up timing".
+ */
+static int w1_f29_disable_test_mode(struct w1_slave *sl)
+{
+	int res;
+	u8 magic[10] = {0x96, };
+	u64 rn = le64_to_cpu(*((u64*)&sl->reg_num));
+	bool lock_needed = sl->master->mutex.owner != current;
+	memcpy(&magic[1], &rn, 8);
+	magic[9] = 0x3C;
+
+	if (lock_needed)
+		mutex_lock(&sl->master->mutex);
+
+	res = w1_reset_bus(sl->master);
+	if (res)
+		goto out;
+	w1_write_block(sl->master, magic, ARRAY_SIZE(magic));
+
+	res = w1_reset_bus(sl->master);
+out:
+	if (lock_needed)
+		mutex_unlock(&sl->master->mutex);
+	return res;
+}
 
 static struct bin_attribute w1_f29_sysfs_bin_files[] = {
 	{
@@ -362,6 +390,10 @@ static int w1_f29_add_slave(struct w1_slave *sl)
 	int err = 0;
 	int i;
 
+	err = w1_f29_disable_test_mode(sl);
+	if (err)
+		return err;
+
 	for (i = 0; i < ARRAY_SIZE(w1_f29_sysfs_bin_files) && !err; ++i)
 		err = sysfs_create_bin_file(
 			&sl->dev.kobj,
-- 
1.8.2.2

