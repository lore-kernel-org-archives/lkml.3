Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbaJIVXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:23:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59498 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbaJIVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 083/163] ASoC: davinci-mcasp: Correct rx format unit configuration
Date: Thu,  9 Oct 2014 14:01:48 -0700
Message-Id: <1412888588-26755-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit fe0a29e163a5d045c73faab682a8dac71c2f8012 upstream.

In case of capture we should not use rotation. The reverse and mask is
enough to get the data align correctly from the bus to MCU:
Format	  data from bus    after reverse (XRBUF)
S16_LE:  |LSB|MSB|xxx|xxx|  |xxx|xxx|MSB|LSB|
S24_3LE: |LSB|DAT|MSB|xxx|  |xxx|MSB|DAT|LSB|
S24_LE:  |LSB|DAT|MSB|xxx|  |xxx|MSB|DAT|LSB|
S32_LE:  |LSB|DAT|DAT|MSB|  |MSB|DAT|DAT|LSB|

With this patch all supported formats will work for playback and capture.

Reported-by: Jyri Sarha <jsarha@ti.com> (broken S24_3LE capture)
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/davinci/davinci-mcasp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 71e14bb3..9de1fe6 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -632,8 +632,17 @@ static int davinci_config_channel_size(struct davinci_audio_dev *dev,
 {
 	u32 fmt;
 	u32 tx_rotate = (word_length / 4) & 0x7;
-	u32 rx_rotate = (32 - word_length) / 4;
 	u32 mask = (1ULL << word_length) - 1;
+	/*
+	 * For captured data we should not rotate, inversion and masking is
+	 * enoguh to get the data to the right position:
+	 * Format	  data from bus		after reverse (XRBUF)
+	 * S16_LE:	|LSB|MSB|xxx|xxx|	|xxx|xxx|MSB|LSB|
+	 * S24_3LE:	|LSB|DAT|MSB|xxx|	|xxx|MSB|DAT|LSB|
+	 * S24_LE:	|LSB|DAT|MSB|xxx|	|xxx|MSB|DAT|LSB|
+	 * S32_LE:	|LSB|DAT|DAT|MSB|	|MSB|DAT|DAT|LSB|
+	 */
+	u32 rx_rotate = 0;
 
 	/*
 	 * if s BCLK-to-LRCLK ratio has been configured via the set_clkdiv()
-- 
1.9.1

