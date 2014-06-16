Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaFPMLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:11:13 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34955 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753083AbaFPMLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:11:10 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ivan <athlon_@mail.ru>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 2/2] tty: Correct INPCK handling
Date: Mon, 16 Jun 2014 08:10:42 -0400
Message-Id: <1402920642-4855-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402920642-4855-1-git-send-email-peter@hurleysoftware.com>
References: <1402920642-4855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If INPCK is not set, input parity detection should be disabled. This means
parity errors should not be received from the tty driver, and the data
received should be treated normally.

SUS v3, 11.2.2, General Terminal Interface - Input Modes, states:
  "If INPCK is set, input parity checking shall be enabled. If INPCK is
   not set, input parity checking shall be disabled, allowing output parity
   generation without input parity errors. Note that whether input parity
   checking is enabled or disabled is independent of whether parity detection
   is enabled or disabled (see Control Modes). If parity detection is enabled
   but input parity checking is disabled, the hardware to which the terminal
   is connected shall recognize the parity bit, but the terminal special file
   shall not check whether or not this bit is correctly set."

Ignore parity errors reported by the tty driver when INPCK is not set, and
handle the received data normally.

Fixes: Bugzilla #71681, 'Improvement of n_tty_receive_parity_error from n_tty.c'
Reported-by: Ivan <athlon_@mail.ru>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index fe9d129..0391f17 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1214,15 +1214,16 @@ static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
-	if (I_IGNPAR(tty))
-		return;
-	if (I_PARMRK(tty)) {
-		put_tty_queue('\377', ldata);
-		put_tty_queue('\0', ldata);
-		put_tty_queue(c, ldata);
-	} else	if (I_INPCK(tty))
-		put_tty_queue('\0', ldata);
-	else
+	if (I_INPCK(tty)) {
+		if (I_IGNPAR(tty))
+			return;
+		if (I_PARMRK(tty)) {
+			put_tty_queue('\377', ldata);
+			put_tty_queue('\0', ldata);
+			put_tty_queue(c, ldata);
+		} else
+			put_tty_queue('\0', ldata);
+	} else
 		put_tty_queue(c, ldata);
 	if (waitqueue_active(&tty->read_wait))
 		wake_up_interruptible(&tty->read_wait);
-- 
2.0.0

