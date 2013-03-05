Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3CEQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:09:59 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41137 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3CEQJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:09:50 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: David Miller <davem@davemloft.net>, Samuel Ortiz <samuel@sortiz.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/4] net/irda: Use barrier to set task state
Date: Tue,  5 Mar 2013 11:09:06 -0500
Message-Id: <1362499747-4262-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
References: <1362371063.3221.185.camel@thor.lan>
 <1362499747-4262-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without a memory and compiler barrier, the task state change
can migrate relative to the condition testing in a blocking loop.
However, the task state change must be visible across all cpus
prior to testing those conditions. Failing to do this can result
in the familiar 'lost wakeup' and this task will hang until killed.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/irda/ircomm/ircomm_tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index d282bbe..522543d 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -324,7 +324,7 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 		if (tty->termios.c_cflag & CBAUD)
 			tty_port_raise_dtr_rts(port);
 
-		current->state = TASK_INTERRUPTIBLE;
+		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (tty_hung_up_p(filp) ||
 		    !test_bit(ASYNCB_INITIALIZED, &port->flags)) {
-- 
1.8.1.2

