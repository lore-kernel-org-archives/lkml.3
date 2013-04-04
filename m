Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab3DDLus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992Ab3DDLuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:50:46 -0400
Date: Thu, 4 Apr 2013 13:50:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>, Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC] kvm: add PV MMIO EVENTFD
Message-ID: <20130404104846.GA6227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With KVM, MMIO is much slower than PIO, due to the need to
do page walk and emulation. But with EPT, it does not have to be: we
know the address from the VMCS so if the address is unique, we can look
up the eventfd directly, bypassing emulation.

Add an interface for userspace to specify this per-address, we can
use this e.g. for virtio.

The implementation adds a separate bus internally. This serves two
purposes:
- minimize overhead for old userspace that does not use PV MMIO
- minimize disruption in other code (since we don't know the length,
  devices on the MMIO bus only get a valid address in write, this
  way we don't need to touch all devices to teach them handle
  an dinvalid length)

At the moment, this optimization is only supported for EPT on x86 and
silently ignored for NPT and MMU, so everything works correctly but
slowly.

TODO: NPT, MMU and non x86 architectures.

The idea was suggested by Peter Anvin.  Lots of thanks to Gleb for
pre-review and suggestions.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/vmx.c       |  4 ++++
 arch/x86/kvm/x86.c       |  1 +
 include/linux/kvm_host.h |  1 +
 include/uapi/linux/kvm.h |  9 +++++++++
 virt/kvm/eventfd.c       | 47 ++++++++++++++++++++++++++++++++++++++++++-----
 virt/kvm/kvm_main.c      |  1 +
 6 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6667042..cdaac9b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5127,6 +5127,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 	gpa_t gpa;
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+	if (!kvm_io_bus_write(vcpu->kvm, KVM_PV_MMIO_BUS, gpa, 0, NULL)) {
+		skip_emulated_instruction(vcpu);
+		return 1;
+	}
 
 	ret = handle_mmio_page_fault_common(vcpu, gpa, true);
 	if (likely(ret == 1))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f19ac0a..b9223d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2483,6 +2483,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_IRQFD:
 	case KVM_CAP_IOEVENTFD:
+	case KVM_CAP_IOEVENTFD_PV_MMIO:
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cad77fe..35b74cd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -149,6 +149,7 @@ struct kvm_io_bus {
 enum kvm_bus {
 	KVM_MMIO_BUS,
 	KVM_PIO_BUS,
+	KVM_PV_MMIO_BUS,
 	KVM_NR_BUSES
 };
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3c56ba3..61783ee 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -449,11 +449,19 @@ enum {
 	kvm_ioeventfd_flag_nr_datamatch,
 	kvm_ioeventfd_flag_nr_pio,
 	kvm_ioeventfd_flag_nr_deassign,
+	kvm_ioeventfd_flag_nr_pv_mmio,
 	kvm_ioeventfd_flag_nr_max,
 };
 
 #define KVM_IOEVENTFD_FLAG_DATAMATCH (1 << kvm_ioeventfd_flag_nr_datamatch)
 #define KVM_IOEVENTFD_FLAG_PIO       (1 << kvm_ioeventfd_flag_nr_pio)
+/*
+ * PV_MMIO - Guest can promise us that all accesses touching this address
+ * are writes of specified length, starting at the specified address.
+ * If not - it's a Guest bug.
+ * Can not be used together with either PIO or DATAMATCH.
+ */
+#define KVM_IOEVENTFD_FLAG_PV_MMIO   (1 << kvm_ioeventfd_flag_nr_pv_mmio)
 #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
 
 #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
@@ -665,6 +673,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_EPR 86
 #define KVM_CAP_ARM_PSCI 87
 #define KVM_CAP_ARM_SET_DEVICE_ADDR 88
+#define KVM_CAP_IOEVENTFD_PV_MMIO 89
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 93e5b05..1b7619e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -579,6 +579,7 @@ struct _ioeventfd {
 	struct kvm_io_device dev;
 	u8                   bus_idx;
 	bool                 wildcard;
+	bool                 pvmmio;
 };
 
 static inline struct _ioeventfd *
@@ -600,7 +601,15 @@ ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const void *val)
 {
 	u64 _val;
 
-	if (!(addr == p->addr && len == p->length))
+	if (addr != p->addr)
+		/* address must be precise for a hit */
+		return false;
+
+	if (p->pvmmio)
+		/* pvmmio only looks at the address, so always a hit */
+		return true;
+
+	if (len != p->length)
 		/* address-range must be precise for a hit */
 		return false;
 
@@ -671,9 +680,11 @@ ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
 
 	list_for_each_entry(_p, &kvm->ioeventfds, list)
 		if (_p->bus_idx == p->bus_idx &&
-		    _p->addr == p->addr && _p->length == p->length &&
-		    (_p->wildcard || p->wildcard ||
-		     _p->datamatch == p->datamatch))
+		    _p->addr == p->addr &&
+		    (_p->pvmmio || p->pvmmio ||
+		     (_p->length == p->length &&
+		      (_p->wildcard || p->wildcard ||
+		       _p->datamatch == p->datamatch))))
 			return true;
 
 	return false;
