Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3EaAk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:40:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52316 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3EaAkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:40:21 -0400
Date: Thu, 30 May 2013 17:39:38 -0700
Message-Id: <201305310039.r4V0dcoN027958@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.10-rc4
Cc: Christian Koenig <christian.koenig@amd.com>, <stable@vger.kernel.org>,
        Alexander Boyko <alexander_boyko@xyratex.com>,
        Andy Whitcroft <apw@canonical.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jan Beulich <jbeulich@suse.com>, Jeremy Kerr <jk@ozlabs.org>,
        Josh Boyer <jwboyer@redhat.com>, Lee@zytor.com,
        Chun-Yi <jlee@suse.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Pekka Riikonen <priikone@iki.fi>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the queue of pending x86 fixes.

3 are EFI-related;
2 are related to early memory initialization;
1 is a build fix for older binutils;
1 is a fix for an eager FPU performance regression -- currently we
  don't allow the use of the FPU at interrupt time *at all* in eager
  mode, which is clearly wrong.  This is the one potentially
  controversial patch in this set as it is a performance regression,
  not a correctness regression, and falls in an area that has,
  obviously, been highly problematic in the past.  If you prefer to
  skip it it is the topmost patch in the set.

The following changes since commit 8f710dd34a46500e135203816c71c3ec567c46fd:

  Merge tag 'sound-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2013-05-17 07:17:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 5187b28ff08249ab8a162e802209ed04e271ca02:

  x86: Allow FPU to be used at interrupt time even with eagerfpu (2013-05-30 16:36:42 -0700)

----------------------------------------------------------------
H. Peter Anvin (1):
      Merge tag 'efi-urgent' into x86/urgent

Jan Beulich (1):
      x86, crc32-pclmul: Fix build with older binutils

Lee, Chun-Yi (1):
      x86, efi: initial the local variable of DataSize to zero

Lingzhu Xiang (1):
      efivarfs: Never return ENOENT from firmware again

Pekka Riikonen (1):
      x86: Allow FPU to be used at interrupt time even with eagerfpu

Seiji Aguchi (1):
      efivar: fix oops in efivar_update_sysfs_entries() caused by memory reuse

Yinghai Lu (1):
      x86, range: fix missing merge during add range

Zhang Yanfei (1):
      x86-64, init: Fix a possible wraparound bug in switchover in head_64.S

 arch/x86/crypto/crc32-pclmul_asm.S |  2 +-
 arch/x86/include/asm/inst.h        | 74 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/head_64.S          |  6 ++--
 arch/x86/kernel/i387.c             | 14 +++-----
 arch/x86/platform/efi/efi.c        |  2 +-
 drivers/firmware/efi/efivars.c     |  8 ++---
 fs/efivarfs/file.c                 | 14 ++++++--
 kernel/range.c                     |  8 +++--
 8 files changed, 103 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/crc32-pclmul_asm.S b/arch/x86/crypto/crc32-pclmul_asm.S
index 94c27df..f247304 100644
--- a/arch/x86/crypto/crc32-pclmul_asm.S
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -240,7 +240,7 @@ fold_64:
 	pand    %xmm3, %xmm1
 	PCLMULQDQ 0x00, CONSTANT, %xmm1
 	pxor    %xmm2, %xmm1
-	pextrd  $0x01, %xmm1, %eax
+	PEXTRD  0x01, %xmm1, %eax
 
 	ret
 ENDPROC(crc32_pclmul_le_16)
diff --git a/arch/x86/include/asm/inst.h b/arch/x86/include/asm/inst.h
index 280bf7f..3e11527 100644
--- a/arch/x86/include/asm/inst.h
+++ b/arch/x86/include/asm/inst.h
@@ -9,12 +9,68 @@
 
 #define REG_NUM_INVALID		100
 
-#define REG_TYPE_R64		0
-#define REG_TYPE_XMM		1
+#define REG_TYPE_R32		0
+#define REG_TYPE_R64		1
+#define REG_TYPE_XMM		2
 #define REG_TYPE_INVALID	100
 
+	.macro R32_NUM opd r32
+	\opd = REG_NUM_INVALID
+	.ifc \r32,%eax
+	\opd = 0
+	.endif
+	.ifc \r32,%ecx
+	\opd = 1
+	.endif
+	.ifc \r32,%edx
+	\opd = 2
+	.endif
+	.ifc \r32,%ebx
+	\opd = 3
+	.endif
+	.ifc \r32,%esp
+	\opd = 4
+	.endif
+	.ifc \r32,%ebp
+	\opd = 5
+	.endif
+	.ifc \r32,%esi
+	\opd = 6
+	.endif
+	.ifc \r32,%edi
+	\opd = 7
+	.endif
+#ifdef CONFIG_X86_64
+	.ifc \r32,%r8d
+	\opd = 8
+	.endif
+	.ifc \r32,%r9d
+	\opd = 9
+	.endif
+	.ifc \r32,%r10d
+	\opd = 10
+	.endif
+	.ifc \r32,%r11d
+	\opd = 11
+	.endif
+	.ifc \r32,%r12d
+	\opd = 12
+	.endif
+	.ifc \r32,%r13d
+	\opd = 13
+	.endif
+	.ifc \r32,%r14d
+	\opd = 14
+	.endif
+	.ifc \r32,%r15d
+	\opd = 15
+	.endif
+#endif
+	.endm
+
 	.macro R64_NUM opd r64
 	\opd = REG_NUM_INVALID
+#ifdef CONFIG_X86_64
 	.ifc \r64,%rax
 	\opd = 0
 	.endif
@@ -63,6 +119,7 @@
 	.ifc \r64,%r15
 	\opd = 15
 	.endif
