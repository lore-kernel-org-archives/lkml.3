Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3CEQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:09:56 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41141 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872Ab3CEQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:09:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: David Miller <davem@davemloft.net>, Samuel Ortiz <samuel@sortiz.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/4] net/irda: Raise dtr in non-blocking open
Date: Tue,  5 Mar 2013 11:09:07 -0500
Message-Id: <1362499747-4262-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
References: <1362371063.3221.185.camel@thor.lan>
 <1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DTR/RTS need to be raised, regardless of the open() mode, but not
if the port has already shutdown.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/irda/ircomm/ircomm_tty.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 522543d..362ba47 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -289,8 +289,15 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 	 * If non-blocking mode is set, or the port is not enabled,
 	 * then make the check up front and then exit.
 	 */
-	if (filp->f_flags & O_NONBLOCK || tty->flags & (1 << TTY_IO_ERROR)){
-		/* nonblock mode is set or port is not enabled */
+	if (test_bit(TTY_IO_ERROR, &tty->flags)) {
+		port->flags |= ASYNC_NORMAL_ACTIVE;
+		return 0;
+	}
+
+	if (filp->f_flags & O_NONBLOCK) {
+		/* nonblock mode is set */
+		if (tty->termios.c_cflag & CBAUD)
+			tty_port_raise_dtr_rts(port);
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		IRDA_DEBUG(1, "%s(), O_NONBLOCK requested!\n", __func__ );
 		return 0;
-- 
1.8.1.2

