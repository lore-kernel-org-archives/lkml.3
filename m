Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbaDTDij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:38:39 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39804 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaDTDi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:38:26 -0400
X-Sasl-enc: C7uKhfpgxZAPNwjIeQXe7aM03IbHOvj9Q2yWSDY9lMDR 1397965105
Message-ID: <53534116.3040705@fastmail.fm>
Date: Sun, 20 Apr 2014 11:37:58 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] staging: gdm72xx: Minor cleanup
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm>
In-Reply-To: <53534051.2020504@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced comparisons on jiffies values with wrap-safe functions.

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_usb.c   | 2 +-
 drivers/staging/gdm72xx/sdio_boot.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 20539d8..9ddf8f5 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -730,7 +730,7 @@ static int k_mode_thread(void *arg)
 			spin_unlock_irqrestore(&k_lock, flags2);
 
 			expire = jiffies + K_WAIT_TIME;
-			while (jiffies < expire)
+			while (time_before(jiffies, expire))
 				schedule_timeout(K_WAIT_TIME);
 
 			spin_lock_irqsave(&rx->lock, flags);
diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
index cbe5dcf..2c02842 100644
--- a/drivers/staging/gdm72xx/sdio_boot.c
+++ b/drivers/staging/gdm72xx/sdio_boot.c
@@ -41,11 +41,11 @@ static u8 *tx_buf;
 
 static int ack_ready(struct sdio_func *func)
 {
-	unsigned long start = jiffies;
+	unsigned long wait = jiffies + HZ;
 	u8 val;
 	int ret;
 
-	while ((jiffies - start) < HZ) {
+	while (time_before(jiffies, wait)) {
 		val = sdio_readb(func, 0x13, &ret);
 		if (val & 0x01)
 			return 1;
-- 
1.7.12.1

