Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaGKKZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:25:50 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58717 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaGKKZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:25:48 -0400
Date: Fri, 11 Jul 2014 19:24:34 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] staging: dgap: removes redundant null check and change
 paramter for dgap_tty_digisetcustombaud()
Message-ID: <20140711102434.GA22355@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks in dgap_tty_digisetcustombaud() are already done by
dgap_tty_ioctl() and change "tty" as a paramter of this function
to "ch", "bd and "un".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 3b76958..32988a8 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -106,8 +106,8 @@ static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct
 			       unsigned int command, unsigned int __user *value);
 static int dgap_get_modem_info(struct channel_t *ch,
 				unsigned int __user *value);
-static int dgap_tty_digisetcustombaud(struct tty_struct *tty,
-				int __user *new_info);
+static int dgap_tty_digisetcustombaud(struct channel_t *ch, struct board_t *bd,
+				      struct un_t *un, int __user *new_info);
 static int dgap_tty_digigetcustombaud(struct channel_t *ch, struct un_t *un,
 				      int __user *retinfo);
 static int dgap_tty_tiocmget(struct tty_struct *tty);
@@ -3344,32 +3344,13 @@ static int dgap_tty_digigetcustombaud(struct channel_t *ch, struct un_t *un,
  *
  * Ioctl to set the custom baud rate setting
  */
-static int dgap_tty_digisetcustombaud(struct tty_struct *tty,
-					int __user *new_info)
+static int dgap_tty_digisetcustombaud(struct channel_t *ch, struct board_t *bd,
+				      struct un_t *un, int __user *new_info)
 {
-	struct board_t *bd;
-	struct channel_t *ch;
-	struct un_t *un;
 	uint new_rate;
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
-
 	if (copy_from_user(&new_rate, new_info, sizeof(unsigned int)))
 		return -EFAULT;
 
@@ -4040,7 +4021,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	case DIGI_SETCUSTOMBAUD:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return dgap_tty_digisetcustombaud(tty, uarg);
+		return dgap_tty_digisetcustombaud(ch, bd, un, uarg);
 
 	case DIGI_RESET_PORT:
 		dgap_firmware_reset_port(ch);
-- 
1.7.1

