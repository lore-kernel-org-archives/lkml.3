Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbbAIRWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:22:21 -0500
Received: from sauhun.de ([89.238.76.85]:49548 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438AbbAIRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:22:20 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [RFC 01/11] i2c: add quirk structure to describe adapter flaws
Date: Fri,  9 Jan 2015 18:21:31 +0100
Message-Id: <1420824103-24169-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of I2C adapters which are not fully I2C compatible is rising,
sadly. Drivers usually do handle the flaws, still the user receives only
some errno for a transfer which normally can be expected to work. This
patch introduces a formal description of flaws. One advantage is that
the core can check before the actual transfer if the messages could be
transferred at all. This is done in the next patch. Another advantage is
that we can pass this information to the user so the restrictions are
exactly known and further actions can be based on that. This will be
done later after some stabilization period for this description.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 include/linux/i2c.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index e3a1721c8354..f8a642713706 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -447,6 +447,40 @@ int i2c_recover_bus(struct i2c_adapter *adap);
 int i2c_generic_gpio_recovery(struct i2c_adapter *adap);
 int i2c_generic_scl_recovery(struct i2c_adapter *adap);
 
+/**
+ * struct i2c_adapter_quirks - describe flaws of an i2c adapter
+ * @flags: see I2C_ADAPTER_QUIRK_* for possible flags
+ * @max_num_msgs: maximum number of messages per transfer
+ * @max_write_len: maximum length of a write message
+ * @max_read_len: maximum length of a read message
+ * @max_comb_write_len: maximum length of a write in a combined message
+ * @max_comb_read_len: maximum length of a read in a combined message
+ *
+ * Note about combined messages: Some I2C controllers can only send one
+ * message per transfer, plus something called combined message or
+ * write-then-read. This is a (usually) small write message followed by
+ * a read message and barely enough to access register based slaves like
+ * EEPROMs. There is a flag to support this mode. It implies max_num_msg = 2
+ * and does the length checks with max_comb_*_len because combined message mode
+ * usually has its own limitations. Read/write flags of the messages are also
+ * checked to be proper. Because of HW implementation, some controllers can
+ * actually do write-then-anything. To support that, write-then-read has been
+ * broken out into write-first and read-second.
+ */
+struct i2c_adapter_quirks {
+	u64 flags;
+	int max_num_msgs;
+	u16 max_write_len;
+	u16 max_read_len;
+	u16 max_comb_write_len;
+	u16 max_comb_read_len;
+};
+
+#define I2C_ADAPTER_QUIRK_COMB_WRITE_FIRST	BIT(0)
+#define I2C_ADAPTER_QUIRK_COMB_READ_SECOND	BIT(1)
+#define I2C_ADAPTER_QUIRK_COMB_WRITE_THEN_READ	(I2C_ADAPTER_QUIRK_COMB_WRITE_FIRST | \
+						I2C_ADAPTER_QUIRK_COMB_READ_SECOND)
+
 /*
  * i2c_adapter is the structure used to identify a physical i2c bus along
  * with the access algorithms necessary to access it.
@@ -472,6 +506,7 @@ struct i2c_adapter {
 	struct list_head userspace_clients;
 
 	struct i2c_bus_recovery_info *bus_recovery_info;
+	struct i2c_adapter_quirks *quirks;
 };
 #define to_i2c_adapter(d) container_of(d, struct i2c_adapter, dev)
 
-- 
2.1.3

