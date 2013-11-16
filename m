Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3KPAGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:06:53 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45165 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3KPABm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:42 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 08/23] crypto: omap-aes - raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:11 +0200
Message-Id: <1384560086-11994-9-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 drivers/crypto/omap-aes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce791c2..777ae0a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -195,7 +195,7 @@ static DEFINE_SPINLOCK(list_lock);
 #define omap_aes_read(dd, offset)				\
 ({								\
 	int _read_ret;						\
-	_read_ret = __raw_readl(dd->io_base + offset);		\
+	_read_ret = readl_relaxed(dd->io_base + offset);		\
 	pr_debug("omap_aes_read(" #offset "=%#x)= %#x\n",	\
 		 offset, _read_ret);				\
 	_read_ret;						\
@@ -203,7 +203,7 @@ static DEFINE_SPINLOCK(list_lock);
 #else
 static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
 {
-	return __raw_readl(dd->io_base + offset);
+	return readl_relaxed(dd->io_base + offset);
 }
 #endif
 
@@ -212,13 +212,13 @@ static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
 	do {								\
 		pr_debug("omap_aes_write(" #offset "=%#x) value=%#x\n",	\
 			 offset, value);				\
-		__raw_writel(value, dd->io_base + offset);		\
+		writel_relaxed(value, dd->io_base + offset);		\
 	} while (0)
 #else
 static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
 				  u32 value)
 {
-	__raw_writel(value, dd->io_base + offset);
+	writel_relaxed(value, dd->io_base + offset);
 }
 #endif
 
-- 
1.7.9.5

