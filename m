Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab3K1L3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:29:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41527 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab3K1L3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:29:30 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3/3] pinctrl: single: fix infinite loop caused by bad mask
Date: Thu, 28 Nov 2013 13:29:20 +0200
Message-ID: <1385638160-30125-3-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
References: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the masks in DT data are not quite right,
pcs_parse_bits_in_pinctrl_entry() can end up in an infinite loop,
trashing memory at the same time.

Add a check to verify that each loop actually removes bits from the
'mask', so that the loop can eventually end.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/pinctrl/pinctrl-single.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 174f4c50cd77..de6459628b4f 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1318,6 +1318,14 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
 			mask_pos = ((pcs->fmask) << (bit_pos - 1));
 			val_pos = val & mask_pos;
 			submask = mask & mask_pos;
+
+			if ((mask & mask_pos) == 0) {
+				dev_err(pcs->dev,
+					"Invalid mask for %s at 0x%x\n",
+					np->name, offset);
+				break;
+			}
+
 			mask &= ~mask_pos;
 
 			if (submask != mask_pos) {
-- 
1.8.3.2

