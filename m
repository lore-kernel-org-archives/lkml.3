Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbaEMPCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:02:42 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:38782 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965061AbaEMPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:36 -0400
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
Subject: [PATCH v1 RFC 10/10] QEMU: s390: cpu model enablement
Date: Tue, 13 May 2014 17:00:22 +0200
Message-Id: <1399993222-16339-11-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-2966-0000-0000-00000B41BE88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This patch enables all previous cpu model related patches and
    allows the feature to become active. It basically implements
    the host properties being fetched from the host and applied to
    the predefined S390 cpu classes during initialization of the
    HW platform. In a second step, the requsted cpu model determines
    from which cpu class the cpus become instantiated.

    In S390/KVM context, the cpudesc_avail() function returns false
    to avoid the list_cpus() function to be called early. As soon an
    cpu model configuration has been successfully requested and
    the cpu classes have been updated accordingly, the function
    also returns true.

    This patch starts using cpu class s390-cpu as common cpu class
    also for cpus with model properties defined. All cpus will be
    instantiated by means of this class, but the cpu model related
    properties of the class will be updated on behalf of the cpu model.
    This will allow in future to change cpu models concurrently without
    dropping or recreating of cpu objects derived from different cpu
    classes. This class is required in the absence of a class
    transformation operation.

    Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 hw/s390x/s390-virtio-ccw.c |   2 +
 hw/s390x/s390-virtio.c     | 104 +++++++++++++++++++++++++++++++++++++++++++++
 hw/s390x/s390-virtio.h     |   1 +
 3 files changed, 107 insertions(+)

diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index 0d4f6ae..38ec425 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -106,6 +106,8 @@ static void ccw_init(QEMUMachineInitArgs *args)
                       args->initrd_filename, "s390-ccw.img");
     s390_flic_init();
 
+    s390_set_cpu_model(args->cpu_model);
+
     /* register hypercalls */
     virtio_ccw_register_hcalls();
 
diff --git a/hw/s390x/s390-virtio.c b/hw/s390x/s390-virtio.c
index aef2003..0d47523 100644
--- a/hw/s390x/s390-virtio.c
+++ b/hw/s390x/s390-virtio.c
@@ -32,6 +32,7 @@
 #include "hw/virtio/virtio.h"
 #include "hw/sysbus.h"
 #include "sysemu/kvm.h"
+#include "sysemu/cpus.h"
 #include "exec/address-spaces.h"
 
 #include "hw/s390x/s390-virtio-bus.h"
@@ -39,6 +40,8 @@
 #include "hw/s390x/s390_flic.h"
 #include "hw/s390x/s390-virtio.h"
 
+#include "cpu-models.h"
+
 //#define DEBUG_S390
 
 #ifdef DEBUG_S390
@@ -223,6 +226,105 @@ void s390_create_virtio_net(BusState *bus, const char *name)
     }
 }
 
+void s390_set_cpu_model(const char *cpu_model)
+{
+    S390MachineProps mach = {
+        /* base model for TCG */
+        .cpuid = 0xffdecade20640000,
+        .fac_mask[0] = FAC0_CPU_S390_2064_GA1,
+        .hard_fac_list[0] = FAC0_CPU_S390_2064_GA1,
+    };
+    S390CPUClass *cc, *tc;
+    ObjectClass *oc;
+    char *str, *name, *feature;
+#ifdef CONFIG_KVM
+    S390ProcessorProps proc;
+#endif
+
+    /* assume user wants model "host" if non is selected */
+    if (!cpu_model) {
+        cpu_model = "host";
+    }
+
+    s390_cpu_model_mode = true;
+#ifdef CONFIG_KVM
+    /* request host specific properties from kvm */
+    if (kvm_enabled()) {
+        if (kvm_check_extension(kvm_state, KVM_CAP_VM_ATTRIBUTES) == 0) {
+            goto out_legacy_cpu;
+        }
+        if (!kvm_s390_has_cpu_model_call(KVM_S390_VM_CPU_PROCESSOR) ||
+            !kvm_s390_has_cpu_model_call(KVM_S390_VM_CPU_MACHINE)) {
+            goto out_legacy_cpu;
+        }
+        if (kvm_s390_get_machine_props(&mach)) {
+            goto out_legacy_cpu;
+        }
+    }
+#endif
+
+    /* split off cpu model name */
+    str = g_strdup(cpu_model);
+    name = g_strdup(strtok(str, ","));
+
+    /* parse remaining features */
+    for (feature = strtok(NULL, ","); feature; feature = strtok(NULL, ",")) {
+        if (!strcmp(feature, "+sofl")) {
+            /* allow use of soft facilities */
+            s390_use_sofl = true;
+            continue;
+        }
+    }
+    g_free(str);
+
+    /* populate cpu classes with life */
+    if (s390_setup_cpu_classes(&mach) != 0) {
+        goto out_legacy_cpu;
+    }
+
+    /* print help on cpu models if requested */
+    if (is_help_option(name)) {
+        list_cpus(stdout, &fprintf, name);
+        exit(0);
+    }
+
+    /* get handle to cpu model specific cpu class */
+    oc = s390_cpu_class_by_name(name);
+    g_free(name);
+    if (!oc) {
+        goto out_legacy_cpu;
+    }
+    cc = S390_CPU_CLASS(oc);
+    if (!cc) {
+        goto out_legacy_cpu;
+    }
+
+#ifdef CONFIG_KVM
+    /* request kvm to use selected cpu model properties */
+    if (kvm_enabled()) {
+        proc.cpuid = ver_cpuid(cc->proc->ver);
+        proc.cpuid |= id_cpuid(cc->proc->id);
+        proc.cpuid |= type_cpuid(cc->proc->type);
+        proc.ibc = cc->proc->ibc;
+        memcpy(proc.fac_list, cc->fac_list,
+               S390_FAC_LIST_SIZE_BYTE);
+        if (kvm_s390_set_processor_props(&proc) != 0) {
+            goto out_legacy_cpu;
+        }
+    }
+#endif
+
+    /* update central cpu class with cpu model properties */
+    tc = S390_CPU_CLASS(object_class_by_name(TYPE_S390_CPU));
+    s390_update_cpu_class_properties(tc, cc);
+
+    return;
+
+out_legacy_cpu:
+    /* fall back to non cpu model mode */
+    s390_cpu_model_mode = false;
+}
+
 /* PC hardware initialisation */
 static void s390_init(QEMUMachineInitArgs *args)
 {
@@ -252,6 +354,8 @@ static void s390_init(QEMUMachineInitArgs *args)
                       args->initrd_filename, ZIPL_FILENAME);
     s390_flic_init();
 
+    s390_set_cpu_model(args->cpu_model);
+
     /* register hypercalls */
     s390_virtio_register_hcalls();
 
diff --git a/hw/s390x/s390-virtio.h b/hw/s390x/s390-virtio.h
index 5c405e7..17bdddf 100644
--- a/hw/s390x/s390-virtio.h
+++ b/hw/s390x/s390-virtio.h
@@ -26,4 +26,5 @@ void s390_init_ipl_dev(const char *kernel_filename,
                        const char *initrd_filename,
                        const char *firmware);
 void s390_create_virtio_net(BusState *bus, const char *name);
+void s390_set_cpu_model(const char *cpu_model);
 #endif
-- 
1.8.3.1

