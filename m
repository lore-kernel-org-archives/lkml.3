Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaGHA2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:28:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaGGXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ivan <athlon_@mail.ru>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.14 81/94] tty: Correct INPCK handling
Date: Mon,  7 Jul 2014 16:58:11 -0700
Message-Id: <20140707235759.162748650@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1214,15 +1214,16 @@ static void n_tty_receive_parity_error(s
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


