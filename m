Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaHTLxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:53:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59008 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christopher Alexander Tobias Schulze 
	<cat.schulze@alice-dsl.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/104] sunsab: Fix detection of BREAK on sunsab serial console
Date: Wed, 20 Aug 2014 13:43:19 +0200
Message-Id: <add908eff1c76d0d1a08284ef97ffc017bd75270.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/sunsab.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 2fee558f2b13..09c86720cb03 100644
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
2.0.4

