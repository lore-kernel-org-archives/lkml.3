Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbbADPTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 10:19:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57966 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbbADPTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 10:19:01 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <chris@printf.net>, <ulf.hansson@linaro.org>
CC: <peter.griffin@linaro.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH next 1/2] mmc: sdhci-pxav3: fix unbalanced clock issues during probe
Date: Sun, 4 Jan 2015 23:15:47 +0800
Message-ID: <1420384548-7816-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420384548-7816-1-git-send-email-jszhang@marvell.com>
References: <1420384548-7816-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-04_03:2015-01-02,2015-01-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501040160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0dcaa2499b7d ("sdhci-pxav3: Fix runtime PM initialization") tries
to fix one hang issue caused by calling sdhci_add_host() on a suspended
device. The fix enables the clock twice, once by clk_prepare_enable() and
another by pm_runtime_get_sync(), meaning that the clock will never be
gated at runtime PM suspend. I observed the power consumption regression on
Marvell BG2Q SoCs.

In fact, the fix is not correct. There still be a very small window
during which a runtime suspend might somehow occur after pm_runtime_enable()
but before pm_runtime_get_sync().

This patch fixes all of the two problems by just incrementing the usage
counter before pm_runtime_enable(). It also adjust the order of disabling
runtime pm and storing the usage count in the error path to handle clock
gating properly.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Cc: <stable@vger.kernel.org> # v3.11+
---
 drivers/mmc/host/sdhci-pxav3.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index ca3424e..1255dd2 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -365,10 +365,11 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 		}
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_get_noresume(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, PXAV3_RPM_DELAY_MS);
 	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
 	pm_suspend_ignore_children(&pdev->dev, 1);
 
 	ret = sdhci_add_host(host);
@@ -391,8 +392,8 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_host:
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 err_of_parse:
 err_cd_req:
 err_mbus_win:
-- 
2.1.4

