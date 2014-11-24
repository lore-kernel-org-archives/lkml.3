Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaKXWer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:34:47 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59037 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaKXWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:16 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>, <linux-spi@vger.kernel.org>
Subject: [PATCH v2 14/14] spi/of: Add OF notifier handler
Date: Mon, 24 Nov 2014 22:33:42 +0000
Message-Id: <1416868422-22103-15-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Add OF notifier handler needed for creating/destroying spi devices
according to dynamic runtime changes in the DT live tree. This code is
enabled when CONFIG_OF_DYNAMIC is selected.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: <linux-spi@vger.kernel.org>
---
 drivers/spi/spi.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a3557c57d4f7..bf1cab0fad66 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2317,6 +2317,86 @@ EXPORT_SYMBOL_GPL(spi_write_then_read);
 
 /*-------------------------------------------------------------------------*/
 
+#if IS_ENABLED(CONFIG_OF_DYNAMIC)
+static int __spi_of_device_match(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+/* must call put_device() when done with returned spi_device device */
+static struct spi_device *of_find_spi_device_by_node(struct device_node *node)
+{
+	struct device *dev = bus_find_device(&spi_bus_type, NULL, node,
+						__spi_of_device_match);
+	return dev ? to_spi_device(dev) : NULL;
+}
+
+static int __spi_of_master_match(struct device *dev, const void *data)
+{
+	return dev->of_node == data;
+}
+
+/* the spi masters are not using spi_bus, so we find it with another way */
+static struct spi_master *of_find_spi_master_by_node(struct device_node *node)
+{
+	struct device *dev;
+
+	dev = class_find_device(&spi_master_class, NULL, node,
+				__spi_of_master_match);
+	if (!dev)
+		return NULL;
+
+	/* reference got in class_find_device */
+	return container_of(dev, struct spi_master, dev);
+}
+
+static int of_spi_notify(struct notifier_block *nb, unsigned long action,
+			 void *arg)
+{
+	struct of_reconfig_data *rd = arg;
+	struct spi_master *master;
+	struct spi_device *spi;
+
+	switch (of_reconfig_get_state_change(action, arg)) {
+	case OF_RECONFIG_CHANGE_ADD:
+		master = of_find_spi_master_by_node(rd->dn->parent);
+		if (master == NULL)
+			return NOTIFY_OK;	/* not for us */
+
+		spi = of_register_spi_device(master, rd->dn);
+		put_device(&master->dev);
+
+		if (IS_ERR(spi)) {
+			pr_err("%s: failed to create for '%s'\n",
+					__func__, rd->dn->full_name);
+			return notifier_from_errno(PTR_ERR(spi));
+		}
+		break;
+
+	case OF_RECONFIG_CHANGE_REMOVE:
+		/* find our device by node */
+		spi = of_find_spi_device_by_node(rd->dn);
+		if (spi == NULL)
+			return NOTIFY_OK;	/* no? not meant for us */
+
+		/* unregister takes one ref away */
+		spi_unregister_device(spi);
+
+		/* and put the reference of the find */
+		put_device(&spi->dev);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block spi_of_notifier = {
+	.notifier_call = of_spi_notify,
+};
+#else /* IS_ENABLED(CONFIG_OF_DYNAMIC) */
+extern struct notifier_block spi_of_notifier;
+#endif /* IS_ENABLED(CONFIG_OF_DYNAMIC) */
+
 static int __init spi_init(void)
 {
 	int	status;
@@ -2334,6 +2414,10 @@ static int __init spi_init(void)
 	status = class_register(&spi_master_class);
 	if (status < 0)
 		goto err2;
+
+	if (IS_ENABLED(CONFIG_OF))
+		WARN_ON(of_reconfig_notifier_register(&spi_of_notifier));
+
 	return 0;
 
 err2:
-- 
1.9.1

