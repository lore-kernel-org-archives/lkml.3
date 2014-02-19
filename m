Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBSGan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:30:43 -0500
Received: from mail-pb0-f74.google.com ([209.85.160.74]:43610 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaBSGaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:30:39 -0500
From: Hsin-Yu Chao <hychao@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dylan Reid <dgreid@chromium.org>,
        Chih-Chung Chang <chihchung@chromium.org>, Xi Wang <xi.wang@gmail.com>,
        Hsin-Yu Chao <hychao@chromium.org>,
        Ian Minett <ian_minett@creativelabs.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ALSA: hda/ca0132 - Fix recording from mode id 0x8
Date: Wed, 19 Feb 2014 14:30:35 +0800
Message-Id: <1392791435-17170-1-git-send-email-hychao@chromium.org>
X-Mailer: git-send-email 1.9.0.rc1.175.g0b1dcb5
In-Reply-To: <s5htxcbtc71.wl%tiwai@suse.de>
References: <s5htxcbtc71.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incorrect ADC is picked in ca0132_capture_pcm_prepare(),
where it assumes multiple streams while there is one stream
per ADC. Note that ca0132_capture_pcm_cleanup() already does
the right thing.

The Chromebook Pixel has a microphone under the keyboard that
is attached to node id 0x8. Before this fix, recording would
always go to the main internal mic (node id 0x7).

Signed-off-by: Hsin-Yu Chao <hychao@chromium.org>
Reviewed-by: Dylan Reid <dgreid@chromium.org>
---
 sound/pci/hda/patch_ca0132.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 0aa72ee..46ecdbb 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2768,9 +2768,7 @@ static int ca0132_capture_pcm_prepare(struct hda_pcm_stream *hinfo,
 					unsigned int format,
 					struct snd_pcm_substream *substream)
 {
-	struct ca0132_spec *spec = codec->spec;
-
-	snd_hda_codec_setup_stream(codec, spec->adcs[substream->number],
+	snd_hda_codec_setup_stream(codec, hinfo->nid,
 				   stream_tag, 0, format);
 
 	return 0;
-- 
1.8.3.2

