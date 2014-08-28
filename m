Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaH1OgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:36:07 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:53174 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaH1OgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:36:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wsa@the-dreams.de,
        grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH 5/8] i2c: Export i2c_match_id() for direct use by device drivers
Date: Thu, 28 Aug 2014 15:35:35 +0100
Message-Id: <1409236538-21274-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there was no other way to match a I2C device to driver i2c_match_id()
was exclusively used.  However, now there are other types of tables which
are commonly supplied, matching on an i2c_device_id table is used less
frequently.  Instead of _always_ calling i2c_match_id() from within the
framework, we only need to do so from drivers which have no other way of
matching.  This patch makes i2c_match_id() available to the aforementioned
device drivers.

Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/i2c-core.c | 3 ++-
 include/linux/i2c.h    | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index c6013cd..7c21f49 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -80,7 +80,7 @@ void i2c_transfer_trace_unreg(void)
 
 /* ------------------------------------------------------------------------- */
 
-static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
+const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
 						const struct i2c_client *client)
 {
 	if (!(id && client))
@@ -93,6 +93,7 @@ static const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(i2c_match_id);
 
 static int i2c_device_match(struct device *dev, struct device_driver *drv)
 {
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a48eadd..79b674d 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -229,6 +229,8 @@ struct i2c_client {
 
 extern struct i2c_client *i2c_verify_client(struct device *dev);
 extern struct i2c_adapter *i2c_verify_adapter(struct device *dev);
+extern const struct i2c_device_id *i2c_match_id(const struct i2c_device_id *id,
+						const struct i2c_client *client);
 
 static inline struct i2c_client *kobj_to_i2c_client(struct kobject *kobj)
 {
-- 
1.9.1

