Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbaHHWFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:05:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbaHHVgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Alexander Tobias Schulze 
	<cat.schulze@alice-dsl.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 22/24] sunsab: Fix detection of BREAK on sunsab serial console
Date: Fri,  8 Aug 2014 14:35:15 -0700
Message-Id: <20140808213336.333610980@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213335.421758947@linuxfoundation.org>
References: <20140808213335.421758947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sunsab.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -157,6 +157,15 @@ receive_chars(struct uart_sunsab_port *u
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
 


