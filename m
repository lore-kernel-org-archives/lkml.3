Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3KEMqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:46:37 -0500
Received: from skyrme.org ([193.175.80.135]:56196 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab3KEMqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:46:35 -0500
X-Greylist: delayed 1955 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Nov 2013 07:46:35 EST
Date: 5 Nov 2013 12:13:54 +0000
Message-Id: <1383653634-13691-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Liam Girdwood" <lgirdwood@gmail.com>
Cc: "Mark Brown" <broonie@kernel.org>, "Sascha Hauer" <s.hauer@pengutronix.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] ASoC: fsl: imx-pcm-fiq: remove bogus period delta calculation
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally snd_hrtimer_callback() used iprtd->period_time for
some jiffies based estimation to determine the right moment
to call snd_pcm_period_elapsed(). As timer drifts may well be a
problem, this was changed in commit b4e82b5b785670b6 to be based
on buffer transmission progress, using iprtd->offset and
runtime->buffer_size to calculate the amount of data since last
period had elapsed.

Unfortunately, iprtd->offset counts in bytes, while
runtime->buffer_size counts frames, so adding these to find some
delta is like comparing apples and oranges, and eventually results
in negative delta values every now and then. This is no big harm,
because it simply causes snd_pcm_period_elapsed() being called
more often than necessary, as negative delta is taken for a
large unsigned value by implicit conversion rule.
Nonetheless, the calculation is broken, so one would replace
the runtime->buffer_size by its equivalent in bytes.

But then, there are chances snd_pcm_period_elapsed() is called
late, because calculating the moment for the elapsed period
into delta is based against the iprtd->last_offset, which is not
necessarily the first byte of the period in question, but some
random byte which the FIQ handler left us with in r8/r9 by
accident. Again, negative impact is low, as there are plenty of
periods already prefilled with data, and snd_pcm_period_elapsed()
will probably be called latest when the following period is
reached. However, the calculation is conceptually broken, and we
are best off removing the clever stuff altogether.

snd_pcm_period_elapsed() is now simply called once everytime
snd_hrtimer_callback() is run, which may not be most accurate,
but at least this way we are quite sure we dont miss an end of
period. There is not much extra effort wasted by superfluous
calls to snd_pcm_period_elapsed(), as the timer frequency
closely matches the period size anyway.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 sound/soc/fsl/imx-pcm-fiq.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/sound/soc/fsl/imx-pcm-fiq.c b/sound/soc/fsl/imx-pcm-fiq.c
index 34043c5..94720a6 100644
--- a/sound/soc/fsl/imx-pcm-fiq.c
+++ b/sound/soc/fsl/imx-pcm-fiq.c
@@ -39,8 +39,6 @@ struct imx_pcm_runtime_data {
 	unsigned int period;
 	int periods;
 	unsigned long offset;
-	unsigned long last_offset;
-	unsigned long size;
 	struct hrtimer hrt;
 	int poll_time_ns;
 	struct snd_pcm_substream *substream;
@@ -54,7 +52,6 @@ static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 	struct snd_pcm_substream *substream = iprtd->substream;
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct pt_regs regs;
-	unsigned long delta;
 
 	if (!atomic_read(&iprtd->running))
 		return HRTIMER_NORESTART;
@@ -66,19 +63,7 @@ static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 	else
 		iprtd->offset = regs.ARM_r9 & 0xffff;
 
-	/* How much data have we transferred since the last period report? */
-	if (iprtd->offset >= iprtd->last_offset)
-		delta = iprtd->offset - iprtd->last_offset;
-	else
-		delta = runtime->buffer_size + iprtd->offset
-			- iprtd->last_offset;
-
-	/* If we've transferred at least a period then report it and
-	 * reset our poll time */
-	if (delta >= iprtd->period) {
-		snd_pcm_period_elapsed(substream);
-		iprtd->last_offset = iprtd->offset;
-	}
+	snd_pcm_period_elapsed(substream);
 
 	hrtimer_forward_now(hrt, ns_to_ktime(iprtd->poll_time_ns));
 
@@ -95,11 +80,9 @@ static int snd_imx_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct imx_pcm_runtime_data *iprtd = runtime->private_data;
 
-	iprtd->size = params_buffer_bytes(params);
 	iprtd->periods = params_periods(params);
-	iprtd->period = params_period_bytes(params) ;
+	iprtd->period = params_period_bytes(params);
 	iprtd->offset = 0;
-	iprtd->last_offset = 0;
 	iprtd->poll_time_ns = 1000000000 / params_rate(params) *
 				params_period_size(params);
 	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
-- 
1.7.9.5

