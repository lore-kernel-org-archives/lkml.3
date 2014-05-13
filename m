Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090AbaEMPAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:00:39 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:40099 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998AbaEMPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:32 -0400
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
Subject: [PATCH v1 RFC 06/10] QEMU: s390: cpu model kvm VM attr interface routines
Date: Tue, 13 May 2014 17:00:18 +0200
Message-Id: <1399993222-16339-7-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-6892-0000-0000-000008C5CAE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch implements routines to set and retrieve processor configuration
data and to retrieve machine configuration data. The machine related data
will be used to determine the list of supported cpu models of this host.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 target-s390x/cpu-models.h | 21 +++++++++++++++
 target-s390x/cpu.c        |  2 ++
 target-s390x/kvm.c        | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/target-s390x/cpu-models.h b/target-s390x/cpu-models.h
index f5c8112..3533c96 100644
--- a/target-s390x/cpu-models.h
+++ b/target-s390x/cpu-models.h
@@ -55,6 +55,27 @@ typedef struct S390CPUAlias {
 } S390CPUAlias;
 extern GSList *s390_cpu_aliases;
 
+typedef struct S390ProcessorProps {
+    uint64_t cpuid;
+    uint16_t ibc;
+    uint8_t  pad[6];
+    uint64_t fac_list[S390_ARCH_FAC_LIST_SIZE_UINT64];
+} S390ProcessorProps;
+
+typedef struct S390MachineProps {
+    uint64_t cpuid;
+    uint32_t ibc_range;
+    uint8_t  pad[4];
+    uint64_t fac_mask[S390_ARCH_FAC_MASK_SIZE_UINT64];
+    uint64_t hard_fac_list[S390_ARCH_FAC_LIST_SIZE_UINT64];
+    uint64_t soft_fac_list[S390_ARCH_FAC_LIST_SIZE_UINT64];
+} S390MachineProps;
+
+int kvm_s390_has_cpu_model_call(uint64_t attr);
+int kvm_s390_get_processor_props(S390ProcessorProps *prob);
+int kvm_s390_set_processor_props(S390ProcessorProps *prob);
+int kvm_s390_get_machine_props(S390MachineProps *prob);
+
 /*
  * bits 0-7   : CMOS generation
  * bits 8-9   : reserved
diff --git a/target-s390x/cpu.c b/target-s390x/cpu.c
index 10a03f9..5e292e7 100644
--- a/target-s390x/cpu.c
+++ b/target-s390x/cpu.c
@@ -28,6 +28,8 @@
 #include "qemu-common.h"
 #include "qemu/timer.h"
 #include "hw/hw.h"
+#include "cpu-qom.h"
+#include "cpu-models.h"
 #ifndef CONFIG_USER_ONLY
 #include "sysemu/arch_init.h"
 #endif
diff --git a/target-s390x/kvm.c b/target-s390x/kvm.c
index b7b0edc..b69d5d0 100644
--- a/target-s390x/kvm.c
+++ b/target-s390x/kvm.c
@@ -33,6 +33,7 @@
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
 #include "cpu.h"
+#include "cpu-models.h"
 #include "sysemu/device_tree.h"
 #include "qapi/qmp/qjson.h"
 #include "monitor/monitor.h"
@@ -93,6 +94,8 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
 static int cap_sync_regs;
 static int cap_async_pf;
 
+static uint64_t cpu_model_call_cache;
+
 static void *legacy_s390_alloc(size_t size);
 
 int kvm_arch_init(KVMState *s)
@@ -959,3 +962,66 @@ int kvm_s390_assign_subch_ioeventfd(EventNotifier *notifier, uint32_t sch,
     }
     return kvm_vm_ioctl(kvm_state, KVM_IOEVENTFD, &kick);
 }
+
+static int cpu_model_get(uint64_t attr, uint64_t addr)
+{
+    struct kvm_device_attr dev_attr = {
+        .group = KVM_S390_VM_CPU_MODEL,
+        .attr = attr,
+        .addr = addr,
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_GET_DEVICE_ATTR, &dev_attr);
+}
+
+static int cpu_model_set(uint64_t attr, uint64_t addr)
+{
+    struct kvm_device_attr dev_attr = {
+        .group = KVM_S390_VM_CPU_MODEL,
+        .attr = attr,
+        .addr = addr,
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &dev_attr);
+}
+
+int kvm_s390_has_cpu_model_call(uint64_t attr)
+{
+    int rc;
+    struct kvm_device_attr dev_attr = {
+        .group = KVM_S390_VM_CPU_MODEL,
+        .attr = attr,
+    };
+
+    if (dev_attr.attr >= sizeof(cpu_model_call_cache)) {
+        return 0;
+    }
+
+    if (cpu_model_call_cache & (1UL << dev_attr.attr)) {
+        return 1;
+    }
+
+    rc = kvm_vm_ioctl(kvm_state, KVM_HAS_DEVICE_ATTR, &dev_attr);
+    if (rc == 0) {
+        cpu_model_call_cache |= (1UL << dev_attr.attr);
+        return 1;
+    }
+
+    return 0;
+}
+
+int kvm_s390_get_processor_props(S390ProcessorProps *prop)
+{
+    return cpu_model_get(KVM_S390_VM_CPU_PROCESSOR, (uint64_t) prop);
+}
+
+int kvm_s390_set_processor_props(S390ProcessorProps *prop)
+{
+    return cpu_model_set(KVM_S390_VM_CPU_PROCESSOR, (uint64_t) prop);
+}
+
+int kvm_s390_get_machine_props(S390MachineProps *prop)
+{
+    return cpu_model_get(KVM_S390_VM_CPU_MACHINE, (uint64_t) prop);
+}
+
-- 
1.8.3.1

