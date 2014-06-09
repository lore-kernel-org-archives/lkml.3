Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483AbaFIW4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:56:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934243AbaFIWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Welling <mwelling@ieee.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.14 77/78] gpio: mcp23s08: Bug fix of SPI device tree registration.
Date: Mon,  9 Jun 2014 15:48:57 -0700
Message-Id: <20140609224815.787303692@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-mcp23s08.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-mcp23s08.c
+++ b/drivers/gpio/gpio-mcp23s08.c
@@ -895,8 +895,11 @@ static int mcp23s08_probe(struct spi_dev
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
@@ -919,12 +922,12 @@ static int mcp23s08_probe(struct spi_dev
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


