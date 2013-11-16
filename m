Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3KPADJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:03:09 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33316 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3KPACA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:02:00 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>, Chris Ball <cjb@laptop.org>,
        Balaji T K <balajitk@ti.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 04/23] mmc: omap: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:07 +0200
Message-Id: <1384560086-11994-5-git-send-email-taras.kondratiuk@linaro.org>
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
 drivers/mmc/host/omap.c       |    4 ++--
 drivers/mmc/host/omap_hsmmc.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index b94f38e..ef2d088 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -79,8 +79,8 @@
 #define mmc_omap2()	(!mmc_omap1())
 
 #define OMAP_MMC_REG(host, reg)		(OMAP_MMC_REG_##reg << (host)->reg_shift)
-#define OMAP_MMC_READ(host, reg)	__raw_readw((host)->virt_base + OMAP_MMC_REG(host, reg))
-#define OMAP_MMC_WRITE(host, reg, val)	__raw_writew((val), (host)->virt_base + OMAP_MMC_REG(host, reg))
+#define OMAP_MMC_READ(host, reg)        readw_relaxed((host)->virt_base + OMAP_MMC_REG(host, reg))
+#define OMAP_MMC_WRITE(host, reg, val)	writew_relaxed((val), (host)->virt_base + OMAP_MMC_REG(host, reg))
 
 /*
  * Command types
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 6ac63df..fbbbfc0 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -135,10 +135,10 @@
  * MMC Host controller read/write API's
  */
 #define OMAP_HSMMC_READ(base, reg)	\
-	__raw_readl((base) + OMAP_HSMMC_##reg)
+	readl_relaxed((base) + OMAP_HSMMC_##reg)
 
 #define OMAP_HSMMC_WRITE(base, reg, val) \
-	__raw_writel((val), (base) + OMAP_HSMMC_##reg)
+	writel_relaxed((val), (base) + OMAP_HSMMC_##reg)
 
 struct omap_hsmmc_next {
 	unsigned int	dma_len;
-- 
1.7.9.5

