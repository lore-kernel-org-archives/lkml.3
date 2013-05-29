Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966844Ab3E2PIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:08:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38096 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966095Ab3E2PIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:08:18 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 3/7] thermal: ti-soc-thermal: freeze FSM while computing trend
Date: Wed, 29 May 2013 11:07:42 -0400
Message-ID: <1369840066-20357-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
References: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to read the history buffer, it is required to
freeze BG FSM. This patch adds the missing piece of code
to freeze the FSM and also a contention area to avoid
other parts of the code to access the DTEMPs.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index f20c1cf..be9dba5 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -992,9 +992,12 @@ int ti_bandgap_get_trend(struct ti_bandgap *bgp, int id, int *trend)
 		goto exit;
 	}
 
+	spin_lock(&bgp->lock);
+
 	tsr = bgp->conf->sensors[id].registers;
 
 	/* Freeze and read the last 2 valid readings */
+	RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 1);
 	reg1 = tsr->ctrl_dtemp_1;
 	reg2 = tsr->ctrl_dtemp_2;
 
@@ -1008,22 +1011,26 @@ int ti_bandgap_get_trend(struct ti_bandgap *bgp, int id, int *trend)
 	/* Convert from adc values to mCelsius temperature */
 	ret = ti_bandgap_adc_to_mcelsius(bgp, temp1, &t1);
 	if (ret)
-		goto exit;
+		goto unfreeze;
 
 	ret = ti_bandgap_adc_to_mcelsius(bgp, temp2, &t2);
 	if (ret)
-		goto exit;
+		goto unfreeze;
 
 	/* Fetch the update interval */
 	ret = ti_bandgap_read_update_interval(bgp, id, &interval);
 	if (ret || !interval)
-		goto exit;
+		goto unfreeze;
 
 	*trend = (t1 - t2) / interval;
 
 	dev_dbg(bgp->dev, "The temperatures are t1 = %d and t2 = %d and trend =%d\n",
 		t1, t2, *trend);
 
+unfreeze:
+	RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 0);
+unlock:
+	spin_unlock(&bgp->lock);
 exit:
 	return ret;
 }
-- 
1.8.2.1.342.gfa7285d

