Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaJCVot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:44:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaJCVnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.16 218/357] ASoC: davinci-mcasp: Correct rx format unit configuration
Date: Fri,  3 Oct 2014 14:30:04 -0700
Message-Id: <20141003212940.071954811@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/davinci/davinci-mcasp.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -455,8 +455,17 @@ static int davinci_config_channel_size(s
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


