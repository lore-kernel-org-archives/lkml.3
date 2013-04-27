Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3D0Ctf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 22:49:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34590 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3D0Ctd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 22:49:33 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.32 with qID r3R2nEtX030581, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <rdunlap@infradead.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH] linux-next:usb-stor:realtek_cr:Fix compile error
Date: Sat, 27 Apr 2013 10:49:13 +0800
Message-ID: <1367030953-24707-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

To fix the compile error when CONFIG_PM_RUNTIME is not enabled,
move the declaration of us out of CONFIG_REALTEK_AUTOPM macro in rts51x_chip.

drivers/usb/storage/realtek_cr.c: In function 'realtek_cr_destructor':
drivers/usb/storage/realtek_cr.c:942:11: error: 'struct rts51x_chip' has no member named 'us'

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/usb/storage/realtek_cr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 4797228..64c2b28 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -105,8 +105,9 @@ struct rts51x_chip {
 	int status_len;
 
 	u32 flag;
-#ifdef CONFIG_REALTEK_AUTOPM
 	struct us_data *us;
+
+#ifdef CONFIG_REALTEK_AUTOPM
 	struct timer_list rts51x_suspend_timer;
 	unsigned long timer_expires;
 	int pwr_state;
@@ -991,6 +992,7 @@ static int init_realtek_cr(struct us_data *us)
 	us->extra = chip;
 	us->extra_destructor = realtek_cr_destructor;
 	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
+	chip->us = us;
 
 	usb_stor_dbg(us, "chip->max_lun = %d\n", chip->max_lun);
 
@@ -1013,10 +1015,8 @@ static int init_realtek_cr(struct us_data *us)
 			SET_AUTO_DELINK(chip);
 	}
 #ifdef CONFIG_REALTEK_AUTOPM
-	if (ss_en) {
-		chip->us = us;
+	if (ss_en)
 		realtek_cr_autosuspend_setup(us);
-	}
 #endif
 
 	usb_stor_dbg(us, "chip->flag = 0x%x\n", chip->flag);
-- 
1.7.11.3

