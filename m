Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbbAEIDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:03:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61745 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbbAEIDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:03:01 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <chris@printf.net>, <ulf.hansson@linaro.org>
CC: <peter.griffin@linaro.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH next] mmc: sdhci-pxav3: Remove checks for optional core clock in error/remove path
Date: Mon, 5 Jan 2015 15:59:19 +0800
Message-ID: <1420444759-3812-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-05_01:2015-01-02,2015-01-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501050090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 63589e92c2d9 ("clk: Ignore error and NULL pointers passed to
clk_{unprepare, disable}()") allows NULL or error pointer to be passed
unconditionally.

This patch is to simplify probe error and remove code paths.

However, we reserve the core clock checks in runtime suspend/resume code
because we want a little smaller latency.

This patch can be applied after the sdhci-pxav3 unbalanced pm/clock issues
patches being merged.
http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/313103.html

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/mmc/host/sdhci-pxav3.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 4de39fb..63967b8 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -398,8 +398,7 @@ err_of_parse:
 err_cd_req:
 err_mbus_win:
 	clk_disable_unprepare(pxa->clk_io);
-	if (!IS_ERR(pxa->clk_core))
-		clk_disable_unprepare(pxa->clk_core);
+	clk_disable_unprepare(pxa->clk_core);
 err_clk_get:
 	sdhci_pltfm_free(pdev);
 	return ret;
@@ -418,8 +417,7 @@ static int sdhci_pxav3_remove(struct platform_device *pdev)
 	sdhci_remove_host(host, 1);
 
 	clk_disable_unprepare(pxa->clk_io);
-	if (!IS_ERR(pxa->clk_core))
-		clk_disable_unprepare(pxa->clk_core);
+	clk_disable_unprepare(pxa->clk_core);
 
 	sdhci_pltfm_free(pdev);
 
-- 
2.1.4

