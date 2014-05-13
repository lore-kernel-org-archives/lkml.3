Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbaEMPAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:00:22 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:59749 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991AbaEMO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:58:51 -0400
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, mimu@linux.vnet.ibm.com
Subject: [PATCH v1 RFC 3/6] KVM: s390: use facilities and cpu_id per KVM
Date: Tue, 13 May 2014 16:58:31 +0200
Message-Id: <1399993114-15333-4-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051314-0342-0000-0000-000008BF6BAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introduces facilities and cpu_ids per virtual machine.
Different virtual machines may want to expose different facilities and
cpu ids to the guest, so let's make them per-vm instead of global.

In addition this patch renames all ocurrences of *facilities to *fac_list
smilar to the already exiting symbol stfl_fac_list in lowcore.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   7 +++
 arch/s390/kvm/gaccess.c          |   4 +-
 arch/s390/kvm/kvm-s390.c         | 107 +++++++++++++++++++++++++++------------
 arch/s390/kvm/kvm-s390.h         |  23 +++++++--
 arch/s390/kvm/priv.c             |  13 +++--
 5 files changed, 113 insertions(+), 41 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 38d487a..b4751ba 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -414,6 +414,12 @@ struct kvm_s390_config {
 	struct kvm_s390_attr_name name;
 };
 
+struct kvm_s390_cpu_model {
+	unsigned long *sie_fac;
+	struct cpuid cpu_id;
+	unsigned long *fac_list;
+};
+
 struct kvm_arch{
 	struct sca_block *sca;
 	debug_info_t *dbf;
@@ -427,6 +433,7 @@ struct kvm_arch{
 	wait_queue_head_t ipte_wq;
 	struct kvm_s390_config *cfg;
 	spinlock_t start_stop_lock;
+	struct kvm_s390_cpu_model model;
 };
 
 #define KVM_HVA_ERR_BAD		(-1UL)
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index db608c3..4c7ca40 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -358,8 +358,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 	union asce asce;
 
 	ctlreg0.val = vcpu->arch.sie_block->gcr[0];
-	edat1 = ctlreg0.edat && test_vfacility(8);
-	edat2 = edat1 && test_vfacility(78);
+	edat1 = ctlreg0.edat && test_kvm_facility(vcpu->kvm, 8);
+	edat2 = edat1 && test_kvm_facility(vcpu->kvm, 78);
 	asce.val = get_vcpu_asce(vcpu);
 	if (asce.r)
 		goto real_address;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 01a5212..a53652f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1,5 +1,5 @@
 /*
- * hosting zSeries kernel virtual machines
+ * Hosting zSeries kernel virtual machines
  *
  * Copyright IBM Corp. 2008, 2009
  *
@@ -30,7 +30,6 @@
 #include <asm/pgtable.h>
 #include <asm/nmi.h>
 #include <asm/switch_to.h>
-#include <asm/facility.h>
 #include <asm/sclp.h>
 #include<asm/timex.h>
 #include "kvm-s390.h"
@@ -92,15 +91,33 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-unsigned long *vfacilities;
-static struct gmap_notifier gmap_notifier;
+/* upper facilities limit for kvm */
+unsigned long kvm_s390_fac_list_mask[] = {
+	0xff82fff3f47c2000UL,
+	0x005c000000000000UL,
+};
+
+unsigned long kvm_s390_fac_list_mask_size(void)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(kvm_s390_fac_list_mask) >
+		     S390_ARCH_FAC_MASK_SIZE_U64);
+	return ARRAY_SIZE(kvm_s390_fac_list_mask);
+}
 
-/* test availability of vfacility */
-int test_vfacility(unsigned long nr)
+void kvm_s390_apply_fac_list_mask(unsigned long fac_list[])
 {
-	return __test_facility(nr, (void *) vfacilities);
+	unsigned int i;
+
+	for (i = 0; i < S390_ARCH_FAC_LIST_SIZE_U64; i++) {
+		if (i < kvm_s390_fac_list_mask_size())
+			fac_list[i] &= kvm_s390_fac_list_mask[i];
+		else
+			fac_list[i] &= 0UL;
+	}
 }
 
+static struct gmap_notifier gmap_notifier;
+
 /* Section: not file related */
 int kvm_arch_hardware_enable(void *garbage)
 {
@@ -485,6 +502,30 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	return r;
 }
 
