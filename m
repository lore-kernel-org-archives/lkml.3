Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaGKKXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:23:55 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39782 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaGKKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:23:53 -0400
Date: Fri, 11 Jul 2014 19:22:39 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] staging: dgap: removes redundant null check and change
 the paramter for dgap_param()
Message-ID: <20140711102239.GA22321@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_param() has a paramter which is tty_struct and
use variables in that struct. That variables which are "ch", "bd", "bs"
and "un" do not need to check NULL so these statements are removed.

And also change the parameter of this function because
it is possible to let someone know what paramters
are needed for this function.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   49 +++++++++++-------------------------------
 1 files changed, 13 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index ad7b462..4e5b594 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -141,7 +141,7 @@ static void dgap_cmdb(struct channel_t *ch, u8 cmd, u8 byte1,
 			u8 byte2, uint ncmds);
 static void dgap_cmdw(struct channel_t *ch, u8 cmd, u16 word, uint ncmds);
 static void dgap_wmove(struct channel_t *ch, char *buf, uint cnt);
-static int dgap_param(struct tty_struct *tty);
+static int dgap_param(struct channel_t *ch, struct board_t *bd, u32 un_type);
 static void dgap_parity_scan(struct channel_t *ch, unsigned char *cbuf,
 				unsigned char *fbuf, int *len);
 static uint dgap_get_custom_baud(struct channel_t *ch);
@@ -2029,7 +2029,7 @@ static int dgap_tty_open(struct tty_struct *tty, struct file *file)
 	/*
 	 * Run param in case we changed anything
 	 */
-	dgap_param(tty);
+	dgap_param(ch, brd, un->un_type);
 
 	/*
 	 * follow protocol for opening port
@@ -2927,7 +2927,7 @@ static int dgap_tty_tiocmset(struct tty_struct *tty,
 		ch->ch_mval   &= ~(D_DTR(ch));
 	}
 
-	dgap_param(tty);
+	dgap_param(ch, bd, un->un_type);
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
@@ -3173,7 +3173,7 @@ static int dgap_set_modem_info(struct tty_struct *tty, unsigned int command,
 	spin_lock_irqsave(&bd->bd_lock, lock_flags);
 	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
 
-	dgap_param(tty);
+	dgap_param(ch, bd, un->un_type);
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
@@ -3285,7 +3285,7 @@ static int dgap_tty_digiseta(struct tty_struct *tty,
 	if (ch->ch_digi.digi_offlen > DIGI_PLEN)
 		ch->ch_digi.digi_offlen = DIGI_PLEN;
 
-	dgap_param(tty);
+	dgap_param(ch, bd, un->un_type);
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
@@ -3372,7 +3372,7 @@ static int dgap_tty_digisetedelay(struct tty_struct *tty, int __user *new_info)
 
 	writew((u16) new_digi, &(ch->ch_bs->edelay));
 
-	dgap_param(tty);
+	dgap_param(ch, bd, un->un_type);
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
@@ -3460,7 +3460,7 @@ static int dgap_tty_digisetcustombaud(struct tty_struct *tty,
 
 		ch->ch_custom_speed = new_rate;
 
-		dgap_param(tty);
+		dgap_param(ch, bd, un->un_type);
 
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
@@ -3507,7 +3507,7 @@ static void dgap_tty_set_termios(struct tty_struct *tty,
 	ch->ch_stopc     = tty->termios.c_cc[VSTOP];
 
 	dgap_carrier(ch);
-	dgap_param(tty);
+	dgap_param(ch, bd, un->un_type);
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
@@ -3914,7 +3914,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		spin_lock_irqsave(&ch->ch_lock, lock_flags2);
 		tty->termios.c_cflag = ((tty->termios.c_cflag & ~CLOCAL) |
 						(arg ? CLOCAL : 0));
-		dgap_param(tty);
+		dgap_param(ch, bd, un->un_type);
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 
@@ -4124,7 +4124,7 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 	case DIGI_RESET_PORT:
 		dgap_firmware_reset_port(ch);
-		dgap_param(tty);
+		dgap_param(ch, bd, un->un_type);
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 		return 0;
@@ -5066,37 +5066,14 @@ static void dgap_firmware_reset_port(struct channel_t *ch)
  *              struct tty_struct *     - TTY for port.
  *
  *=======================================================================*/
-static int dgap_param(struct tty_struct *tty)
+static int dgap_param(struct channel_t *ch, struct board_t *bd, u32 un_type)
 {
-	struct board_t *bd;
-	struct channel_t *ch;
-	struct bs_t __iomem *bs;
-	struct un_t *un;
 	u16 head;
 	u16 cflag;
 	u16 iflag;
 	u8 mval;
 	u8 hflow;
 
-	if (!tty || tty->magic != TTY_MAGIC)
-		return -EIO;
-
-	un = (struct un_t *) tty->driver_data;
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
-	bs = ch->ch_bs;
-	if (!bs)
-		return -EIO;
-
 	/*
 	 * If baud rate is zero, flush queues, and set mval to drop DTR.
 	 */
@@ -5176,7 +5153,7 @@ static int dgap_param(struct tty_struct *tty)
 		 * terminal unit is NOT open
 		 */
 		if (!(ch->ch_tun.un_flags & UN_ISOPEN) &&
-		     (un->un_type == DGAP_PRINT))
+		    un_type == DGAP_PRINT)
 			baud = C_BAUD(ch->ch_pun.un_tty) & 0xff;
 		else
 			baud = C_BAUD(ch->ch_tun.un_tty) & 0xff;
@@ -5374,7 +5351,7 @@ static int dgap_param(struct tty_struct *tty)
 	/*
 	 * Read modem signals, and then call carrier function.
 	 */
-	ch->ch_mistat = readb(&(bs->m_stat));
+	ch->ch_mistat = readb(&(ch->ch_bs->m_stat));
 	dgap_carrier(ch);
 
 	/*
-- 
1.7.1

