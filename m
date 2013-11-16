Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3KPAC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:02:28 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41044 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3KPABl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:41 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Deepak Saxena <dsaxena@plexity.net>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
Subject: [RFC 07/23] hwrng: omap - raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:10 +0200
Message-Id: <1384560086-11994-8-git-send-email-taras.kondratiuk@linaro.org>
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
 drivers/char/hw_random/omap-rng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 9b89ff4..d68cf8a 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -131,13 +131,13 @@ struct omap_rng_dev {
 
 static inline u32 omap_rng_read(struct omap_rng_dev *priv, u16 reg)
 {
-	return __raw_readl(priv->base + priv->pdata->regs[reg]);
+	return readl_relaxed(priv->base + priv->pdata->regs[reg]);
 }
 
 static inline void omap_rng_write(struct omap_rng_dev *priv, u16 reg,
 				      u32 val)
 {
-	__raw_writel(val, priv->base + priv->pdata->regs[reg]);
+	writel_relaxed(val, priv->base + priv->pdata->regs[reg]);
 }
 
 static int omap_rng_data_present(struct hwrng *rng, int wait)
-- 
1.7.9.5

