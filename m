Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab3KPAEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:04:25 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63032 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3KPABv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:51 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [RFC 16/23] ASoC: omap: mcbsp, mcpdm, dmic: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:19 +0200
Message-Id: <1384560086-11994-17-git-send-email-taras.kondratiuk@linaro.org>
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
 sound/soc/omap/mcbsp.c      |   12 ++++++------
 sound/soc/omap/omap-dmic.c  |    4 ++--
 sound/soc/omap/omap-mcpdm.c |    4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/omap/mcbsp.c b/sound/soc/omap/mcbsp.c
index 83433fd..86c7538 100644
--- a/sound/soc/omap/mcbsp.c
+++ b/sound/soc/omap/mcbsp.c
@@ -36,10 +36,10 @@ static void omap_mcbsp_write(struct omap_mcbsp *mcbsp, u16 reg, u32 val)
 
 	if (mcbsp->pdata->reg_size == 2) {
 		((u16 *)mcbsp->reg_cache)[reg] = (u16)val;
-		__raw_writew((u16)val, addr);
+		writew_relaxed((u16)val, addr);
 	} else {
 		((u32 *)mcbsp->reg_cache)[reg] = val;
-		__raw_writel(val, addr);
+		writel_relaxed(val, addr);
 	}
 }
 
@@ -48,22 +48,22 @@ static int omap_mcbsp_read(struct omap_mcbsp *mcbsp, u16 reg, bool from_cache)
 	void __iomem *addr = mcbsp->io_base + reg * mcbsp->pdata->reg_step;
 
 	if (mcbsp->pdata->reg_size == 2) {
-		return !from_cache ? __raw_readw(addr) :
+		return !from_cache ? readw_relaxed(addr) :
 				     ((u16 *)mcbsp->reg_cache)[reg];
 	} else {
-		return !from_cache ? __raw_readl(addr) :
+		return !from_cache ? readl_relaxed(addr) :
 				     ((u32 *)mcbsp->reg_cache)[reg];
 	}
 }
 
 static void omap_mcbsp_st_write(struct omap_mcbsp *mcbsp, u16 reg, u32 val)
 {
-	__raw_writel(val, mcbsp->st_data->io_base_st + reg);
+	writel_relaxed(val, mcbsp->st_data->io_base_st + reg);
 }
 
 static int omap_mcbsp_st_read(struct omap_mcbsp *mcbsp, u16 reg)
 {
-	return __raw_readl(mcbsp->st_data->io_base_st + reg);
+	return readl_relaxed(mcbsp->st_data->io_base_st + reg);
 }
 
 #define MCBSP_READ(mcbsp, reg) \
diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index 12e566b..1bd531d 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -61,12 +61,12 @@ struct omap_dmic {
 
 static inline void omap_dmic_write(struct omap_dmic *dmic, u16 reg, u32 val)
 {
-	__raw_writel(val, dmic->io_base + reg);
+	writel_relaxed(val, dmic->io_base + reg);
 }
 
 static inline int omap_dmic_read(struct omap_dmic *dmic, u16 reg)
 {
-	return __raw_readl(dmic->io_base + reg);
+	return readl_relaxed(dmic->io_base + reg);
 }
 
 static inline void omap_dmic_start(struct omap_dmic *dmic)
diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index 90d2a7c..653ba1c 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -74,12 +74,12 @@ struct omap_mcpdm {
 
 static inline void omap_mcpdm_write(struct omap_mcpdm *mcpdm, u16 reg, u32 val)
 {
-	__raw_writel(val, mcpdm->io_base + reg);
+	writel_relaxed(val, mcpdm->io_base + reg);
 }
 
 static inline int omap_mcpdm_read(struct omap_mcpdm *mcpdm, u16 reg)
 {
-	return __raw_readl(mcpdm->io_base + reg);
+	return readl_relaxed(mcpdm->io_base + reg);
 }
 
 #ifdef DEBUG
-- 
1.7.9.5

