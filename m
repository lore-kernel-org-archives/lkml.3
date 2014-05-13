Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120AbaEMPAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:00:44 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:49756 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049AbaEMPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:33 -0400
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
Subject: [PATCH v1 RFC 07/10] QEMU: s390: cpu model class initialization
Date: Tue, 13 May 2014 17:00:19 +0200
Message-Id: <1399993222-16339-8-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-0542-0000-0000-000008F95B26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides routines to dynamically update the previously defined S390
cpu classes in the current host context. The main function issuing this process
is s390_setup_cpu_classes(). It takes the current host context as parameter to
setup the classes accordingly. It basically performs the following sub-tasks:

- update of cpu classes with KVM host properties
- mark cpu class for cpu model "host"
- invalidate cpu classes not supported by this host
- set machine type aliases to latest ga of model (e.g. 2064 -> 2064-ga3)
- set aliases for common model names to machine types
- set alias for cpu model "host"

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 target-s390x/cpu-models.c | 401 ++++++++++++++++++++++++++++++++++++++++++++++
 target-s390x/cpu-models.h |  25 +++
 target-s390x/cpu.c        |  26 ++-
 target-s390x/cpu.h        |   3 +
 4 files changed, 454 insertions(+), 1 deletion(-)

diff --git a/target-s390x/cpu-models.c b/target-s390x/cpu-models.c
index 25147a4..19bbb30 100644
--- a/target-s390x/cpu-models.c
+++ b/target-s390x/cpu-models.c
@@ -12,6 +12,7 @@
 
 #include "cpu.h"
 #include "cpu-models.h"
+#include "qemu/error-report.h"
 
 #define S390_FAC_NAME(n, _cpu_id)               \
     glue(glue(glue(FAC, n), _), _cpu_id)
@@ -86,8 +87,42 @@ S390_PROC_DEF("2827-ga1", CPU_S390_2827_GA1, "IBM zEnterprise EC12 GA1")
 S390_PROC_DEF("2827-ga2", CPU_S390_2827_GA2, "IBM zEnterprise EC12 GA2")
 S390_PROC_DEF("2828-ga1", CPU_S390_2828_GA1, "IBM zEnterprise BC12 GA1")
 
+/* some types for calls to g_list_foreach() with arguments */
+typedef struct ArgTCV {
+    unsigned short type;
+    unsigned short class;
+    bool valid;
+} ArgTCV;
+
+typedef struct ArgTGV {
+    unsigned short type;
+    unsigned short gen;
+    bool valid;
+} ArgTGV;
+
+typedef struct ArgTC {
+    unsigned short type;
+    unsigned short class;
+} ArgTC;
+
+typedef struct ArgPH {
+    S390MachineProps *prop;
+    S390CPUClass *host_cc;
+} ArgPH;
+
+typedef struct ArgH {
+    S390CPUClass *host_cc;
+} ArgH;
+
+typedef struct ArgTG {
+    unsigned short type;
+    unsigned short ga;
+} ArgTG;
+
 /* S390 CPU aliases can be added dynamically to this list */
 GSList *s390_cpu_aliases;
+bool s390_cpu_classes_prepared;
+bool s390_use_sofl;
 
 static inline unsigned long bit_in_word(unsigned int nr)
 {
@@ -107,6 +142,21 @@ static inline int test_facility(unsigned long nr, unsigned long *fac_list)
     return (*ptr & bit_in_word(nr)) != 0;
 }
 
+/* compare order of two cpu classes for ascending sort */
+gint s390_cpu_class_asc_order_compare(gconstpointer a, gconstpointer b)
+{
+    S390CPUClass *cc_a = S390_CPU_CLASS((ObjectClass *) a);
+    S390CPUClass *cc_b = S390_CPU_CLASS((ObjectClass *) b);
+
+    if (cc_a->mach->order < cc_b->mach->order) {
+        return -1;
+    }
+    if (cc_a->mach->order > cc_b->mach->order) {
+        return 1;
+    }
+    return 0;
+}
+
 static gint s390_cpu_compare_class_name(gconstpointer a, gconstpointer b)
 {
     ObjectClass *oc = (ObjectClass *)a;
@@ -167,3 +217,354 @@ int set_s390_cpu_alias(const char *name, const char *model)
 
     return 0;
 }
