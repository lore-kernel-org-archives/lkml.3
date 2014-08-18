Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaHRJgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:36:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaHRJgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 126/137] sunsab: Fix detection of BREAK on sunsab serial console
Date: Mon, 18 Aug 2014 10:33:07 +0100
Message-Id: <1408354398-10226-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>

commit fe418231b195c205701c0cc550a03f6c9758fd9e upstream.

Fix detection of BREAK on sunsab serial console: BREAK detection was only
performed when there were also serial characters received simultaneously.
To handle all BREAKs correctly, the check for BREAK and the corresponding
call to uart_handle_break() must also be done if count == 0, therefore
duplicate this code fragment and pull it out of the loop over the received
characters.

Patch applies to 3.16-rc6.

Signed-off-by: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/sunsab.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 5d6136b2a04a..edcb84980d60 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -157,6 +157,15 @@ receive_chars(struct uart_sunsab_port *up,
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
 
-- 
1.9.1

