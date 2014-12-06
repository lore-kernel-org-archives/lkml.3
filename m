Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaLFPIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:08:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47720 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752287AbaLFPIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 26/66] ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use
Date: Sat,  6 Dec 2014 16:07:18 +0100
Message-Id: <0655044cc4972492962c4bb6f6c7098beb0b98c2.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9da7a5a9fdeeb76b2243f6b473363a7e6147ab6f upstream.

We should not free any buffers associated with writing out coefficients
to the DSP until all the async writes have completed. This patch updates
the out of memory path when allocating a new buffer to include a call to
regmap_async_complete.

Reported-by: JS Park <aitdark.park@samsung.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/wm_adsp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 61e871bf63dd..f0e97fcde1bf 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1341,6 +1341,7 @@ static int wm_adsp_load_coeff(struct wm_adsp *dsp)
 			  file, blocks, pos - firmware->size);
 
 out_fw:
+	regmap_async_complete(regmap);
 	release_firmware(firmware);
 	wm_adsp_buf_free(&buf_list);
 out:
-- 
2.1.3

