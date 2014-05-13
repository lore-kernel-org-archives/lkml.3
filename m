Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199AbaEMPDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:03:31 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:53161 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934163AbaEMPAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:31 -0400
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
Subject: [PATCH v1 RFC 02/10] QEMU: s390: cpu model cpu class definition
Date: Tue, 13 May 2014 17:00:14 +0200
Message-Id: <1399993222-16339-3-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-3548-0000-0000-0000090BC60D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the static part of the s390 cpu class definitions.
It defines single cpu models by means of virtual cpu ids which contain
information on the cpu generation, the machine class, the GA number and
the machine type. The cpu id is used to instantiate a cpu class per cpu
id.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 target-s390x/Makefile.objs |  1 +
 target-s390x/cpu-models.c  | 82 ++++++++++++++++++++++++++++++++++++++++++++++
 target-s390x/cpu-models.h  | 67 +++++++++++++++++++++++++++++++++++++
 target-s390x/cpu-qom.h     | 22 +++++++++++++
 target-s390x/cpu.c         |  2 ++
 5 files changed, 174 insertions(+)
 create mode 100644 target-s390x/cpu-models.c
 create mode 100644 target-s390x/cpu-models.h

diff --git a/target-s390x/Makefile.objs b/target-s390x/Makefile.objs
index f873146..6a38ce9 100644
--- a/target-s390x/Makefile.objs
+++ b/target-s390x/Makefile.objs
@@ -1,5 +1,6 @@
 obj-y += translate.o helper.o cpu.o interrupt.o
 obj-y += int_helper.o fpu_helper.o cc_helper.o mem_helper.o misc_helper.o
 obj-y += gdbstub.o
+obj-y += cpu-models.o
 obj-$(CONFIG_SOFTMMU) += ioinst.o arch_dump.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/target-s390x/cpu-models.c b/target-s390x/cpu-models.c
