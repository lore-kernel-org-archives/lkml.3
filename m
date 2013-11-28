Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab3K1LaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:30:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40819 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758544Ab3K1L32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:29:28 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/3] pinctrl: single: fix pcs_disable with bits_per_mux
Date: Thu, 28 Nov 2013 13:29:19 +0200
Message-ID: <1385638160-30125-2-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
References: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcs_enable() uses vals->mask instead of pcs->fmask when bits_per_mux is
enabled. However, pcs_disable() always uses pcs->fmask.

Fix pcs_disable() to use vals->mask with bits_per_mux.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/pinctrl/pinctrl-single.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 829b98c5c66f..174f4c50cd77 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -525,12 +525,18 @@ static void pcs_disable(struct pinctrl_dev *pctldev, unsigned fselector,
 	for (i = 0; i < func->nvals; i++) {
 		struct pcs_func_vals *vals;
 		unsigned long flags;
-		unsigned val;
+		unsigned val, mask;
 
 		vals = &func->vals[i];
 		raw_spin_lock_irqsave(&pcs->lock, flags);
 		val = pcs->read(vals->reg);
-		val &= ~pcs->fmask;
+
+		if (pcs->bits_per_mux)
+			mask = vals->mask;
+		else
+			mask = pcs->fmask;
+
+		val &= ~mask;
 		val |= pcs->foff << pcs->fshift;
 		pcs->write(val, vals->reg);
 		raw_spin_unlock_irqrestore(&pcs->lock, flags);
-- 
1.8.3.2

