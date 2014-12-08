Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaLHDDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:03:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41298 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbaLHDDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:03:52 -0500
From: Shaohua Li <shli@fb.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <kernel-team@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/3] X86: make VDSO data support multiple pages
Date: Sun, 7 Dec 2014 19:03:46 -0800
Message-ID: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
X-Mailer: git-send-email 1.8.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-07_02:2014-12-05,2014-12-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=502.112
 compositescore=0.986137415400633 urlsuspect_oldscore=0.986137415400633
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412080033
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vdso data is one page. Next patches will add per-cpu data to
vdso, which requires several pages if CPU number is big. This makes VDSO
data support multiple pages.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 arch/x86/include/asm/vvar.h     | 6 +++++-
 arch/x86/kernel/asm-offsets.c   | 5 +++++
 arch/x86/kernel/vmlinux.lds.S   | 4 +---
 arch/x86/vdso/vdso-layout.lds.S | 5 +++--
 arch/x86/vdso/vma.c             | 3 ++-
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 5d2b9ad..fcbe621 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -47,7 +47,11 @@ extern char __vvar_page;
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
 DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
-
+/*
+ * you must update VVAR_TOTAL_SIZE to reflect all of the variables we're
+ * stuffing into the vvar area.  Don't change any of the above without
+ * also changing this math of VVAR_TOTAL_SIZE
+ */
 #undef DECLARE_VVAR
 
 #endif
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 9f6b934..0ab31a9 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -16,6 +16,7 @@
 #include <asm/sigframe.h>
 #include <asm/bootparam.h>
 #include <asm/suspend.h>
+#include <asm/vgtod.h>
 
 #ifdef CONFIG_XEN
 #include <xen/interface/xen.h>
@@ -71,4 +72,8 @@ void common(void) {
 
 	BLANK();
 	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
+
+	BLANK();
+	DEFINE(VVAR_TOTAL_SIZE,
+		ALIGN(128 + sizeof(struct vsyscall_gtod_data), PAGE_SIZE));
 }
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 49edf2d..8b11307 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -168,11 +168,9 @@ SECTIONS
 		 * Pad the rest of the page with zeros.  Otherwise the loader
 		 * can leave garbage here.
 		 */
-		. = __vvar_beginning_hack + PAGE_SIZE;
+		. = __vvar_beginning_hack + VVAR_TOTAL_SIZE;
 	} :data
 
-       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
-
 	/* Init code and data - will be freed after init */
 	. = ALIGN(PAGE_SIZE);
 	.init.begin : AT(ADDR(.init.begin) - LOAD_OFFSET) {
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index de2c921..acaf8ce 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -1,4 +1,5 @@
 #include <asm/vdso.h>
+#include <asm/asm-offsets.h>
 
 /*
  * Linker script for vDSO.  This is an ELF shared object prelinked to
@@ -25,7 +26,7 @@ SECTIONS
 	 * segment.
 	 */
 
-	vvar_start = . - 2 * PAGE_SIZE;
+	vvar_start = . - (VVAR_TOTAL_SIZE + PAGE_SIZE);
 	vvar_page = vvar_start;
 
 	/* Place all vvars at the offsets in asm/vvar.h. */
@@ -35,7 +36,7 @@ SECTIONS
 #undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
-	hpet_page = vvar_start + PAGE_SIZE;
+	hpet_page = vvar_start + VVAR_TOTAL_SIZE;
 
 	. = SIZEOF_HEADERS;
 
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 970463b..fc37067 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -16,6 +16,7 @@
 #include <asm/vdso.h>
 #include <asm/page.h>
 #include <asm/hpet.h>
+#include <asm/asm-offsets.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
@@ -150,7 +151,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 		ret = remap_pfn_range(vma,
 				      text_start + image->sym_vvar_page,
 				      __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
-				      PAGE_SIZE,
+				      VVAR_TOTAL_SIZE,
 				      PAGE_READONLY);
 
 	if (ret)
-- 
1.8.1

