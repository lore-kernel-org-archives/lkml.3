Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3GXMaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:30:25 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:56194 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3GXMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:30:22 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 2/9] n_tty: Eliminate char tests from IXANY restart test
Date: Wed, 24 Jul 2013 08:29:50 -0400
Message-Id: <1374668997-29726-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
References: <20130724001259.GA9239@kroah.com>
 <1374668997-29726-1-git-send-email-peter@hurleysoftware.com>
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
index 15d95e4..d3b4129 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1269,13 +1269,6 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
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
@@ -1284,6 +1277,13 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
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
@@ -1330,6 +1330,11 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
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

