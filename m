Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbaIOXCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:02:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbaIOWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 061/187] ASoC: samsung: Correct I2S DAI suspend/resume ops
Date: Mon, 15 Sep 2014 15:07:51 -0700
Message-Id: <1410818997-9432-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit d3d4e5247b013008a39e4d5f69ce4c60ed57f997 upstream.

We should save/restore relevant I2S registers regardless of
the dai->active flag, otherwise some settings are being lost
after system suspend/resume cycle. E.g. I2S slave mode set only
during dai initialization is not preserved and the device ends
up in master mode after system resume.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/samsung/i2s.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index a5cbdb4..27ca0aa 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -915,11 +915,9 @@ static int i2s_suspend(struct snd_soc_dai *dai)
 {
 	struct i2s_dai *i2s = to_info(dai);
 
-	if (dai->active) {
-		i2s->suspend_i2smod = readl(i2s->addr + I2SMOD);
-		i2s->suspend_i2scon = readl(i2s->addr + I2SCON);
-		i2s->suspend_i2spsr = readl(i2s->addr + I2SPSR);
-	}
+	i2s->suspend_i2smod = readl(i2s->addr + I2SMOD);
+	i2s->suspend_i2scon = readl(i2s->addr + I2SCON);
+	i2s->suspend_i2spsr = readl(i2s->addr + I2SPSR);
 
 	return 0;
 }
@@ -928,11 +926,9 @@ static int i2s_resume(struct snd_soc_dai *dai)
 {
 	struct i2s_dai *i2s = to_info(dai);
 
-	if (dai->active) {
-		writel(i2s->suspend_i2scon, i2s->addr + I2SCON);
-		writel(i2s->suspend_i2smod, i2s->addr + I2SMOD);
-		writel(i2s->suspend_i2spsr, i2s->addr + I2SPSR);
-	}
+	writel(i2s->suspend_i2scon, i2s->addr + I2SCON);
+	writel(i2s->suspend_i2smod, i2s->addr + I2SMOD);
+	writel(i2s->suspend_i2spsr, i2s->addr + I2SPSR);
 
 	return 0;
 }
-- 
1.9.1

