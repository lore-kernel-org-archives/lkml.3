Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966232AbaFQVsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966193AbaFQVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Welling <mwelling@ieee.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 102/212] gpio: mcp23s08: Bug fix of SPI device tree registration.
Date: Tue, 17 Jun 2014 14:43:16 -0700
Message-Id: <1403041506-13646-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Welling <mwelling@ieee.org>

commit 99e4b98dbe3ad1fe38a74d12c3b8d44a55930de4 upstream.

The chips variable needs to be incremented for each chip that is
found in the spi_present_mask when registering via device tree.
Without this and the checking a negative index is passed to the
data->chip array in a subsequent loop.

Signed-off-by: Michael Welling <mwelling@ieee.org>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpio/gpio-mcp23s08.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 2deb0c5..114e1aa 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -656,9 +656,11 @@ static int mcp23s08_probe(struct spi_device *spi)
 			dev_err(&spi->dev, "invalid spi-present-mask\n");
 			return -ENODEV;
 		}
-
-		for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++)
+		for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
+			if ((spi_present_mask & (1 << addr)))
+				chips++;
 			pullups[addr] = 0;
+		}
 	} else {
 		type = spi_get_device_id(spi)->driver_data;
 		pdata = dev_get_platdata(&spi->dev);
@@ -681,12 +683,12 @@ static int mcp23s08_probe(struct spi_device *spi)
 			pullups[addr] = pdata->chip[addr].pullups;
 		}
 
-		if (!chips)
-			return -ENODEV;
-
 		base = pdata->base;
 	}
 
+	if (!chips)
+		return -ENODEV;
+
 	data = kzalloc(sizeof *data + chips * sizeof(struct mcp23s08),
 			GFP_KERNEL);
 	if (!data)
-- 
1.9.1

