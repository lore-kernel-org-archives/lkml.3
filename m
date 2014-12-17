Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaLQXMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:12:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43566 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbaLQXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:12:33 -0500
From: Shaohua Li <shli@fb.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <Kernel-team@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 1/3] X86: make VDSO data support multiple pages
Date: Wed, 17 Dec 2014 15:12:24 -0800
Message-ID: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
X-Mailer: git-send-email 1.8.1
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

Currently vdso data is one page. Next patches will add per-cpu data to
vdso, which requires several pages if CPU number is big. This makes VDSO
data support multiple pages.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 arch/x86/include/asm/vdso.h     | 2 +-
 arch/x86/include/asm/vvar.h     | 8 ++++++--
 arch/x86/kernel/asm-offsets.c   | 5 +++++
 arch/x86/kernel/vmlinux.lds.S   | 6 +++---
 arch/x86/tools/relocs.c         | 2 +-
 arch/x86/vdso/vdso-layout.lds.S | 9 +++++----
 arch/x86/vdso/vdso2c.c          | 6 +++---
 arch/x86/vdso/vma.c             | 9 +++++----
 8 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 8021bd2..35ca749 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -20,7 +20,7 @@ struct vdso_image {
 
 	long sym_vvar_start;  /* Negative offset to the vvar area */
 
-	long sym_vvar_page;
+	long sym_vvar_pages;
 	long sym_hpet_page;
 	long sym_VDSO32_NOTE_MASK;
 	long sym___kernel_sigreturn;
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 3f32dfc..62bc6f8 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -29,7 +29,7 @@
 
 #else
 
-extern char __vvar_page;
+extern char __vvar_pages;
 
 #define DECLARE_VVAR(offset, type, name)				\
 	extern type vvar_ ## name __attribute__((visibility("hidden")));
@@ -45,7 +45,11 @@ extern char __vvar_page;
 /* DECLARE_VVAR(offset, type, name) */
 
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
index 00bf300..2efeee9 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -149,7 +149,7 @@ SECTIONS
 
 
 	. = ALIGN(PAGE_SIZE);
-	__vvar_page = .;
+	__vvar_pages = .;
 
 	.vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
 		/* work around gold bug 13023 */
@@ -168,10 +168,10 @@ SECTIONS
 		 * Pad the rest of the page with zeros.  Otherwise the loader
 		 * can leave garbage here.
 		 */
-		. = __vvar_beginning_hack + PAGE_SIZE;
+		. = __vvar_beginning_hack + VVAR_TOTAL_SIZE;
 	} :data
 
-       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
+	. = ALIGN(__vvar_pages + VVAR_TOTAL_SIZE, PAGE_SIZE);
 
 	/* Init code and data - will be freed after init */
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 0c2fae8..ea01c48 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -73,7 +73,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"init_per_cpu__.*|"
 	"__end_rodata_hpage_align|"
 #endif
-	"__vvar_page|"
+	"__vvar_pages|"
 	"_end)$"
 };
 
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index de2c921..413c739 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -1,4 +1,5 @@
 #include <asm/vdso.h>
+#include <asm/asm-offsets.h>
 
 /*
  * Linker script for vDSO.  This is an ELF shared object prelinked to
@@ -25,17 +26,17 @@ SECTIONS
 	 * segment.
 	 */
 
-	vvar_start = . - 2 * PAGE_SIZE;
-	vvar_page = vvar_start;
+	vvar_start = . - (VVAR_TOTAL_SIZE + PAGE_SIZE);
+	vvar_pages = vvar_start;
 
 	/* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
+#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_pages + offset;
 #define __VVAR_KERNEL_LDS
 #include <asm/vvar.h>
 #undef __VVAR_KERNEL_LDS
 #undef EMIT_VVAR
 
-	hpet_page = vvar_start + PAGE_SIZE;
+	hpet_page = vvar_start + VVAR_TOTAL_SIZE;
 
 	. = SIZEOF_HEADERS;
 
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 8627db2..95eda74 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -71,14 +71,14 @@ const char *outfilename;
 /* Symbols that we need in vdso2c. */
 enum {
 	sym_vvar_start,
-	sym_vvar_page,
+	sym_vvar_pages,
 	sym_hpet_page,
 	sym_VDSO_FAKE_SECTION_TABLE_START,
 	sym_VDSO_FAKE_SECTION_TABLE_END,
 };
 
 const int special_pages[] = {
-	sym_vvar_page,
+	sym_vvar_pages,
 	sym_hpet_page,
 };
 
@@ -89,7 +89,7 @@ struct vdso_sym {
 
 struct vdso_sym required_syms[] = {
 	[sym_vvar_start] = {"vvar_start", true},
-	[sym_vvar_page] = {"vvar_page", true},
+	[sym_vvar_pages] = {"vvar_pages", true},
 	[sym_hpet_page] = {"hpet_page", true},
 	[sym_VDSO_FAKE_SECTION_TABLE_START] = {
 		"VDSO_FAKE_SECTION_TABLE_START", false
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 009495b..6496c65 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -19,6 +19,7 @@
 #include <asm/page.h>
 #include <asm/hpet.h>
 #include <asm/desc.h>
+#include <asm/asm-offsets.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
@@ -133,11 +134,11 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 		goto up_fail;
 	}
 
-	if (image->sym_vvar_page)
+	if (image->sym_vvar_pages)
 		ret = remap_pfn_range(vma,
-				      text_start + image->sym_vvar_page,
-				      __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
-				      PAGE_SIZE,
+				      text_start + image->sym_vvar_pages,
+				      __pa_symbol(&__vvar_pages) >> PAGE_SHIFT,
+				      VVAR_TOTAL_SIZE,
 				      PAGE_READONLY);
 
 	if (ret)
-- 
1.8.1

