Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaFWIz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55508 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Welling <mwelling@ieee.org>,
        Linus Walleij <linus.walleij@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/111] gpio: mcp23s08: Bug fix of SPI device tree registration.
Date: Mon, 23 Jun 2014 10:31:34 +0200
Message-Id: <af1cf97144be97a768b9198be6a9a5bdd2bb19ed.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Welling <mwelling@ieee.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 99e4b98dbe3ad1fe38a74d12c3b8d44a55930de4 upstream.

The chips variable needs to be incremented for each chip that is
found in the spi_present_mask when registering via device tree.
Without this and the checking a negative index is passed to the
data->chip array in a subsequent loop.

Signed-off-by: Michael Welling <mwelling@ieee.org>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpio/gpio-mcp23s08.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
index 2deb0c5e54a4..380fedb7d93c 100644
--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -657,8 +657,11 @@ static int mcp23s08_probe(struct spi_device *spi)
 			return -ENODEV;
 		}
 
-		for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++)
+		for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
 			pullups[addr] = 0;
+			if (spi_present_mask & (1 << addr))
+				chips++;
+		}
 	} else {
 		type = spi_get_device_id(spi)->driver_data;
 		pdata = dev_get_platdata(&spi->dev);
@@ -681,12 +684,12 @@ static int mcp23s08_probe(struct spi_device *spi)
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
2.0.0

