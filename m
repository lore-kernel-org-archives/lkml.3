Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbaAGAC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:02:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaAFWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 015/144] ASoC: wm_adsp: Add small delay while polling DSP RAM start
Date: Mon,  6 Jan 2014 14:36:16 -0800
Message-Id: <20140106223745.765372136@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit 939fd1e8d9deff206f12bd9d4e54aa7a4bd0ffd6 upstream.

Some devices are getting very close to the limit whilst polling the RAM
start, this patch adds a small delay to this loop to give a longer
startup timeout.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_adsp.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1466,13 +1466,17 @@ static int wm_adsp2_ena(struct wm_adsp *
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


