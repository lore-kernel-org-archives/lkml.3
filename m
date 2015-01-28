Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761837AbbA1Upf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:45:35 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29937 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761759AbbA1UpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:45:11 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <chris@printf.net>, <ulf.hansson@linaro.org>,
        <sebastian.hesselbarth@gmail.com>
CC: <thomas.petazzoni@free-electrons.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH] mmc: sdhci-pxav3: fix setting of pdata->clk_delay_cycles
Date: Wed, 28 Jan 2015 19:54:12 +0800
Message-ID: <1422446052-2323-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-28_01:2015-01-27,2015-01-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501280125
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code checks "clk_delay_cycles > 0" to know whether the optional
"mrvl,clk_delay_cycles" is set or not. But of_property_read_u32() doesn't
touch clk_delay_cycles if the property is not set. And type of
clk_delay_cycles is u32, so we may always set pdata->clk_delay_cycles as a
random value.

This patch fix this problem by check the return value of of_property_read_u32()
to know whether the optional clk-delay-cycles is set or not.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Cc: <stable@vger.kernel.org> # v3.6+
---
 drivers/mmc/host/sdhci-pxav3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index c5db5d2..f1c6362 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -268,8 +268,8 @@ static struct sdhci_pxa_platdata *pxav3_get_mmc_pdata(struct device *dev)
 	if (!pdata)
 		return NULL;
 
-	of_property_read_u32(np, "mrvl,clk-delay-cycles", &clk_delay_cycles);
-	if (clk_delay_cycles > 0)
+	if (!of_property_read_u32(np, "mrvl,clk-delay-cycles",
+				  &clk_delay_cycles))
 		pdata->clk_delay_cycles = clk_delay_cycles;
 
 	return pdata;
-- 
2.1.4

