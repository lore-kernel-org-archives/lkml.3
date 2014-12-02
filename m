Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbaLBTop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:44:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465AbaLBTY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:24:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 107/121] ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use
Date: Tue,  2 Dec 2014 11:19:46 -0800
Message-Id: <1417548000-1794-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm_adsp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 07c99e8..c9524db 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1340,6 +1340,7 @@ static int wm_adsp_load_coeff(struct wm_adsp *dsp)
 			  file, blocks, pos - firmware->size);
 
 out_fw:
+	regmap_async_complete(regmap);
 	release_firmware(firmware);
 	wm_adsp_buf_free(&buf_list);
 out:
-- 
1.9.1

