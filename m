Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588Ab3JPWUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:20:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47683 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755830Ab3JPWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:20:08 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2] mmc: atmel-mci: add vmmc-supply support
Date: Thu, 17 Oct 2013 00:19:59 +0200
Message-Id: <1381961999-8187-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other MMC hosts handle a regulator named vmmc-supply that allows to power the
MMC card or SDIO device before communicating on the bus.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---

Changes in v2:
 - use mmc_regulator_get_supply instead of devm_regulator_get

 drivers/mmc/host/atmel-mci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 69e438e..4ea5333 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -23,6 +23,7 @@
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 #include <linux/scatterlist.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -2198,6 +2199,14 @@ static int __init atmci_init_slot(struct atmel_mci *host,
 	host->slot[id] = slot;
 	mmc_add_host(mmc);
 
+	mmc_regulator_get_supply(mmc);
+	if (!IS_ERR(mmc->supply.vmmc)) {
+		int ret = regulator_enable(mmc->supply.vmmc);
+		if (ret)
+			dev_err(&mmc->class_dev,
+				"failed to enable regulator: %d\n", ret);
+	}
+
 	if (gpio_is_valid(slot->detect_pin)) {
 		int ret;
 
-- 
1.8.1.2

