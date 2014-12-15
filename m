Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaLOO1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaLOO1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 032/168] ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use
Date: Mon, 15 Dec 2014 14:24:46 +0000
Message-Id: <1418653622-21105-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 9da7a5a9fdeeb76b2243f6b473363a7e6147ab6f upstream.

We should not free any buffers associated with writing out coefficients
to the DSP until all the async writes have completed. This patch updates
the out of memory path when allocating a new buffer to include a call to
regmap_async_complete.

Reported-by: JS Park <aitdark.park@samsung.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm_adsp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 2537725dd53f..051350052d62 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1355,6 +1355,7 @@ static int wm_adsp_load_coeff(struct wm_adsp *dsp)
 			  file, blocks, pos - firmware->size);
 
 out_fw:
+	regmap_async_complete(regmap);
 	release_firmware(firmware);
 	wm_adsp_buf_free(&buf_list);
 out:
-- 
2.1.3

