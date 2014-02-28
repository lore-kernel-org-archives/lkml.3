Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaB1ODX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:03:23 -0500
Received: from mv-drv-hcb003.ocn.ad.jp ([118.23.109.133]:44633 "EHLO
	mv-drv-hcb003.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaB1ODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:03:22 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Mark Brown <broonie@kernel.org>
Cc: iivanov@mm-sol.com, gsi@denx.de, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi: core: make zero length transfer valid again
Date: Fri, 28 Feb 2014 23:03:16 +0900
Message-Id: <1393596196-8652-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero length transfer becomes invalid since
"spi: core: Validate length of the transfers in message" commit,
but it should be valid to support an odd device, for example, which
requires long delay between chipselect and the first transfer, etc.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/spi/spi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c2605aa..454a523 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1808,7 +1808,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 {
 	struct spi_master *master = spi->master;
 	struct spi_transfer *xfer;
-	int w_size, n_words;
+	int w_size;
 
 	if (list_empty(&message->transfers))
 		return -EINVAL;
@@ -1871,9 +1871,8 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 		else
 			w_size = 4;
 
-		n_words = xfer->len / w_size;
 		/* No partial transfers accepted */
-		if (!n_words || xfer->len % w_size)
+		if (xfer->len % w_size)
 			return -EINVAL;
 
 		if (xfer->speed_hz && master->min_speed_hz &&
-- 
1.7.9.5

