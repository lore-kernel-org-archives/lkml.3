Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab3DOPdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:33:49 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:46019 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3DOPdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:33:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 09/20] n_tty: Factor raw mode receive_buf() into separate fn
Date: Mon, 15 Apr 2013 11:32:40 -0400
Message-Id: <1366039971-8770-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
References: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
 <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to modal receive_buf() processing; factor raw mode
per-char i/o into n_tty_receive_buf_raw().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index dce77cb..cf99660 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1259,11 +1259,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	struct n_tty_data *ldata = tty->disc_data;
 	int parmrk;
 
-	if (ldata->raw) {
-		put_tty_queue(c, ldata);
-		return;
-	}
-
 	if (I_ISTRIP(tty))
 		c &= 0x7f;
 	if (I_IUCLC(tty) && L_IEXTEN(tty))
@@ -1530,6 +1525,23 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
 	ldata->read_head += n;
 }
 
+static void
+n_tty_receive_buf_raw(struct tty_struct *tty, const unsigned char *cp,
+		      char *fp, int count)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	char flag = TTY_NORMAL;
+
+	while (count--) {
+		if (fp)
+			flag = *fp++;
+		if (likely(flag == TTY_NORMAL))
+			put_tty_queue(*cp++, ldata);
+		else
+			n_tty_receive_char_flagged(tty, *cp++, flag);
+	}
+}
+
 static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			  char *fp, int count)
 {
@@ -1537,6 +1549,8 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	if (ldata->real_raw)
 		n_tty_receive_buf_real_raw(tty, cp, fp, count);
+	else if (ldata->raw)
+		n_tty_receive_buf_raw(tty, cp, fp, count);
 	else {
 		char flag = TTY_NORMAL;
 
-- 
1.8.1.2

