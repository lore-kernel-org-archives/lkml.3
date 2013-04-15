Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3DOQCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:02:54 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:48290 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3DOQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:02:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 15/20] n_tty: Factor ISTRIP and IUCLC receive_buf into separate fn
Date: Mon, 15 Apr 2013 11:32:46 -0400
Message-Id: <1366039971-8770-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
References: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
 <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
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
index 8601d6e..6316426 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1417,16 +1417,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
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
@@ -1584,9 +1574,34 @@ n_tty_receive_buf_closing(struct tty_struct *tty, const unsigned char *cp,
 
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
@@ -1612,7 +1627,10 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
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

