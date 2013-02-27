Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab3B0Ajd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:39:33 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:65415 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab3B0Aj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:39:29 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH Resend v5 01/16] spi/spi-atmel: fix master->num_chipselect wrongly set.
Date: Wed, 27 Feb 2013 08:37:14 +0800
Message-ID: <1361925434-11929-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361925297-11854-1-git-send-email-wenyou.yang@atmel.com>
References: <1361925297-11854-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if the spi property "cs-gpios" is set as below:

	cs-gpios = <0>, <&pioC 11 0>, <0>, <0>;

the master->num_chipselect will wrongly be set to 0,
and the spi fail to probe.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 drivers/spi/spi-atmel.c |    2 +-
 drivers/spi/spi.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index ab34497..5bf3786 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -944,7 +944,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
 
 	master->dev.of_node = pdev->dev.of_node;
 	master->bus_num = pdev->id;
-	master->num_chipselect = master->dev.of_node ? 0 : 4;
+	master->num_chipselect = 4;
 	master->setup = atmel_spi_setup;
 	master->transfer = atmel_spi_transfer;
 	master->cleanup = atmel_spi_cleanup;
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..d88cbef 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1070,7 +1070,7 @@ static int of_spi_register_master(struct spi_master *master)
 	master->num_chipselect = max(nb, master->num_chipselect);
 
 	if (nb < 1)
-		return 0;
+		nb = master->num_chipselect;
 
 	cs = devm_kzalloc(&master->dev,
 			  sizeof(int) * master->num_chipselect,
-- 
1.7.9.5

