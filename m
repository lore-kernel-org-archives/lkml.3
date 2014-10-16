Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaJPKNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:13:49 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34554 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJPKNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:13:46 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 1/2] Revert "mfd: sec-core: Prepare regulators for suspend state to reduce power-consumption"
Date: Thu, 16 Oct 2014 12:13:29 +0200
Message-Id: <1413454410-23396-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413454410-23396-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413454410-23396-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b7cde7078d2344073c310aa65fc2b0a845d2cb5b
("mfd: sec-core: Prepare regulators for suspend state to reduce power-consumption")

Commit b7cde7078d23 called regulator_suspend_prepare() to prepare the
regulators for a suspend state. But did it from the device pm suspend
handler but regulator_suspend_prepare() iterates over all regulators
and not only the one managed by this device so it doesn't seems to be
correct to call it from a device driver.

It is better to call the regulator suspend prepare/finish functions
from platform code instead so this patch reverts the mentioned commit.
---
 drivers/mfd/Kconfig    |  1 -
 drivers/mfd/sec-core.c | 10 ----------
 2 files changed, 11 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1456ea7..fd8cc4c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -655,7 +655,6 @@ config MFD_SEC_CORE
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	select REGULATOR
 	help
 	 Support for the Samsung Electronics MFD series.
 	 This driver provides common support for accessing the device,
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index dba7e2b..5993608 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -31,7 +31,6 @@
 #include <linux/mfd/samsung/s2mpu02.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
-#include <linux/regulator/machine.h>
 #include <linux/regmap.h>
 
 static const struct mfd_cell s5m8751_devs[] = {
@@ -432,15 +431,6 @@ static int sec_pmic_suspend(struct device *dev)
 	 */
 	disable_irq(sec_pmic->irq);
 
-	switch (sec_pmic->device_type) {
-	case S2MPS14X:
-	case S2MPU02:
-		regulator_suspend_prepare(PM_SUSPEND_MEM);
-		break;
-	default:
-		break;
-	}
-
 	return 0;
 }
 
-- 
2.1.0

