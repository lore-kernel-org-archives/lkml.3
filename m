Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbaGXPiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:38:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbaGXPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:38:17 -0400
Date: Thu, 24 Jul 2014 08:36:36 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-4fae4e7624653ef498d0e2a38f00620b9701ab04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rjw@rjwysocki.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, rjw@rjwysocki.net
In-Reply-To: <20140724133921.GY6758@twins.programming.kicks-ass.net>
References: <20140724133921.GY6758@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq:
  Warn when shared interrupts do not match on NO_SUSPEND
Git-Commit-ID: 4fae4e7624653ef498d0e2a38f00620b9701ab04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fae4e7624653ef498d0e2a38f00620b9701ab04
Gitweb:     http://git.kernel.org/tip/4fae4e7624653ef498d0e2a38f00620b9701ab04
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 24 Jul 2014 15:39:21 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 24 Jul 2014 17:32:56 +0200

irq: Warn when shared interrupts do not match on NO_SUSPEND

When suspend_device_irqs() iterates all descriptors, its pointless if
one has NO_SUSPEND set while another has not.

Validate on request_irq() that NO_SUSPEND state maches for SHARED
interrupts.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Link: http://lkml.kernel.org/r/20140724133921.GY6758@twins.programming.kicks-ass.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 88657d7..27a1fe0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1077,9 +1077,12 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * set the trigger type must match. Also all must
 		 * agree on ONESHOT.
 		 */
+
+#define IRQF_MISMATCH \
+	(IRQF_TRIGGER_MASK | IRQF_ONESHOT | IRQF_NO_SUSPEND)
+
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
-		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
+		    ((old->flags ^ new->flags) & IRQF_MISMATCH))
 			goto mismatch;
 
 		/* All handlers must agree on per-cpuness */
