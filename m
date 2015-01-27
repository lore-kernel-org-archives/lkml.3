Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbbA0Mxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:53:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbbA0MQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 001/126] spi: sh-msiof: Add runtime PM lock in initializing
Date: Tue, 27 Jan 2015 12:15:06 +0000
Message-Id: <1422361031-19364-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>

commit 015760563ec77bf17cec712fa94afdf53b285287 upstream.

SH-MSIOF driver is enabled autosuspend API of spi framework.
But autosuspend framework doesn't work during initializing.
So runtime PM lock is added in SH-MSIOF driver initializing.

Fixes: e2a0ba547ba31c (spi: sh-msiof: Convert to spi core auto_runtime_pm framework)
Signed-off-by: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-sh-msiof.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 45b09142afe2..7f0f2ebf3cdc 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -421,6 +421,8 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 	struct device_node	*np = spi->master->dev.of_node;
 	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
 
+	pm_runtime_get_sync(&p->pdev->dev);
+
 	if (!np) {
 		/*
 		 * Use spi->controller_data for CS (same strategy as spi_gpio),
@@ -439,6 +441,9 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 	if (spi->cs_gpio >= 0)
 		gpio_set_value(spi->cs_gpio, !(spi->mode & SPI_CS_HIGH));
 
+
+	pm_runtime_put_sync(&p->pdev->dev);
+
 	return 0;
 }
 
-- 
2.1.4

