Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3KVDB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:01:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:58197 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3KVDBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:01:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,749,1378882800"; 
   d="scan'208";a="437741020"
Subject: [PATCH V2] wm8994: move dcs done irq request to the end of
 initialization of completion
From: wangbiao <biao.wang@intel.com>
To: Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: di.zhang@intel.com, biao.wang@intel.com,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1384996978.19494.7.camel@wangbiao>
References: <1384996978.19494.7.camel@wangbiao>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 22 Nov 2013 10:44:30 +0800
Message-ID: <1385088270.20782.12.camel@wangbiao>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

once code return from request_threaded_irq, irq was setup enabled by
default, but completion var dcs_done not got initialized yet, if then a
dcs done irq was raised, system will got hung as the sync mechanism is
invalid now.

so this patch move dcs done irq request to the end of initialization 
of completion.

Signed-off-by: wang, biao <biao.wang@intel.com>
Signed-off-by: Zhang, Di <di.zhang@intel.com>
---
 sound/soc/codecs/wm8994.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 86426a1..b9be9cb 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4077,12 +4077,6 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 	wm8994_request_irq(wm8994->wm8994, WM8994_IRQ_TEMP_SHUT,
 			   wm8994_temp_shut, "Thermal shutdown", codec);
 
-	ret = wm8994_request_irq(wm8994->wm8994, WM8994_IRQ_DCS_DONE,
-				 wm_hubs_dcs_done, "DC servo done",
-				 &wm8994->hubs);
-	if (ret == 0)
-		wm8994->hubs.dcs_done_irq = true;
-
 	switch (control->type) {
 	case WM8994:
 		if (wm8994->micdet_irq) {
@@ -4313,6 +4307,11 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 	}
 
 	wm_hubs_add_analogue_routes(codec, 0, 0);
+	ret = wm8994_request_irq(wm8994->wm8994, WM8994_IRQ_DCS_DONE,
+				 wm_hubs_dcs_done, "DC servo done",
+				 &wm8994->hubs);
+	if (ret == 0)
+		wm8994->hubs.dcs_done_irq = true;
 	snd_soc_dapm_add_routes(dapm, intercon, ARRAY_SIZE(intercon));
 
 	switch (control->type) {
-- 
1.7.0.4



