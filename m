Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbaIKMid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:38:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51704 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.420946282@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 002/131] ASoC: samsung: Correct I2S DAI suspend/resume ops
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/samsung/i2s.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -824,11 +824,9 @@ static int i2s_suspend(struct snd_soc_da
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
@@ -837,11 +835,9 @@ static int i2s_resume(struct snd_soc_dai
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

