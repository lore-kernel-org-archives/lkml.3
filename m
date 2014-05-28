Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaE1MrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:47:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57037 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaE1MrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:47:07 -0400
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
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v5 6/9] OF: i2c: Add OF notifier handler
Date: Wed, 28 May 2014 15:46:30 +0300
Message-Id: <1401281193-27146-7-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1401281193-27146-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF notifier handler needed for creating/destroying i2c devices
according to dynamic runtime changes in the DT live tree.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/i2c/i2c-core.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 6e47f73..ce78388 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1083,7 +1083,6 @@ struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
 	return i2c_verify_client(dev);
 }
 EXPORT_SYMBOL(of_find_i2c_device_by_node);
-
 /* must call put_device() when done with returned i2c_adapter device */
 struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
 {
@@ -1097,6 +1096,7 @@ struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
 	return i2c_verify_adapter(dev);
 }
 EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
+
 #else
 static void of_i2c_register_devices(struct i2c_adapter *adap) { }
 #endif /* CONFIG_OF */
@@ -1675,6 +1675,57 @@ void i2c_clients_command(struct i2c_adapter *adap, unsigned int cmd, void *arg)
 }
 EXPORT_SYMBOL(i2c_clients_command);
 
+#if IS_ENABLED(CONFIG_OF)
+
+static int of_i2c_notify(struct notifier_block *nb,
+				unsigned long action, void *arg)
+{
+	struct device_node *dn;
+	struct i2c_adapter *adap;
+	struct i2c_client *client;
+
+	if (action == OF_RECONFIG_DYNAMIC_CREATE_DEV) {
+
+		dn = arg;
+
+		adap = of_find_i2c_adapter_by_node(dn->parent);
+		if (adap == NULL)
+			return NOTIFY_OK;	/* not for us */
+
+		client = of_i2c_register_device(adap, dn);
+		put_device(&adap->dev);
+
+		if (IS_ERR(client)) {
+			pr_err("%s: failed to create for '%s'\n",
+					__func__, dn->full_name);
+			return notifier_from_errno(PTR_ERR(client));
+		}
+
+	} else if (action == OF_RECONFIG_DYNAMIC_DESTROY_DEV) {
+
+		dn = arg;
+
+		/* find our device by node */
+		client = of_find_i2c_device_by_node(dn);
+		if (client == NULL)
+			return NOTIFY_OK;	/* no? not meant for us */
+
+		/* unregister takes one ref away */
+		i2c_unregister_device(client);
+
+		/* and put the reference of the find */
+		put_device(&client->dev);
+
+	} else
+		return NOTIFY_OK;
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block i2c_of_notifier;
+
+#endif
+
 static int __init i2c_init(void)
 {
 	int retval;
@@ -1692,8 +1743,19 @@ static int __init i2c_init(void)
 	retval = i2c_add_driver(&dummy_driver);
 	if (retval)
 		goto class_err;
-	return 0;
 
+#if IS_ENABLED(CONFIG_OF)
+	i2c_of_notifier.notifier_call = of_i2c_notify;
+	retval = of_reconfig_notifier_register(&i2c_of_notifier);
+	if (retval)
+		goto notifier_err;
+#endif
+
+	return 0;
+#if IS_ENABLED(CONFIG_OF)
+notifier_err:
+	i2c_del_driver(&dummy_driver);
+#endif
 class_err:
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_unregister(i2c_adapter_compat_class);
-- 
1.7.12

