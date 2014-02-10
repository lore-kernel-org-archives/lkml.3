Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaBJSlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:41:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:41452 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbaBJSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:41:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <sparclinux@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        <stable@vger.kernel.org>
Subject: [PATCH] irqdesc: Fix missing irq_to_desc export for !CONFIG_SPARSE_IRQ
Date: Mon, 10 Feb 2014 13:39:53 -0500
Message-ID: <1392057610-11514-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In allmodconfig builds for sparc and any other arch which does
not set CONFIG_SPARSE_IRQ, the following will be seen at modpost:

  CC [M]  lib/cpu-notifier-error-inject.o
  CC [M]  lib/pm-notifier-error-inject.o
ERROR: "irq_to_desc" [drivers/gpio/gpio-mcp23s08.ko] undefined!
make[2]: *** [__modpost] Error 1

This happens because commit 3911ff30f5d1175e2e67e73244405e3492b35c79
("genirq: export handle_edge_irq() and irq_to_desc()") added one
export for it, but there were actually two instances of it, in
an if/else clause for CONFIG_SPARSE_IRQ.  Add the second one.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org	# 3.4+
Fixes: 3911ff30f5d1 ("genirq: export handle_edge_irq() and irq_to_desc()")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302d6cfd..8ab8e9390297 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -274,6 +274,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 {
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
+EXPORT_SYMBOL(irq_to_desc);
 
 static void free_desc(unsigned int irq)
 {
-- 
1.8.5.2

