Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060Ab3GLNwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:52:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57257 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3GLNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:52:42 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: <khilman@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Subject: [PATCH v1 2/2] PM / AVS: SmartReflex: disable spamming interrupts
Date: Fri, 12 Jul 2013 16:52:03 +0300
Message-ID: <1373637123-1152-3-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373637123-1152-1-git-send-email-andrii.tseglytskyi@ti.com>
References: <1373637123-1152-1-git-send-email-andrii.tseglytskyi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

At times with bad SR configurations, especially during silicon bring-ups,
we could get continuous spurious interrupts which end up hanging the
platform in the form of an ISR call for status bits that are
automatically enabled by the hardware without any software clearing
option.

If we detect scenarios where ISR was called without the corresponding
notification bit being set, instead of hanging up the system,
we will disable interrupt after noting the event in the system log
to try and keep system sanity and allow developer to debug and fix
the condition.

The same condition applies when a notifier does not exist OR is unable
to handle the interrupt as well.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
---
 drivers/power/avs/smartreflex.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index 5b2b703..185098f 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -120,8 +120,27 @@ static irqreturn_t sr_interrupt(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	if (sr_class->notify)
-		sr_class->notify(sr_info, status);
+	/* Attempt some resemblance of recovery! */
+	if (!status) {
+		dev_err(&sr_info->pdev->dev,
+			"%s: Spurious interrupt!status = 0x%08x."
+			"Disabling to prevent spamming!!\n",
+			__func__, status);
+		disable_irq_nosync(sr_info->irq);
+	} else {
+		/*
+		 * If the notifier does not exist OR reports inability to
+		 * handle, disable as well
+		 */
+		if (!sr_class->notify ||
+		    sr_class->notify(sr_info, status)) {
+			dev_err(&sr_info->pdev->dev,
+				"%s: Callback cant handle int status=0x%08x."
+				"Disabling to prevent spam!!\n",
+				__func__, status);
+			disable_irq_nosync(sr_info->irq);
+		}
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.7.9.5

