Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbaCUIja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:39:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51017 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbaCUIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:39:28 -0400
X-Sasl-enc: qV4WMRg2st7AeoAkOn5ZR37us7Fpd09ujKHV3wBo4MVS 1395391161
Message-ID: <532BFAB2.2000007@fastmail.fm>
Date: Fri, 21 Mar 2014 16:39:14 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131204 Thunderbird/17.0.11
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: gdm72xx: Removed direct comparisons on jiffies
References: <532BF9B0.2080008@fastmail.fm>
In-Reply-To: <532BF9B0.2080008@fastmail.fm>
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


