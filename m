Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3CEQJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:09:55 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41140 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3CEQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:09:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: David Miller <davem@davemloft.net>, Samuel Ortiz <samuel@sortiz.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/4] net/irda: Hold port lock while bumping blocked_open
Date: Tue,  5 Mar 2013 11:09:05 -0500
Message-Id: <1362499747-4262-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
References: <1362371063.3221.185.camel@thor.lan>
 <1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although tty_lock() already protects concurrent update to
blocked_open, that fails to meet the separation-of-concerns between
tty_port and tty.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/irda/ircomm/ircomm_tty.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 1721dc7..d282bbe 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -317,8 +317,8 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 	spin_lock_irqsave(&port->lock, flags);
 	if (!tty_hung_up_p(filp))
 		port->count--;
-	spin_unlock_irqrestore(&port->lock, flags);
 	port->blocked_open++;
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	while (1) {
 		if (tty->termios.c_cflag & CBAUD)
@@ -362,8 +362,8 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 	spin_lock_irqsave(&port->lock, flags);
 	if (!tty_hung_up_p(filp))
 		port->count++;
-	spin_unlock_irqrestore(&port->lock, flags);
 	port->blocked_open--;
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	IRDA_DEBUG(1, "%s(%d):block_til_ready after blocking on %s open_count=%d\n",
 	      __FILE__, __LINE__, tty->driver->name, port->count);
-- 
1.8.1.2

