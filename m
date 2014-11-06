Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKFUMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:12:50 -0500
Received: from filter1.ibarracuda.nl ([83.247.7.10]:48019 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaKFUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:12:48 -0500
X-ASG-Debug-ID: 1415304760-0759e711ce1deb30002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] serial: 8250_core: actually limit char reads to max_count
Date: Thu, 6 Nov 2014 21:10:17 +0100
X-ASG-Orig-Subj: [PATCH v2] serial: 8250_core: actually limit char reads to max_count
Message-ID: <1415304617-14835-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413212951-20901-1-git-send-email-frans.klaver@xsens.com>
References: <1413212951-20901-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1415304760
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.11303
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In serial8250_rx_chars(), max_count is set to 256. Due to the
post-decrement operator used in the while() condition, the maximum
number of iterations actually 257. This is not a problem, but it is
mildly surprising if you're debugging. Use pre-decrement instead.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
v1..v2: change subject to better reflect the goal of the patch

 drivers/tty/serial/8250/8250_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index a06084d..cc9f1a8 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1485,7 +1485,7 @@ serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr)
 
 ignore_char:
 		lsr = serial_in(up, UART_LSR);
-	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0));
+	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (--max_count > 0));
 	spin_unlock(&port->lock);
 	tty_flip_buffer_push(&port->state->port);
 	spin_lock(&port->lock);
-- 
2.1.0

