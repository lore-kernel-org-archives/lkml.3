Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaDEU4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 16:56:01 -0400
Received: from mail.ispras.ru ([83.149.199.45]:41383 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbaDEUza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 16:55:30 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] mfd: ezx-pcap: avoid calling mutex_lock() in irq handler
Date: Sun,  6 Apr 2014 00:55:14 +0400
Message-Id: <1396731314-7112-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcap_adc_irq() calls mutex_lock(), while it is registered
as nonthreaded irq handler.

The patch makes a switch to threaded irq handling.
Compile tested only.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/mfd/ezx-pcap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 2ed774e7d342..b27830035e36 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -485,8 +485,8 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
 					PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
 
-	ret = devm_request_irq(&spi->dev, adc_irq, pcap_adc_irq, 0, "ADC",
-				pcap);
+	ret = devm_request_threaded_irq(&spi->dev, adc_irq, NULL,
+					pcap_adc_irq, 0, "ADC", pcap);
 	if (ret)
 		goto free_irqchip;
 
-- 
1.8.3.2

