Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaGKKYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:24:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52581 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaGKKYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:24:51 -0400
Date: Fri, 11 Jul 2014 19:23:34 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] staging: dgap: removes redundant null check and change
 paramter for dgap_set_modem_info()
Message-ID: <20140711102334.GA22338@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks in dgap_set_modem_info() are already done by
dgap_tty_ioctl() and change "tty" as a paramter of this function
to "ch", "bd" and "un".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   36 ++++++++----------------------------
 1 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 7ebbf50..1d9e3e8 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -86,8 +86,7 @@ static int dgap_block_til_ready(struct tty_struct *tty, struct file *file,
 				struct channel_t *ch);
 static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 				unsigned long arg);
-static int dgap_tty_digigeta(struct channel_t *ch, struct un_t *un,
-			     struct digi_t __user *retinfo);
+static int dgap_tty_digigeta(struct channel_t *ch, struct digi_t __user *retinfo);
 static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
 			     struct un_t *un, struct digi_t __user *new_info);
 static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo);
@@ -102,8 +101,8 @@ static void dgap_tty_flush_chars(struct tty_struct *tty);
 static void dgap_tty_flush_buffer(struct tty_struct *tty);
 static void dgap_tty_hangup(struct tty_struct *tty);
 static int dgap_wait_for_drain(struct tty_struct *tty);
-static int dgap_set_modem_info(struct tty_struct *tty, unsigned int command,
-				unsigned int __user *value);
+static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct un_t *un,
+			       unsigned int command, unsigned int __user *value);
 static int dgap_get_modem_info(struct channel_t *ch,
 				unsigned int __user *value);
 static int dgap_tty_digisetcustombaud(struct tty_struct *tty,
@@ -3094,32 +3093,14 @@ static int dgap_get_modem_info(struct channel_t *ch, unsigned int __user *value)
  *
  * Set modem signals, called by ld.
  */
-static int dgap_set_modem_info(struct tty_struct *tty, unsigned int command,
-				unsigned int __user *value)
+static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd, struct un_t *un,
+			       unsigned int command, unsigned int __user *value)
 {
-	struct board_t *bd;
-	struct channel_t *ch;
-	struct un_t *un;
 	int ret;
 	unsigned int arg;
 	ulong lock_flags;
 	ulong lock_flags2;
 
-	if (!tty || tty->magic != TTY_MAGIC)
-		return -EIO;
-
-	un = tty->driver_data;
-	if (!un || un->magic != DGAP_UNIT_MAGIC)
-		return -EIO;
-
-	ch = un->un_ch;
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return -EIO;
-
-	bd = ch->ch_bd;
-	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
-		return -EIO;
-
 	ret = get_user(arg, value);
 	if (ret)
 		return ret;
@@ -3189,8 +3170,7 @@ static int dgap_set_modem_info(struct tty_struct *tty, unsigned int command,
  *
  *
  */
-static int dgap_tty_digigeta(struct channel_t *ch, struct un_t *un,
-			     struct digi_t __user *retinfo)
+static int dgap_tty_digigeta(struct channel_t *ch, struct digi_t __user *retinfo)
 {
 	struct digi_t tmp;
 	ulong lock_flags;
@@ -3899,7 +3879,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	case TIOCMSET:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return dgap_set_modem_info(tty, cmd, uarg);
+		return dgap_set_modem_info(ch, bd, un, cmd, uarg);
 
 		/*
 		 * Here are any additional ioctl's that we want to implement
@@ -4047,7 +4027,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		/* get information for ditty */
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return dgap_tty_digigeta(ch, un, uarg);
+		return dgap_tty_digigeta(ch, uarg);
 
 	case DIGI_SETAW:
 	case DIGI_SETAF:
-- 
1.7.1

