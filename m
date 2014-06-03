Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaFCLlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630AbaFCLl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Welling <mwelling@ieee.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/138] gpio: mcp23s08: Bug fix of SPI device tree registration.
Date: Tue,  3 Jun 2014 12:38:30 +0100
Message-Id: <1401795584-22664-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpio/gpio-mcp23s08.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 65d2590b0ecd..236c4dcd7084 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -630,9 +630,11 @@ static int mcp23s08_probe(struct spi_device *spi)
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
 		pdata = spi->dev.platform_data;
@@ -655,12 +657,12 @@ static int mcp23s08_probe(struct spi_device *spi)
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
 	data = kzalloc(sizeof(*data) + chips * sizeof(struct mcp23s08),
 			GFP_KERNEL);
 	if (!data)
-- 
1.9.1

