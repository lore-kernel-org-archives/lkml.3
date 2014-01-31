Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaAaKZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:25:21 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42873 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751411AbaAaKZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:25:15 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/3] spi: core: Add devm_spi_alloc_master
Date: Fri, 31 Jan 2014 11:23:10 +0100
Message-Id: <1391163792-21819-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using devm_spi_register_master leads to a memory leak on the spi_master
structure.

spi_alloc_master uses kzalloc to allocate the spi_master but the introduction
of devm_spi_register_master removed all the matching calls to spi_master_put,
leaking the spi_master structure.

Add a devm_spi_alloc_master to provide the intended behaviour.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/spi/spi.c       | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/spi/spi.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 63613a9..eb728ec 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1266,6 +1266,42 @@ struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
 }
 EXPORT_SYMBOL_GPL(spi_alloc_master);
 
+static void devm_spi_put(struct device *dev, void *res)
+{
+	spi_master_put(*(struct spi_master **)res);
+}
+
+/**
+ * devm_spi_alloc_master - allocate SPI master controller
+ * @dev: the controller, possibly using the platform_bus
+ * @size: how much zeroed driver-private data to allocate; the pointer to this
+ *	memory is in the driver_data field of the returned device,
+ *	accessible with spi_master_get_devdata().
+ * Context: can sleep
+ *
+ * Allocates a master controller as with spi_alloc_master() which will
+ * automatically be freed
+ */
+struct spi_master *devm_spi_alloc_master(struct device *dev, unsigned size)
+{
+	struct spi_master **ptr, *master;
+
+	ptr = devres_alloc(devm_spi_put, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	master = spi_alloc_master(dev, size);
+	if (master) {
+		*ptr = master;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return master;
+}
+EXPORT_SYMBOL_GPL(devm_spi_alloc_master);
+
 #ifdef CONFIG_OF
 static int of_spi_register_master(struct spi_master *master)
 {
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index a1d4ca2..6fbdb2b 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -462,6 +462,8 @@ extern void spi_finalize_current_transfer(struct spi_master *master);
 /* the spi driver core manages memory for the spi_master classdev */
 extern struct spi_master *
 spi_alloc_master(struct device *host, unsigned size);
+extern struct spi_master *
+devm_spi_alloc_master(struct device *host, unsigned size);
 
 extern int spi_register_master(struct spi_master *master);
 extern int devm_spi_register_master(struct device *dev,
-- 
1.8.4.2

