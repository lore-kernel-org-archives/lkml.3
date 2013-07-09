Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3GIMem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:34:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:53715 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3GIMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:34:40 -0400
Message-ID: <51DC0354.2010701@huawei.com>
Date: Tue, 9 Jul 2013 20:34:28 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: <matthew.garrett@nebula.com>
CC: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND] x86 platform drivers: fix gpio leak
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when request_irq fails, we should release gpiochip

v2:
  fix warning: ignoring return value of 'gpiochip_remove

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/platform/x86/intel_pmic_gpio.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/intel_pmic_gpio.c b/drivers/platform/x86/intel_pmic_gpio.c
index 6f4b728..9830264 100644
--- a/drivers/platform/x86/intel_pmic_gpio.c
+++ b/drivers/platform/x86/intel_pmic_gpio.c
@@ -288,7 +288,7 @@ static int platform_pmic_gpio_probe(struct platform_device *pdev)
 	retval = request_irq(pg->irq, pmic_irq_handler, 0, "pmic", pg);
 	if (retval) {
 		pr_warn("Interrupt request failed\n");
-		goto err;
+		goto fail_request_irq;
 	}

 	for (i = 0; i < 8; i++) {
@@ -299,6 +299,10 @@ static int platform_pmic_gpio_probe(struct platform_device *pdev)
 		irq_set_chip_data(i + pg->irq_base, pg);
 	}
 	return 0;
+
+fail_request_irq:
+	if (gpiochip_remove(&pg->chip))
+		pr_err("gpiochip_remove failed\n");
 err:
 	iounmap(pg->gpiointr);
 err2:
-- 
1.7.1


