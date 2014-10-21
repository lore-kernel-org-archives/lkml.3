Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaJUCbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:31:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:32343 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaJUCbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:31:22 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <khilman@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <wenyou.yang@atmel.com>
Subject: [PATCH v2 2/3] i2c/at91: add support for system PM
Date: Tue, 21 Oct 2014 10:26:18 +0800
Message-ID: <1413858379-22865-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413858379-22865-1-git-send-email-wenyou.yang@atmel.com>
References: <1413858379-22865-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 drivers/i2c/busses/i2c-at91.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 1b43b08..8f8fd2a 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -861,7 +861,32 @@ static int at91_twi_runtime_resume(struct device *dev)
 	return clk_prepare_enable(twi_dev->clk);
 }
 
+static int at91_twi_suspend(struct device *dev)
+{
+	if (!pm_runtime_suspended(dev))
+		at91_twi_runtime_suspend(dev);
+
+	return 0;
+}
+
+static int at91_twi_resume(struct device *dev)
+{
+	int ret;
+
+	if (!pm_runtime_suspended(dev)) {
+		ret = at91_twi_runtime_resume(dev);
+		if (ret)
+			return ret;
+	}
+
+	pm_runtime_mark_last_busy(dev);
+	pm_request_autosuspend(dev);
+
+	return 0;
+}
+
 static const struct dev_pm_ops at91_twi_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(at91_twi_suspend, at91_twi_resume)
 	SET_RUNTIME_PM_OPS(at91_twi_runtime_suspend,
 				at91_twi_runtime_resume, NULL)
 };
-- 
1.7.9.5

