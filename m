Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3FOOaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:30:21 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40621 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3FOO1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:27:51 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 15/20] n_tty: Factor ISTRIP and IUCLC receive_buf into separate fn
Date: Sat, 15 Jun 2013 10:21:31 -0400
Message-Id: <1371306096-5571-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to modal receive_buf processing; factor char receive
processing for unusual termios settings out of normal per-char
i/o path.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3e96828..17cb70e 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1416,16 +1416,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	struct n_tty_data *ldata = tty->disc_data;
 	int parmrk;
 
-	if (I_ISTRIP(tty))
-		c &= 0x7f;
-	if (I_IUCLC(tty) && L_IEXTEN(tty))
-		c = tolower(c);
-
-	if (L_EXTPROC(tty)) {
-		put_tty_queue(c, ldata);
-		return;
-	}
-
 	/*
 	 * If the previous character was LNEXT, or we know that this
 	 * character is not one of the characters that we'll have to
@@ -1583,9 +1573,34 @@ n_tty_receive_buf_closing(struct tty_struct *tty, const unsigned char *cp,
 
 static void
 n_tty_receive_buf_standard(struct tty_struct *tty, const unsigned char *cp,
-			   char *fp, int count)
+			  char *fp, int count)
+{
+	char flag = TTY_NORMAL;
+
+	while (count--) {
+		if (fp)
+			flag = *fp++;
+		if (likely(flag == TTY_NORMAL)) {
+			unsigned char c = *cp++;
+
+			if (I_ISTRIP(tty))
+				c &= 0x7f;
+			if (I_IUCLC(tty) && L_IEXTEN(tty))
+				c = tolower(c);
+			if (L_EXTPROC(tty)) {
+				put_tty_queue(c, ldata);
+				continue;
+			}
+			n_tty_receive_char(tty, c);
+		} else
+			n_tty_receive_char_flagged(tty, *cp++, flag);
+	}
+}
+
+static void
+n_tty_receive_buf_fast(struct tty_struct *tty, const unsigned char *cp,
+		       char *fp, int count)
 {
-	struct n_tty_data *ldata = tty->disc_data;
 	char flag = TTY_NORMAL;
 
 	while (count--) {
@@ -1611,7 +1626,10 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	else if (tty->closing && !L_EXTPROC(tty))
 		n_tty_receive_buf_closing(tty, cp, fp, count);
 	else {
-		n_tty_receive_buf_standard(tty, cp, fp, count);
+		if (!preops)
+			n_tty_receive_buf_fast(tty, cp, fp, count);
+		else
+			n_tty_receive_buf_standard(tty, cp, fp, count);
 
 		flush_echoes(tty);
 		if (tty->ops->flush_chars)
-- 
1.8.1.2

