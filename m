Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbaIKNTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:19:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51475 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Christopher Alexander Tobias Schulze" <cat.schulze@alice-dsl.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.860537771@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 118/131] sunsab: Fix detection of BREAK on sunsab
 serial console
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>

[ Upstream commit fe418231b195c205701c0cc550a03f6c9758fd9e ]

Fix detection of BREAK on sunsab serial console: BREAK detection was only
performed when there were also serial characters received simultaneously.
To handle all BREAKs correctly, the check for BREAK and the corresponding
call to uart_handle_break() must also be done if count == 0, therefore
duplicate this code fragment and pull it out of the loop over the received
characters.

Patch applies to 3.16-rc6.

Signed-off-by: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/sunsab.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b5fa2a5..5d80bb9 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -156,6 +156,15 @@ receive_chars(struct uart_sunsab_port *up,
 	    (up->port.line == up->port.cons->index))
 		saw_console_brk = 1;
 
+	if (count == 0) {
+		if (unlikely(stat->sreg.isr1 & SAB82532_ISR1_BRK)) {
+			stat->sreg.isr0 &= ~(SAB82532_ISR0_PERR |
+					     SAB82532_ISR0_FERR);
+			up->port.icount.brk++;
+			uart_handle_break(&up->port);
+		}
+	}
+
 	for (i = 0; i < count; i++) {
 		unsigned char ch = buf[i], flag;
 

