Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3ETRIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:08:01 -0400
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1066 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752761Ab3ETRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:08:00 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7923
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Benjamin Krill <ben@codiert.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] tty: nwpserial: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 19:07:30 +0200
Message-Id: <1369069650-1742-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() expects the same pointer that was passed to request_irq(), otherwise
the IRQ is not freed.

The issue was found using the following coccinelle script:

<smpl>
@r1@
type T;
T devid;
@@
request_irq(..., devid)

@r2@
type r1.T;
T devid;
position p;
@@
free_irq@p(..., devid)

@@
position p != r2.p;
@@
*free_irq@p(...)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/tty/serial/nwpserial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/nwpserial.c b/drivers/tty/serial/nwpserial.c
index 77287c5..549c70a 100644
--- a/drivers/tty/serial/nwpserial.c
+++ b/drivers/tty/serial/nwpserial.c
@@ -199,7 +199,7 @@ static void nwpserial_shutdown(struct uart_port *port)
 	dcr_write(up->dcr_host, UART_IER, up->ier);
 
 	/* free irq */
-	free_irq(up->port.irq, port);
+	free_irq(up->port.irq, up);
 }
 
 static int nwpserial_verify_port(struct uart_port *port,
-- 
1.8.0

