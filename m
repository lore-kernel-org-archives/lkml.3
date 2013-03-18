Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3CRPAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:00:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43876 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3CRPAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:00:49 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/8] staging: omap-thermal: use spin_lock_irqsave inside IRQ handler
Date: Mon, 18 Mar 2013 10:59:10 -0400
Message-ID: <1363618756-15851-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the IRQ is not firing because it is ONE_SHOT and disable
at INTC level, the IRQ handler must use spin_lock_irqsave.
It is necessary to disable IRQs from the current
CPU while it is holding a spin_lock which is need.

Cc: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index cb7aa35..a4ac06c 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -168,9 +168,10 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 	struct omap_bandgap *bg_ptr = data;
 	struct temp_sensor_registers *tsr;
 	u32 t_hot = 0, t_cold = 0, ctrl;
+	unsigned long flags;
 	int i;
 
-	spin_lock(&bg_ptr->lock);
+	spin_lock_irqsave(&bg_ptr->lock, flags);
 	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
 		tsr = bg_ptr->conf->sensors[i].registers;
 		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_status);
@@ -209,7 +210,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 		if (bg_ptr->conf->report_temperature)
 			bg_ptr->conf->report_temperature(bg_ptr, i);
 	}
-	spin_unlock(&bg_ptr->lock);
+	spin_unlock_irqrestore(&bg_ptr->lock, flags);
 
 	return IRQ_HANDLED;
 }
-- 
1.7.7.1.488.ge8e1c

