Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaGLAWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:22:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaGLAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:22:01 -0400
Date: Fri, 11 Jul 2014 17:21:36 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-e6577a7ce99a506b587bcd1d2cd803cb45119557@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <156c78c0d93144ff1055a66493783b9e56813983.1405040914.git.luto@amacapital.net>
References: <156c78c0d93144ff1055a66493783b9e56813983.1405040914.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Move the vvar area before the vdso text
Git-Commit-ID: e6577a7ce99a506b587bcd1d2cd803cb45119557
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6577a7ce99a506b587bcd1d2cd803cb45119557
Gitweb:     http://git.kernel.org/tip/e6577a7ce99a506b587bcd1d2cd803cb45119557
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 10 Jul 2014 18:13:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 11 Jul 2014 16:57:51 -0700

x86, vdso: Move the vvar area before the vdso text

Putting the vvar area after the vdso text is rather complicated: it
only works of the total length of the vdso text mapping is known at
vdso link time, and the linker doesn't allow symbol addresses to
depend on the sizes of non-allocatable data after the PT_LOAD
segment.

Moving the vvar area before the vdso text will allow is to safely
map non-allocatable data after the vdso text, which is a nice
simplification.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/156c78c0d93144ff1055a66493783b9e56813983.1405040914.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/vdso.h     | 18 ++++++++---------
 arch/x86/vdso/vdso-layout.lds.S | 44 ++++++++++++++++++-----------------------
 arch/x86/vdso/vdso2c.c          | 12 ++++++-----
 arch/x86/vdso/vdso2c.h          | 25 ++++++++++++++---------
 arch/x86/vdso/vma.c             | 20 ++++++++++---------
 5 files changed, 62 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 30be253..8021bd2 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -18,15 +18,15 @@ struct vdso_image {
 
 	unsigned long alt, alt_len;
 
-	unsigned long sym_end_mapping;  /* Total size of the mapping */
-
-	unsigned long sym_vvar_page;
-	unsigned long sym_hpet_page;
-	unsigned long sym_VDSO32_NOTE_MASK;
-	unsigned long sym___kernel_sigreturn;
-	unsigned long sym___kernel_rt_sigreturn;
-	unsigned long sym___kernel_vsyscall;
-	unsigned long sym_VDSO32_SYSENTER_RETURN;
+	long sym_vvar_start;  /* Negative offset to the vvar area */
+
+	long sym_vvar_page;
+	long sym_hpet_page;
+	long sym_VDSO32_NOTE_MASK;
+	long sym___kernel_sigreturn;
+	long sym___kernel_rt_sigreturn;
+	long sym___kernel_vsyscall;
+	long sym_VDSO32_SYSENTER_RETURN;
 };
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 9197544..de2c921 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -18,6 +18,25 @@
 
 SECTIONS
 {
+	/*
+	 * User/kernel shared data is before the vDSO.  This may be a little
+	 * uglier than putting it after the vDSO, but it avoids issues with
+	 * non-allocatable things that dangle past the end of the PT_LOAD
+	 * segment.
+	 */
+
+	vvar_start = . - 2 * PAGE_SIZE;
+	vvar_page = vvar_start;
+
+	/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+
+	hpet_page = vvar_start + PAGE_SIZE;
+
 	. = SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
@@ -74,31 +93,6 @@ SECTIONS
 	.altinstructions	: { *(.altinstructions) }	:text
 	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
 
-	/*
-	 * The remainder of the vDSO consists of special pages that are
-	 * shared between the kernel and userspace.  It needs to be at the
-	 * end so that it doesn't overlap the mapping of the actual
-	 * vDSO image.
-	 */
-
-	. = ALIGN(PAGE_SIZE);
-	vvar_page = .;
-
-	/* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
-#undef EMIT_VVAR
-
-	. = vvar_page + PAGE_SIZE;
-
-	hpet_page = .;
-	. = . + PAGE_SIZE;
-
-	. = ALIGN(PAGE_SIZE);
-	end_mapping = .;
-
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 238dbe82..22c54d0 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -20,9 +20,9 @@ const char *outfilename;
 
 /* Symbols that we need in vdso2c. */
 enum {
+	sym_vvar_start,
 	sym_vvar_page,
 	sym_hpet_page,
-	sym_end_mapping,
 	sym_VDSO_FAKE_SECTION_TABLE_START,
 	sym_VDSO_FAKE_SECTION_TABLE_END,
 };
@@ -38,9 +38,9 @@ struct vdso_sym {
 };
 
 struct vdso_sym required_syms[] = {
+	[sym_vvar_start] = {"vvar_start", true},
 	[sym_vvar_page] = {"vvar_page", true},
 	[sym_hpet_page] = {"hpet_page", true},
-	[sym_end_mapping] = {"end_mapping", true},
 	[sym_VDSO_FAKE_SECTION_TABLE_START] = {
 		"VDSO_FAKE_SECTION_TABLE_START", false
 	},
@@ -96,9 +96,11 @@ extern void bad_put_le(void);
 
 #define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
 
-#define BITSFUNC3(name, bits) name##bits
-#define BITSFUNC2(name, bits) BITSFUNC3(name, bits)
-#define BITSFUNC(name) BITSFUNC2(name, ELF_BITS)
+#define BITSFUNC3(name, bits, suffix) name##bits##suffix
+#define BITSFUNC2(name, bits, suffix) BITSFUNC3(name, bits, suffix)
+#define BITSFUNC(name) BITSFUNC2(name, ELF_BITS, )
+
+#define INT_BITS BITSFUNC2(int, ELF_BITS, _t)
 
 #define ELF_BITS_XFORM2(bits, x) Elf##bits##_##x
 #define ELF_BITS_XFORM(bits, x) ELF_BITS_XFORM2(bits, x)
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 11b65d4..2da32fbc 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -132,7 +132,7 @@ static void BITSFUNC(go)(void *addr, size_t len,
 		*alt_sec = NULL;
 	ELF(Dyn) *dyn = 0, *dyn_end = 0;
 	const char *secstrings;
-	uint64_t syms[NSYMS] = {};
+	INT_BITS syms[NSYMS] = {};
 
 	struct BITSFUNC(fake_sections) fake_sections = {};
 
@@ -209,6 +209,13 @@ static void BITSFUNC(go)(void *addr, size_t len,
 					fail("duplicate symbol %s\n",
 					     required_syms[k].name);
 				}
+
+				/*
+				 * Careful: we use negative addresses, but
+				 * st_value is unsigned, so we rely
+				 * on syms[k] being a signed type of the
+				 * correct width.
+				 */
 				syms[k] = GET_LE(&sym->st_value);
 			}
 		}
@@ -263,15 +270,15 @@ static void BITSFUNC(go)(void *addr, size_t len,
 		if (syms[i] % 4096)
 			fail("%s must be a multiple of 4096\n",
 			     required_syms[i].name);
-		if (syms[i] < data_size)
-			fail("%s must be after the text mapping\n",
+		if (syms[sym_vvar_start] > syms[i] + 4096)
+			fail("%s underruns begin_vvar\n",
 			     required_syms[i].name);
-		if (syms[sym_end_mapping] < syms[i] + 4096)
-			fail("%s overruns end_mapping\n",
+		if (syms[i] + 4096 > 0)
+			fail("%s is on the wrong side of the vdso text\n",
 			     required_syms[i].name);
 	}
-	if (syms[sym_end_mapping] % 4096)
-		fail("end_mapping must be a multiple of 4096\n");
+	if (syms[sym_vvar_start] % 4096)
+		fail("vvar_begin must be a multiple of 4096\n");
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
@@ -311,8 +318,8 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	}
 	for (i = 0; i < NSYMS; i++) {
 		if (required_syms[i].export && syms[i])
-			fprintf(outfile, "\t.sym_%s = 0x%" PRIx64 ",\n",
-				required_syms[i].name, syms[i]);
+			fprintf(outfile, "\t.sym_%s = %" PRIi64 ",\n",
+				required_syms[i].name, (int64_t)syms[i]);
 	}
 	fprintf(outfile, "};\n");
 }
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 5a5176d..dbef622 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -93,7 +93,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long addr;
+	unsigned long addr, text_start;
 	int ret = 0;
 	static struct page *no_pages[] = {NULL};
 	static struct vm_special_mapping vvar_mapping = {
@@ -103,26 +103,28 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 
 	if (calculate_addr) {
 		addr = vdso_addr(current->mm->start_stack,
-				 image->sym_end_mapping);
+				 image->size - image->sym_vvar_start);
 	} else {
 		addr = 0;
 	}
 
 	down_write(&mm->mmap_sem);
 
-	addr = get_unmapped_area(NULL, addr, image->sym_end_mapping, 0, 0);
+	addr = get_unmapped_area(NULL, addr,
+				 image->size - image->sym_vvar_start, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 
-	current->mm->context.vdso = (void __user *)addr;
+	text_start = addr - image->sym_vvar_start;
+	current->mm->context.vdso = (void __user *)text_start;
 
 	/*
 	 * MAYWRITE to allow gdb to COW and set breakpoints
 	 */
 	vma = _install_special_mapping(mm,
-				       addr,
+				       text_start,
 				       image->size,
 				       VM_READ|VM_EXEC|
 				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
@@ -134,8 +136,8 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 	}
 
 	vma = _install_special_mapping(mm,
-				       addr + image->size,
-				       image->sym_end_mapping - image->size,
+				       addr,
+				       -image->sym_vvar_start,
 				       VM_READ,
 				       &vvar_mapping);
 
@@ -146,7 +148,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 
 	if (image->sym_vvar_page)
 		ret = remap_pfn_range(vma,
-				      addr + image->sym_vvar_page,
+				      text_start + image->sym_vvar_page,
 				      __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
 				      PAGE_SIZE,
 				      PAGE_READONLY);
@@ -157,7 +159,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 #ifdef CONFIG_HPET_TIMER
 	if (hpet_address && image->sym_hpet_page) {
 		ret = io_remap_pfn_range(vma,
-			addr + image->sym_hpet_page,
+			text_start + image->sym_hpet_page,
 			hpet_address >> PAGE_SHIFT,
 			PAGE_SIZE,
 			pgprot_noncached(PAGE_READONLY));
