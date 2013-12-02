Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3LBTxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:53:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3LBTSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heorhi Valakhanovich <valahanovich@tut.by>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.12 118/212] tty: Reset hupped state on open
Date: Mon,  2 Dec 2013 11:15:09 -0800
Message-Id: <20131202191300.339003023@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit d4855e1fc03c2bb32dd64badf51cec5a2a26ab2a upstream.

A common security idiom is to hangup the current tty (via vhangup())
after forking but before execing a root shell. This hangs up any
existing opens which other processes may have and ensures subsequent
opens have the necessary permissions to open the root shell tty/pty.

Reset the TTY_HUPPED state after the driver has successfully
returned the opened tty (perform the reset while the tty is locked
to avoid racing with concurrent hangups).

Reported-by: Heorhi Valakhanovich <valahanovich@tut.by>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Tested-by: Heorhi Valakhanovich <valahanovich@tut.by>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2086,6 +2086,7 @@ retry_open:
 			filp->f_op = &tty_fops;
 		goto retry_open;
 	}
+	clear_bit(TTY_HUPPED, &tty->flags);
 	tty_unlock(tty);
 
 


