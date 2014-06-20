Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967423AbaFTMDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:03:40 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41473 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967329AbaFTMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:03:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/9] i2c: Match using traditional OF methods, then by vendor-less compatible strings
Date: Fri, 20 Jun 2014 13:02:28 +0100
Message-Id: <1403265753-25851-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
References: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function provides a single call for all I2C devices which need to
match firstly using traditional OF means i.e by of_node, then if that
fails we attempt to match using the supplied I2C client name with a
list of supplied compatible strings with the '<vendor>,' string
removed.  The latter is required due to the unruly naming conventions
used currently by I2C devices.

Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/i2c-core.c | 16 ++++++++++++++++
 include/linux/i2c.h    | 12 ++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 8a37745..a9c97c4 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1111,6 +1111,22 @@ i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
 	return NULL;
 }
 
+const struct of_device_id
+*i2c_of_match_device(const struct of_device_id *matches,
+		     struct i2c_client *client)
+{
+	const struct of_device_id *match;
+
+	if (!(client && matches))
+		return NULL;
+
+	match = of_match_device(matches, &client->dev);
+	if (match)
+		return match;
+
+	return i2c_of_match_device_strip_vendor(matches, client);
+}
+EXPORT_SYMBOL_GPL(i2c_of_match_device);
 #else
 static void of_i2c_register_devices(struct i2c_adapter *adap) { }
 #endif /* CONFIG_OF */
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index b556e0a..3d0350c 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -564,6 +564,10 @@ extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
 /* must call put_device() when done with returned i2c_adapter device */
 extern struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
 
+extern const struct of_device_id
+*i2c_of_match_device(const struct of_device_id *matches,
+		     struct i2c_client *client);
+
 #else
 
 static inline struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
@@ -575,6 +579,14 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
 {
 	return NULL;
 }
+
+const struct of_device_id
+*i2c_of_match_device(const struct of_device_id *matches,
+		     struct i2c_client *client)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_OF */
 
 #endif /* _LINUX_I2C_H */
-- 
1.8.3.2

