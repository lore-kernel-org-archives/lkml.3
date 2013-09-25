Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3IYHhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:37:48 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53999 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3IYHhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:47 -0400
MIME-Version: 1.0
Date: Wed, 25 Sep 2013 15:37:45 +0800
Message-ID: <CAPgLHd-XqeHscSMmFuUH5gqrbuW6QDvHuLAR+9hPqtjiNXhKZQ@mail.gmail.com>
Subject: [PATCH] mfd: ezx-pcap: drop devm_free_irq of devm_ allocated irq
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The devm_request_irq function allocates irq that is released
when a driver detaches. Thus, there is no reason to explicitly
call devm_free_irq in probe or remove functions.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/ezx-pcap.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 7245b0c..986d6d9 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -395,15 +395,12 @@ static int ezx_pcap_remove(struct spi_device *spi)
 {
 	struct pcap_chip *pcap = spi_get_drvdata(spi);
 	struct pcap_platform_data *pdata = dev_get_platdata(&spi->dev);
-	int i, adc_irq;
+	int i;
 
 	/* remove all registered subdevs */
 	device_for_each_child(&spi->dev, NULL, pcap_remove_subdev);
 
 	/* cleanup ADC */
-	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
-				PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
-	devm_free_irq(&spi->dev, adc_irq, pcap);
 	mutex_lock(&pcap->adc_mutex);
 	for (i = 0; i < PCAP_ADC_MAXQ; i++)
 		kfree(pcap->adc_queue[i]);
@@ -509,8 +506,6 @@ static int ezx_pcap_probe(struct spi_device *spi)
 
 remove_subdevs:
 	device_for_each_child(&spi->dev, NULL, pcap_remove_subdev);
-/* free_adc: */
-	devm_free_irq(&spi->dev, adc_irq, pcap);
 free_irqchip:
 	for (i = pcap->irq_base; i < (pcap->irq_base + PCAP_NIRQS); i++)
 		irq_set_chip_and_handler(i, NULL, NULL);

