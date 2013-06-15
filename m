Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3FOO21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:28:27 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40646 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3FOO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:28:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 12/20] n_tty: Factor standard per-char i/o into separate fn
Date: Sat, 15 Jun 2013 10:21:28 -0400
Message-Id: <1371306096-5571-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify __receive_buf() into a dispatch function; perform per-char
processing for all other modes not already handled.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 099b02d..785def1 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1567,6 +1567,23 @@ n_tty_receive_buf_closing(struct tty_struct *tty, const unsigned char *cp,
 	}
 }
 
+static void
+n_tty_receive_buf_standard(struct tty_struct *tty, const unsigned char *cp,
+			   char *fp, int count)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	char flag = TTY_NORMAL;
+
+	while (count--) {
+		if (fp)
+			flag = *fp++;
+		if (likely(flag == TTY_NORMAL))
+			n_tty_receive_char(tty, *cp++);
+		else
+			n_tty_receive_char_flagged(tty, *cp++, flag);
+	}
+}
+
 static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			  char *fp, int count)
 {
@@ -1580,16 +1597,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	else if (tty->closing && !L_EXTPROC(tty))
 		n_tty_receive_buf_closing(tty, cp, fp, count);
 	else {
-		char flag = TTY_NORMAL;
-
-		while (count--) {
-			if (fp)
-				flag = *fp++;
-			if (likely(flag == TTY_NORMAL))
-				n_tty_receive_char(tty, *cp++);
-			else
-				n_tty_receive_char_flagged(tty, *cp++, flag);
-		}
+		n_tty_receive_buf_standard(tty, cp, fp, count);
 
 		flush_echoes(tty);
 		if (tty->ops->flush_chars)
-- 
1.8.1.2

