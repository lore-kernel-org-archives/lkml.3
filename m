Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaF3WYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:24:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:28284 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaF3WYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:24:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,577,1400050800"; 
   d="scan'208";a="566275220"
From: Keith Busch <keith.busch@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] genirq: Fix memory leak when calling irq_free_hwirqs()
Date: Mon, 30 Jun 2014 16:24:44 -0600
Message-Id: <1404167084-8070-1-git-send-email-keith.busch@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_free_hwirqs() always calls irq_free_descs() with a cnt == 0
which makes it a no-op since the interrupt count to free is
decremented in itself.

Fixes: 7b6ef1262549f6afc5c881aaef80beb8fd15f908

Signed-off-by: Keith Busch <keith.busch@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Rientjes <rientjes@google.com>
---
 kernel/irq/irqdesc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 7339e42..1487a12 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -455,9 +455,9 @@ EXPORT_SYMBOL_GPL(irq_alloc_hwirqs);
  */
 void irq_free_hwirqs(unsigned int from, int cnt)
 {
-	int i;
+	int i, j;
 
-	for (i = from; cnt > 0; i++, cnt--) {
+	for (i = from, j = cnt; j > 0; i++, j--) {
 		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
 		arch_teardown_hwirq(i);
 	}
-- 
1.7.10.4

