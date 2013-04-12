Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3DLIdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:33:54 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:44291 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3DLIdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:33:50 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        "David S. Miller" <davem@davemloft.net>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3/4] TTY: synclinkmp: fix DTR being raised on hang up
Date: Fri, 12 Apr 2013 10:32:30 +0200
Message-Id: <1365755551-17824-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365755551-17824-1-git-send-email-jhovold@gmail.com>
References: <1365755551-17824-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure to check ASYNC_INITIALISED before raising DTR when waking up
from blocked open in block_til_ready.

Currently DTR could get raised at hang up as a blocked process would
raise DTR unconditionally before checking for hang up and returning.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/tty/synclinkmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 6d5780c..ff17138 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -3329,7 +3329,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	port->blocked_open++;
 
 	while (1) {
-		if (tty->termios.c_cflag & CBAUD)
+		if (C_BAUD(tty) && test_bit(ASYNCB_INITIALIZED, &port->flags))
 			tty_port_raise_dtr_rts(port);
 
 		set_current_state(TASK_INTERRUPTIBLE);
-- 
1.8.1.5

