Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3GXMaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:30:22 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:56187 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3GXMaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:30:20 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 1/9] n_tty: Factor standard per-char i/o into separate fn
Date: Wed, 24 Jul 2013 08:29:49 -0400
Message-Id: <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130724001259.GA9239@kroah.com>
References: <20130724001259.GA9239@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify __receive_buf() into a dispatch function; perform per-char
processing for all other modes not already handled.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index ed6c4e4..15d95e4 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1568,6 +1568,22 @@ n_tty_receive_buf_closing(struct tty_struct *tty, const unsigned char *cp,
 	}
 }
 
+static void
+n_tty_receive_buf_standard(struct tty_struct *tty, const unsigned char *cp,
+			   char *fp, int count)
+{
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
@@ -1581,16 +1597,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
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

