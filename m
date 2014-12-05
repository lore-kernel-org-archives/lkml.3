Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaLEX0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:26:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaLEX0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:26:47 -0500
Date: Fri, 5 Dec 2014 15:26:23 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b2c85fdee5b43210e934c639cb8ab7a0ca650b8d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        bp@alien8.de, mingo@kernel.org, joro@8bytes.org, tglx@linutronix.de
Reply-To: tglx@linutronix.de, joro@8bytes.org, mingo@kernel.org, bp@alien8.de,
        jiang.liu@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20141205084147.393737205@linutronix.de>
References: <20141205084147.393737205@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] irqdomain: Revert gfp hackery
Git-Commit-ID: b2c85fdee5b43210e934c639cb8ab7a0ca650b8d
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

Commit-ID:  b2c85fdee5b43210e934c639cb8ab7a0ca650b8d
Gitweb:     http://git.kernel.org/tip/b2c85fdee5b43210e934c639cb8ab7a0ca650b8d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 5 Dec 2014 08:48:34 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 6 Dec 2014 00:19:25 +0100

irqdomain: Revert gfp hackery

Reverts: eda7516e1d428 'irqdomain: Correct early allocation of irq
domains with IRQs off'

Now that we distangled the allocations and the enablement of irq
remapping and removed the pointless preempt disabled region from
native_smp_prepare_cpus() we can remove that hackaround

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141205084147.393737205@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 3395d89..7fac311 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -46,31 +46,14 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
 				    void *host_data)
 {
 	struct irq_domain *domain;
-	gfp_t gfp_flags = GFP_KERNEL;
-
-#ifdef CONFIG_X86
-	/*
-	 * BIG FAT COMMENT: Early initialization paths like enable_IR_x2apic(),
-	 * for example, call into here with interrupts disabled but then we do
-	 * allocate memory and can sleep so no-no. A proper fix would be to do
-	 * x2APIC IR setup in the early irq setup path but it is too late for
-	 * fixing it this way now, shortly before the merge window.
-	 *
-	 * So we do this little brown paper bag, which is temporary! Do not even
-	 * think of calling irq domain setup code with IRQs disabled. You will
-	 * get frozen-sharked!
-	 */
-	if (irqs_disabled())
-		gfp_flags = GFP_NOFS;
-#endif
 
 	domain = kzalloc_node(sizeof(*domain) + (sizeof(unsigned int) * size),
-			      gfp_flags, of_node_to_nid(of_node));
+			      GFP_KERNEL, of_node_to_nid(of_node));
 	if (WARN_ON(!domain))
 		return NULL;
 
 	/* Fill structure */
-	INIT_RADIX_TREE(&domain->revmap_tree, gfp_flags);
+	INIT_RADIX_TREE(&domain->revmap_tree, GFP_KERNEL);
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
