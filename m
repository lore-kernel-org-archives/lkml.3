Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967773Ab3DRQ70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:59:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32954 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967751Ab3DRQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:59:21 -0400
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: sameo@linux.intel.com
Cc: mchehab@redhat.com, andrew.smirnov@gmail.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] radio-si476x: vidioc_s* now uses a const parameter
Date: Thu, 18 Apr 2013 09:58:36 -0700
Message-Id: <1366304318-29620-11-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@redhat.com>

vidioc_s_tuner, vidioc_s_frequency and vidioc_s_register now
uses a constant argument. So, the driver reports warnings:

	drivers/media/radio/radio-si476x.c:1196:2: warning: initialization from incompatible pointer type [enabled by default]
	drivers/media/radio/radio-si476x.c:1196:2: warning: (near initialization for 'si4761_ioctl_ops.vidioc_s_tuner') [enabled by default]
	drivers/media/radio/radio-si476x.c:1199:2: warning: initialization from incompatible pointer type [enabled by default]
	drivers/media/radio/radio-si476x.c:1199:2: warning: (near initialization for 'si4761_ioctl_ops.vidioc_s_frequency') [enabled by default]
	drivers/media/radio/radio-si476x.c:1209:2: warning: initialization from incompatible pointer type [enabled by default]
	drivers/media/radio/radio-si476x.c:1209:2: warning: (near initialization for 'si4761_ioctl_ops.vidioc_s_register') [enabled by default]

This is due to a (soft) merge conflict, as both this driver and the
const patches were applied for the same Kernel version.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/radio/radio-si476x.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 0895a0c..9430c6a 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -472,7 +472,7 @@ static int si476x_radio_g_tuner(struct file *file, void *priv,
 }
 
 static int si476x_radio_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *tuner)
+				const struct v4l2_tuner *tuner)
 {
 	struct si476x_radio *radio = video_drvdata(file);
 
@@ -699,15 +699,16 @@ static int si476x_radio_g_frequency(struct file *file, void *priv,
 }
 
 static int si476x_radio_s_frequency(struct file *file, void *priv,
-				    struct v4l2_frequency *f)
+				    const struct v4l2_frequency *f)
 {
 	int err;
+	u32 freq = f->frequency;
 	struct si476x_tune_freq_args args;
 	struct si476x_radio *radio = video_drvdata(file);
 
 	const u32 midrange = (si476x_bands[SI476X_BAND_AM].rangehigh +
 			      si476x_bands[SI476X_BAND_FM].rangelow) / 2;
-	const int band = (f->frequency > midrange) ?
+	const int band = (freq > midrange) ?
 		SI476X_BAND_FM : SI476X_BAND_AM;
 	const enum si476x_func func = (band == SI476X_BAND_AM) ?
 		SI476X_FUNC_AM_RECEIVER : SI476X_FUNC_FM_RECEIVER;
@@ -718,11 +719,11 @@ static int si476x_radio_s_frequency(struct file *file, void *priv,
 
 	si476x_core_lock(radio->core);
 
-	f->frequency = clamp(f->frequency,
-			     si476x_bands[band].rangelow,
-			     si476x_bands[band].rangehigh);
+	freq = clamp(freq,
+		     si476x_bands[band].rangelow,
+		     si476x_bands[band].rangehigh);
 
-	if (si476x_radio_freq_is_inside_of_the_band(f->frequency,
+	if (si476x_radio_freq_is_inside_of_the_band(freq,
 						    SI476X_BAND_AM) &&
 	    (!si476x_core_has_am(radio->core) ||
 	     si476x_core_is_a_secondary_tuner(radio->core))) {
@@ -737,8 +738,7 @@ static int si476x_radio_s_frequency(struct file *file, void *priv,
 	args.zifsr		= false;
 	args.hd			= false;
 	args.injside		= SI476X_INJSIDE_AUTO;
-	args.freq		= v4l2_to_si476x(radio->core,
-						 f->frequency);
+	args.freq		= v4l2_to_si476x(radio->core, freq);
 	args.tunemode		= SI476X_TM_VALIDATED_NORMAL_TUNE;
 	args.smoothmetrics	= SI476X_SM_INITIALIZE_AUDIO;
 	args.antcap		= 0;
@@ -1046,7 +1046,7 @@ static int si476x_radio_g_register(struct file *file, void *fh,
 	return err;
 }
 static int si476x_radio_s_register(struct file *file, void *fh,
-				   struct v4l2_dbg_register *reg)
+				   const struct v4l2_dbg_register *reg)
 {
 
 	int err;
-- 
1.7.10.4

