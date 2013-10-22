Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3JVKp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:45:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9552 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574Ab3JVKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:45:27 -0400
From: Yi Zhang <yizhang@marvell.com>
To: <broonie@kernel.org>, <yizhang.mrvl@gmail.com>, <yizhang@marvell.com>
CC: <zhouqiao@marvell.com>, <zhangwm@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] regmap: irq: clear status when disable irq
Date: Tue, 22 Oct 2013 18:44:32 +0800
Message-ID: <1382438672-19392-1-git-send-email-yizhang@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-22_03:2013-10-22,2013-10-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310220023
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
 drivers/base/regmap/regmap-irq.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index d10456f..763c60d 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -105,6 +105,22 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
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
+		if (d->mask_buf[i] && d->chip->ack_base) {
+			reg = d->chip->ack_base +
+				(i * map->reg_stride * d->irq_reg_stride);
+			ret = regmap_write(map, reg, d->mask_buf[i]);
+			if (ret != 0)
+				dev_err(d->map->dev, "Failed to ack 0x%x: %d\n",
+					reg, ret);
+		}
 	}
 
 	if (d->chip->runtime_pm)
-- 
1.7.9.5

