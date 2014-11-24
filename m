Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaKXWfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:35:06 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35610 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaKXWeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:15 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org
Subject: [PATCH v2 12/14] i2c/of: Add OF_RECONFIG notifier handler
Date: Mon, 24 Nov 2014 22:33:40 +0000
Message-Id: <1416868422-22103-13-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

CONFIG_OF_DYNAMIC enables runtime changes to the device tree which in
turn may trigger addition or removal of devices from Linux. Add an
OF_RECONFIG notifier handler to receive tree change events and to
creating or destroy i2c devices as required.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
[grant.likely: clean up #ifdefs and drop unneeded error handling]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/i2c-core.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 15ba6185dba5..d8afd3f28ca4 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1951,6 +1951,52 @@ void i2c_clients_command(struct i2c_adapter *adap, unsigned int cmd, void *arg)
 }
 EXPORT_SYMBOL(i2c_clients_command);
 
+#if IS_ENABLED(CONFIG_OF_DYNAMIC)
+static int of_i2c_notify(struct notifier_block *nb, unsigned long action,
+			 void *arg)
+{
+	struct of_reconfig_data *rd = arg;
+	struct i2c_adapter *adap;
+	struct i2c_client *client;
+
+	switch (of_reconfig_get_state_change(action, rd)) {
+	case OF_RECONFIG_CHANGE_ADD:
+		adap = of_find_i2c_adapter_by_node(rd->dn->parent);
+		if (adap == NULL)
+			return NOTIFY_OK;	/* not for us */
+
+		client = of_i2c_register_device(adap, rd->dn);
+		put_device(&adap->dev);
+
+		if (IS_ERR(client)) {
+			pr_err("%s: failed to create for '%s'\n",
+					__func__, rd->dn->full_name);
+			return notifier_from_errno(PTR_ERR(client));
+		}
+		break;
+	case OF_RECONFIG_CHANGE_REMOVE:
+		/* find our device by node */
+		client = of_find_i2c_device_by_node(rd->dn);
+		if (client == NULL)
+			return NOTIFY_OK;	/* no? not meant for us */
+
+		/* unregister takes one ref away */
+		i2c_unregister_device(client);
+
+		/* and put the reference of the find */
+		put_device(&client->dev);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+static struct notifier_block i2c_of_notifier = {
+	.notifier_call = of_i2c_notify,
+};
+#else
+extern struct notifier_block i2c_of_notifier;
+#endif /* CONFIG_OF_DYNAMIC */
+
 static int __init i2c_init(void)
 {
 	int retval;
@@ -1968,6 +2014,10 @@ static int __init i2c_init(void)
 	retval = i2c_add_driver(&dummy_driver);
 	if (retval)
 		goto class_err;
+
+	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
+		WARN_ON(of_reconfig_notifier_register(&i2c_of_notifier));
+
 	return 0;
 
 class_err:
@@ -1981,6 +2031,8 @@ bus_err:
 
 static void __exit i2c_exit(void)
 {
+	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
+		WARN_ON(of_reconfig_notifier_unregister(&i2c_of_notifier));
 	i2c_del_driver(&dummy_driver);
 #ifdef CONFIG_I2C_COMPAT
 	class_compat_unregister(i2c_adapter_compat_class);
-- 
1.9.1

