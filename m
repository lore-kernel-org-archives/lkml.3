Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaEFPot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:44:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52539 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755237AbaEFPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:44:47 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] spi: atmel: fix incorrect comparison
Date: Tue,  6 May 2014 17:44:41 +0200
Message-Id: <1399391081-16095-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using smatch:
drivers/spi/spi-atmel.c:878 atmel_spi_pump_pio_data() warn: unsigned
'as->current_remaining_bytes' is never less than zero.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/spi/spi-atmel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 079e6b1b0cdb..39417fd8462f 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -874,8 +874,9 @@ atmel_spi_pump_pio_data(struct atmel_spi *as, struct spi_transfer *xfer)
 		spi_readl(as, RDR);
 	}
 	if (xfer->bits_per_word > 8) {
-		as->current_remaining_bytes -= 2;
-		if (as->current_remaining_bytes < 0)
+		if (as->current_remaining_bytes > 2)
+			as->current_remaining_bytes -= 2;
+		else
 			as->current_remaining_bytes = 0;
 	} else {
 		as->current_remaining_bytes--;
-- 
1.9.1

