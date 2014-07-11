Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaGKKZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:25:14 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46942 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaGKKZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:25:09 -0400
Date: Fri, 11 Jul 2014 19:23:54 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] staging: dgap: removes redundant null check and change
 paramter for dgap_tty_digisetedelay()
Message-ID: <20140711102354.GA22343@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks in dgap_tty_digisetedelay() are already done by
dgap_tty_ioctl() and change "tty" as a paramter of this function
to "ch", "bd and "un".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 1d9e3e8..6bc4a30 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -90,7 +90,8 @@ static int dgap_tty_digigeta(struct channel_t *ch, struct digi_t __user *retinfo
 static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
 			     struct un_t *un, struct digi_t __user *new_info);
 static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo);
-static int dgap_tty_digisetedelay(struct tty_struct *tty, int __user *new_info);
+static int dgap_tty_digisetedelay(struct channel_t *ch, struct board_t *bd,
+				  struct un_t *un, int __user *new_info);
 static int dgap_tty_write_room(struct tty_struct *tty);
 static int dgap_tty_chars_in_buffer(struct tty_struct *tty);
 static void dgap_tty_start(struct tty_struct *tty);
@@ -3289,30 +3290,13 @@ static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo)
  * Ioctl to set the EDELAY setting
  *
  */
-static int dgap_tty_digisetedelay(struct tty_struct *tty, int __user *new_info)
+static int dgap_tty_digisetedelay(struct channel_t *ch, struct board_t *bd,
+				  struct un_t *un, int __user *new_info)
 {
-	struct board_t *bd;
-	struct channel_t *ch;
-	struct un_t *un;
 	int new_digi;
 	ulong lock_flags;
 	ulong lock_flags2;
 
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
 	if (copy_from_user(&new_digi, new_info, sizeof(int)))
 		return -EFAULT;
 
@@ -4059,7 +4043,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	case DIGI_SEDELAY:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return dgap_tty_digisetedelay(tty, uarg);
+		return dgap_tty_digisetedelay(ch, bd, un, uarg);
 
 	case DIGI_GETCUSTOMBAUD:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-- 
1.7.1

