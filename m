Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbaIOWd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:33:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbaIOWTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 032/187] sunsab: Fix detection of BREAK on sunsab serial console
Date: Mon, 15 Sep 2014 15:07:22 -0700
Message-Id: <1410818997-9432-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/sunsab.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 380fb53..1c0e2a4 100644
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

