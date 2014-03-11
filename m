Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaCKL5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:57:17 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.148]:51126 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbaCKL5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:57:02 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-13.tower-178.messagelabs.com!1394539009!31081465!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <f0379126f3ac73f6ae332978d614f3a5c0236e76.1394536652.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1394536652.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1394536652.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Tue, 11 Mar 2014 11:56:49 +0000
Subject: [PATCH Resend 2/2] rtc: da9055: Remove use of regmap_irq_get_virq()
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Alessandro Zummo <a.zummo@towertech.it>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using platform_get_irq_byname() to retrieve the IRQ number
returns the VIRQ number rather than the local IRQ number for
the device. Passing that value then into regmap_irq_get_virq()
causes a failure because the function is expecting the local
IRQ number (e.g. 0, 1, 2, 3, etc). This patch removes use of
regmap_irq_get_virq() to prevent this failure from happening

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/rtc/rtc-da9055.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index 48cb2ac..a825491 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -302,7 +302,9 @@ static int da9055_rtc_probe(struct platform_device *pdev)
 	}

 	alm_irq = platform_get_irq_byname(pdev, "ALM");
-	alm_irq = regmap_irq_get_virq(rtc->da9055->irq_data, alm_irq);
+	if (alm_irq < 0)
+		return alm_irq;
+
 	ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
 					da9055_rtc_alm_irq,
 					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
--
1.7.0.4

