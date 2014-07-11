Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaGKKYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:24:32 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40789 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaGKKYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:24:30 -0400
Date: Fri, 11 Jul 2014 19:23:16 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] staging: dgap: removes redundant null check and change
 paramter for dgap_tty_digigeta()
Message-ID: <20140711102316.GA22333@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks in dgap_tty_digigeta() are already done by
dgap_tty_ioctl() and change "tty" as a paramter of this function
to "ch" and "un".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 160a960..7ebbf50 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -86,8 +86,8 @@ static int dgap_block_til_ready(struct tty_struct *tty, struct file *file,
 				struct channel_t *ch);
 static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 				unsigned long arg);
-static int dgap_tty_digigeta(struct tty_struct *tty,
-				struct digi_t __user *retinfo);
+static int dgap_tty_digigeta(struct channel_t *ch, struct un_t *un,
+			     struct digi_t __user *retinfo);
 static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
 			     struct un_t *un, struct digi_t __user *new_info);
 static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo);
@@ -3189,28 +3189,15 @@ static int dgap_set_modem_info(struct tty_struct *tty, unsigned int command,
  *
  *
  */
-static int dgap_tty_digigeta(struct tty_struct *tty,
-				struct digi_t __user *retinfo)
+static int dgap_tty_digigeta(struct channel_t *ch, struct un_t *un,
+			     struct digi_t __user *retinfo)
 {
-	struct channel_t *ch;
-	struct un_t *un;
 	struct digi_t tmp;
 	ulong lock_flags;
 
 	if (!retinfo)
 		return -EFAULT;
 
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
 	memset(&tmp, 0, sizeof(tmp));
 
 	spin_lock_irqsave(&ch->ch_lock, lock_flags);
@@ -4060,7 +4047,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		/* get information for ditty */
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return dgap_tty_digigeta(tty, uarg);
+		return dgap_tty_digigeta(ch, un, uarg);
 
 	case DIGI_SETAW:
 	case DIGI_SETAF:
-- 
1.7.1

