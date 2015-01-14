Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbbANHb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:31:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbbANHbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.18 141/150] spi: sh-msiof: Add runtime PM lock in initializing
Date: Tue, 13 Jan 2015 23:23:32 -0800
Message-Id: <20150114072102.238263958@linuxfoundation.org>
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

From: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>

commit 015760563ec77bf17cec712fa94afdf53b285287 upstream.

SH-MSIOF driver is enabled autosuspend API of spi framework.
But autosuspend framework doesn't work during initializing.
So runtime PM lock is added in SH-MSIOF driver initializing.

Fixes: e2a0ba547ba31c (spi: sh-msiof: Convert to spi core auto_runtime_pm framework)
Signed-off-by: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sh-msiof.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -480,6 +480,8 @@ static int sh_msiof_spi_setup(struct spi
 	struct device_node	*np = spi->master->dev.of_node;
 	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
 
+	pm_runtime_get_sync(&p->pdev->dev);
+
 	if (!np) {
 		/*
 		 * Use spi->controller_data for CS (same strategy as spi_gpio),
@@ -498,6 +500,9 @@ static int sh_msiof_spi_setup(struct spi
 	if (spi->cs_gpio >= 0)
 		gpio_set_value(spi->cs_gpio, !(spi->mode & SPI_CS_HIGH));
 
+
+	pm_runtime_put_sync(&p->pdev->dev);
+
 	return 0;
 }
 


