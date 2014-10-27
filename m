Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaJ0T1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:27:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaJ0S5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 010/105] kvm: fix potentially corrupt mmio cache
Date: Mon, 27 Oct 2014 11:55:45 -0700
Message-Id: <1414436240-13879-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

commit ee3d1570b58677885b4552bce8217fda7b226a68 upstream.

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
2  srcu_read_unlock(&kvm->srcu)             |
3  decide to cache something based on       |
     old memslots                           |
4                                           | change memslots
                                            | (increments generation)
5                                           | synchronize_srcu(&kvm->srcu);
6  retrieve generation # from new memslots  |
7  tag cache with new memslot generation    |
8  srcu_read_unlock(&kvm->srcu)             |
...                                         |
   <action based on cache occurs even       |
    though the caching decision was based   |
    on the old memslots>                    |
...                                         |
   <action *continues* to occur until next  |
    memslot generation change, which may    |
    be never>                               |
                                            |

By incrementing the generation after synchronizing with kvm->srcu readers,
we ensure that the generation retrieved in (6) will become invalid soon
after (8).

Keeping the existing increment is not strictly necessary, but we
do keep it and just move it for consistency from update_memslots to
install_new_memslots.  It invalidates old cached MMIOs immediately,
instead of having to wait for the end of synchronize_srcu_expedited,
which makes the code more clearly correct in case CPU 1 is preempted
right after synchronize_srcu() returns.

To avoid halving the generation space in SPTEs, always presume that the
low bit of the generation is zero when reconstructing a generation number
out of an SPTE.  This effectively disables MMIO caching in SPTEs during
the call to synchronize_srcu_expedited.  Using the low bit this way is
somewhat like a seqcount---where the protected thing is a cache, and
instead of retrying we can simply punt if we observe the low bit to be 1.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ kamal: backport to 3.13-stable: also made update_memslots() static,
  as per 7940876 "kvm: make local functions static" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/virtual/kvm/mmu.txt | 14 ++++++++++++++
 arch/x86/kvm/mmu.c                | 20 ++++++++++++--------
 include/linux/kvm_host.h          |  2 --
 virt/kvm/kvm_main.c               | 22 +++++++++++++++++-----
 4 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 2908941..53838d9 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -425,6 +425,20 @@ fault through the slow path.
 Since only 19 bits are used to store generation-number on mmio spte, all
 pages are zapped when there is an overflow.
 
+Unfortunately, a single memory access might access kvm_memslots(kvm) multiple
+times, the last one happening when the generation number is retrieved and
+stored into the MMIO spte.  Thus, the MMIO spte might be created based on
+out-of-date information, but with an up-to-date generation number.
+
+To avoid this, the generation number is incremented again after synchronize_srcu
+returns; thus, the low bit of kvm_memslots(kvm)->generation is only 1 during a
+memslot update, while some SRCU readers might be using the old copy.  We do not
+want to use an MMIO sptes created with an odd generation number, and we can do
+this without losing a bit in the MMIO spte.  The low bit of the generation
+is not stored in MMIO spte, and presumed zero when it is extracted out of the
+spte.  If KVM is unlucky and creates an MMIO spte while the low bit is 1,
+the next access to the spte will always be a cache miss.
+
 
 Further reading
 ===============
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0fefcd4..f20484a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -198,16 +198,20 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
 /*
- * spte bits of bit 3 ~ bit 11 are used as low 9 bits of generation number,
- * the bits of bits 52 ~ bit 61 are used as high 10 bits of generation
- * number.
+ * the low bit of the generation number is always presumed to be zero.
+ * This disables mmio caching during memslot updates.  The concept is
+ * similar to a seqcount but instead of retrying the access we just punt
+ * and ignore the cache.
+ *
+ * spte bits 3-11 are used as bits 1-9 of the generation number,
+ * the bits 52-61 are used as bits 10-19 of the generation number.
  */
-#define MMIO_SPTE_GEN_LOW_SHIFT		3
+#define MMIO_SPTE_GEN_LOW_SHIFT		2
 #define MMIO_SPTE_GEN_HIGH_SHIFT	52
 
-#define MMIO_GEN_SHIFT			19
-#define MMIO_GEN_LOW_SHIFT		9
-#define MMIO_GEN_LOW_MASK		((1 << MMIO_GEN_LOW_SHIFT) - 1)
+#define MMIO_GEN_SHIFT			20
+#define MMIO_GEN_LOW_SHIFT		10
+#define MMIO_GEN_LOW_MASK		((1 << MMIO_GEN_LOW_SHIFT) - 2)
 #define MMIO_GEN_MASK			((1 << MMIO_GEN_SHIFT) - 1)
 #define MMIO_MAX_GEN			((1 << MMIO_GEN_SHIFT) - 1)
 
@@ -4373,7 +4377,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
 	 * The very rare case: if the generation-number is round,
 	 * zap all shadow pages.
 	 */
-	if (unlikely(kvm_current_mmio_generation(kvm) >= MMIO_MAX_GEN)) {
+	if (unlikely(kvm_current_mmio_generation(kvm) == 0)) {
 		printk_ratelimited(KERN_INFO "kvm: zapping shadow pages for mmio generation wraparound\n");
 		kvm_mmu_invalidate_zap_all_pages(kvm);
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9523d2a..cc595f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -463,8 +463,6 @@ void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
-void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
-		     u64 last_generation);
 
 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5c6b84c..44652f2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -682,8 +682,8 @@ static void sort_memslots(struct kvm_memslots *slots)
 		slots->id_to_index[slots->memslots[i].id] = i;
 }
 
-void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
-		     u64 last_generation)
+static void update_memslots(struct kvm_memslots *slots,
+			    struct kvm_memory_slot *new)
 {
 	if (new) {
 		int id = new->id;
@@ -694,8 +694,6 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
 		if (new->npages != npages)
 			sort_memslots(slots);
 	}
-
-	slots->generation = last_generation + 1;
 }
 
 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
@@ -717,10 +715,24 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 {
 	struct kvm_memslots *old_memslots = kvm->memslots;
 
-	update_memslots(slots, new, kvm->memslots->generation);
+	/*
+	 * Set the low bit in the generation, which disables SPTE caching
+	 * until the end of synchronize_srcu_expedited.
+	 */
+	WARN_ON(old_memslots->generation & 1);
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
1.9.1

