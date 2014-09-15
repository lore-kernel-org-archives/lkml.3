Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbaIOWRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:17:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136AbaIOWRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 089/187] [media] xc5000: Fix get_frequency()
Date: Mon, 15 Sep 2014 15:08:19 -0700
Message-Id: <1410818997-9432-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit a3eec916cbc17dc1aaa3ddf120836cd5200eb4ef upstream.

The programmed frequency on xc5000 is not the middle
frequency, but the initial frequency on the bandwidth range.
However, the DVB API works with the middle frequency.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/tuners/xc5000.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 5cd09a6..b2d9e9c 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -55,7 +55,7 @@ struct xc5000_priv {
 
 	u32 if_khz;
 	u16 xtal_khz;
-	u32 freq_hz;
+	u32 freq_hz, freq_offset;
 	u32 bandwidth;
 	u8  video_standard;
 	u8  rf_mode;
@@ -755,13 +755,13 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	case SYS_ATSC:
 		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
-		priv->freq_hz = freq - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = DTV6;
 		break;
 	case SYS_DVBC_ANNEX_B:
 		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
-		priv->freq_hz = freq - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = DTV6;
 		break;
 	case SYS_ISDBT:
@@ -776,15 +776,15 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		switch (bw) {
 		case 6000000:
 			priv->video_standard = DTV6;
-			priv->freq_hz = freq - 1750000;
+			priv->freq_offset = 1750000;
 			break;
 		case 7000000:
 			priv->video_standard = DTV7;
-			priv->freq_hz = freq - 2250000;
+			priv->freq_offset = 2250000;
 			break;
 		case 8000000:
 			priv->video_standard = DTV8;
-			priv->freq_hz = freq - 2750000;
+			priv->freq_offset = 2750000;
 			break;
 		default:
 			printk(KERN_ERR "xc5000 bandwidth not set!\n");
@@ -798,15 +798,15 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		priv->rf_mode = XC_RF_MODE_CABLE;
 		if (bw <= 6000000) {
 			priv->video_standard = DTV6;
-			priv->freq_hz = freq - 1750000;
+			priv->freq_offset = 1750000;
 			b = 6;
 		} else if (bw <= 7000000) {
 			priv->video_standard = DTV7;
-			priv->freq_hz = freq - 2250000;
+			priv->freq_offset = 2250000;
 			b = 7;
 		} else {
 			priv->video_standard = DTV7_8;
-			priv->freq_hz = freq - 2750000;
+			priv->freq_offset = 2750000;
 			b = 8;
 		}
 		dprintk(1, "%s() Bandwidth %dMHz (%d)\n", __func__,
@@ -817,6 +817,8 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
+	priv->freq_hz = freq - priv->freq_offset;
+
 	dprintk(1, "%s() frequency=%d (compensated to %d)\n",
 		__func__, freq, priv->freq_hz);
 
@@ -1067,7 +1069,7 @@ static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	dprintk(1, "%s()\n", __func__);
-	*freq = priv->freq_hz;
+	*freq = priv->freq_hz + priv->freq_offset;
 	return 0;
 }
 
-- 
1.9.1

