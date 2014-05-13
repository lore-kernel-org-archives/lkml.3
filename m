Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016AbaEMPAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:00:17 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:52535 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004AbaEMO6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:58:53 -0400
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
Subject: [PATCH v1 RFC 6/6] KVM: s390: add cpu model support
Date: Tue, 13 May 2014 16:58:34 +0200
Message-Id: <1399993114-15333-7-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051314-3548-0000-0000-0000090BC429
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables cpu model support in kvm/s390 via the vm attribute
interface.

During KVM initialization, the host properties cpuid, IBC value and the
facility list are stored in the architecture specific cpu model structure.

During vcpu setup, these properties are taken to initialize the related SIE
state. This mechanism allows to adjust the properties from user space and thus
to implement different selectable cpu models.

This patch uses the IBC functionality to block instructions that have not
been implemented at the requested CPU type and GA level compared to the
full host capability.

Userspace has to initialize the cpu model before vcpu creation. A cpu model
change of running vcpus is currently not possible.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   4 +-
 arch/s390/include/uapi/asm/kvm.h |  23 ++++++
 arch/s390/kvm/kvm-s390.c         | 146 ++++++++++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |   1 +
 4 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index b4751ba..6b826cb 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -84,7 +84,8 @@ struct kvm_s390_sie_block {
 	atomic_t cpuflags;		/* 0x0000 */
 	__u32 : 1;			/* 0x0004 */
 	__u32 prefix : 18;
-	__u32 : 13;
+	__u32 : 1;
+	__u32 ibc : 12;
 	__u8	reserved08[4];		/* 0x0008 */
 #define PROG_IN_SIE (1<<0)
 	__u32	prog0c;			/* 0x000c */
@@ -418,6 +419,7 @@ struct kvm_s390_cpu_model {
 	unsigned long *sie_fac;
 	struct cpuid cpu_id;
 	unsigned long *fac_list;
+	unsigned short ibc;
 };
 
 struct kvm_arch{
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 313100a..82ef1b5 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -58,12 +58,35 @@ struct kvm_s390_io_adapter_req {
 
 /* kvm attr_group  on vm fd */
 #define KVM_S390_VM_MEM_CTRL		0
+#define KVM_S390_VM_CPU_MODEL		1
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
 #define KVM_S390_VM_MEM_CLR_CMMA	1
 #define KVM_S390_VM_MEM_CLR_PAGES	2
 
+/* kvm attributes for cpu_model */
+
+/* the s390 processor related attributes are r/w */
+#define KVM_S390_VM_CPU_PROCESSOR	0
+struct kvm_s390_vm_cpu_processor {
+	__u64 cpuid;
+	__u16 ibc;
+	__u8  pad[6];
+	__u64 fac_list[256];
+};
+
+/* the machine related attributes are read only */
+#define KVM_S390_VM_CPU_MACHINE		1
+struct kvm_s390_vm_cpu_machine {
+	__u64 cpuid;
+	__u32 ibc_range;
+	__u8  pad[4];
+	__u64 fac_mask[256];
+	__u64 hard_fac_list[256];
+	__u64 soft_fac_list[256];
+};
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index a53652f..9965d8b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -369,6 +369,110 @@ static int kvm_s390_mem_control(struct kvm *kvm, struct kvm_device_attr *attr)
 	return ret;
 }
 
+static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_processor *proc;
+
+	if (atomic_read(&kvm->online_vcpus))
+		return -EBUSY;
+
+	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
+	if (!proc)
+		return -ENOMEM;
+
+	if (copy_from_user(proc, (void __user *)attr->addr,
+			   sizeof(*proc))) {
+		kfree(proc);
+		return -EFAULT;
+	}
+
+	mutex_lock(&kvm->lock);
+	memcpy(&kvm->arch.model.cpu_id, &proc->cpuid,
+	       sizeof(struct cpuid));
+	kvm->arch.model.ibc = proc->ibc;
+	kvm_s390_apply_fac_list_mask((long unsigned *)proc->fac_list);
+	memcpy(kvm->arch.model.fac_list, proc->fac_list,
+	       S390_ARCH_FAC_LIST_SIZE_BYTE);
+	mutex_unlock(&kvm->lock);
+	kfree(proc);
+
+	return 0;
+}
+
+static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_CPU_PROCESSOR:
+		ret = kvm_s390_set_processor(kvm, attr);
+		break;
+	}
+	return ret;
+}
+
+static int kvm_s390_get_processor(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_processor *proc;
+	int rc = 0;
+
+	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
+	if (!proc) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	memcpy(&proc->cpuid, &kvm->arch.model.cpu_id, sizeof(struct cpuid));
+	proc->ibc = kvm->arch.model.ibc;
+	memcpy(&proc->fac_list, kvm->arch.model.fac_list,
+	       S390_ARCH_FAC_LIST_SIZE_BYTE);
+	if (copy_to_user((void __user *)attr->addr, proc, sizeof(*proc)))
+		rc = -EFAULT;
+	kfree(proc);
+out:
+	return rc;
+}
+
+static int kvm_s390_get_machine(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_vm_cpu_machine *mach;
+	int rc = 0;
+
+	mach = kzalloc(sizeof(*mach), GFP_KERNEL);
+	if (!mach) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	get_cpu_id((struct cpuid *) &mach->cpuid);
+	mach->ibc_range = kvm_s390_lowest_ibc() << 16;
+	mach->ibc_range |= kvm_s390_latest_ibc();
+	memcpy(&mach->fac_mask, kvm_s390_fac_list_mask,
+	       kvm_s390_fac_list_mask_size() * sizeof(u64));
+	kvm_s390_get_hard_fac_list((long unsigned int *) &mach->hard_fac_list,
+				   S390_ARCH_FAC_LIST_SIZE_U64);
+	kvm_s390_get_soft_fac_list((long unsigned int *) &mach->soft_fac_list,
+				   S390_ARCH_FAC_LIST_SIZE_U64);
+	if (copy_to_user((void __user *)attr->addr, mach, sizeof(*mach)))
+		rc = -EFAULT;
+	kfree(mach);
+out:
+	return rc;
+}
+
+static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_CPU_PROCESSOR:
+		ret = kvm_s390_get_processor(kvm, attr);
+		break;
+	case KVM_S390_VM_CPU_MACHINE:
+		ret = kvm_s390_get_machine(kvm, attr);
+		break;
+	}
+	return ret;
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -377,6 +481,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MEM_CTRL:
 		ret = kvm_s390_mem_control(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_MODEL:
+		ret = kvm_s390_set_cpu_model(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -387,7 +494,18 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 
 static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	int ret;
+
+	switch (attr->group) {
+	case KVM_S390_VM_CPU_MODEL:
+		ret = kvm_s390_get_cpu_model(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
 }
 
 static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
@@ -407,6 +525,17 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 			break;
 		}
 		break;
+	case KVM_S390_VM_CPU_MODEL:
+		switch (attr->attr) {
+		case KVM_S390_VM_CPU_PROCESSOR:
+		case KVM_S390_VM_CPU_MACHINE:
+			ret = 0;
+			break;
+		default:
+			ret = -ENXIO;
+			break;
+		}
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -520,6 +649,16 @@ void kvm_s390_get_hard_fac_list(unsigned long *fac_list, int size)
 		fac_list[i] &= kvm_s390_fac_list_mask[i];
 }
 
+/* make sure the memory used for fac_list is zeroed */
+void kvm_s390_get_soft_fac_list(unsigned long *fac_list, int size)
+{
+	int i;
+
+	stsfle(fac_list, size - 1);
+	for (i = 0; i < size && i < kvm_s390_fac_list_mask_size(); i++)
+		fac_list[i] &= kvm_s390_fac_list_mask[i];
+}
+
 static void kvm_s390_get_cpu_id(struct cpuid *cpu_id)
 {
 	get_cpu_id(cpu_id);
@@ -579,6 +718,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_s390_get_hard_fac_list(kvm->arch.model.fac_list,
 				kvm_s390_fac_list_mask_size());
 	kvm_s390_get_cpu_id(&kvm->arch.model.cpu_id);
+	kvm->arch.model.ibc = kvm_s390_latest_ibc();
 
 	spin_lock_init(&kvm->arch.float_int.lock);
 	INIT_LIST_HEAD(&kvm->arch.float_int.list);
@@ -801,9 +941,13 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	tasklet_init(&vcpu->arch.tasklet, kvm_s390_tasklet,
 		     (unsigned long) vcpu);
 	vcpu->arch.ckc_timer.function = kvm_s390_idle_wakeup;
+
+	mutex_lock(&vcpu->kvm->lock);
 	vcpu->arch.cpu_id = vcpu->kvm->arch.model.cpu_id;
 	memcpy(vcpu->kvm->arch.model.sie_fac, vcpu->kvm->arch.model.fac_list,
 	       S390_ARCH_FAC_LIST_SIZE_BYTE);
+	vcpu->arch.sie_block->ibc = vcpu->kvm->arch.model.ibc;
+	mutex_unlock(&vcpu->kvm->lock);
 
 	return rc;
 }
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 10de678..f3c7f83 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -196,6 +196,7 @@ unsigned long kvm_s390_fac_list__mask_size(void);
 void kvm_s390_apply_fac_list_mask(unsigned long fac_list[]);
 extern unsigned long kvm_s390_fac_list_mask[];
 void kvm_s390_get_hard_fac_list(unsigned long *fac_list, int size);
+void kvm_s390_get_soft_fac_list(unsigned long *fac_list, int size);
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
-- 
1.8.3.1

