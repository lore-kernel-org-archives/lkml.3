Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaD2CIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:08:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47694 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347AbaD2CIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:08:30 -0400
X-Sasl-enc: VEpGetlVsM2d4ar69bDOurNufXtlec6zdtsxjoqdURY/ 1398737310
Message-ID: <535F097B.5020104@fastmail.fm>
Date: Tue, 29 Apr 2014 10:07:55 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/10] staging: gdm72xx: Replaced comparisons on jiffies
 values with wrap-safe functions
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
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
1.8.4

