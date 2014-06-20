Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967496AbaFTMFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:05:19 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62404 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967301AbaFTMDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:03:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/9] i2c: Add the ability to match device to compatible string without an of_node
Date: Fri, 20 Jun 2014 13:02:27 +0100
Message-Id: <1403265753-25851-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
References: <1403265753-25851-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A great deal of I2C devices are currently matched via DT node name, and
as such the compatible naming convention of '<vendor>,<device>' has gone
somewhat awry - some nodes don't supply one, some supply an arbitrary
string and others the correct device name with an arbitrary vendor prefix.

In an effort to correct this problem we have to supply a mechanism to
match a device by compatible string AND by simple device name.  This
function strips off the '<vendor>,' part of a supplied compatible string
and attempts to match without it.

The plan is to remove this function once all of the compatible strings
for each device have been brought into line.

Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/i2c-core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index d3802dc..8a37745 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1090,6 +1090,27 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
 	return i2c_verify_adapter(dev);
 }
 EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
+
+static const struct of_device_id*
+i2c_of_match_device_strip_vendor(const struct of_device_id *matches,
+				  struct i2c_client *client)
+{
+	const char *name;
+
+	for (; matches->compatible[0]; matches++) {
+		name = strchr(matches->compatible, ',');
+		if (!name)
+			name = matches->compatible;
+		else
+			name++;
+
+		if (!strnicmp(client->name, name, strlen(client->name)))
+			return matches;
+	}
+
+	return NULL;
+}
+
 #else
 static void of_i2c_register_devices(struct i2c_adapter *adap) { }
 #endif /* CONFIG_OF */
-- 
1.8.3.2