+#endif
 	.endm
 
 	.macro XMM_NUM opd xmm
@@ -118,10 +175,13 @@
 	.endm
 
 	.macro REG_TYPE type reg
+	R32_NUM reg_type_r32 \reg
 	R64_NUM reg_type_r64 \reg
 	XMM_NUM reg_type_xmm \reg
 	.if reg_type_r64 <> REG_NUM_INVALID
 	\type = REG_TYPE_R64
+	.elseif reg_type_r32 <> REG_NUM_INVALID
+	\type = REG_TYPE_R32
 	.elseif reg_type_xmm <> REG_NUM_INVALID
 	\type = REG_TYPE_XMM
 	.else
@@ -162,6 +222,16 @@
 	.byte \imm8
 	.endm
 
+	.macro PEXTRD imm8 xmm gpr
+	R32_NUM extrd_opd1 \gpr
+	XMM_NUM extrd_opd2 \xmm
+	PFX_OPD_SIZE
+	PFX_REX extrd_opd1 extrd_opd2
+	.byte 0x0f, 0x3a, 0x16
+	MODRM 0xc0 extrd_opd1 extrd_opd2
+	.byte \imm8
+	.endm
+
 	.macro AESKEYGENASSIST rcon xmm1 xmm2
 	XMM_NUM aeskeygen_opd1 \xmm1
 	XMM_NUM aeskeygen_opd2 \xmm2
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 08f7e80..321d65e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -115,8 +115,10 @@ startup_64:
 	movq	%rdi, %rax
 	shrq	$PUD_SHIFT, %rax
 	andl	$(PTRS_PER_PUD-1), %eax
-	movq	%rdx, (4096+0)(%rbx,%rax,8)
-	movq	%rdx, (4096+8)(%rbx,%rax,8)
+	movq	%rdx, 4096(%rbx,%rax,8)
+	incl	%eax
+	andl	$(PTRS_PER_PUD-1), %eax
+	movq	%rdx, 4096(%rbx,%rax,8)
 
 	addq	$8192, %rbx
 	movq	%rdi, %rax
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 245a71d..cb33909 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -22,23 +22,19 @@
 /*
  * Were we in an interrupt that interrupted kernel mode?
  *
- * For now, with eagerfpu we will return interrupted kernel FPU
- * state as not-idle. TBD: Ideally we can change the return value
- * to something like __thread_has_fpu(current). But we need to
- * be careful of doing __thread_clear_has_fpu() before saving
- * the FPU etc for supporting nested uses etc. For now, take
- * the simple route!
- *
  * On others, we can do a kernel_fpu_begin/end() pair *ONLY* if that
  * pair does nothing at all: the thread must not have fpu (so
  * that we don't try to save the FPU state), and TS must
  * be set (so that the clts/stts pair does nothing that is
  * visible in the interrupted kernel thread).
+ *
+ * Except for the eagerfpu case when we return 1 unless we've already
+ * been eager and saved the state in kernel_fpu_begin().
  */
 static inline bool interrupted_kernel_fpu_idle(void)
 {
 	if (use_eager_fpu())
-		return 0;
+		return __thread_has_fpu(current);
 
 	return !__thread_has_fpu(current) &&
 		(read_cr0() & X86_CR0_TS);
@@ -78,8 +74,8 @@ void __kernel_fpu_begin(void)
 	struct task_struct *me = current;
 
 	if (__thread_has_fpu(me)) {
-		__save_init_fpu(me);
 		__thread_clear_has_fpu(me);
+		__save_init_fpu(me);
 		/* We do 'stts()' in __kernel_fpu_end() */
 	} else if (!use_eager_fpu()) {
 		this_cpu_write(fpu_owner_task, NULL);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 55856b2..82089d8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -206,7 +206,7 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 	}
 
 	if (boot_used_size && !finished) {
-		unsigned long size;
+		unsigned long size = 0;
 		u32 attr;
 		efi_status_t s;
 		void *tmp;
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index b623c59..8bd1bb6 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -523,13 +523,11 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
 	struct efivar_entry *entry;
 	int err;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return;
-
 	/* Add new sysfs entries */
 	while (1) {
-		memset(entry, 0, sizeof(*entry));
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			return;
 
 		err = efivar_init(efivar_update_sysfs_entry, entry,
 				  true, false, &efivar_sysfs_list);
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index bfb5315..8dd524f 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -44,8 +44,11 @@ static ssize_t efivarfs_file_write(struct file *file,
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
-	if (!set && bytes)
+	if (!set && bytes) {
+		if (bytes == -ENOENT)
+			bytes = -EIO;
 		goto out;
+	}
 
 	if (bytes == -ENOENT) {
 		drop_nlink(inode);
@@ -76,7 +79,14 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	int err;
 
 	err = efivar_entry_size(var, &datasize);
-	if (err)
+
+	/*
+	 * efivarfs represents uncommitted variables with
+	 * zero-length files. Reading them should return EOF.
+	 */
+	if (err == -ENOENT)
+		return 0;
+	else if (err)
 		return err;
 
 	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
diff --git a/kernel/range.c b/kernel/range.c
index 071b0ab..eb911db 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -48,9 +48,11 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 		final_start = min(range[i].start, start);
 		final_end = max(range[i].end, end);
 
-		range[i].start = final_start;
-		range[i].end =  final_end;
-		return nr_range;
+		/* clear it and add it back for further merge */
+		range[i].start = 0;
+		range[i].end =  0;
+		return add_range_with_merge(range, az, nr_range,
+			final_start, final_end);
 	}
 
 	/* Need to add it: */
