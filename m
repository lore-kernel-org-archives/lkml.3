Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161495Ab3LFNB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:01:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43926 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161478Ab3LFNBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oskar Schirmer <oskar@scara.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 083/272] ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm in unbalanced situations
Date: Fri,  6 Dec 2013 12:56:12 +0000
Message-Id: <1386334761-25517-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oskar Schirmer <oskar@scara.com>

commit fc7dc61d9a87011aaf8a6eb3144ebf9552adf5d2 upstream.

Unbalanced calls to snd_imx_pcm_trigger() may result in endless
FIQ activity and thus provoke eternal sound. While on the first glance,
the switch statement looks pretty symmetric, the SUSPEND/RESUME
pair is not: the suspend case comes along snd_pcm_suspend_all(),
which for fsl/imx-pcm-fiq is called only at snd_soc_suspend(),
but the resume case originates straight from the SNDRV_PCM_IOCTL_RESUME.
This way userland may provoke an unbalanced resume, which might cause
the fiq_enable counter to increase and never return to zero again,
so eventually imx_pcm_fiq is never disabled.

Simply removing the fiq_enable will solve the problem, as long as
one never goes play and capture game simultaneously, but beware
trying both at once, the early TRIGGER_STOP will cut off the other
activity prematurely. So now playing and capturing is scrutinized
separately, instead of by counting.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/fsl/imx-pcm-fiq.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/sound/soc/fsl/imx-pcm-fiq.c b/sound/soc/fsl/imx-pcm-fiq.c
index 310d902..b71f943 100644
--- a/sound/soc/fsl/imx-pcm-fiq.c
+++ b/sound/soc/fsl/imx-pcm-fiq.c
@@ -42,7 +42,8 @@ struct imx_pcm_runtime_data {
 	struct hrtimer hrt;
 	int poll_time_ns;
 	struct snd_pcm_substream *substream;
-	atomic_t running;
+	atomic_t playing;
+	atomic_t capturing;
 };
 
 static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
@@ -54,7 +55,7 @@ static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 	struct pt_regs regs;
 	unsigned long delta;
 
-	if (!atomic_read(&iprtd->running))
+	if (!atomic_read(&iprtd->playing) && !atomic_read(&iprtd->capturing))
 		return HRTIMER_NORESTART;
 
 	get_fiq_regs(&regs);
@@ -122,7 +123,6 @@ static int snd_imx_pcm_prepare(struct snd_pcm_substream *substream)
 	return 0;
 }
 
-static int fiq_enable;
 static int imx_pcm_fiq;
 
 static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
@@ -134,23 +134,27 @@ static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		atomic_set(&iprtd->running, 1);
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			atomic_set(&iprtd->playing, 1);
+		else
+			atomic_set(&iprtd->capturing, 1);
 		hrtimer_start(&iprtd->hrt, ns_to_ktime(iprtd->poll_time_ns),
 		      HRTIMER_MODE_REL);
-		if (++fiq_enable == 1)
-			enable_fiq(imx_pcm_fiq);
-
+		enable_fiq(imx_pcm_fiq);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		atomic_set(&iprtd->running, 0);
-
-		if (--fiq_enable == 0)
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			atomic_set(&iprtd->playing, 0);
+		else
+			atomic_set(&iprtd->capturing, 0);
+		if (!atomic_read(&iprtd->playing) &&
+				!atomic_read(&iprtd->capturing))
 			disable_fiq(imx_pcm_fiq);
-
 		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -198,7 +202,8 @@ static int snd_imx_open(struct snd_pcm_substream *substream)
 
 	iprtd->substream = substream;
 
-	atomic_set(&iprtd->running, 0);
+	atomic_set(&iprtd->playing, 0);
+	atomic_set(&iprtd->capturing, 0);
 	hrtimer_init(&iprtd->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	iprtd->hrt.function = snd_hrtimer_callback;
 
-- 
1.8.3.2

