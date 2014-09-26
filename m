Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaIZK2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:28:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbaIZJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 039/142] spi: orion: fix incorrect handling of cell-index DT property
Date: Fri, 26 Sep 2014 11:44:10 +0200
Message-Id: <16f6aabf953b586ddc88bdcb0c29548d04877f80.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi-orion.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index 1d1d321d90c4..72006e63d513 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -404,8 +404,6 @@ static int orion_spi_probe(struct platform_device *pdev)
 	struct resource *r;
 	unsigned long tclk_hz;
 	int status = 0;
-	const u32 *iprop;
-	int size;
 
 	master = spi_alloc_master(&pdev->dev, sizeof *spi);
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
2.1.0

