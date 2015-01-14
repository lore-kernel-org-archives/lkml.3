Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbbANHg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:36:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbbANHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:36:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Mark Brown <broonie@linaro.org>,
        Esben Haabendal <esbenhaabendal@gmail.com>
Subject: [PATCH 3.14 73/77] spi: fsl: Fix problem with multi message transfers
Date: Tue, 13 Jan 2015 23:23:53 -0800
Message-Id: <20150114072228.366282057@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Roese <sr@denx.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-spi.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -362,18 +362,28 @@ static int fsl_spi_bufs(struct spi_devic
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


