Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3CONHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:07:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59976 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3CONHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:07:10 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 16/50] staging: omap-thermal: read status only once inside alert IRQ
Date: Fri, 15 Mar 2013 09:00:04 -0400
Message-ID: <1363352438-15935-17-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to re-read status register.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 531e853..fce3942 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -164,15 +164,15 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 	u32 t_hot = 0, t_cold = 0, ctrl;
 	int i;
 
-	/* Read the status of t_hot */
 	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
 		tsr = bg_ptr->conf->sensors[i].registers;
-		t_hot = omap_bandgap_readl(bg_ptr, tsr->bgap_status);
-		t_hot &= tsr->status_hot_mask;
+		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_status);
+
+		/* Read the status of t_hot */
+		t_hot = ctrl & tsr->status_hot_mask;
 
 		/* Read the status of t_cold */
-		t_cold = omap_bandgap_readl(bg_ptr, tsr->bgap_status);
-		t_cold &= tsr->status_cold_mask;
+		t_cold = ctrl & tsr->status_cold_mask;
 
 		if (!t_cold && !t_hot)
 			continue;
-- 
1.7.7.1.488.ge8e1c

