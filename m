Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3KUBkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:40:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:39345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3KUBka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:40:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="412132271"
Subject: [PATCH] wm8994: avoid to enable dcs done irq before init
 completion dcs_done
From: wangbiao <biao.wang@intel.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        biao.wang@intel.com, di.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 21 Nov 2013 09:22:58 +0800
Message-ID: <1384996978.19494.7.camel@wangbiao>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang, biao <biao.wang@intel.com>
Date: Wed, 20 Nov 2013 17:53:28 +0800
Subject: [PATCH] wm8994: avoid to enable dcs done irq before init completion dcs_done

once code return from request_threaded_irq, irq was setup enabled by
default, but completion var dcs_done not got initialized yet, if then a
dcs done irq was raised, system will got hung as the sync mechanism is
invalid now.

so this patch try not enable irq when request it until we got things
ready.

Signed-off-by: wang, biao <biao.wang@intel.com>
Signed-off-by: Zhang, Di <di.zhang@intel.com>
---
 sound/soc/codecs/wm8994.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 86426a1..d7e59dd 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3981,6 +3981,7 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 	struct wm8994 *control = dev_get_drvdata(codec->dev->parent);
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	unsigned int dcs_done_irq;
 	unsigned int reg;
 	int ret, i;
 
@@ -4077,6 +4078,9 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 	wm8994_request_irq(wm8994->wm8994, WM8994_IRQ_TEMP_SHUT,
 			   wm8994_temp_shut, "Thermal shutdown", codec);
 
+	dcs_done_irq = regmap_irq_get_virq(wm8994->wm8994->irq_data,
+					   WM8994_IRQ_DCS_DONE);
+	irq_set_status_flags(dcs_done_irq, IRQ_NOAUTOEN);
 	ret = wm8994_request_irq(wm8994->wm8994, WM8994_IRQ_DCS_DONE,
 				 wm_hubs_dcs_done, "DC servo done",
 				 &wm8994->hubs);
@@ -4313,6 +4317,7 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 	}
 
 	wm_hubs_add_analogue_routes(codec, 0, 0);
+	enable_irq(dcs_done_irq);
 	snd_soc_dapm_add_routes(dapm, intercon, ARRAY_SIZE(intercon));
 
 	switch (control->type) {
-- 
1.7.0.4



