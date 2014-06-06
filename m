Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaFFPw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:52:56 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41887 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaFFPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:52:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/9] i2c: Match using traditional OF methods, then by vendor-less compatible strings
Date: Fri,  6 Jun 2014 16:52:26 +0100
Message-Id: <1402069952-28022-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402069952-28022-1-git-send-email-lee.jones@linaro.org>
References: <1402069952-28022-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function provides a single call for all I2C devices which need to
match firstly using traditional OF means i.e by of_node, then if that
fails we attempt to match using the supplied I2C client name with a
list of supplied compatible strings with the '<vendor>,' string
removed.  The latter is required due to the unruly naming conventions
used currently by I2C devices.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/i2c-core.c | 13 +++++++++++++
 include/linux/i2c.h    |  9 +++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index face8f9..80a2f2e 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1115,6 +1115,19 @@ const struct of_device_id
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(i2c_of_match_device_strip_vendor);
+
+const struct of_device_id
+*i2c_of_match_device(const struct of_device_id *matches, struct device *dev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_device(matches, dev);
+	if (match)
+		return match;
+
+	return i2c_of_match_device_strip_vendor(matches, dev);
+}
+EXPORT_SYMBOL_GPL(i2c_of_match_device);
 #else
 static void of_i2c_register_devices(struct i2c_adapter *adap) { }
 #endif /* CONFIG_OF */
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index f7ec75b..ab5866f 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -565,6 +565,9 @@ extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
 extern struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
 
 extern const struct of_device_id
+*i2c_of_match_device(const struct of_device_id *matches, struct device *dev);
+
+extern const struct of_device_id
 *i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
 				  struct device *dev);
 #else
@@ -580,6 +583,12 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
 }
 
 const struct of_device_id
+*i2c_of_match_device(const struct of_device_id *matches, struct device *dev)
+{
+	return NULL;
+}
+
+const struct of_device_id
 *i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
 				  struct device *dev)
 {
-- 
1.8.3.2

