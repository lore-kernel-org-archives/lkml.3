Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3FVUn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:43:57 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:50315 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3FVUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:43:24 -0400
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
Subject: [RFC PATCH v2 05/12] dmaengine: PL08x: Add support for different maximum transfer size
Date: Sat, 22 Jun 2013 22:42:37 +0200
Message-Id: <1371933764-24875-6-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
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
 drivers/dma/amba-pl08x.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 103bc1a..89b8120 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -122,6 +122,7 @@ struct vendor_data {
 	bool dualmaster;
 	bool nomadik;
 	bool pl080s;
+	u32 max_transfer_size;
 };
 
 	u32 cctl1;
@@ -772,6 +773,7 @@ static inline u32 pl08x_cctl_bits(u32 cctl, u8 srcwidth, u8 dstwidth,
 		break;
 	}
 
+	tsize &= PL080_CONTROL_TRANSFER_SIZE_MASK;
 	retbits |= tsize << PL080_CONTROL_TRANSFER_SIZE_SHIFT;
 	return retbits;
 }
@@ -1001,7 +1003,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			 * MIN(buswidths)
 			 */
 			max_bytes_per_lli = bd.srcbus.buswidth *
-				PL080_CONTROL_TRANSFER_SIZE_MASK;
+						pl08x->vd->max_transfer_size;
 			dev_vdbg(&pl08x->adev->dev,
 				"%s max bytes per lli = %zu\n",
 				__func__, max_bytes_per_lli);
@@ -2111,6 +2113,7 @@ static struct vendor_data vendor_pl080 = {
 	.config_offset = PL080_CH_CONFIG,
 	.channels = 8,
 	.dualmaster = true,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_nomadik = {
@@ -2118,18 +2121,21 @@ static struct vendor_data vendor_nomadik = {
 	.channels = 8,
 	.dualmaster = true,
 	.nomadik = true,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_pl080s = {
 	.config_offset = PL080S_CH_CONFIG,
 	.channels = 8,
 	.pl080s = true,
+	.max_transfer_size = PL080S_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct vendor_data vendor_pl081 = {
 	.config_offset = PL080_CH_CONFIG,
 	.channels = 2,
 	.dualmaster = false,
+	.max_transfer_size = PL080_CONTROL_TRANSFER_SIZE_MASK,
 };
 
 static struct amba_id pl08x_ids[] = {
-- 
1.8.2.1

