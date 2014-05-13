Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbaEMPD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:03:27 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49842 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbaEMPAd (ORCPT
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
Subject: [PATCH v1 RFC 08/10] QEMU: s390: cpu model QMP query-cpu-definitions
Date: Tue, 13 May 2014 17:00:20 +0200
Message-Id: <1399993222-16339-9-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-1948-0000-0000-000008C5B97A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the QMP command "query-cpu-definitions" in the S390
context. The command returns a descending sorted list of cpu model names
derived from the currently (in the current host context) supported set of
cpu classes. That means a consumer can successfully request each reported
cpu model. Implicitly, the first reported cpu model is the host cpu model.

request: {"execute": "query-cpu-definitions"}
answer:  {"return":  [{"name": "2827-ga1"}, {"name": "2818-ga1"}, {"name": "2817-ga2"},
{"name": "2817-ga1"}, {"name": "2098-ga2"}, {"name": "2098-ga1"}, {"name": "2097-ga3"},
{"name": "2097-ga2"}, {"name": "2097-ga1"}, {"name": "2096-ga2"}, {"name": "2096-ga1"},
{"name": "2094-ga3"}, {"name": "2094-ga2"}, {"name": "2094-ga1"}, {"name": "2086-ga3"},
{"name": "2086-ga2"}, {"name": "2086-ga1"}, {"name": "2084-ga5"}, {"name": "2084-ga4"},
{"name": "2084-ga3"}, {"name": "2084-ga2"}, {"name": "2084-ga1"}, {"name": "2068-ga1"},
{"name": "2064-ga3"}, {"name": "2064-ga2"}, {"name": "2064-ga1"}]}

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 target-s390x/cpu-models.c | 16 ++++++++
 target-s390x/cpu-models.h |  3 ++
 target-s390x/cpu.c        | 96 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/target-s390x/cpu-models.c b/target-s390x/cpu-models.c
index 19bbb30..ed087cb 100644
--- a/target-s390x/cpu-models.c
+++ b/target-s390x/cpu-models.c
@@ -123,6 +123,7 @@ typedef struct ArgTG {
 GSList *s390_cpu_aliases;
 bool s390_cpu_classes_prepared;
 bool s390_use_sofl;
+bool s390_cpu_model_mode;
 
 static inline unsigned long bit_in_word(unsigned int nr)
 {
@@ -218,6 +219,21 @@ int set_s390_cpu_alias(const char *name, const char *model)
     return 0;
 }
 
+/* compare order of two cpu classes for descending sort */
+gint s390_cpu_class_desc_order_compare(gconstpointer a, gconstpointer b)
+{
+    S390CPUClass *cc_a = S390_CPU_CLASS((ObjectClass *) a);
+    S390CPUClass *cc_b = S390_CPU_CLASS((ObjectClass *) b);
+
+    if (cc_a->mach->order < cc_b->mach->order) {
+        return 1;
+    }
+    if (cc_a->mach->order > cc_b->mach->order) {
+        return -1;
+    }
+    return 0;
+}
+
 /* return machine class for specific machine type */
 static void s390_machine_class_test_cpu_class(gpointer data, gpointer user_data)
 {
diff --git a/target-s390x/cpu-models.h b/target-s390x/cpu-models.h
index cc917d4..c2675cb 100644
--- a/target-s390x/cpu-models.h
+++ b/target-s390x/cpu-models.h
@@ -88,6 +88,8 @@ typedef struct S390MachineProps {
 
 /* indicates the cpu classes have been successfully updated */
 extern bool s390_cpu_classes_prepared;
+/* indicates qemu is running without cpu models */
+extern bool s390_cpu_model_mode;
 
 /* indicates use of soft facilities is requested */
 extern bool s390_use_sofl;
@@ -100,6 +102,7 @@ int s390_setup_cpu_classes(S390MachineProps *prop);
 gint s390_cpu_class_asc_order_compare(gconstpointer a, gconstpointer b);
 void s390_cpu_list_entry(gpointer data, gpointer user_data);
 void s390_update_cpu_class_properties(S390CPUClass *dst, S390CPUClass *src);
+gint s390_cpu_class_desc_order_compare(gconstpointer a, gconstpointer b);
 
 /*
  * bits 0-7   : CMOS generation
diff --git a/target-s390x/cpu.c b/target-s390x/cpu.c
index 741f3ce..6479659 100644
--- a/target-s390x/cpu.c
+++ b/target-s390x/cpu.c
@@ -37,6 +37,13 @@
 #define CR0_RESET       0xE0UL
 #define CR14_RESET      0xC2000000UL;
 
+#ifdef CONFIG_KVM
+typedef struct CpuDefinition {
+    CpuDefinitionInfoList *head;
+    CpuDefinitionInfoList *tail;
+} CpuDefinition;
+#endif
+
 /* generate CPU information for cpu -? */
 void s390_cpu_list(FILE *f, fprintf_function cpu_fprintf)
 {
@@ -70,18 +77,99 @@ bool s390_cpudesc_ready(void)
 }
 
 #ifndef CONFIG_USER_ONLY
+#ifdef CONFIG_KVM
+static void s390_query_cpu_definition(gpointer data, gpointer user_data)
+{
+    S390CPUClass *cc = S390_CPU_CLASS((ObjectClass *) data);
+    char model[16];
+    CpuDefinition *cpu_definition = user_data;
+    CpuDefinitionInfo *info;
+    CpuDefinitionInfoList *entry;
+
+    if (!cc->is_active) {
+        return;
+    }
+
+    info = g_try_malloc0(sizeof(*info));
+    if (!info) {
+        goto out_info;
+    }
+
+    snprintf(model, sizeof(model), "%04x-ga%u", cc->proc->type, cc->mach->ga);
+    info->name = g_strdup(model);
+    if (!info->name) {
+        goto out_name;
+    }
+
+    entry = g_try_malloc0(sizeof(*entry));
+    if (!entry) {
+        goto out_entry;
+    }
+    entry->value = info;
+    entry->next = NULL;
+
+    if (cpu_definition->tail) {
+        cpu_definition->tail->next = entry;
+        cpu_definition->tail = cpu_definition->tail->next;
+    } else {
+        cpu_definition->head = cpu_definition->tail = entry;
+    }
+    return;
+
+out_entry:
+    g_free(info->name);
+out_name:
+    g_free(info);
+out_info:
+    return;
+}
+#endif
+
 CpuDefinitionInfoList *arch_query_cpu_definitions(Error **errp)
 {
     CpuDefinitionInfoList *entry;
     CpuDefinitionInfo *info;
 
-    info = g_malloc0(sizeof(*info));
-    info->name = g_strdup("host");
+#ifdef CONFIG_KVM
+    GSList *list;
+    CpuDefinition cpu_definition;
 
-    entry = g_malloc0(sizeof(*entry));
-    entry->value = info;
+    /* There are no valid cpu classes defined in this case. */
+    if (!s390_cpu_model_mode) {
+        return NULL;
+    }
 
+    list = object_class_get_list(TYPE_S390_CPU, false);
+    list = g_slist_sort(list, s390_cpu_class_desc_order_compare);
+    cpu_definition.head = NULL;
+    cpu_definition.tail = NULL;
+    g_slist_foreach(list, s390_query_cpu_definition, &cpu_definition);
+    g_slist_free(list);
+
+    return cpu_definition.head;
+#endif
+
+    info = g_try_malloc0(sizeof(*info));
+    if (!info) {
+        goto out_info;
+    }
+    info->name = g_strdup("host");
+    if (!info->name) {
+        goto out_name;
+    }
+    entry = g_try_malloc0(sizeof(*entry));
+    if (!entry) {
+        goto out_entry;
+    }
+    entry->value = info;
     return entry;
+
+out_entry:
+    g_free(info->name);
+out_name:
+    g_free(info);
+out_info:
+    return NULL;
 }
 #endif
 
-- 
1.8.3.1

