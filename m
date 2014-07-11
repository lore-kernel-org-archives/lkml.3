Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaGKKZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:25:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44581 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaGKKZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:25:29 -0400
Date: Fri, 11 Jul 2014 19:24:14 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] staging: dgap: removes redundant null check and change
 paramter for dgap_tty_digigetcustombaud()
Message-ID: <20140711102414.GA22348@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Null checks in dgap_tty_digigetcustombaud() are already done by
dgap_tty_ioctl() and change "tty" as a paramter of this function
to "ch" and "un".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 6bc4a30..3b76958 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -108,8 +108,8 @@ static int dgap_get_modem_info(struct channel_t *ch,
 				unsigned int __user *value);
 static int dgap_tty_digisetcustombaud(struct tty_struct *tty,
 				int __user *new_info);
-static int dgap_tty_digigetcustombaud(struct tty_struct *tty,
-				int __user *retinfo);
+static int dgap_tty_digigetcustombaud(struct channel_t *ch, struct un_t *un,
+				      int __user *retinfo);
 static int dgap_tty_tiocmget(struct tty_struct *tty);
 static int dgap_tty_tiocmset(struct tty_struct *tty, unsigned int set,
 				unsigned int clear);
@@ -3318,28 +3318,15 @@ static int dgap_tty_digisetedelay(struct channel_t *ch, struct board_t *bd,
  *
  * Ioctl to get the current custom baud rate setting.
  */
-static int dgap_tty_digigetcustombaud(struct tty_struct *tty,
-					int __user *retinfo)
+static int dgap_tty_digigetcustombaud(struct channel_t *ch, struct un_t *un,
+				      int __user *retinfo)
 {
-	struct channel_t *ch;
-	struct un_t *un;
 	int tmp;
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
@@ -4048,7 +4035,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	case DIGI_GETCUSTOMBAUD:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return dgap_tty_digigetcustombaud(tty, uarg);
+		return dgap_tty_digigetcustombaud(ch, un, uarg);
 
 	case DIGI_SETCUSTOMBAUD:
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-- 
1.7.1

