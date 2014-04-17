Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161018AbaDQJkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:40:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54788 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752289AbaDQJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:40:17 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 1/2] regmap: add reg_read/reg_write callbacks to regmap_bus struct
Date: Thu, 17 Apr 2014 11:40:11 +0200
Message-Id: <1397727612-32103-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some busses do not support sending/receiving multiple registers in one go.
Such kind of busses just unpack the registers that have been previously
packed by the regmap core or pack registers that will be later unpacked by
the core code.

Add reg_write and reg_read callbacks in order to optimize access through
this kind of busses.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/base/regmap/regmap.c | 26 ++++++++++++++++++++++++++
 include/linux/regmap.h       |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d0a0724..c2a9933 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -35,10 +35,14 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 			       unsigned int mask, unsigned int val,
 			       bool *change);
 
+static int _regmap_bus_reg_read(void *context, unsigned int reg,
+				unsigned int *val);
 static int _regmap_bus_read(void *context, unsigned int reg,
 			    unsigned int *val);
 static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 				       unsigned int val);
+static int _regmap_bus_reg_write(void *context, unsigned int reg,
+				 unsigned int val);
 static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 unsigned int val);
 
@@ -495,6 +499,12 @@ struct regmap *regmap_init(struct device *dev,
 
 		map->defer_caching = false;
 		goto skip_format_initialization;
+	} else if (!bus->read || !bus->write) {
+		map->reg_read = _regmap_bus_reg_read;
+		map->reg_write = _regmap_bus_reg_write;
+
+		map->defer_caching = false;
+		goto skip_format_initialization;
 	} else {
 		map->reg_read  = _regmap_bus_read;
 	}
@@ -1283,6 +1293,14 @@ static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 	return ret;
 }
 
+static int _regmap_bus_reg_write(void *context, unsigned int reg,
+				 unsigned int val)
+{
+	struct regmap *map = context;
+
+	return map->bus->reg_write(map->bus_context, reg, val);
+}
+
 static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 unsigned int val)
 {
@@ -1924,6 +1942,14 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	return ret;
 }
 
+static int _regmap_bus_reg_read(void *context, unsigned int reg,
+				unsigned int *val)
+{
+	struct regmap *map = context;
+
+	return map->bus->reg_read(map->bus_context, reg, val);
+}
+
 static int _regmap_bus_read(void *context, unsigned int reg,
 			    unsigned int *val)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 34ef2c7..0c23ed5 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -276,6 +276,10 @@ typedef int (*regmap_hw_async_write)(void *context,
 typedef int (*regmap_hw_read)(void *context,
 			      const void *reg_buf, size_t reg_size,
 			      void *val_buf, size_t val_size);
+typedef int (*regmap_hw_reg_read)(void *context, unsigned int reg,
+				  unsigned int *val);
+typedef int (*regmap_hw_reg_write)(void *context, unsigned int reg,
+				   unsigned int val);
 typedef struct regmap_async *(*regmap_hw_async_alloc)(void);
 typedef void (*regmap_hw_free_context)(void *context);
 
@@ -309,7 +313,9 @@ struct regmap_bus {
 	regmap_hw_write write;
 	regmap_hw_gather_write gather_write;
 	regmap_hw_async_write async_write;
+	regmap_hw_reg_write reg_write;
 	regmap_hw_read read;
+	regmap_hw_reg_read reg_read;
 	regmap_hw_free_context free_context;
 	regmap_hw_async_alloc async_alloc;
 	u8 read_flag_mask;
-- 
1.8.3.2

