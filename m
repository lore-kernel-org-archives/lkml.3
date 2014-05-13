Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbaEMPDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:03:25 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49867 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965057AbaEMPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:35 -0400
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
Subject: [PATCH v1 RFC 09/10] QEMU: s390: cpu model QMP query-cpu-model
Date: Tue, 13 May 2014 17:00:21 +0200
Message-Id: <1399993222-16339-10-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-1948-0000-0000-000008C5B980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a new QMP request named "query-cpu-model". It returns
the cpu model of cpu 0. eg:

request: '{"execute" : "query-cpu-model" }
answer:  '{"return" : {"name": "2827-ga2"}}

Alias names are resolved to their respective machine type and GA names
already during cpu instantiation. Thus, also a cpu name like "host",
which is implemented as alias, will return its normalized cpu model name.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/sysemu/arch_init.h |  1 +
 qapi-schema.json           | 23 +++++++++++++++++++++++
 qmp-commands.hx            |  6 ++++++
 qmp.c                      |  5 +++++
 stubs/Makefile.objs        |  1 +
 stubs/arch-query-cpu-mod.c |  9 +++++++++
 target-s390x/cpu.c         | 42 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 87 insertions(+)
 create mode 100644 stubs/arch-query-cpu-mod.c

diff --git a/include/sysemu/arch_init.h b/include/sysemu/arch_init.h
index cadcedc..dcdb1ed 100644
--- a/include/sysemu/arch_init.h
+++ b/include/sysemu/arch_init.h
@@ -38,5 +38,6 @@ int xen_available(void);
 bool cpudesc_avail(void);
 
 CpuDefinitionInfoList *arch_query_cpu_definitions(Error **errp);
+CpuModelInfo *arch_query_cpu_model(Error **errp);
 
 #endif
diff --git a/qapi-schema.json b/qapi-schema.json
index 36cb964..0a95f7b 100644
--- a/qapi-schema.json
+++ b/qapi-schema.json
@@ -3460,6 +3460,29 @@
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'] }
 
+##
+# @CpuModelInfo:
+#
+# Virtual CPU model definition.
+#
+# @name: the name of the CPU model definition
+#
+# Since: 2.1.0
+##
+{ 'type': 'CpuModelInfo',
+  'data': { 'name': 'str' } }
+
+##
+# @query-cpu-model:
+#
+# Return to current virtual CPU model
+#
+# Returns: CpuModelInfo
+#
+# Since: 2.1.0
+##
+{ 'command': 'query-cpu-model', 'returns': 'CpuModelInfo' }
+
 # @AddfdInfo:
 #
 # Information about a file descriptor that was added to an fd set.
diff --git a/qmp-commands.hx b/qmp-commands.hx
index cae890e..e56d3a9 100644
--- a/qmp-commands.hx
+++ b/qmp-commands.hx
@@ -3247,6 +3247,12 @@ EQMP
     },
 
     {
+        .name       = "query-cpu-model",
+        .args_type  = "",
+        .mhandler.cmd_new = qmp_marshal_input_query_cpu_model,
+    },
+
+    {
         .name       = "query-target",
         .args_type  = "",
         .mhandler.cmd_new = qmp_marshal_input_query_target,
diff --git a/qmp.c b/qmp.c
index a7f432b..1903db1 100644
--- a/qmp.c
+++ b/qmp.c
@@ -486,6 +486,11 @@ CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
     return arch_query_cpu_definitions(errp);
 }
 
+CpuModelInfo *qmp_query_cpu_model(Error **errp)
+{
+    return arch_query_cpu_model(errp);
+}
+
 void qmp_add_client(const char *protocol, const char *fdname,
                     bool has_skipauth, bool skipauth, bool has_tls, bool tls,
                     Error **errp)
diff --git a/stubs/Makefile.objs b/stubs/Makefile.objs
index d99e2b9..f6db116 100644
--- a/stubs/Makefile.objs
+++ b/stubs/Makefile.objs
@@ -1,4 +1,5 @@
 stub-obj-y += arch-query-cpu-def.o
+stub-obj-y += arch-query-cpu-mod.o
 stub-obj-y += clock-warp.o
 stub-obj-y += cpu-get-clock.o
 stub-obj-y += cpu-get-icount.o
diff --git a/stubs/arch-query-cpu-mod.c b/stubs/arch-query-cpu-mod.c
new file mode 100644
index 0000000..90ebd08
--- /dev/null
+++ b/stubs/arch-query-cpu-mod.c
@@ -0,0 +1,9 @@
+#include "qemu-common.h"
+#include "sysemu/arch_init.h"
+#include "qapi/qmp/qerror.h"
+
+CpuModelInfo *arch_query_cpu_model(Error **errp)
+{
+    error_set(errp, QERR_UNSUPPORTED);
+    return NULL;
+}
diff --git a/target-s390x/cpu.c b/target-s390x/cpu.c
index 6479659..132b468 100644
--- a/target-s390x/cpu.c
+++ b/target-s390x/cpu.c
@@ -37,6 +37,8 @@
 #define CR0_RESET       0xE0UL
 #define CR14_RESET      0xC2000000UL;
 
+#define CPU_MODEL_NAME_LEN 32
+
 #ifdef CONFIG_KVM
 typedef struct CpuDefinition {
     CpuDefinitionInfoList *head;
@@ -171,6 +173,46 @@ out_name:
 out_info:
     return NULL;
 }
+
+CpuModelInfo *arch_query_cpu_model(Error **errp)
+{
+    CpuModelInfo *cpu_model;
+    S390CPUClass *cc;
+    S390CPU *cpu;
+
+    cpu = s390_cpu_addr2state(0);
+    if (!cpu) {
+        goto out_no_cpu;
+    }
+    cc = S390_CPU_GET_CLASS(cpu);
+    if (!cc) {
+        goto out_no_cpu;
+    }
+    if (!cc->proc->type) {
+        goto out_no_cpu;
+    }
+    cpu_model = g_try_malloc0(sizeof(*cpu_model));
+    if (!cpu_model) {
+        goto out_no_mem;
+    }
+    cpu_model->name = g_try_malloc0(CPU_MODEL_NAME_LEN);
+    if (!cpu_model->name) {
+        goto out_no_mem;
+    }
+    snprintf(cpu_model->name, CPU_MODEL_NAME_LEN - 1, "%04x-ga%u",
+             cc->proc->type, cc->mach->ga);
+    if (s390_use_sofl) {
+        strncat(cpu_model->name, ",+sofl", CPU_MODEL_NAME_LEN - 1);
+    }
+    return cpu_model;
+
+out_no_mem:
+    if (cpu_model) {
+        g_free(cpu_model);
+    }
+out_no_cpu:
+    return NULL;
+}
 #endif
 
 static void s390_cpu_set_pc(CPUState *cs, vaddr value)
-- 
1.8.3.1

