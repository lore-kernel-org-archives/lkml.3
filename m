Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaAMQsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:48:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaAMQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 071/208] ASoC: wm_adsp: Add small delay while polling DSP RAM start
Date: Mon, 13 Jan 2014 15:58:32 +0000
Message-Id: <1389628849-1614-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 939fd1e8d9deff206f12bd9d4e54aa7a4bd0ffd6 upstream.

Some devices are getting very close to the limit whilst polling the RAM
start, this patch adds a small delay to this loop to give a longer
startup timeout.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm_adsp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index d1c59b6..bea3844 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1495,13 +1495,17 @@ static int wm_adsp2_ena(struct wm_adsp *dsp)
 		return ret;
 
 	/* Wait for the RAM to start, should be near instantaneous */
-	count = 0;
-	do {
+	for (count = 0; count < 10; ++count) {
 		ret = regmap_read(dsp->regmap, dsp->base + ADSP2_STATUS1,
 				  &val);
 		if (ret != 0)
 			return ret;
-	} while (!(val & ADSP2_RAM_RDY) && ++count < 10);
+
+		if (val & ADSP2_RAM_RDY)
+			break;
+
+		msleep(1);
+	}
 
 	if (!(val & ADSP2_RAM_RDY)) {
 		adsp_err(dsp, "Failed to start DSP RAM\n");
-- 
1.8.3.2

