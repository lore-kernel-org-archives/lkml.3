Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaGQQ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:56:12 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56020 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaGQQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:56:10 -0400
Date: Thu, 17 Jul 2014 09:56:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] i2c: stub: Add support for SMBus block commands
Message-ID: <20140717165603.GA16408@roeck-us.net>
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net>
 <20140717132135.GI2740@katana>
 <20140717154020.650ad59c@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717154020.650ad59c@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMBus block commands are different to I2C block commands since
the returned data is not normally accessible with byte or word
commands on other command offsets. Add linked list of 'block'
commands to support those commands.

Access mechanism is quite simple: Block commands must be written
before they can be read. Subsequent writes can be partial. Block
read commands always return the number of bytes associated with
the longest previous write.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Document that SMBus block commands are by default disabled and how
    to enable them.
    Merge Jean's "increasing block length" patch into this one.
v2: Make new functionality only available on request via functionality
    module parameter.
    Add more details about SMBus block mode support to documentation.
    Use correct sizeof() variable in devm_kzalloc.
    Use stub_find_block() only in SMBus block command itself.
    Store first word of block data in chip->words[].
    When writing block data and the written data is longer than
    the first write, bail out with debug message indicating the reason
    for the error.

 Documentation/i2c/i2c-stub | 12 +++++-
 drivers/i2c/i2c-stub.c     | 99 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 104 insertions(+), 7 deletions(-)

diff --git a/Documentation/i2c/i2c-stub b/Documentation/i2c/i2c-stub
index fa4b669..a0fe7a0 100644
--- a/Documentation/i2c/i2c-stub
+++ b/Documentation/i2c/i2c-stub
@@ -2,9 +2,9 @@ MODULE: i2c-stub
 
 DESCRIPTION:
 
-This module is a very simple fake I2C/SMBus driver.  It implements five
+This module is a very simple fake I2C/SMBus driver.  It implements six
 types of SMBus commands: write quick, (r/w) byte, (r/w) byte data, (r/w)
-word data, and (r/w) I2C block data.
+word data, (r/w) I2C block data, and (r/w) SMBus block data.
 
 You need to provide chip addresses as a module parameter when loading this
 driver, which will then only react to SMBus commands to these addresses.
@@ -19,6 +19,14 @@ A pointer register with auto-increment is implemented for all byte
 operations.  This allows for continuous byte reads like those supported by
 EEPROMs, among others.
 
+SMBus block command support is disabled by default, and must be enabled
+explicitly by setting the respective bits (0x03000000) in the functionality
+module parameter.
+
+SMBus block commands must be written to configure an SMBus command for
+SMBus block operations. Writes can be partial. Block read commands always
+return the number of bytes selected with the largest write so far.
+
 The typical use-case is like this:
 	1. load this module
 	2. use i2cset (from the i2c-tools project) to pre-load some data
diff --git a/drivers/i2c/i2c-stub.c b/drivers/i2c/i2c-stub.c
index 77e4849..e0bb465 100644
--- a/drivers/i2c/i2c-stub.c
+++ b/drivers/i2c/i2c-stub.c
@@ -27,29 +27,70 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
+#include <linux/list.h>
 
 #define MAX_CHIPS 10
-#define STUB_FUNC (I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE | \
-		   I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA | \
-		   I2C_FUNC_SMBUS_I2C_BLOCK)
+
+/*
+ * Support for I2C_FUNC_SMBUS_BLOCK_DATA is disabled by default and must
+ * be enabled explicitly by setting the I2C_FUNC_SMBUS_BLOCK_DATA bits
+ * in the 'functionality' module parameter.
+ */
+#define STUB_FUNC_DEFAULT \
+		(I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE | \
+		 I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA | \
+		 I2C_FUNC_SMBUS_I2C_BLOCK)
+
+#define STUB_FUNC_ALL \
+		(STUB_FUNC_DEFAULT | I2C_FUNC_SMBUS_BLOCK_DATA)
 
 static unsigned short chip_addr[MAX_CHIPS];
 module_param_array(chip_addr, ushort, NULL, S_IRUGO);
 MODULE_PARM_DESC(chip_addr,
 		 "Chip addresses (up to 10, between 0x03 and 0x77)");
 
