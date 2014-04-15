Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaDOW4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:56:30 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:42492 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDOW42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:56:28 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: lee.jones@linaro.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2] mfd: mc13xxx-core: Initialize the lock prior to using it
Date: Tue, 15 Apr 2014 19:56:14 -0300
Message-Id: <1397602574-28025-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

After request_threaded_irq() is called there is a chance that an interrupt
may occur before the 'mc13xxx->lock' is initialized, which will trigger a kernel
oops.

In order to prevent that, move the initialization of 'mc13xxx->lock' prior to
requesting the interrupts.

Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Changed kernel warning --> kernel oops to better describe the problem
- Added Russell's Ack

 drivers/mfd/mc13xxx-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 06e64b6..9e296c4 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -660,13 +660,13 @@ int mc13xxx_common_init(struct device *dev)
 	if (ret)
 		return ret;
 
+	mutex_init(&mc13xxx->lock);
+
 	ret = request_threaded_irq(mc13xxx->irq, NULL, mc13xxx_irq_thread,
 			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
 	if (ret)
 		return ret;
 
-	mutex_init(&mc13xxx->lock);
-
 	if (mc13xxx_probe_flags_dt(mc13xxx) < 0 && pdata)
 		mc13xxx->flags = pdata->flags;
 
-- 
1.8.3.2