@@ -707,6 +718,12 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	if (args->flags & ~KVM_IOEVENTFD_VALID_FLAG_MASK)
 		return -EINVAL;
 
+	/* PV MMIO can't be combined with PIO or DATAMATCH */
+	if (args->flags & KVM_IOEVENTFD_FLAG_PV_MMIO &&
+	    args->flags & (KVM_IOEVENTFD_FLAG_PIO |
+			   KVM_IOEVENTFD_FLAG_DATAMATCH))
+		return -EINVAL;
+
 	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
@@ -722,6 +739,7 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	p->bus_idx = bus_idx;
 	p->length  = args->len;
 	p->eventfd = eventfd;
+	p->pvmmio = args->flags & KVM_IOEVENTFD_FLAG_PV_MMIO;
 
 	/* The datamatch feature is optional, otherwise this is a wildcard */
 	if (args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH)
@@ -729,6 +747,7 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	else
 		p->wildcard = true;
 
+
 	mutex_lock(&kvm->slots_lock);
 
 	/* Verify that there isn't a match already */
@@ -744,12 +763,24 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	if (ret < 0)
 		goto unlock_fail;
 
+	/* PV MMIO is also put on a separate bus, for faster lookups.
+	 * Length is ignored for PV MMIO bus. */
+	if (p->pvmmio) {
+		ret = kvm_io_bus_register_dev(kvm, KVM_PV_MMIO_BUS,
+					      p->addr, 0, &p->dev);
+		if (ret < 0)
+			goto register_fail;
+	}
+
 	list_add_tail(&p->list, &kvm->ioeventfds);
 
 	mutex_unlock(&kvm->slots_lock);
 
 	return 0;
 
+register_fail:
+	kvm_io_bus_register_dev(kvm, bus_idx, p->addr, p->length,
+                                      &p->dev);
 unlock_fail:
 	mutex_unlock(&kvm->slots_lock);
 
@@ -776,19 +807,25 @@ kvm_deassign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	mutex_lock(&kvm->slots_lock);
 
 	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
+		bool pvmmio = args->flags & KVM_IOEVENTFD_FLAG_PV_MMIO;
 		bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
 
 		if (p->bus_idx != bus_idx ||
 		    p->eventfd != eventfd  ||
 		    p->addr != args->addr  ||
 		    p->length != args->len ||
-		    p->wildcard != wildcard)
+		    p->wildcard != wildcard ||
+		    p->pvmmio != pvmmio)
 			continue;
 
 		if (!p->wildcard && p->datamatch != args->datamatch)
 			continue;
 
 		kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
+		if (pvmmio) {
+			kvm_io_bus_unregister_dev(kvm, KVM_PV_MMIO_BUS,
+						  &p->dev);
+		}
 		ioeventfd_release(p);
 		ret = 0;
 		break;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index adc68fe..74c5eb5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2709,6 +2709,7 @@ int kvm_io_bus_write(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 
 	return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(kvm_io_bus_write);
 
 /* kvm_io_bus_read - called under kvm->slots_lock */
 int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
-- 
MST
