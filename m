Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3E0O4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:56:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21325 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3E0O4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:56:23 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-66-51a37415fd18
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: broonie@opensource.wolfsonmicro.com
Cc: grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] spi: s3c64xx: Fix pm_runtime_get_sync() return value check
Date: Mon, 27 May 2013 16:56:00 +0200
Message-id: <1369666560-12436-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t9jQV3RksWBBpNvKlj8m32KzeLAnx2M
	Fmeb3rBbXN41h81ixvl9TBaH37SzOrB53Lm2h83j5cTfbB59W1YxenzeJBfAEsVlk5Kak1mW
	WqRvl8CV8WlhesEtjopZzzcxNTD2sHcxcnJICJhIrJz9F8oWk7hwbz1bFyMXh5DAdEaJ3+++
	MUM4HUwS8+d0sYBUsQkYSvQe7WPsYuTgEBFQl9h6XAekhllgF6PEt32f2UBqhAW8JVr/fQar
	ZxFQlXi28yEjiM0r4Cax6doVdpBeCQEFiTmTbCYwci9gZFjFKJpakFxQnJSea6RXnJhbXJqX
	rpecn7uJERwOz6R3MK5qsDjEKMDBqMTDOyF7caAQa2JZcWXuIUYJDmYlEV4pM6AQb0piZVVq
	UX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGRpnGtOXrCyy/9oezPV/+
	oM/eteHLh+0+fhYCXetfKh2/MbErIHAW87uz3D893mjGLdNtU4hdOddW6P/b+RGbq892zXdM
	S8oWcdLUv5K66X8A1zHmt5ffbjH6FaK4139VqsHmKwGbWxbYXz2/fHHUdm059n4zfbGHdncr
	Hs2RujM789dk75onB5RYijMSDbWYi4oTAa/7llYDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is already in a runtime PM enabled state
pm_runtime_get_sync() will return 1, so a test for negative
value should be used to check for errors.

Without this patch there are seen errors like:

[    8.540000] s3c64xx-spi 13930000.spi: Failed to enable device: 1
[    8.545000] spi_master spi1: failed to prepare transfer hardware

Likely because the driver uses synchronous API to runtime enable
the device and asychronous one to disable it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 5000586..71cc3e6 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -444,7 +444,7 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
 	}
 
 	ret = pm_runtime_get_sync(&sdd->pdev->dev);
-	if (ret != 0) {
+	if (ret < 0) {
 		dev_err(dev, "Failed to enable device: %d\n", ret);
 		goto out_tx;
 	}
-- 
1.7.9.5

