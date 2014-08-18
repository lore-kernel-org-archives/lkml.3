Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaHRWqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:46:43 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:42617 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaHRWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:46:41 -0400
From: David Matlack <dmatlack@google.com>
To: pbonzini@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        avi.kivity@gmail.com, mtosatti@redhat.com,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 1/2] kvm: fix potentially corrupt mmio cache
Date: Mon, 18 Aug 2014 15:46:06 -0700
Message-Id: <1408401967-27211-1-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vcpu exits and memslot mutations can run concurrently as long as the
vcpu does not aquire the slots mutex. Thus it is theoretically possible
for memslots to change underneath a vcpu that is handling an exit.

If we increment the memslot generation number again after
synchronize_srcu_expedited(), vcpus can safely cache memslot generation
without maintaining a single rcu_dereference through an entire vm exit.
And much of the x86/kvm code does not maintain a single rcu_dereference
of the current memslots during each exit.

We can prevent the following case:

   vcpu (CPU 0)                             | thread (CPU 1)
--------------------------------------------+--------------------------
1  vm exit                                  |
2  decide to cache something based on       |
     old memslots                           |
3                                           | change memslots
4                                           | increment generation
5  tag cache with new memslot generation    |
...                                         |
   <action based on cache occurs even       |
    though the caching decision was based   |
    on the old memslots>                    |
...                                         |
   <action *continues* to occur until next  |
    memslot generation change, which may    |
    be never>                               |

By incrementing the generation again after synchronizing kvm->srcu
readers, we guarantee the generation cached in (5) will very soon
become invalid.

Cc: stable@vger.kernel.org
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4b6c01b..86d3697 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -95,8 +95,6 @@ static int hardware_enable_all(void);
 static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
-static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *new, u64 last_generation);
 
 static void kvm_release_pfn_dirty(pfn_t pfn);
 static void mark_page_dirty_in_slot(struct kvm *kvm,
@@ -685,8 +683,7 @@ static void sort_memslots(struct kvm_memslots *slots)
 }
 
 static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *new,
-			    u64 last_generation)
+			    struct kvm_memory_slot *new)
 {
 	if (new) {
 		int id = new->id;
@@ -697,8 +694,6 @@ static void update_memslots(struct kvm_memslots *slots,
 		if (new->npages != npages)
 			sort_memslots(slots);
 	}
-
-	slots->generation = last_generation + 1;
 }
 
 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
@@ -720,10 +715,19 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 {
 	struct kvm_memslots *old_memslots = kvm->memslots;
 
-	update_memslots(slots, new, kvm->memslots->generation);
+	slots->generation = old_memslots->generation + 1;
+
+	update_memslots(slots, new);
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
 
+	/*
+	 * Increment the new memslot generation a second time. This prevents
+	 * vm exits that race with memslot updates from caching a memslot
+	 * generation that will (potentially) be valid forever.
+	 */
+	slots->generation++;
+
 	kvm_arch_memslots_updated(kvm);
 
 	return old_memslots;
-- 
2.1.0.rc2.206.gedb03e5

