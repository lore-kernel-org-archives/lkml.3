Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab3E1OQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:16:53 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:59972 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890Ab3E1OQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:16:52 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ASoC: ux500: Ensure consistent configuration between DAIs
Date: Tue, 28 May 2013 16:16:39 +0200
Message-Id: <1369750599-10795-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation of mop500_ab8500 allows for inconsistent sample
rate and channel count configuration between the playback and recording
interfaces, through in the hardware the two MSP controllers share
common clock and frame sync signals.

This patch adds the necessary code to ensure that the two device are
configure consistently.  The check is added at machine driver level, as
how to lock DAI configuration depend of the actual hardware
implementation.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/ux500/mop500_ab8500.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/sound/soc/ux500/mop500_ab8500.c b/sound/soc/ux500/mop500_ab8500.c
index 5e0f146..7e923ec 100644
--- a/sound/soc/ux500/mop500_ab8500.c
+++ b/sound/soc/ux500/mop500_ab8500.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/mutex.h>
 
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
@@ -44,6 +45,12 @@
 static unsigned int tx_slots = DEF_TX_SLOTS;
 static unsigned int rx_slots = DEF_RX_SLOTS;
 
+/* Configuration consistency parameters */
+static DEFINE_MUTEX(mop500_ab8500_params_lock);
+static unsigned long mop500_ab8500_usage;
+static int mop500_ab8500_rate;
+static int mop500_ab8500_channels;
+
 /* Clocks */
 static const char * const enum_mclk[] = {
 	"SYSCLK",
@@ -231,6 +238,21 @@ static int mop500_ab8500_hw_params(struct snd_pcm_substream *substream,
 		substream->name,
 		substream->number);
 
+	/* Ensure configuration consistency between DAIs */
+	mutex_lock(&mop500_ab8500_params_lock);
+	if (mop500_ab8500_usage) {
+		if (mop500_ab8500_rate != params_rate(params) ||
+		    mop500_ab8500_channels != params_channels(params)) {
+			mutex_unlock(&mop500_ab8500_params_lock);
+			return -EBUSY;
+		}
+	} else {
+		mop500_ab8500_rate = params_rate(params);
+		mop500_ab8500_channels = params_channels(params);
+	}
+	__set_bit(cpu_dai->id, &mop500_ab8500_usage);
+	mutex_unlock(&mop500_ab8500_params_lock);
+
 	channels = params_channels(params);
 
 	switch (params_format(params)) {
@@ -329,9 +351,22 @@ static int mop500_ab8500_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+static int mop500_ab8500_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+
+	mutex_lock(&mop500_ab8500_params_lock);
+	__clear_bit(cpu_dai->id, &mop500_ab8500_usage);
+	mutex_unlock(&mop500_ab8500_params_lock);
+
+	return 0;
+}
+
 struct snd_soc_ops mop500_ab8500_ops[] = {
 	{
 		.hw_params = mop500_ab8500_hw_params,
+		.hw_free = mop500_ab8500_hw_free,
 		.startup = mop500_ab8500_startup,
 		.shutdown = mop500_ab8500_shutdown,
 	}
-- 
1.8.2

