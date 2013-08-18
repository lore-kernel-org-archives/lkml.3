Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3HRCpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:45:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52865 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab3HRCnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:46 -0400
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
Subject: [PATCH v2 02/14] crypto: omap-aes: Add useful debug macros
Date: Sat, 17 Aug 2013 21:42:23 -0500
Message-ID: <1376793755-30478-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DEBUG is enabled, these macros can be used to print variables in integer
and hex format, and clearly display which registers, offsets and values are
being read/written , including printing the names of the offsets and their values.

Note:
This patch results in a checkpatch error that cannot be fixed.
ERROR: Macros with multiple statements should be enclosed in a do - while loop
+#define omap_aes_read(dd, offset)                                      \
+       __raw_readl(dd->io_base + offset);                              \
+       pr_debug("omap_aes_read(" #offset ")\n");

Using do-while loop will break a lot of code such as:
ret = omap_aes_read(..);

On the other hand, not using a do-while loop will only result in a spurious
debug print message when DEBUG is enabled, all other issues would be caught at
compile time if any. As such, there is no code in the driver as of now that
requires a do-while loop, but there is code that will break if a do-while loop
is used in the macro so we ignore the checkpatch error in this case.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ee15b0f..26b802b 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -13,7 +13,8 @@
  *
  */
 
-#define pr_fmt(fmt) "%s: " fmt, __func__
+#define prn(num) pr_debug(#num "=%d\n", num)
+#define prx(num) pr_debug(#num "=%x\n", num)
 
 #include <linux/err.h>
 #include <linux/module.h>
@@ -172,16 +173,35 @@ struct omap_aes_dev {
 static LIST_HEAD(dev_list);
 static DEFINE_SPINLOCK(list_lock);
 
+#ifdef DEBUG
+/*
+ * Note: In DEBUG mode, when using conditionals, omap_aes_read _must_
+ * be surrounded by braces otherwise you may see spurious prints.
+ */
+#define omap_aes_read(dd, offset)					\
+	__raw_readl(dd->io_base + offset);				\
+	pr_debug("omap_aes_read(" #offset ")\n");
+#else
 static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
 {
 	return __raw_readl(dd->io_base + offset);
 }
+#endif
 
+#ifdef DEBUG
+#define omap_aes_write(dd, offset, value)				\
+	do {								\
+		pr_debug("omap_aes_write(" #offset "=%x) value=%d\n",	\
+			 offset, value);				\
+		__raw_writel(value, dd->io_base + offset);		\
+	} while (0)
+#else
 static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
 				  u32 value)
 {
 	__raw_writel(value, dd->io_base + offset);
 }
+#endif
 
 static inline void omap_aes_write_mask(struct omap_aes_dev *dd, u32 offset,
 					u32 value, u32 mask)
-- 
1.7.9.5

