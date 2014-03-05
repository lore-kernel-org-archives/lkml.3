Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaCEOZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbaCEOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Shiyan <shc_work@mail.ru>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/131] ASoC: txx9aclc_ac97: Fix kernel crash on probe
Date: Wed,  5 Mar 2014 14:22:39 +0000
Message-Id: <1394029455-23128-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

commit 9febd494d15c4a351e9c9cae7184643144eea892 upstream.

This patch fixes a crash caused by commit 3bed3344c826
(ASoC: txx9aclc_ac97: Convert to devm_ioremap_resource()).
This is an attempt to assign "drvdata->base" while memory
for "drvdata" is not already allocated.

Fixes: 3bed3344c826 (ASoC: txx9aclc_ac97: Convert to devm_ioremap_resource())
Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/txx9/txx9aclc-ac97.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/txx9/txx9aclc-ac97.c b/sound/soc/txx9/txx9aclc-ac97.c
index 4bcce8a..91977ea 100644
--- a/sound/soc/txx9/txx9aclc-ac97.c
+++ b/sound/soc/txx9/txx9aclc-ac97.c
@@ -183,6 +183,11 @@ static int txx9aclc_ac97_dev_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
+
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -EBUSY;
@@ -191,9 +196,6 @@ static int txx9aclc_ac97_dev_probe(struct platform_device *pdev)
 	if (IS_ERR(drvdata->base))
 		return PTR_ERR(drvdata->base);
 
-	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
 	platform_set_drvdata(pdev, drvdata);
 	drvdata->physbase = r->start;
 	if (sizeof(drvdata->physbase) > sizeof(r->start) &&
-- 
1.9.0

