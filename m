Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3LBT1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:27:40 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44382 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3LBTZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:45 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 4/8] n_tty: Refactor PARMRK doubling checks
Date: Mon,  2 Dec 2013 14:24:44 -0500
Message-Id: <1386012288-5079-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
 <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform PARMRK doubling checks explicitly; remove ternary idiom
and local variable.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f8a76d3..008b6e5 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1260,7 +1260,6 @@ static int
 n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int parmrk;
 
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
@@ -1345,8 +1344,6 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 		}
 		if ((c == EOL_CHAR(tty)) ||
 		    (c == EOL2_CHAR(tty) && L_IEXTEN(tty))) {
-			parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty))
-				 ? 1 : 0;
 			/*
 			 * XXX are EOL_CHAR and EOL2_CHAR echoed?!?
 			 */
@@ -1361,7 +1358,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 			 * XXX does PARMRK doubling happen for
 			 * EOL_CHAR and EOL2_CHAR?
 			 */
-			if (parmrk)
+			if (c == (unsigned char) '\377' && I_PARMRK(tty))
 				put_tty_queue(c, ldata);
 
 handle_newline:
@@ -1375,7 +1372,6 @@ handle_newline:
 		}
 	}
 
-	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
 	if (L_ECHO(tty)) {
 		finish_erasing(ldata);
 		if (c == '\n')
@@ -1389,7 +1385,8 @@ handle_newline:
 		commit_echoes(tty);
 	}
 
-	if (parmrk)
+	/* PARMRK doubling check */
+	if (c == (unsigned char) '\377' && I_PARMRK(tty))
 		put_tty_queue(c, ldata);
 
 	put_tty_queue(c, ldata);
@@ -1400,7 +1397,6 @@ static inline void
 n_tty_receive_char_inline(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int parmrk;
 
 	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty)) {
 		start_tty(tty);
@@ -1414,8 +1410,8 @@ n_tty_receive_char_inline(struct tty_struct *tty, unsigned char c)
 		echo_char(c, tty);
 		commit_echoes(tty);
 	}
-	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
-	if (parmrk)
+	/* PARMRK doubling check */
+	if (c == (unsigned char) '\377' && I_PARMRK(tty))
 		put_tty_queue(c, ldata);
 	put_tty_queue(c, ldata);
 }
-- 
1.8.1.2

