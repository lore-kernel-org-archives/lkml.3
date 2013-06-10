Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3FJQXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:23:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35488 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3FJQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:23:04 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-ce-51b5fd65659d
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, spi-devel-general@lists.sourceforge.net,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RESEND] spi: s3c64xx: Fix pm_runtime_get_sync() return value
 check
Date: Mon, 10 Jun 2013 18:22:26 +0200
Message-id: <1370881346-28000-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t9jAd3Uv1sDDd5fN7OY+vAJm8XZpjfs
	Fpd3zWGzmHF+H5PF4TftrBZHpjSyO7B5bFrVyeaxe8FnJo++LasYPT5vkgtgieKySUnNySxL
	LdK3S+DKeHD2LXPBN86Kj79PMzYwTuboYuTkkBAwkeg5dpYRwhaTuHBvPVsXIxeHkMAiRok5
	Db1QTgeTxNN1j1lAqtgEDCV6j/aBdYgAddye08kMYjML7GCUOLjEHcQWFgiR2DX/HSuIzSKg
	KvH5+Eewel4BN4mls6YBDeUA2qYgMWeSzQRG7gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLz
	czcxggPimdQOxpUNFocYBTgYlXh4H/zaEijEmlhWXJl7iFGCg1lJhDf5zdZAId6UxMqq1KL8
	+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYwZnzkYbkx1yJUSvzSXubPB
	q+hM+fIF8acZTctdog32ndVyatsS6n6w1mnvmYooR45XeRxzrDnXnxe91MO66Kh9xhGFi1l5
	f+a1/5jz99njiae/1ETFOPf8qwxUM3D6aihTOvn0urRAz2czhUz8gyanO3Ufb4184Hzp4qcM
	nV47lmnLDCVjlyuxFGckGmoxFxUnAgBDvPp6BAIAAA==
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
the device and asynchronous one to disable it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
I used broonie@kernel.org e-mail address this time, as found in MAINATAINERS,
instead of broonie@opensource.wolfsonmicro.com which seems to be inactive.

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

