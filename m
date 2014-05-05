Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbaEEUXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:23:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40201 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752161AbaEEUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:23:21 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] rtc: rtc-at91rm9200: fix lost ACKUPD interrupt
Date: Mon,  5 May 2014 22:23:08 +0200
Message-Id: <1399321388-15148-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <55cab9fba2ea4eed8f73591b37cc874b@BLUPR05MB037.namprd05.prod.outlook.com>
References: <55cab9fba2ea4eed8f73591b37cc874b@BLUPR05MB037.namprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an alarm interrupt raises just after the CR register is written and
before the ACKUPD is unmasked the ACKUPD bit might be cleaned up without
waking up the waiting thread.

Unmask the ACKUPD interrupt before writing the CR register so that the
ACKUPD cannot be lost.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
---
Hello Bryan,

Could you try to apply this patch and tell me if it fixes your bug ?

Best Regards,

Boris

 drivers/rtc/rtc-at91rm9200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 3281c90..c16c423 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -163,9 +163,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 
 	/* Stop Time/Calendar from counting */
 	cr = at91_rtc_read(AT91_RTC_CR);
+	at91_rtc_write_ier(AT91_RTC_ACKUPD);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
-	at91_rtc_write_ier(AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
 	at91_rtc_write_idr(AT91_RTC_ACKUPD);
 
-- 
1.8.3.2

