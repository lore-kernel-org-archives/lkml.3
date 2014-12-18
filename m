Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaLRWaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:30:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:7786 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaLRWac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:30:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="501202273"
Subject: [PATCH] genirq: fix symbol export for __irq_set_affinity
To: tglx@linutronix.de
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 14:30:31 -0800
Message-ID: <20141218223031.23847.86103.stgit@jbrandeb-cp2.jf.intel.com>
User-Agent: StGit/0.16-44-gd947d-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function __irq_set_affinity is referenced by interrupt.h
with static inlines, but if you try to use one of the inlines
in interrupt.h (for instance to call irq_set_affinity) then
compile fails due to a missing symbol, when building modules.

Enabling this function means that kernel drivers can include
an initial affinity setting for the interrupt, instead of all
interrupts starting out life on CPU0.  It seems to have just
been an oversight that it was not included.

This function and the helpers that call it from interrupt.h were
already in the kernel API, but if used would then fail to compile
due to the lack of an export even though already defined via extern.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>

---

Note: The use of EXPORT_SYMBOL_GPL was only because the next
      latest function added to this file (irq_set_affinity_hint)
      also used it.
---
 kernel/irq/manage.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8069237..8c1a5ad 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -233,6 +233,7 @@ int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__irq_set_affinity);
 
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {

