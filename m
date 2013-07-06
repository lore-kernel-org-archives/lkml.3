Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3GFMPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 08:15:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41852 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3GFMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 08:15:24 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] irq: add lock annotation to squelch a sparse warning
Date: Sat,  6 Jul 2013 17:41:26 +0530
Message-Id: <1373112686-28501-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.733.gf8abaeb
In-Reply-To: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
References: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__irq_put_desc_unlock() releases &desc->lock, but being a static
analyzer, sparse emits a warning:

  context imbalance in '__irq_put_desc_unlock' - unexpected unlock

Help it by annotating the function with a __release.  Do not annotate
its counterpart which acquires the lock, __irq_get_desc_lock(), because
it does so conditionally.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 kernel/irq/irqdesc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..d6bc26a 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -449,6 +449,7 @@ __irq_get_desc_lock(unsigned int irq, unsigned long *flags, bool bus,
 }
 
 void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
+	__releases(&desc->lock)
 {
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	if (bus)
-- 
1.8.3.2.733.gf8abaeb

