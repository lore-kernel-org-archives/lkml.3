Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaEIKJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:09:21 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40229 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbaEIKJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:17 -0400
X-Sasl-enc: oqLaamp++M/qb001THUJjt49h0NZNgksmbQAEqXWVOJn 1399630156
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH v5 02/10] staging: gdm72xx: Replace comparisons on jiffies values with wrap-safe functions
Date: Fri,  9 May 2014 18:08:21 +0800
Message-Id: <1399630109-18701-2-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <536CA86B.7000109@fastmail.fm>
References: <536CA86B.7000109@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch.pl issue:

WARNING: Comparing jiffies is almost always wrong; prefer time_after,
time_before and friends

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