+
+/* return machine class for specific machine type */
+static void s390_machine_class_test_cpu_class(gpointer data, gpointer user_data)
+{
+    S390CPUClass *cc = S390_CPU_CLASS((ObjectClass *) data);
+    ArgTCV *arg = user_data;
+
+    if (arg->valid || !cc->proc->type || arg->type != cc->proc->type) {
+        return;
+    }
+
+    arg->class = cc->mach->class;
+    arg->valid = true;
+}
+
+/* return machine class by machine type */
+static unsigned short machine_class(unsigned short type, void *user_data)
+{
+    GSList *list = object_class_get_list(TYPE_S390_CPU, false);
+    ArgTC  *arg = user_data;
+    ArgTCV arg_class;
+
+    if (arg->type != type) {
+        arg->class = 0;
+    }
+    if (!arg->class) {
+        arg_class.type = type;
+        arg_class.class = 0;
+        arg_class.valid = false;
+        g_slist_foreach(list, (GFunc) s390_machine_class_test_cpu_class,
+                        &arg_class);
+        g_slist_free(list);
+        if (arg_class.valid) {
+            arg->class = arg_class.class;
+        }
+    }
+    arg->type = type;
+
+    return arg->class;
+}
+
+/* return CMOS generation for specific machine type */
+static void s390_machine_class_test_cpu_gen(gpointer data, gpointer user_data)
+{
+    S390CPUClass *cc = S390_CPU_CLASS((ObjectClass *) data);
+    ArgTGV *arg = user_data;
+
+    if (arg->valid) {
+        return;
+    }
+
+    if (arg->type == cc->proc->type) {
+        arg->gen = cc->proc->gen;
+        arg->valid = true;
+    }
+}
+
+/* return CMOS generation by machine type */
+static uint16_t machine_gen(unsigned short type)
+{
+    GSList *list = object_class_get_list(TYPE_S390_CPU, false);
+    ArgTGV arg_gen;
+
+    arg_gen.type = type;
+    arg_gen.gen = 0;
+    arg_gen.valid = false;
+    g_slist_foreach(list, (GFunc) s390_machine_class_test_cpu_gen,
+                    &arg_gen);
+    g_slist_free(list);
+
+    return arg_gen.gen;
+}
+
+/* mark cpu class, used in host cpu model case */
+static void s390_mark_host_cpu_class(gpointer data, gpointer user_data)
+{
+    S390CPUClass *cc = S390_CPU_CLASS((ObjectClass *) data);
+    ArgPH *arg = user_data;
+    ArgTC arg_tc;
+
+    if (!cc->is_active) {
+        return;
+    }
+
+    arg_tc.type = 0;
+    arg_tc.class = 0;
+    if (cc->mach->class != machine_class(
+            cpuid_type(arg->prop->cpuid), &arg_tc)) {
+        /* sort out machines that differ from host machine class */
+        return;
+    }
+    if (!arg->host_cc) {
+        /* use first matching machine type */
+        cc->is_host = true;
+        arg->host_cc = cc;
+        return;
+    }
+    if (cc->proc->gen > machine_gen(cpuid_type(arg->prop->cpuid))) {
+        /* sort out CMOS generations later than hosts generation */
+        cc->is_active = false;
+        return;
+    }
+    if (cc->mach->order > arg->host_cc->mach->order) {
+        /* select later machine as host */
+        arg->host_cc->is_host = false;
+        cc->is_host = true;
+        arg->host_cc = cc;
+    }
+}
+
+/* update a specific cpu model class with host retrieved configuration */
+static void s390_update_cpu_class(gpointer data, gpointer user_data)
+{
+    ObjectClass *oc = data;
+    S390MachineProps *prop = user_data;
+    S390CPUClass *cc = S390_CPU_CLASS(oc);
+    unsigned int i;
+
+    if (!cc->proc->type) {
+        return;
+    }
+
+    /* set processor identifier */
+    cc->proc->id = cpuid_id(prop->cpuid);
+
+    /*
+     * define model specific IBC value in current host context.
+     * IBC was introduced with CMOS version 10 i.e. type 2097.
+     * For older CPUs it is assumed to be 0x000. The BC system
+     * has always the same IBC version as the previous EC system.
+     * If the host supports IBC but not the requested type, it
+     * will be set to the lowest supported value.
+     */
+    if (has_ibc(prop->ibc_range)) {
+        if (cc->proc->gen >= S390_CMOS_G10) {
+            cc->proc->ibc = ((cc->proc->gen - S390_CMOS_G10) << 4);
+            cc->proc->ibc += cc->mach->ga;
+            if (cc->mach->class == S390_BC) {
+                cc->proc->ibc++;
+            }
+            if (cc->proc->ibc < lowest_ibc(prop->ibc_range)) {
+                cc->proc->ibc = lowest_ibc(prop->ibc_range);
+            }
+            if (cc->proc->ibc > latest_ibc(prop->ibc_range)) {
+                cc->proc->ibc = latest_ibc(prop->ibc_range);
+            }
+        } else {
+            cc->proc->ibc = lowest_ibc(prop->ibc_range);
+        }
+    }
+
+    /* set desired facility list of class */
+    for (i = 0; i < S390_FAC_LIST_SIZE_UINT64; i++) {
+        cc->fac_list[i] = prop->fac_mask[i] & cc->proc->fac_list[i];
+    }
+
+    /* mark cpu class inactive if not all desired facility bits are available */
+    for (i = 0; i < S390_FAC_LIST_SIZE_BIT && cc->is_active; i++) {
+        if (test_facility(i, cc->fac_list) &&
+            !test_facility(i, prop->hard_fac_list)) {
+            cc->is_active = false;
+        }
+    }
+
+    /* extend desired facility list by offered soft facility list */
+    if (s390_use_sofl) {
+        for (i = 0; i < S390_FAC_LIST_SIZE_UINT64; i++) {
+            cc->fac_list[i] |= prop->fac_mask[i] & prop->soft_fac_list[i];
+        }
+    }
+}
+
+/* a cpu class that is newer then the current host */
+static void s390_deactivate_not_supported_cpu_class(gpointer data,
+                                                    gpointer user_data)
+{
+    S390CPUClass *cc = S390_CPU_CLASS((ObjectClass *) data);
+    ArgH *arg = user_data;
+
+    if (!cc->is_active) {
+        return;
+    }
+    if (cc->mach->order > arg->host_cc->mach->order) {
+        cc->is_active = false;
+    }
+}
+
+/* set alias by type and ga */
+static int set_s390_cpu_alias_by_type_ga(unsigned short type, unsigned short ga)
+{
+    char name[8], model[16];
+
+    snprintf(name, sizeof(name), "%04x", type);
+    snprintf(model, sizeof(model), "%04x-ga%u", type, ga);
+
+    return set_s390_cpu_alias(name, model);
+}
+
+/* set alias if system has latest ga of a type */
+static void s390_set_ga_alias_from_cpu_class(gpointer data, gpointer user_data)
+{
+    S390CPUClass *cc = S390_CPU_CLASS((ObjectClass *) data);
+    ArgTG *arg = user_data;
+
+    if (!cc->is_active) {
+        return;
+    }
+    if (!arg->type) {
+        arg->type = cc->proc->type;
+    }
+    if (cc->proc->type == arg->type) {
+        arg->ga = cc->mach->ga;
+        return;
+    }
+    set_s390_cpu_alias_by_type_ga(arg->type, arg->ga);
+    arg->type = cc->proc->type;
+    arg->ga = cc->mach->ga;
+}
+
+/* set host marked cpu class as alias to respective class */
+static void s390_set_host_alias_from_cpu_class(gpointer data,
+                                               gpointer user_data)
+{
+    S390CPUClass *cc = S390_CPU_CLASS((ObjectClass *) data);
+    char model[16];
+
+    if (!cc->is_active || !cc->is_host) {
+        return;
+    }
+    snprintf(model, sizeof(model), "%04x-ga%u", cc->proc->type, cc->mach->ga);
+    set_s390_cpu_alias("host", model);
+}
+
+/*
+ * apply host properties retrieved from KVM to cpu model classes,
+ * then find cpu model host and define further aliases
+ */
+int s390_setup_cpu_classes(S390MachineProps *prop)
+{
+    GSList *list;
+    ArgPH arg_host;
+    ArgH  arg_deactivate;
+    ArgTG arg_alias;
+
+    list = object_class_get_list(TYPE_S390_CPU, false);
+    list = g_slist_sort(list, s390_cpu_class_asc_order_compare);
+
+    /* update cpu classes with KVM properties */
+    g_slist_foreach(list, (GFunc) s390_update_cpu_class, (gpointer) prop);
+
+    /* define cpu model "host" */
+    arg_host.prop = prop;
+    arg_host.host_cc = NULL;
+    g_slist_foreach(list, (GFunc) s390_mark_host_cpu_class,
+                    (gpointer) &arg_host);
+
+    if (!arg_host.host_cc) {
+        error_report("Failed to mark host cpu class: %m");
+        return -EINVAL;
+    }
+
+    /* invalidate cpu classes not supported by this host */
+    arg_deactivate.host_cc = arg_host.host_cc;
+    g_slist_foreach(list, (GFunc) s390_deactivate_not_supported_cpu_class,
+                    &arg_deactivate);
+
+    /* set machine type aliases to latest ga of model (e.g. 2064 -> 2064-ga3) */
+    arg_alias.type = 0;
+    arg_alias.ga = 0;
+    g_slist_foreach(list, (GFunc) s390_set_ga_alias_from_cpu_class, &arg_alias);
+    set_s390_cpu_alias_by_type_ga(arg_alias.type, arg_alias.ga);
+
+    /* set aliases for common model names to machine types */
+    set_s390_cpu_alias("z900",   "2064");
+    set_s390_cpu_alias("z800",   "2066");
+    set_s390_cpu_alias("z990",   "2084");
+    set_s390_cpu_alias("z890",   "2086");
+    set_s390_cpu_alias("z9-109", "2094-ga1");
+    set_s390_cpu_alias("z9",     "2094");
+    set_s390_cpu_alias("z9-ec",  "2094");
+    set_s390_cpu_alias("z9-bc",  "2096");
+    set_s390_cpu_alias("z10",    "2097");
+    set_s390_cpu_alias("z10-ec", "2097");
+    set_s390_cpu_alias("z10-bc", "2098");
+    set_s390_cpu_alias("z196",   "2817");
+    set_s390_cpu_alias("z114",   "2818");
+    set_s390_cpu_alias("zEC12",  "2827");
+    set_s390_cpu_alias("zBC12",  "2828");
+
+    /* set alias for cpu model "host" */
+    g_slist_foreach(list, (GFunc) s390_set_host_alias_from_cpu_class, NULL);
+
+    g_slist_free(list);
+
+    s390_cpu_classes_prepared = true;
+
+    return 0;
+}
+
+/* list all supported cpu models and alias names */
+void s390_cpu_list_entry(gpointer data, gpointer user_data)
+{
+    ObjectClass *alias_oc, *oc = data;
+    CPUListState *s = user_data;
+    DeviceClass  *dc = DEVICE_CLASS(oc);
+    S390CPUClass *cc = S390_CPU_CLASS(oc);
+    const char *typename = object_class_get_name(oc);
+    S390CPUAlias *alias;
+    GSList *item;
+    char *name;
+
+    if (!cc->is_active) {
+        return;
+    }
+    name = g_strndup(typename, strlen(typename) - strlen("-" TYPE_S390_CPU));
+    (*s->cpu_fprintf)(s->file, "s390 %-10s %s\n", name, dc->desc);
+
+    for (item = s390_cpu_aliases; item != NULL; item = item->next) {
+        alias = (S390CPUAlias *) item->data;
+        alias_oc = s390_cpu_class_by_name(alias->model);
+        if (alias_oc != oc) {
+            continue;
+        }
+        (*s->cpu_fprintf)(s->file, "s390 %-10s (alias for %s)\n",
+                          alias->name, name);
+    }
+
+    g_free(name);
+}
+
+/* copy cpu class properties to another cpu class */
+void s390_update_cpu_class_properties(S390CPUClass *dst, S390CPUClass *src)
+{
+    if (!dst || !src->is_active) {
+        return;
+    }
+    dst->is_active = src->is_active;
+    dst->is_host = src->is_host;
+    memcpy(dst->fac_list, src->fac_list,
+           S390_FAC_LIST_SIZE_BYTE);
+    dst->mach->order = src->mach->order;
+    dst->mach->class = src->mach->class;
+    dst->mach->ga = src->mach->ga;
+    dst->proc->ver = src->proc->ver;
+    dst->proc->id = src->proc->id;
+    dst->proc->type = src->proc->type;
+    dst->proc->ibc = src->proc->ibc;
+    dst->proc->gen = src->proc->gen;
+    memcpy(dst->proc->fac_list, src->proc->fac_list,
+           S390_FAC_LIST_SIZE_BYTE);
+}
diff --git a/target-s390x/cpu-models.h b/target-s390x/cpu-models.h
index 3533c96..cc917d4 100644
--- a/target-s390x/cpu-models.h
+++ b/target-s390x/cpu-models.h
@@ -37,12 +37,27 @@
 #define FAC_BIT(WORD, BIT) \
     (BIT / 64 == WORD ? 1ull << (63 - BIT % 64) : 0)
 
