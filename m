Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaBRPau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:30:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50475 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125AbaBRPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:30:49 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 04/17 v2] ASoC: dapm: Add unlocked version of snd_soc_dapm_sync
Date: Tue, 18 Feb 2014 15:22:15 +0000
Message-Id: <1392736948-26623-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will often call sync after several functions that require the DAPM
mutex to be held. Rather than release and immediately relock the mutex
provide an unlocked function for this situation.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 include/sound/soc-dapm.h |    1 +
 sound/soc/soc-dapm.c     |   27 ++++++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 6e89ef6..3b99176 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -461,6 +461,7 @@ int snd_soc_dapm_nc_pin_unlocked(struct snd_soc_dapm_context *dapm,
 int snd_soc_dapm_get_pin_status(struct snd_soc_dapm_context *dapm,
 				const char *pin);
 int snd_soc_dapm_sync(struct snd_soc_dapm_context *dapm);
+int snd_soc_dapm_sync_unlocked(struct snd_soc_dapm_context *dapm);
 int snd_soc_dapm_force_enable_pin(struct snd_soc_dapm_context *dapm,
 				  const char *pin);
 int snd_soc_dapm_force_enable_pin_unlocked(struct snd_soc_dapm_context *dapm,
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 1a3fe85..cf8ba48 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2342,18 +2342,18 @@ static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
 }
 
 /**
- * snd_soc_dapm_sync - scan and power dapm paths
+ * snd_soc_dapm_sync_unlocked - scan and power dapm paths
  * @dapm: DAPM context
  *
  * Walks all dapm audio paths and powers widgets according to their
  * stream or path usage.
  *
+ * Requires external locking.
+ *
  * Returns 0 for success.
  */
-int snd_soc_dapm_sync(struct snd_soc_dapm_context *dapm)
+int snd_soc_dapm_sync_unlocked(struct snd_soc_dapm_context *dapm)
 {
-	int ret;
-
 	/*
 	 * Suppress early reports (eg, jacks syncing their state) to avoid
 	 * silly DAPM runs during card startup.
@@ -2361,8 +2361,25 @@ int snd_soc_dapm_sync(struct snd_soc_dapm_context *dapm)
 	if (!dapm->card || !dapm->card->instantiated)
 		return 0;
 
+	return dapm_power_widgets(dapm->card, SND_SOC_DAPM_STREAM_NOP);
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_sync_unlocked);
+
+/**
+ * snd_soc_dapm_sync - scan and power dapm paths
+ * @dapm: DAPM context
+ *
+ * Walks all dapm audio paths and powers widgets according to their
+ * stream or path usage.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_dapm_sync(struct snd_soc_dapm_context *dapm)
+{
+	int ret;
+
 	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
-	ret = dapm_power_widgets(dapm->card, SND_SOC_DAPM_STREAM_NOP);
+	ret = snd_soc_dapm_sync_unlocked(dapm);
 	mutex_unlock(&dapm->card->dapm_mutex);
 	return ret;
 }
-- 
1.7.2.5

