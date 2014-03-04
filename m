Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbaCDVMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:12:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbaCDUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 088/172] ASoC: txx9aclc_ac97: Fix kernel crash on probe
Date: Tue,  4 Mar 2014 12:02:52 -0800
Message-Id: <20140304200302.538541478@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/txx9/txx9aclc-ac97.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/soc/txx9/txx9aclc-ac97.c
+++ b/sound/soc/txx9/txx9aclc-ac97.c
@@ -183,14 +183,16 @@ static int txx9aclc_ac97_dev_probe(struc
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
+
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	drvdata->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(drvdata->base))
 		return PTR_ERR(drvdata->base);
 
-	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
 	platform_set_drvdata(pdev, drvdata);
 	drvdata->physbase = r->start;
 	if (sizeof(drvdata->physbase) > sizeof(r->start) &&


