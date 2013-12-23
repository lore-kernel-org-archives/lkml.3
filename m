Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3LWOji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:39:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3LWOjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:39:36 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        <stable@vger.kernel.org>
Subject: [PATCH] x86, irq, fix logical AND/OR error in check_irq_vectors_for_cpu_disable()
Date: Mon, 23 Dec 2013 09:39:12 -0500
Message-Id: <1387809552-20529-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch is against linux-tip.git and was tested on both linux.git and tip without
any issues.  As expected, the number of required vectors for the down'd cpu
drops from 202 to 181 on my test system (which has 509 vectors assigned in
total).

Many thanks to Gong Chen for catching this.

P.

----8<----

Gong Chen caught this coding error during inspection of the patch.  The
code should be AND not OR.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Janet Morgan <janet.morgan@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ruiv Wang <ruiv.wang@gmail.com>
Cc: Gong Chen <gong.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: x86@kernel.org
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7d40698..aed7acc 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -281,7 +281,7 @@ int check_irq_vectors_for_cpu_disable(void)
 			desc = irq_to_desc(irq);
 			data = irq_desc_get_irq_data(desc);
 			affinity = data->affinity;
-			if (irq_has_action(irq) || !irqd_is_per_cpu(data) ||
+			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
 			    !cpumask_subset(affinity, cpu_online_mask))
 				this_count++;
 		}
-- 
1.8.3.1

