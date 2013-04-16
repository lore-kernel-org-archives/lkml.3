Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab3DPULJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:11:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44581 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936115Ab3DPUJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:09:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/9] xen/events: Check that IRQ value passed in is valid.
Date: Tue, 16 Apr 2013 16:09:02 -0400
Message-Id: <1366142947-18655-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We naively assume that the IRQ value passed in is correct.
If it is not, then any dereference operation for the 'info'
structure will result in crash - so might as well guard ourselves
and sprinkle copious amounts of WARN_ON.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index bb65f75..94daed1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -515,6 +515,9 @@ static void xen_free_irq(unsigned irq)
 {
 	struct irq_info *info = irq_get_handler_data(irq);
 
+	if (WARN_ON(!info))
+		return;
+
 	list_del(&info->list);
 
 	irq_set_handler_data(irq, NULL);
@@ -1003,6 +1006,9 @@ static void unbind_from_irq(unsigned int irq)
 	int evtchn = evtchn_from_irq(irq);
 	struct irq_info *info = irq_get_handler_data(irq);
 
+	if (WARN_ON(!info))
+		return;
+
 	mutex_lock(&irq_mapping_update_lock);
 
 	if (info->refcnt > 0) {
@@ -1130,6 +1136,10 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
+	struct irq_info *info = irq_get_handler_data(irq);
+
+	if (WARN_ON(!info))
+		return;
 	free_irq(irq, dev_id);
 	unbind_from_irq(irq);
 }
@@ -1441,6 +1451,9 @@ void rebind_evtchn_irq(int evtchn, int irq)
 {
 	struct irq_info *info = info_for_irq(irq);
 
+	if (WARN_ON(!info))
+		return;
+
 	/* Make sure the irq is masked, since the new event channel
 	   will also be masked. */
 	disable_irq(irq);
@@ -1714,7 +1727,12 @@ void xen_poll_irq(int irq)
 int xen_test_irq_shared(int irq)
 {
 	struct irq_info *info = info_for_irq(irq);
-	struct physdev_irq_status_query irq_status = { .irq = info->u.pirq.pirq };
+	struct physdev_irq_status_query irq_status;
+
+	if (WARN_ON(!info))
+		return -ENOENT;
+
+	irq_status.irq = info->u.pirq.pirq;
 
 	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
 		return 0;
-- 
1.8.1.4

