Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBOGKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 01:10:52 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:50422 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaBOGKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 01:10:51 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] spi: core: Validate lenght of the transfers in message
Date: Sat, 15 Feb 2014 08:09:26 +0200
Message-Id: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

SPI transfer lenght should be a power-of-two multiple
of eight bits.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/spi/spi.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index d0b28bb..9bed365 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1617,6 +1617,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 {
 	struct spi_master *master = spi->master;
 	struct spi_transfer *xfer;
+	int w_size, n_words;
 
 	if (list_empty(&message->transfers))
 		return -EINVAL;
@@ -1668,6 +1669,22 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 				return -EINVAL;
 		}
 
+		/*
+		 * SPI transfer length should be multiple of SPI word size
+		 * where SPI word size should be power-of-two multiple
+		 */
+		if (xfer->bits_per_word <= 8)
+			w_size = 1;
+		else if (xfer->bits_per_word <= 16)
+			w_size = 2;
+		else
+			w_size = 4;
+
+		n_words = xfer->len / w_size;
+		/* No partial transfers accepted */
+		if (!n_words || xfer->len % xfer->bits_per_word)
+			return -EINVAL;
+
 		if (xfer->speed_hz && master->min_speed_hz &&
 		    xfer->speed_hz < master->min_speed_hz)
 			return -EINVAL;
-- 
1.7.9.5

