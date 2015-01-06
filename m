Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbbAFOdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:33:50 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47169 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbbAFOdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:33:46 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@Fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] w1: slaves: w1_therm: Extract read_rom function
Date: Tue,  6 Jan 2015 15:29:55 +0100
Message-Id: <1420554596-10250-2-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract read_rom function to make it reusable by other attributes.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/w1/slaves/w1_therm.c | 51 ++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 1f11a20..3bad3d6 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -188,24 +188,20 @@ static inline int w1_convert_temp(u8 rom[9], u8 fid)
 }
 
 
-static ssize_t w1_slave_show(struct device *device,
-	struct device_attribute *attr, char *buf)
+/**
+ * read_rom() - Reads slave's 64-bit ROM + 8-bit checksum
+ * @device:	slave device to read from
+ * @rom:	buffer to write to
+ * Return:	negative value on errors, 0=read or checksum failure, 1=success
+ */
+static int read_rom(struct device *device, u8 rom[9])
 {
 	struct w1_slave *sl = dev_to_w1_slave(device);
 	struct w1_master *dev = sl->master;
-	u8 rom[9], crc, verdict, external_power;
 	int i, max_trying = 10;
-	ssize_t c = PAGE_SIZE;
-
-	i = mutex_lock_interruptible(&dev->bus_mutex);
-	if (i != 0)
-		return i;
-
-	memset(rom, 0, sizeof(rom));
+	u8 crc, external_power;
 
 	while (max_trying--) {
-
-		verdict = 0;
 		crc = 0;
 
 		if (!w1_reset_select_slave(sl)) {
@@ -245,7 +241,6 @@ static ssize_t w1_slave_show(struct device *device,
 			}
 
 			if (!w1_reset_select_slave(sl)) {
-
 				w1_write_8(dev, W1_READ_SCRATCHPAD);
 				if ((count = w1_read_block(dev, rom, 9)) != 9) {
 					dev_warn(device, "w1_read_block() "
@@ -256,18 +251,38 @@ static ssize_t w1_slave_show(struct device *device,
 				crc = w1_calc_crc8(rom, 8);
 
 				if (rom[8] == crc)
-					verdict = 1;
+					return 1;
 			}
 		}
-
-		if (verdict)
-			break;
 	}
 
+	return 0;
+}
+
+static ssize_t w1_slave_show(struct device *device,
+	struct device_attribute *attr, char *buf)
+{
+	struct w1_slave *sl = dev_to_w1_slave(device);
+	struct w1_master *dev = sl->master;
+	u8 rom[9], verdict;
+	int i;
+	ssize_t c = PAGE_SIZE;
+
+	i = mutex_lock_interruptible(&dev->bus_mutex);
+	if (i != 0)
+		return i;
+
+	memset(rom, 0, sizeof(rom));
+
+	verdict = read_rom(device, rom);
+	if (verdict < 0)
+		/* Propagate errors to upper layers */
+		return verdict;
+
 	for (i = 0; i < 9; ++i)
 		c -= snprintf(buf + PAGE_SIZE - c, c, "%02x ", rom[i]);
 	c -= snprintf(buf + PAGE_SIZE - c, c, ": crc=%02x %s\n",
-			   crc, (verdict) ? "YES" : "NO");
+			   w1_calc_crc8(rom, 8), (verdict) ? "YES" : "NO");
 	if (verdict)
 		memcpy(sl->family_data, rom, sizeof(rom));
 	else
-- 
2.2.1

