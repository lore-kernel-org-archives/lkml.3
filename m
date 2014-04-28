Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaD1ObY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:31:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:31383 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbaD1O1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:27:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,944,1389772800"; 
   d="scan'208";a="424899226"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tianyu.lan@intel.com
Subject: [Patch V2 6/9] I2C: Add smbus word/block process call helper function
Date: Mon, 28 Apr 2014 22:27:45 +0800
Message-Id: <1398695268-28645-7-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c_smbus_word/block_proc_call() helper function. These will be used
in the implementation of i2c ACPI address space handler.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/i2c/i2c-core.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h    |  4 ++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 3bf0048..638befd 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -2306,6 +2306,30 @@ s32 i2c_smbus_write_word_data(const struct i2c_client *client, u8 command,
 EXPORT_SYMBOL(i2c_smbus_write_word_data);
 
 /**
+ * i2c_smbus_word_proc_call - SMBus "word proc call" protocol
+ * @client: Handle to slave device
+ * @command: Byte interpreted by slave
+ * @value: 16-bit "word" being written
+ *
+ * This executes the SMBus "word proc all" protocol, returning negative errno
+ * else a 16-bit unsigned "word" received from the device.
+ */
+s32 i2c_smbus_word_proc_call(const struct i2c_client *client, u8 command,
+			      u16 value)
+{
+	union i2c_smbus_data data;
+	int status;
+
+	data.word = value;
+	status = i2c_smbus_xfer(client->adapter, client->addr, client->flags,
+			      I2C_SMBUS_READ, command,
+			      I2C_SMBUS_PROC_CALL, &data);
+
+	return (status < 0) ? status : data.word;
+}
+EXPORT_SYMBOL(i2c_smbus_word_proc_call);
+
+/**
  * i2c_smbus_read_block_data - SMBus "block read" protocol
  * @client: Handle to slave device
  * @command: Byte interpreted by slave
@@ -2362,6 +2386,38 @@ s32 i2c_smbus_write_block_data(const struct i2c_client *client, u8 command,
 }
 EXPORT_SYMBOL(i2c_smbus_write_block_data);
 
+/**
+ * i2c_smbus_block_proc_call - SMBus "block write" protocol
+ * @client: Handle to slave device
+ * @command: Byte interpreted by slave
+ * @length: Size of data block; SMBus allows at most 32 bytes
+ * @values: Byte array which will be written.
+ *
+ * This executes the SMBus "block proc call" protocol, returning negative errno
+ * else the number of read bytes.
+ */
+s32 i2c_smbus_block_proc_call(const struct i2c_client *client, u8 command,
+			       u8 length, u8 *values)
+{
+	union i2c_smbus_data data;
+	int status;
+
+	if (length > I2C_SMBUS_BLOCK_MAX)
+		length = I2C_SMBUS_BLOCK_MAX;
+	data.block[0] = length;
+	memcpy(&data.block[1], values, length);
+	status = i2c_smbus_xfer(client->adapter, client->addr, client->flags,
+			      I2C_SMBUS_READ, command,
+			      I2C_SMBUS_BLOCK_PROC_CALL, &data);
+
+	if (status < 0)
+		return status;
+
+	memcpy(values, &data.block[1], data.block[0]);
+	return data.block[0];
+}
+EXPORT_SYMBOL(i2c_smbus_block_proc_call);
+
 /* Returns the number of read bytes */
 s32 i2c_smbus_read_i2c_block_data(const struct i2c_client *client, u8 command,
 				  u8 length, u8 *values)
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 3e6ea90..724440a 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -94,6 +94,10 @@ extern s32 i2c_smbus_read_word_data(const struct i2c_client *client,
 				    u8 command);
 extern s32 i2c_smbus_write_word_data(const struct i2c_client *client,
 				     u8 command, u16 value);
+extern s32 i2c_smbus_word_proc_call(const struct i2c_client *client,
+				    u8 command, u16 value);
+extern s32 i2c_smbus_block_proc_call(const struct i2c_client *client,
+				u8 command, u8 length, u8 *values);
 
 static inline s32
 i2c_smbus_read_word_swapped(const struct i2c_client *client, u8 command)
-- 
1.8.3.1

