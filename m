Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbbATFdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:33:46 -0500
Received: from www.osadl.org ([62.245.132.105]:50611 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbbATFdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:33:44 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] wireless: p54: add handling of the signal case
Date: Tue, 20 Jan 2015 06:25:43 +0100
Message-Id: <1421731543-13290-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if(!wait_for_completion_interruptible_timeout(...))
only handles the timeout case - this patch adds handling the
signal case the same as timeout.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Only the timeout case was being handled, the signal case
(-ERESTARTSYS) was treated just like the case of successful
completion, which is most likely not reasonable.

p54_download_eeprom() is called in p54_read_eeprom() and will 
terminate if p54_download_eeprom() returned != 0 so the logic
should be correct - but this needs a check from someone who
knows the driver. Translating -ETIMEOUT to -EBUSY might be ok
not sure if -ERESTARTSYS also should be returned as -EBUSY ?

Patch was only compild tested with x86_64_defcofnig +
CONFIG_P54_COMMON=m, CONFIG_P54_PCI=m

Patch is against 3.19.0-rc5 -next-20150119

 drivers/net/wireless/p54/fwio.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index bc065e8..5367d51 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -220,6 +220,7 @@ int p54_download_eeprom(struct p54_common *priv, void *buf,
 	struct sk_buff *skb;
 	size_t eeprom_hdr_size;
 	int ret = 0;
+	long timeout;
 
 	if (priv->fw_var >= 0x509)
 		eeprom_hdr_size = sizeof(*eeprom_hdr);
@@ -249,9 +250,11 @@ int p54_download_eeprom(struct p54_common *priv, void *buf,
 
 	p54_tx(priv, skb);
 
-	if (!wait_for_completion_interruptible_timeout(
-	     &priv->eeprom_comp, HZ)) {
-		wiphy_err(priv->hw->wiphy, "device does not respond!\n");
+	timeout = wait_for_completion_interruptible_timeout(
+			&priv->eeprom_comp, HZ);
+	if (timeout <= 0) {
+		wiphy_err(priv->hw->wiphy,
+			"device does not respond or signal received!\n");
 		ret = -EBUSY;
 	}
 	priv->eeprom = NULL;
-- 
1.7.10.4

