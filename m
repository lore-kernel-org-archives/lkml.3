Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3JUNnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:43:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33200 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3JUNnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:43:02 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-d5-52652f63bf0f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] spi/s3c64xx: Do not ignore return value of
 spi_master_resume/suspend
Date: Mon, 21 Oct 2013 15:42:49 +0200
Message-id: <1382362971-16763-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xa7rJ+qlBBl0XDCwmrTvAZDH14RM2
	i9cvDC16F1xlszjb9IbdYtPja6wWl3fNYbOYcX4fk0Xjx5vsFofftLM6cHn8XfWC2WPTqk42
	j81L6j36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEr48HNY4wFTZwVP6//YW5gPMnexcjJISFg
	InFmyjsoW0ziwr31bF2MXBxCAksZJb4sPsoM4fQxSbw/vQ2sik3AWGLz8iVsILaIQJbE7X9b
	wIqYBSYzSZx+uZMRJCEsEC3xbyWEzSKgKrHs4CxmEJtXwF3i4oddQHEOoHUKEnMm2Uxg5F7A
	yLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIySAvuxgXHzM6hCjAAejEg9vgEtKkBBrYllx
	Ze4hRgkOZiUR3s8fgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYg5NmftzB8VPzUGzz7T0CW57G
	dj5d+mJ262Hj5cv667yr71X/nHxJxPPszVBRl5Vna+rvd5xi2yjLeSNz4q4HzzgOKnhbRs/6
	9udYoLTDT/mw3yGnxHrUQ87pNioeuLdu3brm+jsHvpx8bnqzuWP6+Tssi/Jt1W8wbz09/UFA
	z7TAHPv3LKuP7FViKc5INNRiLipOBAC5N52T/gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During PM resume and suspend do not ignore the return value of
spi_master_suspend() or spi_master_resume(). Instead pass it further.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 512b889..59f4fd9 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1480,7 +1480,9 @@ static int s3c64xx_spi_suspend(struct device *dev)
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(master);
 
-	spi_master_suspend(master);
+	int ret = spi_master_suspend(master);
+	if (ret)
+		return ret;
 
 	/* Disable the clock */
 	clk_disable_unprepare(sdd->src_clk);
@@ -1506,9 +1508,7 @@ static int s3c64xx_spi_resume(struct device *dev)
 
 	s3c64xx_spi_hwinit(sdd, sdd->port_id);
 
-	spi_master_resume(master);
-
-	return 0;
+	return spi_master_resume(master);
 }
 #endif /* CONFIG_PM_SLEEP */
 
-- 
1.7.9.5

