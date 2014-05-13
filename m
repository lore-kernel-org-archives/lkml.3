Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbaEMPDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:03:30 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:51762 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169AbaEMPAb (ORCPT
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
Subject: [PATCH v1 RFC 04/10] QEMU: s390: cpu model alias support
Date: Tue, 13 May 2014 17:00:16 +0200
Message-Id: <1399993222-16339-5-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-0342-0000-0000-000008BF6CDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the infrastructure to dynamically add cpu model aliases.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 target-s390x/cpu-models.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++
 target-s390x/cpu-models.h | 12 +++++++++
 2 files changed, 76 insertions(+)

diff --git a/target-s390x/cpu-models.c b/target-s390x/cpu-models.c
index e437bd0..25147a4 100644
--- a/target-s390x/cpu-models.c
+++ b/target-s390x/cpu-models.c
@@ -86,6 +86,9 @@ S390_PROC_DEF("2827-ga1", CPU_S390_2827_GA1, "IBM zEnterprise EC12 GA1")
 S390_PROC_DEF("2827-ga2", CPU_S390_2827_GA2, "IBM zEnterprise EC12 GA2")
 S390_PROC_DEF("2828-ga1", CPU_S390_2828_GA1, "IBM zEnterprise BC12 GA1")
 
+/* S390 CPU aliases can be added dynamically to this list */
+GSList *s390_cpu_aliases;
+
 static inline unsigned long bit_in_word(unsigned int nr)
 {
     return 1ul << (__WORDSIZE - 1 - (nr % __WORDSIZE));
@@ -103,3 +106,64 @@ static inline int test_facility(unsigned long nr, unsigned long *fac_list)
 
     return (*ptr & bit_in_word(nr)) != 0;
 }
+
+static gint s390_cpu_compare_class_name(gconstpointer a, gconstpointer b)
+{
+    ObjectClass *oc = (ObjectClass *)a;
+    const char *name = b;
+
+    if (strncasecmp(name, object_class_get_name(oc), strlen(name)) == 0 &&
+        strcmp(object_class_get_name(oc) + strlen(name),
+               "-" TYPE_S390_CPU) == 0) {
+        return 0;
+    }
+
+    return -1;
+}
+
+ObjectClass *s390_cpu_class_by_name(const char *name)
+{
+    GSList *list, *item;
+    ObjectClass *ret = NULL;
+    S390CPUAlias *alias;
+
+    for (item = s390_cpu_aliases; item != NULL; item = item->next) {
+        alias = (S390CPUAlias *) item->data;
+        if (strcmp(alias->name, name) == 0) {
+            return s390_cpu_class_by_name(alias->model);
+        }
+    }
+    list = object_class_get_list(TYPE_S390_CPU, false);
+    item = g_slist_find_custom(list, name, s390_cpu_compare_class_name);
+    if (item) {
+        ret = OBJECT_CLASS(item->data);
+    }
+    g_slist_free(list);
+
+    return ret;
+}
+
+/* define a new s390 cpu alias */
+int set_s390_cpu_alias(const char *name, const char *model)
+{
+    S390CPUAlias *alias;
+
+    if (!name || !model) {
+        return -EINVAL;
+    }
+    if (!g_strcmp0(name, model)) {
+        return -EINVAL;
+    }
+    if (!s390_cpu_class_by_name(model)) {
+        return -EINVAL;
+    }
+    alias = g_try_malloc0(sizeof(S390CPUAlias));
+    if (!alias) {
+        return -ENOMEM;
+    }
+    alias->name = g_strdup(name);
+    alias->model = g_strdup(model);
+    s390_cpu_aliases = g_slist_append(s390_cpu_aliases, alias);
+
+    return 0;
+}
diff --git a/target-s390x/cpu-models.h b/target-s390x/cpu-models.h
index 6f9a1a1..f5c8112 100644
--- a/target-s390x/cpu-models.h
+++ b/target-s390x/cpu-models.h
@@ -43,6 +43,18 @@
 #define cpu_class(x)      (((x) >> 20) & 0x3)
 #define cpu_generation(x) (((x) >> 24) & 0xff)
 
+ObjectClass *s390_cpu_class_by_name(const char *name);
+int set_s390_cpu_alias(const char *name, const char *model);
+
+/*
+ * S390 cpu aliases will be added dynamically
+ */
+typedef struct S390CPUAlias {
+    char *name;
+    char *model;
+} S390CPUAlias;
+extern GSList *s390_cpu_aliases;
+
 /*
  * bits 0-7   : CMOS generation
  * bits 8-9   : reserved
-- 
1.8.3.1

