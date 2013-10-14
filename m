Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750765Ab3JNE0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 00:26:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21971 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab3JNE0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 00:26:47 -0400
From: Yi Zhang <yizhang@marvell.com>
To: <broonie@kernel.org>
CC: <yizhang@marvell.com>, <qiaozhou@marvell.com>, <zhangwm@marvell.com>,
        <yizhang.mrvl@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] regmap: irq: clear status when disable irq
Date: Mon, 14 Oct 2013 12:23:53 +0800
Message-ID: <1381724633-29586-1-git-send-email-yizhang@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-13_03:2013-10-11,2013-10-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310130197
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

Change-Id: I371201f365c5a8470073a393068cfeb4e3d14a03
Signed-off-by: Yi Zhang <yizhang@marvell.com>
---
 drivers/base/regmap/regmap-irq.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index d10456f..cd655b8 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -105,6 +105,27 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 					"Failed to sync wakes in %x: %d\n",
 					reg, ret);
 		}
+
+		if (!d->chip->init_ack_masked)
+			continue;
+
+		/* Ack masked but set interrupts */
+		reg = d->chip->status_base +
+			(i * map->reg_stride * d->irq_reg_stride);
+		ret = regmap_read(d->map, reg, &d->status_buf[i]);
+		if (ret != 0)
+			dev_err(d->map->dev, "Failed to read IRQ status: %d\n",
+				ret);
+
+		if (d->status_buf[i] && d->chip->ack_base) {
+			reg = d->chip->ack_base +
+				(i * map->reg_stride * d->irq_reg_stride);
+			ret = regmap_write(d->map, reg,
+					d->status_buf[i] & d->mask_buf[i]);
+			if (ret != 0)
+				dev_err(d->map->dev, "Failed to ack 0x%x: %d\n",
+					reg, ret);
+		}
 	}
 
 	if (d->chip->runtime_pm)
-- 
1.7.9.5