+/* make sure the memory used for fac_list is zeroed */
+void kvm_s390_get_hard_fac_list(unsigned long *fac_list, int size)
+{
+	int i;
+
+	if (!test_facility(7))
+		memcpy(fac_list, &S390_lowcore.stfl_fac_list, 4);
+	else {
+		register unsigned long reg0 asm("0") = size - 1;
+		asm volatile(".insn s,0xb2b00000,0(%1)" /* stfle */
+			     : "+d" (reg0)
+			     : "a" (fac_list)
+			     : "memory", "cc");
+	}
+	for (i = 0; i < size && i < kvm_s390_fac_list_mask_size(); i++)
+		fac_list[i] &= kvm_s390_fac_list_mask[i];
+}
+
+static void kvm_s390_get_cpu_id(struct cpuid *cpu_id)
+{
+	get_cpu_id(cpu_id);
+	cpu_id->version = 0xff;
+}
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int rc;
@@ -522,6 +563,23 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (!kvm->arch.dbf)
 		goto out_nodbf;
 
+	/*
+	 * The architected maximum amount of facilities is 16 kbit. To store
+	 * this amount, 2 kbyte of memory is required. Thus we need a full
+	 * page to hold the active copy (arch.model.sie_fac) and the current
+	 * facilities set (arch.model.facilities).
+	 */
+	kvm->arch.model.sie_fac = (unsigned long *)
+		get_zeroed_page(GFP_KERNEL|GFP_DMA);
+	if (!kvm->arch.model.sie_fac)
+		goto out_nofac;
+
+	kvm->arch.model.fac_list = kvm->arch.model.sie_fac;
+	kvm->arch.model.fac_list += S390_ARCH_FAC_LIST_SIZE_U64;
+	kvm_s390_get_hard_fac_list(kvm->arch.model.fac_list,
+				kvm_s390_fac_list_mask_size());
+	kvm_s390_get_cpu_id(&kvm->arch.model.cpu_id);
+
 	spin_lock_init(&kvm->arch.float_int.lock);
 	INIT_LIST_HEAD(&kvm->arch.float_int.list);
 	init_waitqueue_head(&kvm->arch.ipte_wq);
@@ -554,6 +612,8 @@ out_gmap:
 out_nogmap:
 	debug_unregister(kvm->arch.dbf);
 out_nodbf:
+	free_page((unsigned long)kvm->arch.model.sie_fac);
+out_nofac:
 	free_page((unsigned long)(kvm->arch.sca));
 out_err:
 	return rc;
@@ -608,6 +668,7 @@ void kvm_arch_sync_events(struct kvm *kvm)
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_free_vcpus(kvm);
+	free_page((unsigned long)kvm->arch.model.sie_fac);
 	free_page((unsigned long)(kvm->arch.sca));
 	debug_unregister(kvm->arch.dbf);
 	if (!kvm_is_ucontrol(kvm))
@@ -720,14 +781,14 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 						    CPUSTAT_STOPPED |
 						    CPUSTAT_GED);
 	vcpu->arch.sie_block->ecb   = 6;
-	if (test_vfacility(50) && test_vfacility(73))
+	if (test_kvm_facility(vcpu->kvm, 50) &&
+	    test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= 0x10;
 
 	vcpu->arch.sie_block->ecb2  = 8;
 	vcpu->arch.sie_block->eca   = 0xD1002000U;
 	if (sclp_has_siif())
 		vcpu->arch.sie_block->eca |= 1;
-	vcpu->arch.sie_block->fac   = (int) (long) vfacilities;
 	vcpu->arch.sie_block->ictl |= ICTL_ISKE | ICTL_SSKE | ICTL_RRBE |
 				      ICTL_TPROT;
 
@@ -740,8 +801,10 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	tasklet_init(&vcpu->arch.tasklet, kvm_s390_tasklet,
 		     (unsigned long) vcpu);
 	vcpu->arch.ckc_timer.function = kvm_s390_idle_wakeup;
-	get_cpu_id(&vcpu->arch.cpu_id);
-	vcpu->arch.cpu_id.version = 0xff;
+	vcpu->arch.cpu_id = vcpu->kvm->arch.model.cpu_id;
+	memcpy(vcpu->kvm->arch.model.sie_fac, vcpu->kvm->arch.model.fac_list,
+	       S390_ARCH_FAC_LIST_SIZE_BYTE);
+
 	return rc;
 }
 
@@ -782,6 +845,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		vcpu->arch.sie_block->scaol = (__u32)(__u64)kvm->arch.sca;
 		set_bit(63 - id, (unsigned long *) &kvm->arch.sca->mcn);
 	}
