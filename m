Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbaKUP3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:29:23 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:47973 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaKUP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:29:22 -0500
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <support.opensource@diasemi.com>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Subject: [PATCH v2 1/2] mfd: da9063: Get irq base dynamically before registering device
Date: Fri, 21 Nov 2014 18:29:07 +0300
Message-ID: <1416583748-6622-2-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After registering mfd device with proper irq_base
platform_get_irq_byname() calls will return VIRQ instead of local IRQ.
This fixes da9063 rtc registration issue:
da9063-rtc da9063-rtc: Failed to request ALARM IRQ 1: -22

Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
---
 drivers/mfd/da9063-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index 93db8bb..f38bc98 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -118,7 +118,7 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 		da9063->irq_base = pdata->irq_base;
 	} else {
 		da9063->flags = 0;
-		da9063->irq_base = 0;
+		da9063->irq_base = -1;
 	}
 	da9063->chip_irq = irq;
 
@@ -168,6 +168,8 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
 		return ret;
 	}
 
+	da9063->irq_base = regmap_irq_chip_get_base(da9063->regmap_irq);
+
 	ret = mfd_add_devices(da9063->dev, -1, da9063_devs,
 			      ARRAY_SIZE(da9063_devs), NULL, da9063->irq_base,
 			      NULL);
-- 
2.1.3

