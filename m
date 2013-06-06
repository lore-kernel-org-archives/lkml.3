Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3FFT2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:28:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:58527 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab3FFT2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,816,1363158000"; 
   d="scan'208";a="345939200"
Date: Thu, 6 Jun 2013 11:33:46 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: i2c: introduce i2c helper i2c_find_client_by_name()
Message-ID: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c: introduce i2c helper i2c_find_client_by_name()

There is a requirement to get the i2c_client pointer dynamically without
knowing the bus and slave address. But we do know the client name,
i.e. the name in the i2c_board_info. This patch is to fit this requirement.

A good example is that an ISP(Imaging Signal Processor) driver needs
register i2c camera sensor devices via v4l2, so it has to unregister
all i2c clients that were previously registered by calling
i2c_register_board_info(), and then re-register. For this case we
can use this helper to get i2c_client by passing the client name.

Signed-off-by: Bin Gao <bin.gao@linux.intel.com>
---
 drivers/i2c/i2c-core.c |   17 +++++++++++++++++
 include/linux/i2c.h    |    1 +
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 48e31ed..17683de6 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -2326,6 +2326,23 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 }
 EXPORT_SYMBOL(i2c_smbus_xfer);
 
+static int match_name(struct device *dev, void *data)
+{
+	const char *name = data;
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return !strncmp(client->name, name, strlen(client->name));
+}
+
+struct i2c_client *i2c_find_client_by_name(char *name)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&i2c_bus_type, NULL, name, match_name);
+	return dev ? to_i2c_client(dev) : NULL;
+}
+EXPORT_SYMBOL_GPL(i2c_find_client_by_name);
+
 MODULE_AUTHOR("Simon G. Vogl <simon@tk.uni-linz.ac.at>");
 MODULE_DESCRIPTION("I2C-Bus main module");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index e988fa9..7d8bf02 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -509,6 +509,7 @@ extern void i2c_clients_command(struct i2c_adapter *adap,
 extern struct i2c_adapter *i2c_get_adapter(int nr);
 extern void i2c_put_adapter(struct i2c_adapter *adap);
 
+extern struct i2c_client *i2c_find_client_by_name(char *name);
 
 /* Return the functionality mask */
 static inline u32 i2c_get_functionality(struct i2c_adapter *adap)
-- 
1.7.4.4

