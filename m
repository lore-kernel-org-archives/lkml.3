Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422874AbaGRNuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:50:52 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17498 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030501AbaGRNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 121/170] tty: Correct INPCK handling
Date: Fri, 18 Jul 2014 14:12:06 +0200
Message-Id: <2c53a1afadd6984b792b7354298ebd6cf8584f47.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 66528f90669691c85c73bea4f0c9f4a5857c4cab upstream.

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_tty.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index bd73dc25b41d..eac1b0d5b463 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1210,15 +1210,16 @@ static void n_tty_receive_parity_error(struct tty_struct *tty, unsigned char c)
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
 	wake_up_interruptible(&tty->read_wait);
 }
-- 
2.0.0

