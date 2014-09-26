Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaIZJqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbaIZJqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 033/142] media: xc4000: Fix get_frequency()
Date: Fri, 26 Sep 2014 11:44:04 +0200
Message-Id: <72509907c5be4a956e93b008135d69ffee5d0692.1411724723.git.jslaby@suse.cz>
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

commit 4c07e32884ab69574cfd9eb4de3334233c938071 upstream.

The programmed frequency on xc4000 is not the middle
frequency, but the initial frequency on the bandwidth range.
However, the DVB API works with the middle frequency.

This works fine on set_frontend, as the device calculates
the needed offset. However, at get_frequency(), the returned
value is the initial frequency. That's generally not a big
problem on most drivers, however, starting with changeset
6fe1099c7aec, the frequency drift is taken into account at
dib7000p driver.

This broke support for PCTV 340e, with uses dib7000p demod and
xc4000 tuner.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/tuners/xc4000.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 2018befabb5a..e71decbfd0af 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -93,7 +93,7 @@ struct xc4000_priv {
 	struct firmware_description *firm;
 	int	firm_size;
 	u32	if_khz;
-	u32	freq_hz;
+	u32	freq_hz, freq_offset;
 	u32	bandwidth;
 	u8	video_standard;
 	u8	rf_mode;
@@ -1157,14 +1157,14 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 	case SYS_ATSC:
 		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
-		priv->freq_hz = c->frequency - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = XC4000_DTV6;
 		type = DTV6;
 		break;
 	case SYS_DVBC_ANNEX_B:
 		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
-		priv->freq_hz = c->frequency - 1750000;
+		priv->freq_offset = 1750000;
 		priv->video_standard = XC4000_DTV6;
 		type = DTV6;
 		break;
@@ -1173,23 +1173,23 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 		dprintk(1, "%s() OFDM\n", __func__);
 		if (bw == 0) {
 			if (c->frequency < 400000000) {
-				priv->freq_hz = c->frequency - 2250000;
+				priv->freq_offset = 2250000;
 			} else {
-				priv->freq_hz = c->frequency - 2750000;
+				priv->freq_offset = 2750000;
 			}
 			priv->video_standard = XC4000_DTV7_8;
 			type = DTV78;
 		} else if (bw <= 6000000) {
 			priv->video_standard = XC4000_DTV6;
-			priv->freq_hz = c->frequency - 1750000;
+			priv->freq_offset = 1750000;
 			type = DTV6;
 		} else if (bw <= 7000000) {
 			priv->video_standard = XC4000_DTV7;
-			priv->freq_hz = c->frequency - 2250000;
+			priv->freq_offset = 2250000;
 			type = DTV7;
 		} else {
 			priv->video_standard = XC4000_DTV8;
-			priv->freq_hz = c->frequency - 2750000;
+			priv->freq_offset = 2750000;
 			type = DTV8;
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
@@ -1200,6 +1200,8 @@ static int xc4000_set_params(struct dvb_frontend *fe)
 		goto fail;
 	}
 
+	priv->freq_hz = c->frequency - priv->freq_offset;
+
 	dprintk(1, "%s() frequency=%d (compensated)\n",
 		__func__, priv->freq_hz);
 
@@ -1520,7 +1522,7 @@ static int xc4000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 
-	*freq = priv->freq_hz;
+	*freq = priv->freq_hz + priv->freq_offset;
 
 	if (debug) {
 		mutex_lock(&priv->lock);
-- 
2.1.0

