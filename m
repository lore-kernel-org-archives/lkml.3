Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbaIOXMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:12:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50587 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbaIOWLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 105/187] spi: orion: fix incorrect handling of cell-index DT property
Date: Mon, 15 Sep 2014 15:08:35 -0700
Message-Id: <1410818997-9432-106-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit e06871cd2c92e5c65d7ca1d32866b4ca5dd4ac30 upstream.

In commit f814f9ac5a81 ("spi/orion: add device tree binding"), Device
Tree support was added to the spi-orion driver. However, this commit
reads the "cell-index" property, without taking into account the fact
that DT properties are big-endian encoded.

Since most of the platforms using spi-orion with DT have apparently
not used anything but cell-index = <0>, the problem was not
visible. But as soon as one starts using cell-index = <1>, the problem
becomes clearly visible, as the master->bus_num gets a wrong value
(actually it gets the value 0, which conflicts with the first bus that
has cell-index = <0>).

This commit fixes that by using of_property_read_u32() to read the
property value, which does the appropriate endianness conversion when
needed.

Fixes: f814f9ac5a81 ("spi/orion: add device tree binding")
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-orion.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index 744841e..fbc9ac9 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -404,8 +404,6 @@ static int orion_spi_probe(struct platform_device *pdev)
 	struct resource *r;
 	unsigned long tclk_hz;
 	int status = 0;
-	const u32 *iprop;
-	int size;
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*spi));
 	if (master == NULL) {
@@ -416,10 +414,10 @@ static int orion_spi_probe(struct platform_device *pdev)
 	if (pdev->id != -1)
 		master->bus_num = pdev->id;
 	if (pdev->dev.of_node) {
-		iprop = of_get_property(pdev->dev.of_node, "cell-index",
-					&size);
-		if (iprop && size == sizeof(*iprop))
-			master->bus_num = *iprop;
+		u32 cell_index;
+		if (!of_property_read_u32(pdev->dev.of_node, "cell-index",
+					  &cell_index))
+			master->bus_num = cell_index;
 	}
 
 	/* we support only mode 0, and no options */
-- 
1.9.1

