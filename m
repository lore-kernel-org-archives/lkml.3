Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbbA1Uei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:34:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:35876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760346AbbA1Ueg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:34:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,482,1418112000"; 
   d="scan'208";a="669260623"
Subject: [tip:irq/core PATCH] genirq: fix null pointer reference in
 irq_set_affinity_hint()
To: tglx@linutronix.de
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: mingo@kernel.org, netdev@vger.kernel.org, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Date: Wed, 28 Jan 2015 10:57:39 -0800
Message-ID: <20150128185739.9689.84588.stgit@jbrandeb-cp2.jf.intel.com>
User-Agent: StGit/0.16-44-gd947d-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent set_affinity commit by me introduced some null
pointer dereferences on driver unload, because some drivers
call this function with a NULL argument. This fixes the issue
by just checking for null before setting the affinity mask.

Fixes: e2e64a932556 ("genirq: Set initial affinity in irq_set_affinity_hint()")
Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: netdev@vger.kernel.org
---
 kernel/irq/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f038e58..196a06f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -244,7 +244,8 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 	desc->affinity_hint = m;
 	irq_put_desc_unlock(desc, flags);
 	/* set the initial affinity to prevent every interrupt being on CPU0 */
-	__irq_set_affinity(irq, m, false);
+	if (m)
+		__irq_set_affinity(irq, m, false);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);

