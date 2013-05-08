Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3EHIjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:39:33 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42553 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3EHIj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:39:29 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
Date: Wed,  8 May 2013 10:39:14 +0200
Message-Id: <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <20130508080448.GG3102@gmail.com>
References: <20130508080448.GG3102@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As enable_msp gets called only after some audio data has been received,
if the userspace closes the device before sending any data it causes
ux500_msp_i2s_close to clear device state even if it was not previously
initialized.

This in turn leads to some non necessary but harmless writel, but also
to decrementing the pinctrl usage counter (pinctrl_rxtx_ref) below zero.

To prevent this from happening add a condition to skip register and
pinctrl clear if current msp state is already MSP_STATE_IDLE.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Changes from v1:
- fix grammatical error in commit message

Thanks,
Fabio

 sound/soc/ux500/ux500_msp_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index a26c6bf..964cfd6 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -638,7 +638,7 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 	dev_dbg(msp->dev, "%s: Enter (dir = 0x%01x).\n", __func__, dir);
 
 	status = disable_msp(msp, dir);
-	if (msp->dir_busy == 0) {
+	if (msp->dir_busy == 0 && msp->msp_state != MSP_STATE_IDLE) {
 		/* disable sample rate and frame generators */
 		msp->msp_state = MSP_STATE_IDLE;
 		writel((readl(msp->registers + MSP_GCR) &
-- 
1.8.2

