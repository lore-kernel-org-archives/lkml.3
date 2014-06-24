Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaFXWkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:40:08 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33052 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbaFXWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:40:04 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: tiwai@suse.de, chunkeey@googlemail.com, leedom@chelsio.com,
        cocci@systeme.lip6.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] p54: use request_firmware_direct() for optional EEPROM override
Date: Tue, 24 Jun 2014 15:39:43 -0700
Message-Id: <1403649583-12707-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com>
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The p54 driver uses request_firmware() twice, once for actual
firmware and then another time for an optional user overide on
EEPROM, 3826.eeprom. The custom EEPROM  is optional but if not
present we'll introduce an extra lag of 60 seconds with udev
present. Annotate we don't want udev nonsense here to avoid
the lag in case its not present.

This was found with the following SmPL patch.

@ firmware_not_critical @
expression cf;
expression config_file;
expression dev;
int ret;
identifier l;
statement S;
@@

-	ret = request_firmware(&cf, config_file, dev);
+	ret = request_firmware_direct(&cf, config_file, dev);
	if (ret < 0) {
		... when != goto l;
		    when != return ret;
		    when any
	} else {
		...
		release_firmware(cf);
		...
	}

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Cc: cocci@systeme.lip6.fr
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/net/wireless/p54/p54spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index de15171..63de5ee 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -193,7 +193,7 @@ static int p54spi_request_eeprom(struct ieee80211_hw *dev)
 	/* allow users to customize their eeprom.
 	 */
 
-	ret = request_firmware(&eeprom, "3826.eeprom", &priv->spi->dev);
+	ret = request_firmware_direct(&eeprom, "3826.eeprom", &priv->spi->dev);
 	if (ret < 0) {
 #ifdef CONFIG_P54_SPI_DEFAULT_EEPROM
 		dev_info(&priv->spi->dev, "loading default eeprom...\n");
-- 
2.0.0

