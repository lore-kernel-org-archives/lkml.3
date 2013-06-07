Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3FGTNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:13:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51154 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab3FGTNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:13:21 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 3/7] thermal: ti-soc-thermal: freeze FSM while computing trend
Date: Fri, 7 Jun 2013 15:13:13 -0400
Message-ID: <1370632393-21450-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <51B2303B.8090200@ti.com>
References: <51B2303B.8090200@ti.com>
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
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)
---

v2: Removed unused label 'unlock:'.

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index f20c1cf..219c051 100644
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
 
@@ -1008,22 +1011,25 @@ int ti_bandgap_get_trend(struct ti_bandgap *bgp, int id, int *trend)
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
+	spin_unlock(&bgp->lock);
 exit:
 	return ret;
 }
-- 
1.8.2.1.342.gfa7285d

