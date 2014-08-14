Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaHNHCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:02:09 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56882 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaHNHCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:02:07 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio generation number
Date: Thu, 14 Aug 2014 15:01:52 +0800
Message-Id: <1407999713-3726-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081407-5140-0000-0000-0000002958D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may cache the current mmio generation number and stale memslot info
into spte, like this scenario：

       CPU 0                                  CPU 1
page fault:                                add a new memslot
read memslot and detecting its a mmio access
                                           update memslots
                                           update generation number
read generation number
cache the gpa and current gen number into spte

So, if guest accesses the gpa later, it will generate a incorrect
mmio exit

This patch fixes it by updating the generation number after
synchronize_srcu_expedited() that makes sure the generation
number updated only if memslots update is finished

Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33712fb..bb40df3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -96,7 +96,7 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *new, u64 last_generation);
+			    struct kvm_memory_slot *new);
 
 static void kvm_release_pfn_dirty(pfn_t pfn);
 static void mark_page_dirty_in_slot(struct kvm *kvm,
@@ -687,8 +687,7 @@ static void sort_memslots(struct kvm_memslots *slots)
 }
 
 static void update_memslots(struct kvm_memslots *slots,
-			    struct kvm_memory_slot *new,
-			    u64 last_generation)
+			    struct kvm_memory_slot *new)
 {
 	if (new) {
 		int id = new->id;
@@ -699,8 +698,6 @@ static void update_memslots(struct kvm_memslots *slots,
 		if (new->npages != npages)
 			sort_memslots(slots);
 	}
-
-	slots->generation = last_generation + 1;
 }
 
 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
@@ -722,9 +719,12 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 {
 	struct kvm_memslots *old_memslots = kvm->memslots;
 
-	update_memslots(slots, new, kvm->memslots->generation);
+	/* ensure generation number is always increased. */
+	slots->generation = old_memslots->generation;
+	update_memslots(slots, new);
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
+	slots->generation++;
 
 	kvm_arch_memslots_updated(kvm);
 
-- 
1.8.1.4

