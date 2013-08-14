Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3HNXQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:16:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39234 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933460Ab3HNXNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:13:40 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 02/10] crypto: omap-aes: Add useful debug macros
Date: Wed, 14 Aug 2013 18:12:41 -0500
Message-ID: <1376521969-16807-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376521969-16807-1-git-send-email-joelf@ti.com>
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DEBUG is enabled, these macros can be used to print variables
in integer and hex format, and clearly display which registers,
offsets and values are being read/written , including printing the
names of the offsets and their values.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ee15b0f..3838e0a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -15,6 +15,14 @@
 
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
+#ifdef DEBUG
+#define prn(num) printk(#num "=%d\n", num)
+#define prx(num) printk(#num "=%x\n", num)
+#else
+#define prn(num) do { } while (0)
+#define prx(num)  do { } while (0)
+#endif
+
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -172,13 +180,35 @@ struct omap_aes_dev {
 static LIST_HEAD(dev_list);
 static DEFINE_SPINLOCK(list_lock);
 
+#ifdef DEBUG
+#define omap_aes_read(dd, offset)					\
+	do {								\
+		omap_aes_read_1(dd, offset);				\
+		pr_debug("omap_aes_read(" #offset ")\n");		\
+	} while (0)
+
+static inline u32 omap_aes_read_1(struct omap_aes_dev *dd, u32 offset)
+#else
 static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
+#endif
 {
 	return __raw_readl(dd->io_base + offset);
 }
 
+#ifdef DEBUG
+#define omap_aes_write(dd, offset, value)				\
+	do {								\
+		pr_debug("omap_aes_write(" #offset "=%x) value=%d\n",	\
+			 offset, value);				\
+		omap_aes_write_1(dd, offset, value);			\
+	} while (0)
+
+static inline void omap_aes_write_1(struct omap_aes_dev *dd, u32 offset,
+				  u32 value)
+#else
 static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
 				  u32 value)
+#endif
 {
 	__raw_writel(value, dd->io_base + offset);
 }
-- 
1.7.9.5