+/* first s390 CMOS generation supporting IBC */
+#define S390_CMOS_G10 0xa
+
 #define cpu_type(x)       (((x) >>  0) & 0xffff)
 #define cpu_order(x)      (((x) >> 16) & 0xffff)
 #define cpu_ga(x)         (((x) >> 16) & 0xf)
 #define cpu_class(x)      (((x) >> 20) & 0x3)
 #define cpu_generation(x) (((x) >> 24) & 0xff)
 
+#define cpuid_type(x)     (((x) >> 16) & 0xffff)
+#define cpuid_id(x)       (((x) >> 32) & 0xffffff)
+#define cpuid_ver(x)      (((x) >> 56) & 0xff)
+
+#define type_cpuid(x)     ((uint64_t)((x) & 0xffff) << 16)
+#define id_cpuid(x)       ((uint64_t)((x) & 0xffffff) << 32)
+#define ver_cpuid(x)      ((uint64_t)((x) & 0xff) << 56)
+
+#define lowest_ibc(x) (((x) >> 16) & 0xfff)
+#define latest_ibc(x) ((x) & 0xfff)
+#define has_ibc(x)    (lowest_ibc(x) != 0x0)
+
 ObjectClass *s390_cpu_class_by_name(const char *name);
 int set_s390_cpu_alias(const char *name, const char *model);
 
