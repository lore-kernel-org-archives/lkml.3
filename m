Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaIOVUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:20:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaIOT0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.16 003/158] media: xc5000: Fix get_frequency()
Date: Mon, 15 Sep 2014 12:24:02 -0700
Message-Id: <20140915192542.977247788@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit a3eec916cbc17dc1aaa3ddf120836cd5200eb4ef upstream.

The programmed frequency on xc5000 is not the middle
frequency, but the initial frequency on the bandwidth range.
However, the DVB API works with the middle frequency.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/tuners/xc5000.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -56,7 +56,7 @@ struct xc5000_priv {
 
 	u32 if_khz;
 	u16 xtal_khz;
-	u32 freq_hz;
+	u32 freq_hz, freq_offset;
 	u32 bandwidth;
 	u8  video_standard;
 	u8  rf_mode;
@@ -749,13 +749,13 @@ static int xc5000_set_params(struct dvb_
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
@@ -770,15 +770,15 @@ static int xc5000_set_params(struct dvb_
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
@@ -792,15 +792,15 @@ static int xc5000_set_params(struct dvb_
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
@@ -811,6 +811,8 @@ static int xc5000_set_params(struct dvb_
 		return -EINVAL;
 	}
 
+	priv->freq_hz = freq - priv->freq_offset;
+
 	dprintk(1, "%s() frequency=%d (compensated to %d)\n",
 		__func__, freq, priv->freq_hz);
 
@@ -1061,7 +1063,7 @@ static int xc5000_get_frequency(struct d
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 	dprintk(1, "%s()\n", __func__);
-	*freq = priv->freq_hz;
+	*freq = priv->freq_hz + priv->freq_offset;
 	return 0;
 }
 


