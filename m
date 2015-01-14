Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbbANIuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:50:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbbANHZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Binderman <dcb314@hotmail.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.18 022/150] ASoC: tlv320aic31xx: Fix off by one error in the loop stucture.
Date: Tue, 13 Jan 2015 23:21:33 -0800
Message-Id: <20150114072056.868795797@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jyri Sarha <jsarha@ti.com>

commit bbc686b34650b0f54affe9d9a637ccbe02b03760 upstream.

Fix off by one read beyond the end of a table.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Jyri Sarha <jsarha@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic31xx.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -911,12 +911,13 @@ static int aic31xx_set_dai_sysclk(struct
 	}
 	aic31xx->p_div = i;
 
-	for (i = 0; aic31xx_divs[i].mclk_p != freq/aic31xx->p_div; i++) {
-		if (i == ARRAY_SIZE(aic31xx_divs)) {
-			dev_err(aic31xx->dev, "%s: Unsupported frequency %d\n",
-				__func__, freq);
-			return -EINVAL;
-		}
+	for (i = 0; i < ARRAY_SIZE(aic31xx_divs) &&
+		     aic31xx_divs[i].mclk_p != freq/aic31xx->p_div; i++)
+		;
+	if (i == ARRAY_SIZE(aic31xx_divs)) {
+		dev_err(aic31xx->dev, "%s: Unsupported frequency %d\n",
+			__func__, freq);
+		return -EINVAL;
 	}
 
 	/* set clock on MCLK, BCLK, or GPIO1 as PLL input */


