Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3A0ONO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:13:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48876 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755604Ab3A0ONF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:13:05 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: spi: Support asynchronous I/O for SPI
Date: Sun, 27 Jan 2013 22:12:34 +0800
Message-Id: <1359295954-5209-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359295954-5209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1359295954-5209-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-spi.c |   41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
index ffa46a9..bb19592 100644
--- a/drivers/base/regmap/regmap-spi.c
+++ b/drivers/base/regmap/regmap-spi.c
@@ -15,6 +15,21 @@
 #include <linux/init.h>
 #include <linux/module.h>
 
+#include "internal.h"
+
+struct regmap_async_spi {
+	struct regmap_async core;
+	struct spi_message m;
+	struct spi_transfer t[2];
+};
+
+static void regmap_spi_complete(void *data)
+{
+	struct regmap_async_spi *async = data;
+
+	regmap_async_complete_cb(&async->core, async->m.status);
+}
+
 static int regmap_spi_write(void *context, const void *data, size_t count)
 {
 	struct device *dev = context;
@@ -40,6 +55,30 @@ static int regmap_spi_gather_write(void *context,
 	return spi_sync(spi, &m);
 }
 
+static int regmap_spi_async_write(void *context,
+				  const void *reg, size_t reg_len,
+				  const void *val, size_t val_len,
+				  struct regmap_async *a)
+{
+	struct regmap_async_spi *async = (void *)a;
+	struct device *dev = context;
+	struct spi_device *spi = to_spi_device(dev);
+
+	async->t[0].tx_buf = reg;
+	async->t[0].len = reg_len;
+	async->t[1].tx_buf = val;
+	async->t[1].len = val_len;
+
+	spi_message_init(&async->m);
+	spi_message_add_tail(&async->t[0], &async->m);
+	spi_message_add_tail(&async->t[1], &async->m);
+
+	async->m.complete = regmap_spi_complete;
+	async->m.context = async;
+
+	return spi_async(spi, &async->m);
+}
+
 static int regmap_spi_read(void *context,
 			   const void *reg, size_t reg_size,
 			   void *val, size_t val_size)
@@ -53,8 +92,10 @@ static int regmap_spi_read(void *context,
 static struct regmap_bus regmap_spi = {
 	.write = regmap_spi_write,
 	.gather_write = regmap_spi_gather_write,
+	.async_write = regmap_spi_async_write,
 	.read = regmap_spi_read,
 	.read_flag_mask = 0x80,
+	.async_size = sizeof(struct regmap_async_spi),
 };
 
 /**
-- 
1.7.10.4

