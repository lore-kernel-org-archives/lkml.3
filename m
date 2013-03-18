Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3CROCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:02:46 -0400
Received: from storage.astrosoft.ru ([195.218.158.6]:22967 "HELO
	storage.astrosoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751330Ab3CROCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:02:45 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 10:02:44 EDT
From: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
Subject: [PATCH 1/1] The AT24 driver only uses page size of 1 byte if no platform data is provided to the probe function. When this eeprom is detected via open firmware tree in powerpc architecture the correct chip type is given to the probe function. So the driver can extract the page size for optimal performance out of this chip type.
Date: Mon, 18 Mar 2013 17:52:13 +0400
Message-Id: <1363614733-1179-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
X-Mailer: git-send-email 1.7.10.4
X-OriginalArrivalTime: 18 Mar 2013 13:52:06.0154 (UTC) FILETIME=[C6DF86A0:01CE23DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
---
 drivers/misc/eeprom/at24.c | 50 +++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 2baeec5..a467553 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -97,35 +97,39 @@ module_param(write_timeout, uint, 0);
 MODULE_PARM_DESC(write_timeout, "Time (in ms) to try writes (default 25)");
 
 #define AT24_SIZE_BYTELEN 5
+#define AT24_PAGE_SIZE_BYTELEN 4
 #define AT24_SIZE_FLAGS 8
 
 #define AT24_BITMASK(x) (BIT(x) - 1)
 
-/* create non-zero magic value for given eeprom parameters */
-#define AT24_DEVICE_MAGIC(_len, _flags) 		\
-	((1 << AT24_SIZE_FLAGS | (_flags)) 		\
-	    << AT24_SIZE_BYTELEN | ilog2(_len))
+#define AT24_DEVICE_MAGIC(_len, _page_size, _flags)            \
+	(((1 << AT24_SIZE_FLAGS | (_flags)) << \
+	(AT24_SIZE_BYTELEN + AT24_PAGE_SIZE_BYTELEN)) | \
+	(ilog2(_page_size) << AT24_SIZE_BYTELEN) | \
+	ilog2(_len))
+
+
 
 static const struct i2c_device_id at24_ids[] = {
 	/* needs 8 addresses as A0-A2 are ignored */
-	{ "24c00", AT24_DEVICE_MAGIC(128 / 8, AT24_FLAG_TAKE8ADDR) },
+	{ "24c00", AT24_DEVICE_MAGIC(128 / 8, 1, AT24_FLAG_TAKE8ADDR) },
 	/* old variants can't be handled with this generic entry! */
-	{ "24c01", AT24_DEVICE_MAGIC(1024 / 8, 0) },
-	{ "24c02", AT24_DEVICE_MAGIC(2048 / 8, 0) },
+	{ "24c01", AT24_DEVICE_MAGIC(1024 / 8, 1, 0) },
+	{ "24c02", AT24_DEVICE_MAGIC(2048 / 8, 1, 0) },
 	/* spd is a 24c02 in memory DIMMs */
-	{ "spd", AT24_DEVICE_MAGIC(2048 / 8,
+	{ "spd", AT24_DEVICE_MAGIC(2048 / 8, 1,
 		AT24_FLAG_READONLY | AT24_FLAG_IRUGO) },
-	{ "24c04", AT24_DEVICE_MAGIC(4096 / 8, 0) },
+	{ "24c04", AT24_DEVICE_MAGIC(4096 / 8, 16, 0) },
 	/* 24rf08 quirk is handled at i2c-core */
-	{ "24c08", AT24_DEVICE_MAGIC(8192 / 8, 0) },
-	{ "24c16", AT24_DEVICE_MAGIC(16384 / 8, 0) },
-	{ "24c32", AT24_DEVICE_MAGIC(32768 / 8, AT24_FLAG_ADDR16) },
-	{ "24c64", AT24_DEVICE_MAGIC(65536 / 8, AT24_FLAG_ADDR16) },
-	{ "24c128", AT24_DEVICE_MAGIC(131072 / 8, AT24_FLAG_ADDR16) },
-	{ "24c256", AT24_DEVICE_MAGIC(262144 / 8, AT24_FLAG_ADDR16) },
-	{ "24c512", AT24_DEVICE_MAGIC(524288 / 8, AT24_FLAG_ADDR16) },
-	{ "24c1024", AT24_DEVICE_MAGIC(1048576 / 8, AT24_FLAG_ADDR16) },
 	{ "at24", 0 },
+	{ "24c08", AT24_DEVICE_MAGIC(8192 / 8, 16, 0) },
+	{ "24c16", AT24_DEVICE_MAGIC(16384 / 8, 16, 0) },
+	{ "24c32", AT24_DEVICE_MAGIC(32768 / 8, 32, AT24_FLAG_ADDR16) },
+	{ "24c64", AT24_DEVICE_MAGIC(65536 / 8, 32, AT24_FLAG_ADDR16) },
+	{ "24c128", AT24_DEVICE_MAGIC(131072 / 8, 64, AT24_FLAG_ADDR16) },
+	{ "24c256", AT24_DEVICE_MAGIC(262144 / 8, 64, AT24_FLAG_ADDR16) },
+	{ "24c512", AT24_DEVICE_MAGIC(524288 / 8, 128, AT24_FLAG_ADDR16) },
+	{ "24c1024", AT24_DEVICE_MAGIC(1048576 / 8, 256, AT24_FLAG_ADDR16) },
 	{ /* END OF LIST */ }
 };
 MODULE_DEVICE_TABLE(i2c, at24_ids);
@@ -499,15 +503,25 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		magic = id->driver_data;
 		chip.byte_len = BIT(magic & AT24_BITMASK(AT24_SIZE_BYTELEN));
 		magic >>= AT24_SIZE_BYTELEN;
+		chip.page_size = BIT(magic
+			& AT24_BITMASK(AT24_PAGE_SIZE_BYTELEN));
+		magic >>= AT24_PAGE_SIZE_BYTELEN;
+
 		chip.flags = magic & AT24_BITMASK(AT24_SIZE_FLAGS);
 		/*
+		 *If page size is not given in the magic wird,
+		 take page size 1.*
 		 * This is slow, but we can't know all eeproms, so we better
 		 * play safe. Specifying custom eeprom-types via platform_data
 		 * is recommended anyhow.
 		 */
-		chip.page_size = 1;
+
 
 		/* update chipdata if OF is present */
+		if (chip.page_size == 0)
+			chip.page_size = 1;
+
+
 		at24_get_ofdata(client, &chip);
 
 		chip.setup = NULL;
-- 
1.7.11.7

