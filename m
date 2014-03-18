Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbaCRV5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:57:35 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63229 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbaCRV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:56:34 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v3 5/7] OF: i2c: Add overlay bus handler
Date: Tue, 18 Mar 2014 23:56:04 +0200
Message-Id: <1395179766-31575-6-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the bus handler registration needed for performing overlays
containing i2c devices.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/i2c/i2c-core.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 5fb80b8..5120d28 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1073,10 +1073,89 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
 	return i2c_verify_adapter(dev);
 }
 EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
+
+#ifdef CONFIG_OF_OVERLAY
+static int i2c_handler_create(struct of_overlay_device_entry *de,
+		int revert)
+{
+	struct device_node *dn;
+	struct i2c_adapter *adap;
+	struct i2c_client *client;
+
+	if (!de || !de->np)
+		return -ENOTSUPP;
+
+	dn = de->np;
+
+	adap = of_find_i2c_adapter_by_node(dn->parent);
+	if (adap == NULL)
+		return -ENOTSUPP;
+
+	client = of_i2c_register_device(adap, dn);
+	put_device(&adap->dev);
+
+	if (client == NULL) {
+		pr_err("%s: failed to create i2c client device "
+				"for '%s'\n",
+				__func__, dn->full_name);
+		/* of_i2c_device_create tosses the real error code */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int i2c_handler_remove(struct of_overlay_device_entry *de,
+		int revert)
+{
+	struct device_node *dn;
+	struct i2c_client *client;
+
+	if (!de || !de->np)
+		return -ENOTSUPP;
+
+	dn = de->np;
+
+	client = of_find_i2c_device_by_node(dn);
+	if (client == NULL)
+		return -ENOTSUPP;
+
+	/* unregister takes one ref away */
+	i2c_unregister_device(client);
+
+	/* and put the reference of the find */
+	put_device(&client->dev);
+
+	return 0;
+}
+
+static const struct of_overlay_handler_ops i2c_handler_ops = {
+	.create	= i2c_handler_create,
+	.remove = i2c_handler_remove,
+};
+
+static struct of_overlay_handler i2c_handler = {
+	.name = "i2c",
+	.ops = &i2c_handler_ops,
+};
+
+static int __init i2c_bus_handler_register(void)
+{
+	return of_overlay_handler_register(&i2c_handler);
+}
+#endif
+
 #else
 static void of_i2c_register_devices(struct i2c_adapter *adap) { }
 #endif /* CONFIG_OF */
 
+#if !defined(CONFIG_OF) || !defined(CONFIG_OF_OVERLAY)
+static inline int i2c_bus_handler_register(void)
+{
+	return 0;
+}
+#endif
+
 /* ACPI support code */
 
 #if IS_ENABLED(CONFIG_ACPI)
@@ -1668,8 +1747,14 @@ static int __init i2c_init(void)
 	retval = i2c_add_driver(&dummy_driver);
 	if (retval)
 		goto class_err;
-	return 0;
 
+	retval = i2c_bus_handler_register();
+	if (retval)
+		goto bus_handler_err;
+
+	return 0;
+bus_handler_err:
+	i2c_del_driver(&dummy_driver);
 class_err:
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_unregister(i2c_adapter_compat_class);
-- 
1.7.12

