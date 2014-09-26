Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaIZJqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbaIZJqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 032/142] media: xc5000: Fix get_frequency()
Date: Fri, 26 Sep 2014 11:44:03 +0200
Message-Id: <1a590d34144b5d715d59a4c1270dc91f6bed5f24.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a3eec916cbc17dc1aaa3ddf120836cd5200eb4ef upstream.

The programmed frequency on xc5000 is not the middle
frequency, but the initial frequency on the bandwidth range.
However, the DVB API works with the middle frequency.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/tuners/xc5000.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 5cd09a681b6a..b2d9e9cb97f7 100644
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
2.1.0

