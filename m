Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3FPUye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 16:54:34 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:40013 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3FPUyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 16:54:31 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [RFC PATCH 01/11] dma: amba-pl08x: Use bitmap to pass variant specific quirks
Date: Sun, 16 Jun 2013 22:54:08 +0200
Message-Id: <1371416058-22047-2-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of defining new bool field in vendor_data struct for each quirk,
it is more reasonable to use a single flags field and make each quirk
use single bits.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 8bad254..d443a68 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -93,18 +93,22 @@
 static struct amba_driver pl08x_amba_driver;
 struct pl08x_driver_data;
 
+/** Controller supports dual AHB masters. */
+#define PL08X_IS_DUALMASTER	(1 << 0)
+/**
+ * Controller has Nomadik security extension bits that need to be checked
+ * for permission before use and some registers are missing.
+ */
+#define PL08X_IS_NOMADIK	(1 << 1)
+
 /**
  * struct vendor_data - vendor-specific config parameters for PL08x derivatives
  * @channels: the number of channels available in this variant
- * @dualmaster: whether this version supports dual AHB masters or not.
- * @nomadik: whether the channels have Nomadik security extension bits
- *	that need to be checked for permission before use and some registers are
- *	missing
+ * @flags: Vendor-specific flags, see PL08X_IS_*
  */
 struct vendor_data {
 	u8 channels;
-	bool dualmaster;
-	bool nomadik;
+	u32 flags;
 };
 
 /*
@@ -1391,7 +1395,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 	/* Both to be incremented or the code will break */
 	txd->cctl |= PL080_CONTROL_SRC_INCR | PL080_CONTROL_DST_INCR;
 
-	if (pl08x->vd->dualmaster)
+	if (pl08x->vd->flags & PL08X_IS_DUALMASTER)
 		txd->cctl |= pl08x_select_bus(pl08x->mem_buses,
 					      pl08x->mem_buses);
 
@@ -1612,7 +1616,7 @@ bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
 static void pl08x_ensure_on(struct pl08x_driver_data *pl08x)
 {
 	/* The Nomadik variant does not have the config register */
-	if (pl08x->vd->nomadik)
+	if (pl08x->vd->flags & PL08X_IS_NOMADIK)
 		return;
 	writel(PL080_CONFIG_ENABLE, pl08x->base + PL080_CONFIG);
 }
@@ -1897,7 +1901,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	/* By default, AHB1 only.  If dualmaster, from platform */
 	pl08x->lli_buses = PL08X_AHB1;
 	pl08x->mem_buses = PL08X_AHB1;
-	if (pl08x->vd->dualmaster) {
+	if (pl08x->vd->flags & PL08X_IS_DUALMASTER) {
 		pl08x->lli_buses = pl08x->pd->lli_buses;
 		pl08x->mem_buses = pl08x->pd->mem_buses;
 	}
@@ -1954,7 +1958,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		 * down for the secure world only. Lock up these channels
 		 * by perpetually serving a dummy virtual channel.
 		 */
-		if (vd->nomadik) {
+		if (vd->flags & PL08X_IS_NOMADIK) {
 			u32 val;
 
 			val = readl(ch->base + PL080_CH_CONFIG);
@@ -2039,18 +2043,17 @@ out_no_pl08x:
 /* PL080 has 8 channels and the PL080 have just 2 */
 static struct vendor_data vendor_pl080 = {
 	.channels = 8,
-	.dualmaster = true,
+	.flags = PL08X_IS_DUALMASTER,
 };
 
 static struct vendor_data vendor_nomadik = {
 	.channels = 8,
-	.dualmaster = true,
-	.nomadik = true,
+	.flags = PL08X_IS_DUALMASTER | PL08X_IS_NOMADIK,
 };
 
 static struct vendor_data vendor_pl081 = {
 	.channels = 2,
-	.dualmaster = false,
+	.flags = 0,
 };
 
 static struct amba_id pl08x_ids[] = {
-- 
1.8.2.1

