Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaBSUCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:02:06 -0500
Received: from mail1.windriver.com ([147.11.146.13]:43049 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaBSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:02:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH] drivers/tty/serial: deal with 8250_core.c uninitialized warning for good
Date: Wed, 19 Feb 2014 15:00:13 -0500
Message-ID: <1392840013-15957-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every couple of months, someone sends a patch to fix:

drivers/tty/serial/8250/8250_core.c: In function 'serial_unlink_irq_chain':
drivers/tty/serial/8250/8250_core.c:1712:2: warning: 'i' may be used uninitialized in this function [-Wuninitialized]

and they in turn get a NACK for their efforts, and are told that
their compiler is broken.  This has been going on since at least
the year 2008:  https://lkml.org/lkml/2008/11/24/433

Lets add a comment, so that subsequent patches don't get as far as
the maintainers or the mailing lists.

Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 69932b7556cf..747073b8c38a 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1694,6 +1694,10 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
+	/*
+	 * yes, some broken gcc emit "warning: 'i' may be used uninitialized"
+	 * but no, we are not going to take a patch that assigns NULL below.
+	 */
 	struct irq_info *i;
 	struct hlist_node *n;
 	struct hlist_head *h;
-- 
1.8.5.2

