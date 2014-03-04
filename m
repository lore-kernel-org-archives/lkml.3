Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaCDQll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:41:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaCDQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:41:38 -0500
Date: Tue, 4 Mar 2014 08:41:03 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-02893afdd310fab8f41f6afbe5233c6609ec19ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
In-Reply-To: <20140223212738.579581220@linutronix.de>
References: <20140223212738.579581220@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] xen: Get rid of the last irq_desc abuse
Git-Commit-ID: 02893afdd310fab8f41f6afbe5233c6609ec19ed
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

Commit-ID:  02893afdd310fab8f41f6afbe5233c6609ec19ed
Gitweb:     http://git.kernel.org/tip/02893afdd310fab8f41f6afbe5233c6609ec19ed
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:20 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:53 +0100

xen: Get rid of the last irq_desc abuse

Warn if any PIRQ cannot be bound to an event channel. Remove the check
for irq_desc->action. This hypercall never fails in practice so we can
emit a warning unconditionally.

Remove a check for a valid irq desc. The only caller of
xen_destroy_irq() will only do so if the irq was previously fully
setup, which means the descriptor has been allocated as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
Cc: David Vrabel <david.vrabel@citrix.com>
Link: http://lkml.kernel.org/r/20140223212738.579581220@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events/events_base.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 7fea02c..5dd2ddf 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -487,13 +487,6 @@ static void pirq_query_unmask(int irq)
 		info->u.pirq.flags |= PIRQ_NEEDS_EOI;
 }
 
-static bool probing_irq(int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	return desc && desc->action == NULL;
-}
-
 static void eoi_pirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
@@ -535,8 +528,7 @@ static unsigned int __startup_pirq(unsigned int irq)
 					BIND_PIRQ__WILL_SHARE : 0;
 	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
 	if (rc != 0) {
-		if (!probing_irq(irq))
-			pr_info("Failed to obtain physical IRQ %d\n", irq);
+		pr_warn("Failed to obtain physical IRQ %d\n", irq);
 		return 0;
 	}
 	evtchn = bind_pirq.port;
@@ -769,17 +761,12 @@ error_irq:
 
 int xen_destroy_irq(int irq)
 {
-	struct irq_desc *desc;
 	struct physdev_unmap_pirq unmap_irq;
 	struct irq_info *info = info_for_irq(irq);
 	int rc = -ENOENT;
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	desc = irq_to_desc(irq);
-	if (!desc)
-		goto out;
-
 	if (xen_initial_domain()) {
 		unmap_irq.pirq = info->u.pirq.pirq;
 		unmap_irq.domid = info->u.pirq.domid;
