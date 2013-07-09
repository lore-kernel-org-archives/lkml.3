Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3GIN5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:57:11 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39554 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3GIN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:57:05 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 1/4] PF: Add FAULT_FLAG_RETRY_NOWAIT for guest fault
Date: Tue,  9 Jul 2013 15:56:44 +0200
Message-Id: <1373378207-10451-2-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070913-5024-0000-0000-0000068A3BDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of a fault retry exit sie64() with gmap_fault indication for the
running thread set. This makes it possible to handle async page faults
without the need for mm notifiers.

Based on a patch from Martin Schwidefsky.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 arch/s390/include/asm/pgtable.h   |  2 ++
 arch/s390/include/asm/processor.h |  1 +
 arch/s390/kvm/kvm-s390.c          | 13 +++++++++++++
 arch/s390/mm/fault.c              | 26 ++++++++++++++++++++++----
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 0ea4e59..4a4cc64 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -740,6 +740,7 @@ static inline void pgste_set_pte(pte_t *ptep, pte_t entry)
  * @table: pointer to the page directory
  * @asce: address space control element for gmap page table
  * @crst_list: list of all crst tables used in the guest address space
+ * @pfault_enabled: defines if pfaults are applicable for the guest
  */
 struct gmap {
 	struct list_head list;
@@ -748,6 +749,7 @@ struct gmap {
 	unsigned long asce;
 	void *private;
 	struct list_head crst_list;
+	unsigned long pfault_enabled;
 };
 
 /**
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 6b49987..4fa96ca 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -77,6 +77,7 @@ struct thread_struct {
         unsigned long ksp;              /* kernel stack pointer             */
 	mm_segment_t mm_segment;
 	unsigned long gmap_addr;	/* address of last gmap fault. */
+	unsigned int gmap_pfault;	/* signal of a pending guest pfault */
 	struct per_regs per_user;	/* User specified PER registers */
 	struct per_event per_event;	/* Cause of the last PER trap */
 	unsigned long per_flags;	/* Flags to control debug behavior */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ba694d2..702daca 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -682,6 +682,15 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void kvm_arch_fault_in_sync(struct kvm_vcpu *vcpu)
+{
+	hva_t fault = gmap_fault(current->thread.gmap_addr, vcpu->arch.gmap);
+	struct mm_struct *mm = current->mm;
+	down_read(&mm->mmap_sem);
+	get_user_pages(current, mm, fault, 1, 1, 0, NULL, NULL);
+	up_read(&mm->mmap_sem);
+}
+
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int rc;
@@ -715,6 +724,10 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	if (rc < 0) {
 		if (kvm_is_ucontrol(vcpu->kvm)) {
 			rc = SIE_INTERCEPT_UCONTROL;
+		} else if (current->thread.gmap_pfault) {
+			kvm_arch_fault_in_sync(vcpu);
+			current->thread.gmap_pfault = 0;
+			rc = 0;
 		} else {
 			VCPU_EVENT(vcpu, 3, "%s", "fault in sie instruction");
 			trace_kvm_s390_sie_fault(vcpu);
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 047c3e4..7d4c4b1 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -50,6 +50,7 @@
 #define VM_FAULT_BADMAP		0x020000
 #define VM_FAULT_BADACCESS	0x040000
 #define VM_FAULT_SIGNAL		0x080000
+#define VM_FAULT_PFAULT		0x100000
 
 static unsigned long store_indication __read_mostly;
 
@@ -232,6 +233,7 @@ static noinline void do_fault_error(struct pt_regs *regs, int fault)
 			return;
 		}
 	case VM_FAULT_BADCONTEXT:
+	case VM_FAULT_PFAULT:
 		do_no_context(regs);
 		break;
 	case VM_FAULT_SIGNAL:
@@ -269,6 +271,9 @@ static noinline void do_fault_error(struct pt_regs *regs, int fault)
  */
 static inline int do_exception(struct pt_regs *regs, int access)
 {
+#ifdef CONFIG_PGSTE
+	struct gmap *gmap;
+#endif
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
@@ -307,9 +312,10 @@ static inline int do_exception(struct pt_regs *regs, int access)
 	down_read(&mm->mmap_sem);
 
 #ifdef CONFIG_PGSTE
-	if ((current->flags & PF_VCPU) && S390_lowcore.gmap) {
-		address = __gmap_fault(address,
-				     (struct gmap *) S390_lowcore.gmap);
+	gmap = (struct gmap *)
+		((current->flags & PF_VCPU) ? S390_lowcore.gmap : 0);
+	if (gmap) {
+		address = __gmap_fault(address, gmap);
 		if (address == -EFAULT) {
 			fault = VM_FAULT_BADMAP;
 			goto out_up;
@@ -318,6 +324,8 @@ static inline int do_exception(struct pt_regs *regs, int access)
 			fault = VM_FAULT_OOM;
 			goto out_up;
 		}
+		if (test_bit(1, &gmap->pfault_enabled))
+			flags |= FAULT_FLAG_RETRY_NOWAIT;
 	}
 #endif
 
@@ -374,9 +382,19 @@ retry:
 				      regs, address);
 		}
 		if (fault & VM_FAULT_RETRY) {
+#ifdef CONFIG_PGSTE
+			if (gmap && (flags & FAULT_FLAG_RETRY_NOWAIT)) {
+				/* FAULT_FLAG_RETRY_NOWAIT has been set,
+				 * mmap_sem has not been released */
+				current->thread.gmap_pfault = 1;
+				fault = VM_FAULT_PFAULT;
+				goto out_up;
+			}
+#endif
 			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
 			 * of starvation. */
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags &= ~(FAULT_FLAG_ALLOW_RETRY |
+				   FAULT_FLAG_RETRY_NOWAIT);
 			flags |= FAULT_FLAG_TRIED;
 			down_read(&mm->mmap_sem);
 			goto retry;
-- 
1.8.2.2

