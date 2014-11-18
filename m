Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaKRRmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:42:02 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52852 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753680AbaKRRl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:41:58 -0500
Message-ID: <546B84C6.3090809@arm.com>
Date: Tue, 18 Nov 2014 17:41:26 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] drm: i2c: tda998x: Retry fetching the EDID if it fails first
 time.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fetching the EDID from a connected monitor is an automated thing
with NXP TDA19988. But on some boards the fetching fails for the
first time silently without any indication that an error has occured.
More than that, subsequent fetches of the EDID succeed until the
monitor(s) are unplugged.

Add a function to validate the read EDID and retry if the block
retrieved is not valid.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/gpu/drm/i2c/tda998x_drv.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d476279..025adc0 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1066,11 +1066,36 @@ static int read_edid_block(struct tda998x_priv *priv, uint8_t *buf, int blk)
 	return 0;
 }
 
+static int
+read_validate_edid_block(struct tda998x_priv *priv, uint8_t *buf, int blk)
+{
+	bool print_bad_edid = drm_debug & DRM_UT_KMS;
+	int ret;
+	int retries = 1;
+
+	do
+	{
+		bool print_bad = print_bad_edid && (retries == 0);
+
+		ret = read_edid_block(priv, buf, blk);
+		/* Fail on I2C error */
+		if (ret)
+			break;
+
+		/* But retry checksum errored blocks */
+		if (drm_edid_block_valid(buf, blk, print_bad))
+			break;
+		else
+			ret = -EINVAL;
+	} while (retries-- > 0);
+
+	return ret;
+}
+
 static uint8_t *do_get_edid(struct tda998x_priv *priv)
 {
 	int j, valid_extensions = 0;
 	uint8_t *block, *new;
-	bool print_bad_edid = drm_debug & DRM_UT_KMS;
 
 	if ((block = kmalloc(EDID_LENGTH, GFP_KERNEL)) == NULL)
 		return NULL;
@@ -1079,10 +1104,7 @@ static uint8_t *do_get_edid(struct tda998x_priv *priv)
 		reg_clear(priv, REG_TX4, TX4_PD_RAM);
 
 	/* base block fetch */
-	if (read_edid_block(priv, block, 0))
-		goto fail;
-
-	if (!drm_edid_block_valid(block, 0, print_bad_edid))
+	if (read_validate_edid_block(priv, block, 0))
 		goto fail;
 
 	/* if there's no extensions, we're done */
@@ -1096,10 +1118,8 @@ static uint8_t *do_get_edid(struct tda998x_priv *priv)
 
 	for (j = 1; j <= block[0x7e]; j++) {
 		uint8_t *ext_block = block + (valid_extensions + 1) * EDID_LENGTH;
-		if (read_edid_block(priv, ext_block, j))
-			goto fail;
 
-		if (!drm_edid_block_valid(ext_block, j, print_bad_edid))
+		if (read_validate_edid_block(priv, ext_block, j))
 			goto fail;
 
 		valid_extensions++;
-- 
1.7.1