@@ -71,10 +86,20 @@ typedef struct S390MachineProps {
     uint64_t soft_fac_list[S390_ARCH_FAC_LIST_SIZE_UINT64];
 } S390MachineProps;
 
+/* indicates the cpu classes have been successfully updated */
+extern bool s390_cpu_classes_prepared;
+
+/* indicates use of soft facilities is requested */
+extern bool s390_use_sofl;
+
 int kvm_s390_has_cpu_model_call(uint64_t attr);
 int kvm_s390_get_processor_props(S390ProcessorProps *prob);
 int kvm_s390_set_processor_props(S390ProcessorProps *prob);
 int kvm_s390_get_machine_props(S390MachineProps *prob);
+int s390_setup_cpu_classes(S390MachineProps *prop);
+gint s390_cpu_class_asc_order_compare(gconstpointer a, gconstpointer b);
+void s390_cpu_list_entry(gpointer data, gpointer user_data);
+void s390_update_cpu_class_properties(S390CPUClass *dst, S390CPUClass *src);
 
 /*
  * bits 0-7   : CMOS generation
diff --git a/target-s390x/cpu.c b/target-s390x/cpu.c
index 5e292e7..741f3ce 100644
--- a/target-s390x/cpu.c
+++ b/target-s390x/cpu.c
@@ -41,7 +41,31 @@
 void s390_cpu_list(FILE *f, fprintf_function cpu_fprintf)
 {
 #ifdef CONFIG_KVM
-    (*cpu_fprintf)(f, "s390 %16s\n", "host");
+    CPUListState s = {
+        .file = f,
+        .cpu_fprintf = cpu_fprintf,
+    };
+    GSList *list;
+
+    if (kvm_enabled()) {
+        list = object_class_get_list(TYPE_S390_CPU, false);
+        list = g_slist_sort(list, s390_cpu_class_asc_order_compare);
+        g_slist_foreach(list, s390_cpu_list_entry, &s);
+        g_slist_free(list);
+    } else {
+#endif
+        (*cpu_fprintf)(f, "s390 host\n");
+#ifdef CONFIG_KVM
+    }
+#endif
+}
+
+bool s390_cpudesc_ready(void)
+{
+#ifdef CONFIG_KVM
+    return s390_cpu_classes_prepared;
+#else
+    return true;
 #endif
 }
 
diff --git a/target-s390x/cpu.h b/target-s390x/cpu.h
index aad277a..7c1c431 100644
--- a/target-s390x/cpu.h
+++ b/target-s390x/cpu.h
@@ -519,6 +519,9 @@ static inline bool css_present(uint8_t cssid)
 void s390_cpu_list(FILE *f, fprintf_function cpu_fprintf);
 #define cpu_list s390_cpu_list
 
+bool s390_cpudesc_ready(void);
+#define cpudesc_ready s390_cpudesc_ready
+
 #include "exec/exec-all.h"
 
 #define EXCP_EXT 1 /* external interrupt */
-- 
1.8.3.1

