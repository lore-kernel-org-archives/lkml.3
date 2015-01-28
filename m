Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbbA2JpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:45:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44826 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759541AbbA2JEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:50 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Mark Brown <broonie@linaro.org>,
        Esben Haabendal <esbenhaabendal@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 052/176] spi: fsl: Fix problem with multi message transfers
Date: Wed, 28 Jan 2015 15:28:02 +0100
Message-Id: <44189ec1996bf5c5dd402d21eb420f4e83e7dfb6.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roese <sr@denx.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4302a59629f7a0bd70fd1605d2b558597517372a upstream.

When used via spidev with more than one messages to tranfer via
SPI_IOC_MESSAGE the current implementation would return with
-EINVAL, since bits_per_word and speed_hz are set in all
transfer structs. And in the 2nd loop status will stay at
-EINVAL as its not overwritten again via fsl_spi_setup_transfer().

This patch changes this behavious by first checking if one of
the messages uses different settings. If this is the case
the function will return with -EINVAL. If not, the messages
are transferred correctly.

Signed-off-by: Stefan Roese <sr@denx.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Cc: Esben Haabendal <esbenhaabendal@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi-fsl-spi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 2129fcd1c31b..6ee3dc4dbb2e 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -362,18 +362,28 @@ static int fsl_spi_bufs(struct spi_device *spi, struct spi_transfer *t,
 static void fsl_spi_do_one_msg(struct spi_message *m)
 {
 	struct spi_device *spi = m->spi;
-	struct spi_transfer *t;
+	struct spi_transfer *t, *first;
 	unsigned int cs_change;
 	const int nsecs = 50;
 	int status;
 
-	cs_change = 1;
-	status = 0;
+	/* Don't allow changes if CS is active */
+	first = list_first_entry(&m->transfers, struct spi_transfer,
+			transfer_list);
 	list_for_each_entry(t, &m->transfers, transfer_list) {
-		if (t->bits_per_word || t->speed_hz) {
-			/* Don't allow changes if CS is active */
+		if ((first->bits_per_word != t->bits_per_word) ||
+			(first->speed_hz != t->speed_hz)) {
 			status = -EINVAL;
+			dev_err(&spi->dev,
+				"bits_per_word/speed_hz should be same for the same SPI transfer\n");
+			return;
+		}
+	}
 
+	cs_change = 1;
+	status = -EINVAL;
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		if (t->bits_per_word || t->speed_hz) {
 			if (cs_change)
 				status = fsl_spi_setup_transfer(spi, t);
 			if (status < 0)
-- 
2.2.2

