Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3A3RFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:05:33 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:46872 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754298Ab3A3RFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:05:31 -0500
From: Roland Stigge <stigge@antcom.de>
To: cjb@laptop.org, plagnioj@jcrosoft.com, grant.likely@secretlab.ca,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] mmc: mmc_spi: Fix return value evaluation of irq_of_parse_and_map()
Date: Wed, 30 Jan 2013 18:05:08 +0100
Message-Id: <1359565508-13362-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When irq_of_parse_and_map() returns an error, it does as zero. But in
mmc_spi_get_pdata(), the error return case is compared against NO_IRQ. This
might work where NO_IRQ is zero (defaults to zero when undefined, as on MIPS)
but not where NO_IRQ is sth. different, e.g. on ARM, where it is -1.

This patch changes to comparison with 0 which is the error return value of
irq_of_parse_and_map(). 

Tested on ARM that mmc_spi is working now.

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index 1534b58..d720b5e 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -146,7 +146,7 @@ struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi)
 		oms->pdata.get_ro = of_mmc_spi_get_ro;
 
 	oms->detect_irq = irq_of_parse_and_map(np, 0);
-	if (oms->detect_irq != NO_IRQ) {
+	if (oms->detect_irq != 0) {
 		oms->pdata.init = of_mmc_spi_init;
 		oms->pdata.exit = of_mmc_spi_exit;
 	} else {
