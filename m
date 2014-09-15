Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaIOT1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:27:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbaIOT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 081/158] ASoC: samsung: Correct I2S DAI suspend/resume ops
Date: Mon, 15 Sep 2014 12:25:20 -0700
Message-Id: <20140915192545.323174250@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/samsung/i2s.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -920,11 +920,9 @@ static int i2s_suspend(struct snd_soc_da
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
@@ -933,11 +931,9 @@ static int i2s_resume(struct snd_soc_dai
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