-static unsigned long functionality = STUB_FUNC;
+static unsigned long functionality = STUB_FUNC_DEFAULT;
 module_param(functionality, ulong, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(functionality, "Override functionality bitfield");
 
+struct smbus_block_data {
+	struct list_head node;
+	u8 command;
+	u8 len;
+	u8 block[I2C_SMBUS_BLOCK_MAX];
+};
+
 struct stub_chip {
 	u8 pointer;
 	u16 words[256];		/* Byte operations use the LSB as per SMBus
 				   specification */
+	struct list_head smbus_blocks;
 };
 
 static struct stub_chip *stub_chips;
 
+static struct smbus_block_data *stub_find_block(struct device *dev,
+						struct stub_chip *chip,
+						u8 command, bool create)
+{
+	struct smbus_block_data *b, *rb = NULL;
+
+	list_for_each_entry(b, &chip->smbus_blocks, node) {
+		if (b->command == command) {
+			rb = b;
+			break;
+		}
+	}
+	if (rb == NULL && create) {
+		rb = devm_kzalloc(dev, sizeof(*rb), GFP_KERNEL);
+		if (rb == NULL)
+			return rb;
+		rb->command = command;
+		list_add(&rb->node, &chip->smbus_blocks);
+	}
+	return rb;
+}
+
 /* Return negative errno on error. */
 static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
 	char read_write, u8 command, int size, union i2c_smbus_data *data)
@@ -57,6 +98,7 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
 	s32 ret;
 	int i, len;
 	struct stub_chip *chip = NULL;
+	struct smbus_block_data *b;
 
 	/* Search for the right chip */
 	for (i = 0; i < MAX_CHIPS && chip_addr[i]; i++) {
@@ -148,6 +190,51 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
 		ret = 0;
 		break;
 
+	case I2C_SMBUS_BLOCK_DATA:
+		b = stub_find_block(&adap->dev, chip, command, false);
+		if (read_write == I2C_SMBUS_WRITE) {
+			len = data->block[0];
+			if (len == 0 || len > I2C_SMBUS_BLOCK_MAX) {
+				ret = -EINVAL;
+				break;
+			}
+			if (b == NULL) {
+				b = stub_find_block(&adap->dev, chip, command,
+						    true);
+				if (b == NULL) {
+					ret = -ENOMEM;
+					break;
+				}
+			}
+			/* Largest write sets read block length */
+			if (len > b->len)
+				b->len = len;
+			for (i = 0; i < len; i++)
+				b->block[i] = data->block[i + 1];
+			/* update for byte and word commands */
+			chip->words[command] = (b->block[0] << 8) | b->len;
+			dev_dbg(&adap->dev,
+				"smbus block data - addr 0x%02x, wrote %d bytes at 0x%02x.\n",
+				addr, len, command);
+		} else {
+			if (b == NULL) {
+				dev_dbg(&adap->dev,
+					"SMBus block read command without prior block write not supported\n");
+				ret = -EOPNOTSUPP;
+				break;
+			}
+			len = b->len;
+			data->block[0] = len;
+			for (i = 0; i < len; i++)
+				data->block[i + 1] = b->block[i];
+			dev_dbg(&adap->dev,
+				"smbus block data - addr 0x%02x, read  %d bytes at 0x%02x.\n",
+				addr, len, command);
+		}
+
+		ret = 0;
+		break;
+
 	default:
 		dev_dbg(&adap->dev, "Unsupported I2C/SMBus command\n");
 		ret = -EOPNOTSUPP;
@@ -159,7 +246,7 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
 
 static u32 stub_func(struct i2c_adapter *adapter)
 {
-	return STUB_FUNC & functionality;
+	return STUB_FUNC_ALL & functionality;
 }
 
 static const struct i2c_algorithm smbus_algorithm = {
@@ -199,6 +286,8 @@ static int __init i2c_stub_init(void)
 		pr_err("i2c-stub: Out of memory\n");
 		return -ENOMEM;
 	}
+	for (i--; i >= 0; i--)
+		INIT_LIST_HEAD(&stub_chips[i].smbus_blocks);
 
 	ret = i2c_add_adapter(&stub_adapter);
 	if (ret)
-- 
1.9.1

