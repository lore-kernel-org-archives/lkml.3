Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3FOO2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:28:45 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40643 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3FOO2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:28:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 13/20] n_tty: Eliminate char tests from IXANY restart test
Date: Sat, 15 Jun 2013 10:21:29 -0400
Message-Id: <1371306096-5571-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relocate the IXANY restart tty test to code paths where the
the received char is not START_CHAR, STOP_CHAR, INTR_CHAR,
QUIT_CHAR or SUSP_CHAR.

Fixes the condition when ISIG if off and one of INTR_CHAR,
QUIT_CHAR or SUSP_CHAR does not restart i/o.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 785def1..1f21c97 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1268,13 +1268,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 		return;
 	}
 
-	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
-	    I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty) &&
-	    c != INTR_CHAR(tty) && c != QUIT_CHAR(tty) && c != SUSP_CHAR(tty)) {
-		start_tty(tty);
-		process_echoes(tty);
-	}
-
 	/*
 	 * If the previous character was LNEXT, or we know that this
 	 * character is not one of the characters that we'll have to
@@ -1283,6 +1276,13 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	 */
 	if (!test_bit(c, ldata->char_map) || ldata->lnext) {
 		ldata->lnext = 0;
+
+		if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
+		    I_IXANY(tty)) {
+			start_tty(tty);
+			process_echoes(tty);
+		}
+
 		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
 		if (read_cnt(ldata) >= (N_TTY_BUF_SIZE - parmrk - 1)) {
 			/* beep if no space */
@@ -1329,6 +1329,11 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 		}
 	}
 
+	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty)) {
+		start_tty(tty);
+		process_echoes(tty);
+	}
+
 	if (c == '\r') {
 		if (I_IGNCR(tty))
 			return;
-- 
1.8.1.2

