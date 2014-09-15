Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbaIOUFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:05:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbaIOTrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 06/71] spi: orion: fix incorrect handling of cell-index DT property
Date: Mon, 15 Sep 2014 12:26:04 -0700
Message-Id: <20140915192638.921626829@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-orion.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -403,8 +403,6 @@ static int orion_spi_probe(struct platfo
 	struct resource *r;
 	unsigned long tclk_hz;
 	int status = 0;
-	const u32 *iprop;
-	int size;
 
 	master = spi_alloc_master(&pdev->dev, sizeof *spi);
 	if (master == NULL) {
@@ -415,10 +413,10 @@ static int orion_spi_probe(struct platfo
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


