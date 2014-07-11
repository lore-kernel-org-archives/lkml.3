Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaGKKYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:24:14 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59138 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaGKKYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:24:11 -0400
Date: Fri, 11 Jul 2014 19:22:58 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] staging: dgap: removes redundant null check and change
 paramter for dgap_tty_digiseta()
Message-ID: <20140711102258.GA22326@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks in dgap_tty_digiseta() are already done by
dgap_tty_ioctl() and change "tty" as a paramter of this function
to "ch" and "bd" which are used in dgap_tty_digiseta().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   28 +++++-----------------------
 1 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 4e5b594..160a960 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -88,8 +88,8 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 				unsigned long arg);
 static int dgap_tty_digigeta(struct tty_struct *tty,
 				struct digi_t __user *retinfo);
-static int dgap_tty_digiseta(struct tty_struct *tty,
-				struct digi_t __user *new_info);
+static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
+			     struct un_t *un, struct digi_t __user *new_info);
 static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo);
 static int dgap_tty_digisetedelay(struct tty_struct *tty, int __user *new_info);
 static int dgap_tty_write_room(struct tty_struct *tty);
@@ -3231,31 +3231,13 @@ static int dgap_tty_digigeta(struct tty_struct *tty,
  *
  *
  */
-static int dgap_tty_digiseta(struct tty_struct *tty,
-				struct digi_t __user *new_info)
+static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
+			     struct un_t *un, struct digi_t __user *new_info)
 {
-	struct board_t *bd;
-	struct channel_t *ch;
-	struct un_t *un;
 	struct digi_t new_digi;
 	ulong lock_flags = 0;
 	unsigned long lock_flags2;
 
-	if (!tty || tty->magic != TTY_MAGIC)
-		return -EFAULT;
-
-	un = tty->driver_data;
-	if (!un || un->magic != DGAP_UNIT_MAGIC)
-		return -EFAULT;
-
-	ch = un->un_ch;
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return -EFAULT;
-
-	bd = ch->ch_bd;
-	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
-		return -EFAULT;
-
 	if (copy_from_user(&new_digi, new_info, sizeof(struct digi_t)))
 		return -EFAULT;
 
@@ -4100,7 +4082,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	case DIGI_SETA:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return dgap_tty_digiseta(tty, uarg);
+		return dgap_tty_digiseta(ch, bd, un, uarg);
 
 	case DIGI_GEDELAY:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-- 
1.7.1

