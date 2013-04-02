Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324Ab3DBLof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:44:35 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:60053 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761292Ab3DBLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:44:32 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 2/3] media: davinci: vpbe: venc: move the enabling of vpss clocks to driver
Date: Tue,  2 Apr 2013 17:14:03 +0530
Message-Id: <1364903044-13752-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

The vpss clocks were enabled by calling a exported function from a driver
in a machine code. calling driver code from platform code is incorrect way.

This patch fixes this issue and calls the function from driver code itself.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_venc.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index f15f211..91d0272 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -202,6 +202,25 @@ static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
 	}
 }
 
+static void
+venc_enable_vpss_clock(int venc_type,
+		       enum vpbe_enc_timings_type type,
+		       unsigned int pclock)
+{
+	if (venc_type == VPBE_VERSION_1)
+		return;
+
+	if (venc_type == VPBE_VERSION_2 && (type == VPBE_ENC_STD ||
+	    (type == VPBE_ENC_DV_TIMINGS && pclock <= 27000000))) {
+		vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
+		vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
+		return;
+	}
+
+	if (venc_type == VPBE_VERSION_3 && type == VPBE_ENC_STD)
+		vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 0);
+}
+
 #define VDAC_CONFIG_SD_V3	0x0E21A6B6
 #define VDAC_CONFIG_SD_V2	0x081141CF
 /*
@@ -220,6 +239,7 @@ static int venc_set_ntsc(struct v4l2_subdev *sd)
 	if (pdata->setup_clock(VPBE_ENC_STD, V4L2_STD_525_60) < 0)
 		return -EINVAL;
 
+	venc_enable_vpss_clock(venc->venc_type, VPBE_ENC_STD, V4L2_STD_525_60);
 	venc_enabledigitaloutput(sd, 0);
 
 	if (venc->venc_type == VPBE_VERSION_3) {
@@ -265,6 +285,7 @@ static int venc_set_pal(struct v4l2_subdev *sd)
 	if (venc->pdata->setup_clock(VPBE_ENC_STD, V4L2_STD_625_50) < 0)
 		return -EINVAL;
 
+	venc_enable_vpss_clock(venc->venc_type, VPBE_ENC_STD, V4L2_STD_625_50);
 	venc_enabledigitaloutput(sd, 0);
 
 	if (venc->venc_type == VPBE_VERSION_3) {
@@ -319,6 +340,7 @@ static int venc_set_480p59_94(struct v4l2_subdev *sd)
 	if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 27000000) < 0)
 		return -EINVAL;
 
+	venc_enable_vpss_clock(venc->venc_type, VPBE_ENC_DV_TIMINGS, 27000000);
 	venc_enabledigitaloutput(sd, 0);
 
 	if (venc->venc_type == VPBE_VERSION_2)
@@ -366,6 +388,7 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
 	if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 27000000) < 0)
 		return -EINVAL;
 
+	venc_enable_vpss_clock(venc->venc_type, VPBE_ENC_DV_TIMINGS, 27000000);
 	venc_enabledigitaloutput(sd, 0);
 
 	if (venc->venc_type == VPBE_VERSION_2)
@@ -406,6 +429,7 @@ static int venc_set_720p60_internal(struct v4l2_subdev *sd)
 	if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 74250000) < 0)
 		return -EINVAL;
 
+	venc_enable_vpss_clock(venc->venc_type, VPBE_ENC_DV_TIMINGS, 74250000);
 	venc_enabledigitaloutput(sd, 0);
 
 	venc_write(sd, VENC_OSDCLK0, 0);
@@ -434,6 +458,7 @@ static int venc_set_1080i30_internal(struct v4l2_subdev *sd)
 	if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 74250000) < 0)
 		return -EINVAL;
 
+	venc_enable_vpss_clock(venc->venc_type, VPBE_ENC_DV_TIMINGS, 74250000);
 	venc_enabledigitaloutput(sd, 0);
 
 	venc_write(sd, VENC_OSDCLK0, 0);
-- 
1.7.4.1