+	vcpu->arch.sie_block->fac = (int) (long) kvm->arch.model.sie_fac;
 
 	spin_lock_init(&vcpu->arch.local_int.lock);
 	INIT_LIST_HEAD(&vcpu->arch.local_int.list);
@@ -1841,30 +1905,11 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 static int __init kvm_s390_init(void)
 {
-	int ret;
-	ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-	if (ret)
-		return ret;
-
-	/*
-	 * guests can ask for up to 255+1 double words, we need a full page
-	 * to hold the maximum amount of facilities. On the other hand, we
-	 * only set facilities that are known to work in KVM.
-	 */
-	vfacilities = (unsigned long *) get_zeroed_page(GFP_KERNEL|GFP_DMA);
-	if (!vfacilities) {
-		kvm_exit();
-		return -ENOMEM;
-	}
-	memcpy(vfacilities, S390_lowcore.stfle_fac_list, 16);
-	vfacilities[0] &= 0xff82fff3f4fc2000UL;
-	vfacilities[1] &= 0x005c000000000000UL;
-	return 0;
+	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 }
 
 static void __exit kvm_s390_exit(void)
 {
-	free_page((unsigned long) vfacilities);
 	kvm_exit();
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 066fdbc..ecadc8a 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -18,14 +18,20 @@
 #include <linux/hrtimer.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <asm/facility.h>
 
 typedef int (*intercept_handler_t)(struct kvm_vcpu *vcpu);
 
-/* declare vfacilities extern */
-extern unsigned long *vfacilities;
-
 int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu);
 
+/* maximum size of facilities and facility mask is 2k bytes */
+#define S390_ARCH_FAC_LIST_SIZE_BYTE (1<<11)
+#define S390_ARCH_FAC_LIST_SIZE_U64 \
+	(S390_ARCH_FAC_LIST_SIZE_BYTE / sizeof(u64))
+#define S390_ARCH_FAC_MASK_SIZE_BYTE S390_ARCH_FAC_LIST_SIZE_BYTE
+#define S390_ARCH_FAC_MASK_SIZE_U64 \
+	(S390_ARCH_FAC_MASK_SIZE_BYTE / sizeof(u64))
+
 /* Transactional Memory Execution related macros */
 #define IS_TE_ENABLED(vcpu)	((vcpu->arch.sie_block->ecb & 0x10))
 #define TDB_FORMAT1		1
@@ -129,6 +135,12 @@ static inline void kvm_s390_set_psw_cc(struct kvm_vcpu *vcpu, unsigned long cc)
 	vcpu->arch.sie_block->gpsw.mask |= cc << 44;
 }
 
+/* test availability of kvm facility */
+static inline int test_kvm_facility(struct kvm *kvm, unsigned long nr)
+{
+	return __test_facility(nr, kvm->arch.model.fac_list);
+}
+
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
 enum hrtimer_restart kvm_s390_idle_wakeup(struct hrtimer *timer);
 void kvm_s390_tasklet(unsigned long parm);
@@ -177,7 +189,10 @@ int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 /* is cmma enabled */
 bool kvm_s390_cmma_enabled(struct kvm *kvm);
-int test_vfacility(unsigned long nr);
+unsigned long kvm_s390_fac_list__mask_size(void);
+void kvm_s390_apply_fac_list_mask(unsigned long fac_list[]);
+extern unsigned long kvm_s390_fac_list_mask[];
+void kvm_s390_get_hard_fac_list(unsigned long *fac_list, int size);
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 19f3475..2de5baf 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -337,19 +337,24 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
 static int handle_stfl(struct kvm_vcpu *vcpu)
 {
 	int rc;
+	unsigned int fac;
 
 	vcpu->stat.instruction_stfl++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
+	/*
+	 * We need to shift the lower 32 facility bits (bit 0-31) from a u64
+	 * into a u32 memory representation. They will remain bits 0-31.
+	 */
+	fac = *vcpu->kvm->arch.model.sie_fac >> 32;
 	rc = write_guest_lc(vcpu, offsetof(struct _lowcore, stfl_fac_list),
-			    vfacilities, 4);
+			    &fac, sizeof(fac));
 	if (rc)
 		return rc;
-	VCPU_EVENT(vcpu, 5, "store facility list value %x",
-		   *(unsigned int *) vfacilities);
-	trace_kvm_s390_handle_stfl(vcpu, *(unsigned int *) vfacilities);
+	VCPU_EVENT(vcpu, 5, "store facility list value %x", fac);
+	trace_kvm_s390_handle_stfl(vcpu, fac);
 	return 0;
 }
 
-- 
1.8.3.1

