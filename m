Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaLQXMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:12:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31470 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbaLQXMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:12:30 -0500
From: Shaohua Li <shli@fb.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <Kernel-team@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 2/3] X86: add a generic API to let vdso code detect context switch
Date: Wed, 17 Dec 2014 15:12:25 -0800
Message-ID: <ecaea9066b4b0ff320bc03f23db56a9c2403a6b0.1418857018.git.shli@fb.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_07:2014-12-17,2014-12-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.32559527191256e-11 kscore.compositescore=0
 circleOfTrustscore=502.112 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412170231
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vdso code can't disable preempt, so it can be preempted at any time.
This makes a challenge to implement specific features. This patch adds a
generic API to let vdso code detect context switch.

We can use a context switch count to do the detection. The change of the
count in giving time can be used to detect if context switch occurs.
Andy suggested we can use a timestamp, so in next patch we can save some
intructions. But the principle isn't changed here. This patch uses the
timestamp approach.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 arch/x86/Kconfig              |  4 ++++
 arch/x86/include/asm/vdso.h   | 17 +++++++++++++++++
 arch/x86/include/asm/vvar.h   |  6 ++++++
 arch/x86/kernel/asm-offsets.c |  6 ++++++
 arch/x86/vdso/vma.c           |  1 +
 kernel/sched/core.c           |  5 +++++
 6 files changed, 39 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d69f1cd..e384147 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1943,6 +1943,10 @@ config COMPAT_VDSO
 	  If unsure, say N: if you are compiling your own kernel, you
 	  are unlikely to be using a buggy version of glibc.
 
+config VDSO_CS_DETECT
+	def_bool y
+	depends on X86_64
+
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	---help---
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 35ca749..d4556a3 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -49,6 +49,23 @@ extern const struct vdso_image *selected_vdso32;
 
 extern void __init init_vdso_image(const struct vdso_image *image);
 
+#ifdef CONFIG_VDSO_CS_DETECT
+struct vdso_percpu_data {
+	u64 last_cs_timestamp;
+} ____cacheline_aligned;
+
+struct vdso_data {
+	int dummy;
+	struct vdso_percpu_data vpercpu[0];
+};
+extern struct vdso_data vdso_data;
+
+static inline void vdso_set_cpu_cs_timestamp(int cpu)
+{
+	rdtscll(vdso_data.vpercpu[cpu].last_cs_timestamp);
+}
+#endif
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_X86_VDSO_H */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 62bc6f8..19ac55c 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -45,6 +45,12 @@ extern char __vvar_pages;
 /* DECLARE_VVAR(offset, type, name) */
 
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
+#if defined(CONFIG_VDSO_CS_DETECT) && defined(CONFIG_X86_64)
+/*
+ * this one needs to be last because it ends with a per-cpu array.
+ */
+DECLARE_VVAR(320, struct vdso_data, vdso_data)
+#endif
 /*
  * you must update VVAR_TOTAL_SIZE to reflect all of the variables we're
  * stuffing into the vvar area.  Don't change any of the above without
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 0ab31a9..7321cdc 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -17,6 +17,7 @@
 #include <asm/bootparam.h>
 #include <asm/suspend.h>
 #include <asm/vgtod.h>
+#include <asm/vdso.h>
 
 #ifdef CONFIG_XEN
 #include <xen/interface/xen.h>
@@ -74,6 +75,11 @@ void common(void) {
 	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
 
 	BLANK();
+#ifdef CONFIG_VDSO_CS_DETECT
+	DEFINE(VVAR_TOTAL_SIZE, ALIGN(320 + sizeof(struct vdso_data)
+		+ sizeof(struct vdso_percpu_data) * CONFIG_NR_CPUS, PAGE_SIZE));
+#else
 	DEFINE(VVAR_TOTAL_SIZE,
 		ALIGN(128 + sizeof(struct vsyscall_gtod_data), PAGE_SIZE));
+#endif
 }
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 6496c65..22b1a69 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -23,6 +23,7 @@
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
+DEFINE_VVAR(struct vdso_data, vdso_data);
 #endif
 
 void __init init_vdso_image(const struct vdso_image *image)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5797b7..d8e882d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2232,6 +2232,11 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	struct rq *rq = this_rq();
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
+#ifdef CONFIG_VDSO_CS_DETECT
+	int cpu = smp_processor_id();
+
+	vdso_set_cpu_cs_timestamp(cpu);
+#endif
 
 	rq->prev_mm = NULL;
 
-- 
1.8.1

