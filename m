Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaHRPBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:01:41 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51590 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaHRPBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:01:39 -0400
Date: Mon, 18 Aug 2014 18:01:29 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: gleb@kernel.org, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] eventfd: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818150129.GA14447@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uses of "rcu_assign_pointer()" are NULLing out the pointers.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 virt/kvm/eventfd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 20c3af7..a49130f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -278,7 +278,7 @@ static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
 	struct kvm_kernel_irq_routing_entry *e;
 
 	if (irqfd->gsi >= irq_rt->nr_rt_entries) {
-		rcu_assign_pointer(irqfd->irq_entry, NULL);
+		RCU_INIT_POINTER(irqfd->irq_entry, NULL);
 		return;
 	}
 
@@ -287,7 +287,7 @@ static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
 		if (e->type == KVM_IRQ_ROUTING_MSI)
 			rcu_assign_pointer(irqfd->irq_entry, e);
 		else
-			rcu_assign_pointer(irqfd->irq_entry, NULL);
+			RCU_INIT_POINTER(irqfd->irq_entry, NULL);
 	}
 }
 
@@ -473,7 +473,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 			 * It is paired with synchronize_srcu done by caller
 			 * of that function.
 			 */
-			rcu_assign_pointer(irqfd->irq_entry, NULL);
+			RCU_INIT_POINTER(irqfd->irq_entry, NULL);
 			irqfd_deactivate(irqfd);
 		}
 	}
-- 
1.9.1

