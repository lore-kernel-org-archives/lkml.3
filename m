Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3CDBf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:35:27 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:45258 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3CDBfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:35:22 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] tty/serial: Fix uninitialized variable warning
Date: Mon,  4 Mar 2013 09:35:07 +0800
Message-Id: <1362360907-4439-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/tty/serial/8250/8250.c: In function 'serial_unlink_irq_chain':
drivers/tty/serial/8250/8250.c:1676:19: warning: 'i' may be used uninitialized in this function

There isn't an actual bug here since the function tests the condition
that would cause i to be uninitialized before dereferencing i. However,
at least some versions of GCC complain as shown above. (in my case,
powerpc gcc 2.5.2). Initializing i to NULL makes it clear to GCC and the
casual code reviewer that i will not be dereferenced to a random
address.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Greg, some may argue that this is a tool problem, not a kernel problem,
but it is useful to me. If anyone objects I'm not going to spend any
time championing for this patch.

g.

 drivers/tty/serial/8250/8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 0efc815..cbbedcf 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1673,7 +1673,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i;
+	struct irq_info *i = NULL;
 	struct hlist_node *n;
 	struct hlist_head *h;
 
-- 
1.7.10.4