new file mode 100644
index 0000000..8f1fa64
--- /dev/null
+++ b/target-s390x/cpu-models.c
@@ -0,0 +1,82 @@
+/*
+ * CPU models for s390
+ *
+ * Copyright 2014 IBM Corp.
+ *
+ * Author(s): Michael Mueller <mimu@linux.vnet.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include "cpu.h"
+#include "cpu-models.h"
+
+#define S390_PROC_DEF(_name, _cpu_id, _desc)                            \
+    static void                                                         \
+    glue(_cpu_id, _cpu_class_init)                                      \
+    (ObjectClass *oc, void *data)                                       \
+    {                                                                   \
+        DeviceClass *dc = DEVICE_CLASS(oc);                             \
+        S390CPUClass *cc = S390_CPU_CLASS(oc);                          \
+                                                                        \
+        cc->is_active   = true;                                         \
+        cc->is_host     = false;                                        \
+        cc->fac_list    = NULL;                                         \
+        cc->mach        = g_malloc0(sizeof(S390CPUMachineProps));       \
+        cc->mach->ga    = cpu_ga(_cpu_id);                              \
+        cc->mach->class = cpu_class(_cpu_id);                           \
+        cc->mach->order = cpu_order(_cpu_id);                           \
+        cc->proc        = g_malloc0(sizeof(S390CPUProcessorProps));     \
+        cc->proc->gen   = cpu_generation(_cpu_id);                      \
+        cc->proc->ver   = S390_DEF_VERSION;                             \
+        cc->proc->id    = S390_DEF_ID;                                  \
+        cc->proc->type  = cpu_type(_cpu_id);                            \
+        cc->proc->ibc   = S390_DEF_IBC;                                 \
+        cc->proc->fac_list = NULL;                                      \
+        dc->desc        = _desc;                                        \
+    }                                                                   \
+    static const TypeInfo                                               \
+    glue(_cpu_id, _cpu_type_info) = {                                   \
+        .name       = _name "-" TYPE_S390_CPU,                          \
+        .parent     = TYPE_S390_CPU,                                    \
+        .class_init = glue(_cpu_id, _cpu_class_init),                   \
+    };                                                                  \
+    static void                                                         \
+    glue(_cpu_id, _cpu_register_types)(void)                            \
+    {                                                                   \
+        type_register_static(                                           \
+            &glue(_cpu_id, _cpu_type_info));                            \
+    }                                                                   \
+    type_init(glue(_cpu_id, _cpu_register_types))
+
+/* define S390 CPU model classes */
+S390_PROC_DEF("2064-ga1", CPU_S390_2064_GA1, "IBM zSeries 900 GA1")
+S390_PROC_DEF("2064-ga2", CPU_S390_2064_GA2, "IBM zSeries 900 GA2")
+S390_PROC_DEF("2064-ga3", CPU_S390_2064_GA3, "IBM zSeries 900 GA3")
+S390_PROC_DEF("2066-ga1", CPU_S390_2066_GA1, "IBM zSeries 800 GA1")
+S390_PROC_DEF("2084-ga1", CPU_S390_2084_GA1, "IBM zSeries 990 GA1")
+S390_PROC_DEF("2084-ga2", CPU_S390_2084_GA2, "IBM zSeries 990 GA2")
+S390_PROC_DEF("2084-ga3", CPU_S390_2084_GA3, "IBM zSeries 990 GA3")
+S390_PROC_DEF("2084-ga4", CPU_S390_2084_GA4, "IBM zSeries 990 GA4")
+S390_PROC_DEF("2084-ga5", CPU_S390_2084_GA5, "IBM zSeries 990 GA5")
+S390_PROC_DEF("2086-ga1", CPU_S390_2086_GA1, "IBM zSeries 890 GA1")
+S390_PROC_DEF("2086-ga2", CPU_S390_2086_GA2, "IBM zSeries 890 GA2")
+S390_PROC_DEF("2086-ga3", CPU_S390_2086_GA3, "IBM zSeries 890 GA3")
+S390_PROC_DEF("2094-ga1", CPU_S390_2094_GA1, "IBM System z9 EC GA1")
+S390_PROC_DEF("2094-ga2", CPU_S390_2094_GA2, "IBM System z9 EC GA2")
+S390_PROC_DEF("2094-ga3", CPU_S390_2094_GA3, "IBM System z9 EC GA3")
+S390_PROC_DEF("2096-ga1", CPU_S390_2096_GA1, "IBM System z9 BC GA1")
+S390_PROC_DEF("2096-ga2", CPU_S390_2096_GA2, "IBM System z9 BC GA2")
+S390_PROC_DEF("2097-ga1", CPU_S390_2097_GA1, "IBM System z10 EC GA1")
+S390_PROC_DEF("2097-ga2", CPU_S390_2097_GA2, "IBM System z10 EC GA2")
+S390_PROC_DEF("2097-ga3", CPU_S390_2097_GA3, "IBM System z10 EC GA3")
+S390_PROC_DEF("2098-ga1", CPU_S390_2098_GA1, "IBM System z10 BC GA1")
+S390_PROC_DEF("2098-ga2", CPU_S390_2098_GA2, "IBM System z10 BC GA2")
+S390_PROC_DEF("2817-ga1", CPU_S390_2817_GA1, "IBM zEnterprise 196 GA1")
+S390_PROC_DEF("2817-ga2", CPU_S390_2817_GA2, "IBM zEnterprise 196 GA2")
+S390_PROC_DEF("2818-ga1", CPU_S390_2818_GA1, "IBM zEnterprise 114 GA1")
+S390_PROC_DEF("2827-ga1", CPU_S390_2827_GA1, "IBM zEnterprise EC12 GA1")
+S390_PROC_DEF("2827-ga2", CPU_S390_2827_GA2, "IBM zEnterprise EC12 GA2")
+S390_PROC_DEF("2828-ga1", CPU_S390_2828_GA1, "IBM zEnterprise BC12 GA1")
diff --git a/target-s390x/cpu-models.h b/target-s390x/cpu-models.h
new file mode 100644
index 0000000..4abd39a
--- /dev/null
+++ b/target-s390x/cpu-models.h
@@ -0,0 +1,67 @@
+/*
+ * CPU models for s390
+ *
+ * Copyright 2014 IBM Corp.
+ *
+ * Author(s): Michael Mueller <mimu@linux.vnet.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef TARGET_S390X_CPU_MODELS_H
+#define TARGET_S390X_CPU_MODELS_H
+
+#define S390_EC 0x1
+#define S390_BC 0x2
+
+#define S390_DEF_VERSION 0xff
+#define S390_DEF_IBC     0x0
+#define S390_DEF_ID      0xdecade
+
+#define cpu_type(x)       (((x) >>  0) & 0xffff)
+#define cpu_order(x)      (((x) >> 16) & 0xffff)
+#define cpu_ga(x)         (((x) >> 16) & 0xf)
+#define cpu_class(x)      (((x) >> 20) & 0x3)
+#define cpu_generation(x) (((x) >> 24) & 0xff)
+
+/*
+ * bits 0-7   : CMOS generation
+ * bits 8-9   : reserved
+ * bits 10-11 : machine class 0=unknown 1=EC 2=BC
+ * bits 12-15 : GA
+ * bits 16-31 : machine type
+ */
+enum {
+    CPU_S390_2064_GA1 = 0x07112064,
+    CPU_S390_2064_GA2 = 0x07122064,
+    CPU_S390_2064_GA3 = 0x07132064,
+    CPU_S390_2066_GA1 = 0x07212066,
+    CPU_S390_2084_GA1 = 0x08112084,
+    CPU_S390_2084_GA2 = 0x08122084,
+    CPU_S390_2084_GA3 = 0x08132084,
+    CPU_S390_2084_GA4 = 0x08142084,
+    CPU_S390_2084_GA5 = 0x08152084,
+    CPU_S390_2086_GA1 = 0x08212086,
+    CPU_S390_2086_GA2 = 0x08222086,
+    CPU_S390_2086_GA3 = 0x08232086,
+    CPU_S390_2094_GA1 = 0x09112094,
+    CPU_S390_2094_GA2 = 0x09122094,
+    CPU_S390_2094_GA3 = 0x09132094,
+    CPU_S390_2096_GA1 = 0x09212096,
+    CPU_S390_2096_GA2 = 0x09222096,
+    CPU_S390_2097_GA1 = 0x0a112097,
+    CPU_S390_2097_GA2 = 0x0a122097,
+    CPU_S390_2097_GA3 = 0x0a132097,
+    CPU_S390_2098_GA1 = 0x0a212098,
+    CPU_S390_2098_GA2 = 0x0a222098,
+    CPU_S390_2817_GA1 = 0x0b112817,
+    CPU_S390_2817_GA2 = 0x0b122817,
+    CPU_S390_2818_GA1 = 0x0b212818,
+    CPU_S390_2827_GA1 = 0x0c112827,
+    CPU_S390_2827_GA2 = 0x0c122827,
+    CPU_S390_2828_GA1 = 0x0c212828,
+};
+
+#endif
diff --git a/target-s390x/cpu-qom.h b/target-s390x/cpu-qom.h
index ac0460e..c34bce5 100644
--- a/target-s390x/cpu-qom.h
+++ b/target-s390x/cpu-qom.h
@@ -32,6 +32,23 @@
 #define S390_CPU_GET_CLASS(obj) \
     OBJECT_GET_CLASS(S390CPUClass, (obj), TYPE_S390_CPU)
 
