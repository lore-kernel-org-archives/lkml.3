Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab3JOM0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:26:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43616 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932270Ab3JOM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:26:35 -0400
From: Yi Zhang <yizhang@marvell.com>
To: <broonie@kernel.org>
CC: <yizhang@marvell.com>, <zhouqiao@marvell.com>, <zhangwm@marvell.com>,
        <yizhang.mrvl@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] regmap: irq: clear status when disable irq
Date: Tue, 15 Oct 2013 20:23:30 +0800
Message-ID: <1381839810-28984-1-git-send-email-yizhang@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-15_04:2013-10-15,2013-10-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310150039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clear the status bit if the mask register doesn't prevent
the chip level irq from being asserted

OR in the following sequence, there will be irq storm happens:
1) interrupt is triggered;
2) another thread disables it(the mask bit is set);
3) _Then_ the interrupt thread is not ACKed(the status bit is not cleared),
   and it's ignored;
4) if the irq is still asserted because of the uncleared status bit,
   the irq storm happens;

Signed-off-by: Yi Zhang <yizhang@marvell.com>
---
 drivers/base/regmap/regmap-irq.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index d10456f..9b0148f 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -61,7 +61,7 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	struct regmap *map = d->map;
-	int i, ret;
+	int i, j, ret, bits_length;
 	u32 reg;
 
 	if (d->chip->runtime_pm) {
@@ -105,6 +105,31 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 					"Failed to sync wakes in %x: %d\n",
 					reg, ret);
 		}
+
+		if (!d->chip->init_ack_masked)
+			continue;
+		/*
+		 * Ack all the masked interrupts uncondictionly,
+		 * OR if there is masked interrupt which hasn't been Acked,
+		 * it'll be ignored in irq handler, then may introduce irq storm
+		 */
+		if (d->chip->ack_base) {
+			reg = d->chip->ack_base +
+				(i * map->reg_stride * d->irq_reg_stride);
+
+			bits_length = d->map->format.val_bytes * BITS_PER_BYTE;
+			for (j = 0; j < bits_length; j++) {
+				if (!(d->mask_buf[i] & (0x1 << j))) {
+					ret = regmap_update_bits(d->map, reg,
+								 (0x1 << j), 0);
+					if (ret != 0)
+						dev_err(d->map->dev,
+							"Failed to ack 0x%x: %d\n",
+							reg, ret);
+				}
+			}
+			/* no need to sync status_buf, update in irq handler */
+		}
 	}
 
 	if (d->chip->runtime_pm)
-- 
1.7.9.5

