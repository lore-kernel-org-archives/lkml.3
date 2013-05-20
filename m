Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3ETCaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:30:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37225 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab3ETCax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:30:53 -0400
Message-ID: <51998AB2.4080909@huawei.com>
Date: Mon, 20 May 2013 10:30:10 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <matthew.garrett@nebula.com>
CC: <platform-driver-x86@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3/3] x86 platform drivers: fix gpio leak
References: <1368889004-5520-4-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1368889004-5520-4-git-send-email-libo.chen@huawei.com>
X-Forwarded-Message-Id: <1368889004-5520-4-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when request_irq faild, we should release gpiochip

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/platform/x86/intel_pmic_gpio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 drivers/platform/x86/intel_pmic_gpio.c

diff --git a/drivers/platform/x86/intel_pmic_gpio.c b/drivers/platform/x86/intel_pmic_gpio.c
old mode 100644
new mode 100755
index 6f4b728..478c3a5
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
@@ -299,6 +299,9 @@ static int platform_pmic_gpio_probe(struct platform_device *pdev)
 		irq_set_chip_data(i + pg->irq_base, pg);
 	}
 	return 0;
+
+fail_request_irq:
+	gpiochip_remove(&pg->chip);
 err:
 	iounmap(pg->gpiointr);
 err2:
-- 
1.8.1.2