+/* machine related properties */
+typedef struct S390CPUMachineProps {
+    uint16_t class;      /* machine class */
+    uint16_t ga;         /* availability number of machine */
+    uint16_t order;      /* order of availability */
+} S390CPUMachineProps;
+
+/* processor related properties */
+typedef struct S390CPUProcessorProps {
+    uint16_t gen;        /* S390 CMOS generation */
+    uint16_t ver;        /* version of processor */
+    uint32_t id;         /* processor identification*/
+    uint16_t type;       /* machine type */
+    uint16_t ibc;        /* IBC value */
+    uint64_t *fac_list;  /* list of facilities */
+} S390CPUProcessorProps;
+
 /**
  * S390CPUClass:
  * @parent_realize: The parent class' realize handler.
@@ -52,6 +69,11 @@ typedef struct S390CPUClass {
     void (*load_normal)(CPUState *cpu);
     void (*cpu_reset)(CPUState *cpu);
     void (*initial_cpu_reset)(CPUState *cpu);
+    bool is_active;               /* true if cpu class supported by host */
+    bool is_host;                 /* true if cpu class respresents "host" */
+    uint64_t *fac_list;           /* active facility_list */
+    S390CPUMachineProps   *mach;  /* machine specific properties */
+    S390CPUProcessorProps *proc;  /* processor specific properties */
 } S390CPUClass;
 
 /**
diff --git a/target-s390x/cpu.c b/target-s390x/cpu.c
index dfd83e8..7fa588c 100644
--- a/target-s390x/cpu.c
+++ b/target-s390x/cpu.c
@@ -256,6 +256,8 @@ static void s390_cpu_class_init(ObjectClass *oc, void *data)
 #endif
     dc->vmsd = &vmstate_s390_cpu;
     cc->gdb_num_core_regs = S390_NUM_REGS;
+    scc->mach = g_malloc0(sizeof(*scc->mach));
+    scc->proc = g_malloc0(sizeof(*scc->proc));
 }
 
 static const TypeInfo s390_cpu_type_info = {
-- 
1.8.3.1

