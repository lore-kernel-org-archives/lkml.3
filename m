Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3CTF2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:28:40 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41907 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3CTF2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:28:38 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3] davinci: vpif: Fix module build for capture and display
Date: Wed, 20 Mar 2013 10:58:27 +0530
Message-Id: <1363757307-12635-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

export the symbols which are used by two modules vpif_capture and
vpif_display. renamed "ch_params" to "vpif_ch_params" so as to avoid
name collision.

This patch fixes following error:
ERROR: "ch_params" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "ch_params" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
make[1]: *** [__modpost] Error 1

Reported-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Changes for v3:
 1: prefixed "ch_params" with driver name to make it "vpif_ch_params"
    as pointed by Mauro.

 Changes for v2:
 1: use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL() as pointed by
    Sekhar.

 drivers/media/platform/davinci/vpif.c         |   10 +++++++---
 drivers/media/platform/davinci/vpif.h         |    2 +-
 drivers/media/platform/davinci/vpif_capture.c |    2 +-
 drivers/media/platform/davinci/vpif_display.c |    2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 28638a8..3bc4db8 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -44,13 +44,15 @@ static struct resource	*res;
 spinlock_t vpif_lock;
 
 void __iomem *vpif_base;
+EXPORT_SYMBOL_GPL(vpif_base);
+
 struct clk *vpif_clk;
 
 /**
- * ch_params: video standard configuration parameters for vpif
+ * vpif_ch_params: video standard configuration parameters for vpif
  * The table must include all presets from supported subdevices.
  */
-const struct vpif_channel_config_params ch_params[] = {
+const struct vpif_channel_config_params vpif_ch_params[] = {
 	/* HDTV formats */
 	{
 		.name = "480p59_94",
@@ -220,8 +222,10 @@ const struct vpif_channel_config_params ch_params[] = {
 		.stdid = V4L2_STD_625_50,
 	},
 };
+EXPORT_SYMBOL_GPL(vpif_ch_params);
 
-const unsigned int vpif_ch_params_count = ARRAY_SIZE(ch_params);
+const unsigned int vpif_ch_params_count = ARRAY_SIZE(vpif_ch_params);
+EXPORT_SYMBOL_GPL(vpif_ch_params_count);
 
 static inline void vpif_wr_bit(u32 reg, u32 bit, u32 val)
 {
diff --git a/drivers/media/platform/davinci/vpif.h b/drivers/media/platform/davinci/vpif.h
index a1ab6a0..9956e67 100644
--- a/drivers/media/platform/davinci/vpif.h
+++ b/drivers/media/platform/davinci/vpif.h
@@ -638,7 +638,7 @@ struct vpif_channel_config_params {
 };
 
 extern const unsigned int vpif_ch_params_count;
-extern const struct vpif_channel_config_params ch_params[];
+extern const struct vpif_channel_config_params vpif_ch_params[];
 
 struct vpif_video_params;
 struct vpif_params;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b15e948..1846cc5 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -563,7 +563,7 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	vpif_dbg(2, debug, "vpif_update_std_info\n");
 
 	for (index = 0; index < vpif_ch_params_count; index++) {
-		config = &ch_params[index];
+		config = &vpif_ch_params[index];
 		if (config->hd_sd == 0) {
 			vpif_dbg(2, debug, "SD format\n");
 			if (config->stdid & vid_ch->stdid) {
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index efdd462..48ed400 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -511,7 +511,7 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	int i;
 
 	for (i = 0; i < vpif_ch_params_count; i++) {
-		config = &ch_params[i];
+		config = &vpif_ch_params[i];
 		if (config->hd_sd == 0) {
 			vpif_dbg(2, debug, "SD format\n");
 			if (config->stdid & vid_ch->stdid) {
-- 
1.7.4.1

