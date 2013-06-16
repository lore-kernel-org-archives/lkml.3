Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3FPUyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 16:54:47 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:40532 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3FPUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 16:54:42 -0400
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
Subject: [RFC PATCH 05/11] dma: amba-pl08x: Add support for different maximum transfer size
Date: Sun, 16 Jun 2013 22:54:12 +0200
Message-Id: <1371416058-22047-6-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PL080S has separate register to store transfer size in, allowing single
transfer to be much larger than in standard PL080.

This patch makes the amba-pl08x driver aware of this and removes writing
transfer size to reserved bits of CH_CONTROL register on PL080S, which
was not a problem witn transfer sizes fitting the original bitfield
of PL080, but now would overwrite other fields.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d1f1333..eb10eb8 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -112,6 +112,7 @@ struct vendor_data {
 	u8 config_offset;
 	u8 channels;
 	u32 flags;
+	u32 max_transfer_size;
 };
 
 /*
@@ -843,7 +844,10 @@ static inline void prep_byte_width_lli(struct pl08x_driver_data *pl08x,
 		struct pl08x_lli_build_data *bd,
 		u32 *cctl, u32 len, int num_llis, size_t *total_bytes)
 {
-	*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
+	if (pl08x->vd->flags & PL08X_IS_PL080S)
+		*cctl = pl08x_cctl_bits(*cctl, 1, 1, 0);
+	else
+		*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
 	pl08x_fill_lli_for_desc(bd, num_llis, len, *cctl, len);
 	(*total_bytes) += len;
 }
@@ -992,7 +996,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			 * MIN(buswidths)
 			 */
 			max_bytes_per_lli = bd.srcbus.buswidth *
-				PL080_CONTROL_TRANSFER_SIZE_MASK;
+						pl08x->vd->max_transfer_size;
 			dev_vdbg(&pl08x->adev->dev,
 				"%s max bytes per lli = %zu\n",
 				__func__, max_bytes_per_lli);
@@ -1025,8 +1029,14 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 					"size 0x%08zx (remainder 0x%08zx)\n",
 					__func__, lli_len, bd.remainder);
 
-				cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
-					bd.dstbus.buswidth, tsize);
+				if (pl08x->vd->flags & PL08X_IS_PL080S)
+					cctl = pl08x_cctl_bits(cctl,
+						bd.srcbus.buswidth,
+						bd.dstbus.buswidth, 0);
+				else
+					cctl = pl08x_cctl_bits(cctl,
+						bd.srcbus.buswidth,
+						bd.dstbus.buswidth, tsize);
 				pl08x_fill_lli_for_desc(&bd, num_llis++,
 						lli_len, cctl, tsize);
 				total_bytes += lli_len;
@@ -2092,24 +2102,28 @@ static struct vendor_data vendor_pl080 = {
 	.channels = 8,
 	.flags = PL08X_IS_DUALMASTER,
 	.config_offset = PL080_CH_CONFIG,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_nomadik = {
 	.channels = 8,
 	.flags = PL08X_IS_DUALMASTER | PL08X_IS_NOMADIK,
 	.config_offset = PL080_CH_CONFIG,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_pl080s = {
 	.channels = 8,
 	.flags = PL08X_IS_DUALMASTER | PL08X_IS_PL080S,
 	.config_offset = PL080S_CH_CONFIG,
+	.max_transfer_size = PL080S_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_pl081 = {
 	.channels = 2,
 	.flags = 0,
 	.config_offset = PL080_CH_CONFIG,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct amba_id pl08x_ids[] = {
-- 
1.8.2.1

