Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaKKLKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57605 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaKKLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 101/170] mtd: m25p80: get rid of spi_get_device_id
Date: Tue, 11 Nov 2014 11:07:40 +0000
Message-Id: <1415704129-12709-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

commit 90e55b3812a1245bb674afcc4410ddba7db402f6 upstream.

This simplifies the way we use spi_nor framework and will allow us to
drop spi_nor_match_id.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/devices/m25p80.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index dcda6287228d..822209d10689 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -197,6 +197,7 @@ static int m25p_probe(struct spi_device *spi)
 	struct m25p *flash;
 	struct spi_nor *nor;
 	enum read_mode mode = SPI_NOR_NORMAL;
+	char *flash_name = NULL;
 	int ret;
 
 	data = dev_get_platdata(&spi->dev);
@@ -236,12 +237,11 @@ static int m25p_probe(struct spi_device *spi)
 	 * If that's the case, respect "type" and ignore a "name".
 	 */
 	if (data && data->type)
-		id = spi_nor_match_id(data->type);
-
-	/* If we didn't get name from platform, simply use "modalias". */
-	if (!id)
-		id = spi_get_device_id(spi);
+		flash_name = data->type;
+	else
+		flash_name = spi->modalias;
 
+	id = spi_nor_match_id(flash_name);
 	ret = spi_nor_scan(nor, id, mode);
 	if (ret)
 		return ret;
-- 
2.1.0

