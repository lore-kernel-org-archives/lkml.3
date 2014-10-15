Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaJOL1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:27:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57898 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaJOL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:27:47 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-6f-543e5a305d55
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] drivers: rtc: fix s3c-rtc initialization failure without rtc
 source clock
Date: Wed, 15 Oct 2014 13:27:26 +0200
Message-id: <1413372446-28541-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJMWRmVeSWpSXmKPExsVy+t/xy7oGUXYhBk8/SlksuXiV3eL6l+es
	Fr0LrrJZnG16w25xedccNou1R+6yW+zv7GB0YPfYM/Ekm0ffllWMHtPn/WTy+LxJLoAlissm
	JTUnsyy1SN8ugSujc/Zx9oKnXBV7p35gb2Ds5+xi5OSQEDCRWL/9HyuELSZx4d56NhBbSGAp
	o8TMDzZdjFxAdh+TxN6zn5hBEmwChhJdb7vAikQEbCQOHb7BDFLELHCZUWL+9TXsIAlhgRiJ
	aRP7wGwWAVWJk9NvgG3gFfCQ+HPsPwvENjmJ/y9XME1g5F7AyLCKUTS1NLmgOCk910ivODG3
	uDQvXS85P3cTIyQ4vu5gXHrM6hCjAAejEg8vxwHbECHWxLLiytxDjBIczEoivDbhdiFCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGK2V9iseX/J7weLXzfELbJmn7KvfV7dFeJ//3tmHV6/0Ms/7
	EyL4yiNbarf4J+t+WYVlx695lb5N1ppaNf+Hn0uAa5uY7vOX96af27p3Wueet1MZKrOy91nI
	3oybevPgtYMvHi/8Er/qoPNR8xTWfu07Rppzu4OYpey2rZAtP221ae3/oNkfDq9VYinOSDTU
	Yi4qTgQAPGZ9suwBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes unconditional initialization failure on non-exynos3250
SoCs. Commit df9e26d093d33a097c5558aab017dd2f540ccfe5 ("rtc: s3c: add support for RTC of Exynos3250 SoC") introduced rtc source clock support,
but also added initialization failure on SoCs, which doesn't need such
clock.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/rtc/rtc-s3c.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index a6b1252c9941..806072238c00 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -535,13 +535,15 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(info->rtc_clk);
 
-	info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
-	if (IS_ERR(info->rtc_src_clk)) {
-		dev_err(&pdev->dev, "failed to find rtc source clock\n");
-		return PTR_ERR(info->rtc_src_clk);
+	if (info->data->needs_src_clk) {
+		info->rtc_src_clk = devm_clk_get(&pdev->dev, "rtc_src");
+		if (IS_ERR(info->rtc_src_clk)) {
+			dev_err(&pdev->dev,
+				"failed to find rtc source clock\n");
+			return PTR_ERR(info->rtc_src_clk);
+		}
+		clk_prepare_enable(info->rtc_src_clk);
 	}
-	clk_prepare_enable(info->rtc_src_clk);
-
 
 	/* check to see if everything is setup correctly */
 	if (info->data->enable)
-- 
1.9.2

