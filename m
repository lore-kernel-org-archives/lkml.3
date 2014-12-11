Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbaLKG3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:29:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55376 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbaLKG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:29:47 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] i2c: designware: use {readl|writel}_relaxed instead of readl/writel
Date: Thu, 11 Dec 2014 14:26:41 +0800
Message-ID: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-11_01:2014-12-10,2014-12-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412110069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readl/writel is too expensive especially on Cortex A9 w/ outer L2 cache.
This introduces i2c read/write errors on Marvell BG2/BG2Q SoCs when there
are heavy L2 cache maintenance operations at the same time.

The driver does not perform DMA, so it's safe to use the relaxed version.
>From another side, the relaxed io accessor macros are available on all
architectures now, so we can use the relaxed versions instead.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/i2c/busses/i2c-designware-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 23628b7..e279948 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -170,10 +170,10 @@ u32 dw_readl(struct dw_i2c_dev *dev, int offset)
 	u32 value;
 
 	if (dev->accessor_flags & ACCESS_16BIT)
-		value = readw(dev->base + offset) |
-			(readw(dev->base + offset + 2) << 16);
+		value = readw_relaxed(dev->base + offset) |
+			(readw_relaxed(dev->base + offset + 2) << 16);
 	else
-		value = readl(dev->base + offset);
+		value = readl_relaxed(dev->base + offset);
 
 	if (dev->accessor_flags & ACCESS_SWAP)
 		return swab32(value);
@@ -187,10 +187,10 @@ void dw_writel(struct dw_i2c_dev *dev, u32 b, int offset)
 		b = swab32(b);
 
 	if (dev->accessor_flags & ACCESS_16BIT) {
-		writew((u16)b, dev->base + offset);
-		writew((u16)(b >> 16), dev->base + offset + 2);
+		writew_relaxed((u16)b, dev->base + offset);
+		writew_relaxed((u16)(b >> 16), dev->base + offset + 2);
 	} else {
-		writel(b, dev->base + offset);
+		writel_relaxed(b, dev->base + offset);
 	}
 }
 
-- 
2.1.3

