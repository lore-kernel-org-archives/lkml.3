Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3LBS4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:56:34 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42513 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3LBS4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:56:31 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 1/5] tty: Always handle NULL flag ptr
Date: Mon,  2 Dec 2013 13:56:03 -0500
Message-Id: <1386010563-4864-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20131122222040.GA12800@core.coreip.homeip.net>
References: <20131122222040.GA12800@core.coreip.homeip.net>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most line disciplines already handle the undocumented NULL flag
ptr in their .receive_buf method; however, several don't.

Document the NULL flag ptr, and correct handling in the
N_MOUSE, N_GSM0710 and N_R394 line disciplines.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---

v2 - Uses 0 for no flags to serio layer per Dmitry.

 drivers/input/serio/serport.c | 28 +++++++++++++++-------------
 drivers/tty/n_gsm.c           |  5 +++--
 drivers/tty/n_r3964.c         |  2 +-
 include/linux/tty_ldisc.h     |  6 ++++--
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 8755f5f..0cb7ef5 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -124,7 +124,7 @@ static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *c
 {
 	struct serport *serport = (struct serport*) tty->disc_data;
 	unsigned long flags;
-	unsigned int ch_flags;
+	unsigned int ch_flags = 0;
 	int i;
 
 	spin_lock_irqsave(&serport->lock, flags);
@@ -133,18 +133,20 @@ static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *c
 		goto out;
 
 	for (i = 0; i < count; i++) {
-		switch (fp[i]) {
-		case TTY_FRAME:
-			ch_flags = SERIO_FRAME;
-			break;
-
-		case TTY_PARITY:
-			ch_flags = SERIO_PARITY;
-			break;
-
-		default:
-			ch_flags = 0;
-			break;
+		if (fp) {
+			switch (fp[i]) {
+			case TTY_FRAME:
+				ch_flags = SERIO_FRAME;
+				break;
+
+			case TTY_PARITY:
+				ch_flags = SERIO_PARITY;
+				break;
+
+			default:
+				ch_flags = 0;
+				break;
+			}
 		}
 
 		serio_interrupt(serport->serio, cp[i], ch_flags);
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c0f76da..c09db11 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2269,14 +2269,15 @@ static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	char *f;
 	int i;
 	char buf[64];
-	char flags;
+	char flags = TTY_NORMAL;
 
 	if (debug & 4)
 		print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
 				     cp, count);
 
 	for (i = count, dp = cp, f = fp; i; i--, dp++) {
-		flags = *f++;
+		if (f)
+			flags = *f++;
 		switch (flags) {
 		case TTY_NORMAL:
 			gsm->receive(gsm, *dp);
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index 1e64050..8b157d6 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -1244,7 +1244,7 @@ static void r3964_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 {
 	struct r3964_info *pInfo = tty->disc_data;
 	const unsigned char *p;
-	char *f, flags = 0;
+	char *f, flags = TTY_NORMAL;
 	int i;
 
 	for (i = count, p = cp, f = fp; i; i--, p++) {
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index f15c898..b8347c2 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -84,7 +84,8 @@
  *	processing.  <cp> is a pointer to the buffer of input
  *	character received by the device.  <fp> is a pointer to a
  *	pointer of flag bytes which indicate whether a character was
- *	received with a parity error, etc.
+ *	received with a parity error, etc. <fp> may be NULL to indicate
+ *	all data received is TTY_NORMAL.
  *
  * void	(*write_wakeup)(struct tty_struct *);
  *
@@ -118,7 +119,8 @@
  *	processing.  <cp> is a pointer to the buffer of input
  *	character received by the device.  <fp> is a pointer to a
  *	pointer of flag bytes which indicate whether a character was
- *	received with a parity error, etc.
+ *	received with a parity error, etc. <fp> may be NULL to indicate
+ *	all data received is TTY_NORMAL.
  *	If assigned, prefer this function for automatic flow control.
  */
 
-- 
1.8.1.2

