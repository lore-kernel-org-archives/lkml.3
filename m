Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3KPAGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:06:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52491 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3KPABo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:44 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 09/23] crypto: omap-sham - raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:12 +0200
Message-Id: <1384560086-11994-10-git-send-email-taras.kondratiuk@linaro.org>
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
 drivers/crypto/omap-sham.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8bdde57..b011b97 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -244,13 +244,13 @@ static struct omap_sham_drv sham = {
 
 static inline u32 omap_sham_read(struct omap_sham_dev *dd, u32 offset)
 {
-	return __raw_readl(dd->io_base + offset);
+	return readl_relaxed(dd->io_base + offset);
 }
 
 static inline void omap_sham_write(struct omap_sham_dev *dd,
 					u32 offset, u32 value)
 {
-	__raw_writel(value, dd->io_base + offset);
+	writel_relaxed(value, dd->io_base + offset);
 }
 
 static inline void omap_sham_write_mask(struct omap_sham_dev *dd, u32 address,
-- 
1.7.9.5

