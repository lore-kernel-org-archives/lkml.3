Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaFDW4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:56:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37232 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaFDW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:56:17 -0400
Date: Wed, 4 Jun 2014 15:55:37 -0700
Message-Id: <201406042255.s54Mtb4g026931@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v3.16
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: bp@suse.de, hpa@linux.intel.com, hpa@zytor.com, leif.lindholm@linaro.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com, mikew@google.com,
        mingo@kernel.org, msalter@redhat.com,
        ricardo.neri-calderon@linux.intel.com, roy.franz@linaro.org,
        tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of EFI changes.  The perhaps most important one is to
fully save and restore the FPU state around each invocation of EFI
runtime, and to not choke on non-ASCII characters in the boot stub.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

for you to fetch changes up to e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:

  efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)

----------------------------------------------------------------
H. Peter Anvin (1):
      efi: x86: Handle arbitrary Unicode characters

Leif Lindholm (1):
      efi: efi-stub-helper cleanup

Mark Salter (1):
      efi: create memory map iteration helper

Matt Fleming (7):
      x86/efi: Delete most of the efi_call* macros
      x86, fpu: Extend the use of static_cpu_has_safe
      efivars: Use local variables instead of a pointer dereference
      efivars: Check size of user object
      efivars: Stop passing a struct argument to efivar_validate()
      efivars: Refactor sanity checking code into separate function
      efivars: Add compatibility code for compat tasks

Ricardo Neri (3):
      x86/efi: Implement a __efi_call_virt macro
      x86/efi: Save and restore FPU context around efi_calls (x86_64)
      x86/efi: Save and restore FPU context around efi_calls (i386)

Roy Franz (2):
      efi: Add shared printk wrapper for consistent prefixing
      efi: Add get_dram_base() helper function

 arch/x86/boot/compressed/eboot.c       |   3 +-
 arch/x86/boot/compressed/head_64.S     |   2 +-
 arch/x86/include/asm/efi.h             | 100 ++++++-----------
 arch/x86/include/asm/fpu-internal.h    |  10 +-
 arch/x86/platform/efi/efi.c            |  48 ++++-----
 arch/x86/platform/efi/efi_stub_64.S    |  81 +-------------
 arch/x86/platform/uv/bios_uv.c         |   2 +-
 drivers/firmware/efi/efi-stub-helper.c | 144 ++++++++++++++++++-------
 drivers/firmware/efi/efivars.c         | 192 +++++++++++++++++++++++++++------
 drivers/firmware/efi/vars.c            |  30 +++---
 include/linux/efi.h                    |  12 ++-
 11 files changed, 361 insertions(+), 263 deletions(-)

 arch/x86/boot/compressed/eboot.c       |   3 +-
 arch/x86/boot/compressed/head_64.S     |   2 +-
 arch/x86/include/asm/efi.h             | 100 ++++++-----------
 arch/x86/include/asm/fpu-internal.h    |  10 +-
 arch/x86/platform/efi/efi.c            |  48 ++++-----
 arch/x86/platform/efi/efi_stub_64.S    |  81 +-------------
 arch/x86/platform/uv/bios_uv.c         |   2 +-
 drivers/firmware/efi/efi-stub-helper.c | 144 ++++++++++++++++++-------
 drivers/firmware/efi/efivars.c         | 192 +++++++++++++++++++++++++++------
 drivers/firmware/efi/vars.c            |  30 +++---
 include/linux/efi.h                    |  12 ++-
 11 files changed, 361 insertions(+), 263 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 4703a6c..0331d76 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1087,8 +1087,7 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
-	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
-						   &options_size);
+	cmdline_ptr = efi_convert_cmdline(sys_table, image, &options_size);
 	if (!cmdline_ptr)
 		goto fail;
 	hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 0d558ee..2884e0c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -452,7 +452,7 @@ efi32_config:
 	.global efi64_config
 efi64_config:
 	.fill	11,8,0
-	.quad	efi_call6
+	.quad	efi_call
 	.byte	1
 #endif /* CONFIG_EFI_STUB */
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0869434..1eb5f64 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_EFI_H
 #define _ASM_X86_EFI_H
 
+#include <asm/i387.h>
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
  * with preserved alignment on virtual addresses starting from -4G down
@@ -27,91 +28,58 @@
 
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
-#define efi_call_phys0(f)		efi_call_phys(f)
-#define efi_call_phys1(f, a1)		efi_call_phys(f, a1)
-#define efi_call_phys2(f, a1, a2)	efi_call_phys(f, a1, a2)
-#define efi_call_phys3(f, a1, a2, a3)	efi_call_phys(f, a1, a2, a3)
-#define efi_call_phys4(f, a1, a2, a3, a4)	\
-	efi_call_phys(f, a1, a2, a3, a4)
-#define efi_call_phys5(f, a1, a2, a3, a4, a5)	\
-	efi_call_phys(f, a1, a2, a3, a4, a5)
-#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)	\
-	efi_call_phys(f, a1, a2, a3, a4, a5, a6)
 /*
  * Wrap all the virtual calls in a way that forces the parameters on the stack.
  */
 
+/* Use this macro if your virtual returns a non-void value */
 #define efi_call_virt(f, args...) \
-	((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
-
-#define efi_call_virt0(f)		efi_call_virt(f)
-#define efi_call_virt1(f, a1)		efi_call_virt(f, a1)
-#define efi_call_virt2(f, a1, a2)	efi_call_virt(f, a1, a2)
-#define efi_call_virt3(f, a1, a2, a3)	efi_call_virt(f, a1, a2, a3)
-#define efi_call_virt4(f, a1, a2, a3, a4)	\
-	efi_call_virt(f, a1, a2, a3, a4)
-#define efi_call_virt5(f, a1, a2, a3, a4, a5)	\
-	efi_call_virt(f, a1, a2, a3, a4, a5)
-#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
-	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
+({									\
+	efi_status_t __s;						\
+	kernel_fpu_begin();						\
+	__s = ((efi_##f##_t __attribute__((regparm(0)))*)		\
+		efi.systab->runtime->f)(args);				\
+	kernel_fpu_end();						\
+	__s;								\
+})
+
+/* Use this macro if your virtual call does not return any value */
+#define __efi_call_virt(f, args...) \
+({									\
+	kernel_fpu_begin();						\
+	((efi_##f##_t __attribute__((regparm(0)))*)			\
+		efi.systab->runtime->f)(args);				\
+	kernel_fpu_end();						\
+})
 
 #define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
-extern u64 efi_call0(void *fp);
-extern u64 efi_call1(void *fp, u64 arg1);
-extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
-extern u64 efi_call3(void *fp, u64 arg1, u64 arg2, u64 arg3);
-extern u64 efi_call4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
-extern u64 efi_call5(void *fp, u64 arg1, u64 arg2, u64 arg3,
-		     u64 arg4, u64 arg5);
-extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
-		     u64 arg4, u64 arg5, u64 arg6);
-
-#define efi_call_phys0(f)			\
-	efi_call0((f))
-#define efi_call_phys1(f, a1)			\
-	efi_call1((f), (u64)(a1))
-#define efi_call_phys2(f, a1, a2)			\
-	efi_call2((f), (u64)(a1), (u64)(a2))
-#define efi_call_phys3(f, a1, a2, a3)				\
-	efi_call3((f), (u64)(a1), (u64)(a2), (u64)(a3))
-#define efi_call_phys4(f, a1, a2, a3, a4)				\
-	efi_call4((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
-		  (u64)(a4))
-#define efi_call_phys5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
-		  (u64)(a4), (u64)(a5))
-#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
-		  (u64)(a4), (u64)(a5), (u64)(a6))
-
-#define _efi_call_virtX(x, f, ...)					\
+#define EFI_LOADER_SIGNATURE	"EL64"
+
+extern u64 asmlinkage efi_call(void *fp, ...);
+
+#define efi_call_phys(f, args...)		efi_call((f), args)
+
+#define efi_call_virt(f, ...)						\
 ({									\
 	efi_status_t __s;						\
 									\
 	efi_sync_low_kernel_mappings();					\
 	preempt_disable();						\
-	__s = efi_call##x((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+	__kernel_fpu_begin();						\
+	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+	__kernel_fpu_end();						\
 	preempt_enable();						\
 	__s;								\
 })
 
-#define efi_call_virt0(f)				\
-	_efi_call_virtX(0, f)
-#define efi_call_virt1(f, a1)				\
-	_efi_call_virtX(1, f, (u64)(a1))
-#define efi_call_virt2(f, a1, a2)			\
-	_efi_call_virtX(2, f, (u64)(a1), (u64)(a2))
-#define efi_call_virt3(f, a1, a2, a3)			\
-	_efi_call_virtX(3, f, (u64)(a1), (u64)(a2), (u64)(a3))
-#define efi_call_virt4(f, a1, a2, a3, a4)		\
-	_efi_call_virtX(4, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4))
-#define efi_call_virt5(f, a1, a2, a3, a4, a5)		\
-	_efi_call_virtX(5, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5))
-#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
-	_efi_call_virtX(6, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
+/*
+ * All X86_64 virt calls return non-void values. Thus, use non-void call for
+ * virt calls that would be void on X86_32.
+ */
+#define __efi_call_virt(f, args...) efi_call_virt(f, args)
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 				 u32 type, u64 attribute);
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index cea1c76..115e368 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -87,22 +87,22 @@ static inline int is_x32_frame(void)
 
 static __always_inline __pure bool use_eager_fpu(void)
 {
-	return static_cpu_has(X86_FEATURE_EAGER_FPU);
+	return static_cpu_has_safe(X86_FEATURE_EAGER_FPU);
 }
 
 static __always_inline __pure bool use_xsaveopt(void)
 {
-	return static_cpu_has(X86_FEATURE_XSAVEOPT);
+	return static_cpu_has_safe(X86_FEATURE_XSAVEOPT);
 }
 
 static __always_inline __pure bool use_xsave(void)
 {
-	return static_cpu_has(X86_FEATURE_XSAVE);
+	return static_cpu_has_safe(X86_FEATURE_XSAVE);
 }
 
 static __always_inline __pure bool use_fxsr(void)
 {
-        return static_cpu_has(X86_FEATURE_FXSR);
+	return static_cpu_has_safe(X86_FEATURE_FXSR);
 }
 
 static inline void fx_finit(struct i387_fxsave_struct *fx)
@@ -293,7 +293,7 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. "m" is a random variable that should be in L1 */
-	if (unlikely(static_cpu_has(X86_FEATURE_FXSAVE_LEAK))) {
+	if (unlikely(static_cpu_has_safe(X86_FEATURE_FXSAVE_LEAK))) {
 		asm volatile(
 			"fnclex\n\t"
 			"emms\n\t"
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3781dd3..835b248 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -110,7 +110,7 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(get_time, tm, tc);
+	status = efi_call_virt(get_time, tm, tc);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -121,7 +121,7 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt1(set_time, tm);
+	status = efi_call_virt(set_time, tm);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -134,8 +134,7 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt3(get_wakeup_time,
-				enabled, pending, tm);
+	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -146,8 +145,7 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt2(set_wakeup_time,
-				enabled, tm);
+	status = efi_call_virt(set_wakeup_time, enabled, tm);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -158,17 +156,17 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	return efi_call_virt5(get_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	return efi_call_virt(get_variable,
+			     name, vendor, attr,
+			     data_size, data);
 }
 
 static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt3(get_next_variable,
-			      name_size, name, vendor);
+	return efi_call_virt(get_next_variable,
+			     name_size, name, vendor);
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -177,9 +175,9 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt5(set_variable,
-			      name, vendor, attr,
-			      data_size, data);
+	return efi_call_virt(set_variable,
+			     name, vendor, attr,
+			     data_size, data);
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -190,13 +188,13 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt4(query_variable_info, attr, storage_space,
-			      remaining_space, max_variable_size);
+	return efi_call_virt(query_variable_info, attr, storage_space,
+			     remaining_space, max_variable_size);
 }
 
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
-	return efi_call_virt1(get_next_high_mono_count, count);
+	return efi_call_virt(get_next_high_mono_count, count);
 }
 
 static void virt_efi_reset_system(int reset_type,
@@ -204,8 +202,8 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	efi_call_virt4(reset_system, reset_type, status,
-		       data_size, data);
+	__efi_call_virt(reset_system, reset_type, status,
+			data_size, data);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
@@ -215,7 +213,7 @@ static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt3(update_capsule, capsules, count, sg_list);
+	return efi_call_virt(update_capsule, capsules, count, sg_list);
 }
 
 static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
@@ -226,8 +224,8 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt4(query_capsule_caps, capsules, count, max_size,
-			      reset_type);
+	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
+			     reset_type);
 }
 
 static efi_status_t __init phys_efi_set_virtual_address_map(
@@ -239,9 +237,9 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	efi_status_t status;
 
 	efi_call_phys_prelog();
-	status = efi_call_phys4(efi_phys.set_virtual_address_map,
-				memory_map_size, descriptor_size,
-				descriptor_version, virtual_map);
+	status = efi_call_phys(efi_phys.set_virtual_address_map,
+			       memory_map_size, descriptor_size,
+			       descriptor_version, virtual_map);
 	efi_call_phys_epilog();
 	return status;
 }
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index e0984ef..5fcda72 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -73,84 +73,7 @@
 	2:
 	.endm
 
-ENTRY(efi_call0)
-	SAVE_XMM
-	subq $32, %rsp
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call0)
-
-ENTRY(efi_call1)
-	SAVE_XMM
-	subq $32, %rsp
-	mov  %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call1)
-
-ENTRY(efi_call2)
-	SAVE_XMM
-	subq $32, %rsp
-	mov  %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call2)
-
-ENTRY(efi_call3)
-	SAVE_XMM
-	subq $32, %rsp
-	mov  %rcx, %r8
-	mov  %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call3)
-
-ENTRY(efi_call4)
-	SAVE_XMM
-	subq $32, %rsp
-	mov %r8, %r9
-	mov %rcx, %r8
-	mov %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $32, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call4)
-
-ENTRY(efi_call5)
-	SAVE_XMM
-	subq $48, %rsp
-	mov %r9, 32(%rsp)
-	mov %r8, %r9
-	mov %rcx, %r8
-	mov %rsi, %rcx
-	SWITCH_PGT
-	call *%rdi
-	RESTORE_PGT
-	addq $48, %rsp
-	RESTORE_XMM
-	ret
-ENDPROC(efi_call5)
-
-ENTRY(efi_call6)
+ENTRY(efi_call)
 	SAVE_XMM
 	mov (%rsp), %rax
 	mov 8(%rax), %rax
@@ -166,7 +89,7 @@ ENTRY(efi_call6)
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
-ENDPROC(efi_call6)
+ENDPROC(efi_call)
 
 #ifdef CONFIG_EFI_MIXED
 
diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
index 7666121..1584cbe 100644
--- a/arch/x86/platform/uv/bios_uv.c
+++ b/arch/x86/platform/uv/bios_uv.c
@@ -39,7 +39,7 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 		 */
 		return BIOS_STATUS_UNIMPLEMENTED;
 
-	ret = efi_call6((void *)__va(tab->function), (u64)which,
+	ret = efi_call((void *)__va(tab->function), (u64)which,
 			a1, a2, a3, a4, a5);
 	return ret;
 }
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 2c41eae..eb6d4be 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -11,6 +11,10 @@
  */
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
+/* error code which can't be mistaken for valid address */
+#define EFI_ERROR	(~0UL)
+
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -33,6 +37,9 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 	}
 }
 
+#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+
 
 static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 				       efi_memory_desc_t **map,
@@ -80,6 +87,32 @@ fail:
 	return status;
 }
 
+
+static unsigned long __init get_dram_base(efi_system_table_t *sys_table_arg)
+{
+	efi_status_t status;
+	unsigned long map_size;
+	unsigned long membase  = EFI_ERROR;
+	struct efi_memory_map map;
+	efi_memory_desc_t *md;
+
+	status = efi_get_memory_map(sys_table_arg, (efi_memory_desc_t **)&map.map,
+				    &map_size, &map.desc_size, NULL, NULL);
+	if (status != EFI_SUCCESS)
+		return membase;
+
+	map.map_end = map.map + map_size;
+
+	for_each_efi_memory_desc(&map, md)
+		if (md->attribute & EFI_MEMORY_WB)
+			if (membase > md->phys_addr)
+				membase = md->phys_addr;
+
+	efi_call_early(free_pool, map.map);
+
+	return membase;
+}
+
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
@@ -267,7 +300,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	struct file_info *files;
 	unsigned long file_addr;
 	u64 file_size_total;
-	efi_file_handle_t *fh;
+	efi_file_handle_t *fh = NULL;
 	efi_status_t status;
 	int nr_files;
 	char *str;
@@ -310,7 +343,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				nr_files * sizeof(*files), (void **)&files);
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
+		pr_efi_err(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
 	}
 
@@ -374,13 +407,13 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 		status = efi_high_alloc(sys_table_arg, file_size_total, 0x1000,
 				    &file_addr, max_addr);
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to alloc highmem for files\n");
+			pr_efi_err(sys_table_arg, "Failed to alloc highmem for files\n");
 			goto close_handles;
 		}
 
 		/* We've run out of free low memory. */
 		if (file_addr > max_addr) {
-			efi_printk(sys_table_arg, "We've run out of free low memory\n");
+			pr_efi_err(sys_table_arg, "We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
 			goto free_file_total;
 		}
@@ -401,7 +434,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 						       &chunksize,
 						       (void *)addr);
 				if (status != EFI_SUCCESS) {
-					efi_printk(sys_table_arg, "Failed to read file\n");
+					pr_efi_err(sys_table_arg, "Failed to read file\n");
 					goto free_file_total;
 				}
 				addr += chunksize;
@@ -486,7 +519,7 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 				       &new_addr);
 	}
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
+		pr_efi_err(sys_table_arg, "Failed to allocate usable memory for kernel.\n");
 		return status;
 	}
 
@@ -503,62 +536,99 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 }
 
 /*
+ * Get the number of UTF-8 bytes corresponding to an UTF-16 character.
+ * This overestimates for surrogates, but that is okay.
+ */
+static int efi_utf8_bytes(u16 c)
+{
+	return 1 + (c >= 0x80) + (c >= 0x800);
+}
+
+/*
+ * Convert an UTF-16 string, not necessarily null terminated, to UTF-8.
+ */
+static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
+{
+	unsigned int c;
+
+	while (n--) {
+		c = *src++;
+		if (n && c >= 0xd800 && c <= 0xdbff &&
+		    *src >= 0xdc00 && *src <= 0xdfff) {
+			c = 0x10000 + ((c & 0x3ff) << 10) + (*src & 0x3ff);
+			src++;
+			n--;
+		}
+		if (c >= 0xd800 && c <= 0xdfff)
+			c = 0xfffd; /* Unmatched surrogate */
+		if (c < 0x80) {
+			*dst++ = c;
+			continue;
+		}
+		if (c < 0x800) {
+			*dst++ = 0xc0 + (c >> 6);
+			goto t1;
+		}
+		if (c < 0x10000) {
+			*dst++ = 0xe0 + (c >> 12);
+			goto t2;
+		}
+		*dst++ = 0xf0 + (c >> 18);
+		*dst++ = 0x80 + ((c >> 12) & 0x3f);
+	t2:
+		*dst++ = 0x80 + ((c >> 6) & 0x3f);
+	t1:
+		*dst++ = 0x80 + (c & 0x3f);
+	}
+
+	return dst;
+}
+
+/*
  * Convert the unicode UEFI command line to ASCII to pass to kernel.
  * Size of memory allocated return in *cmd_line_len.
  * Returns NULL on error.
  */
-static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
-				      efi_loaded_image_t *image,
-				      int *cmd_line_len)
+static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+				 efi_loaded_image_t *image,
+				 int *cmd_line_len)
 {
-	u16 *s2;
+	const u16 *s2;
 	u8 *s1 = NULL;
 	unsigned long cmdline_addr = 0;
-	int load_options_size = image->load_options_size / 2; /* ASCII */
-	void *options = image->load_options;
-	int options_size = 0;
+	int load_options_chars = image->load_options_size / 2; /* UTF-16 */
+	const u16 *options = image->load_options;
+	int options_bytes = 0;  /* UTF-8 bytes */
+	int options_chars = 0;  /* UTF-16 chars */
 	efi_status_t status;
-	int i;
 	u16 zero = 0;
 
 	if (options) {
 		s2 = options;
-		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
-			s2++;
-			options_size++;
+		while (*s2 && *s2 != '\n'
+		       && options_chars < load_options_chars) {
+			options_bytes += efi_utf8_bytes(*s2++);
+			options_chars++;
 		}
 	}
 
-	if (options_size == 0) {
+	if (!options_chars) {
 		/* No command line options, so return empty string*/
-		options_size = 1;
 		options = &zero;
 	}
 
-	options_size++;  /* NUL termination */
-#ifdef CONFIG_ARM
-	/*
-	 * For ARM, allocate at a high address to avoid reserved
-	 * regions at low addresses that we don't know the specfics of
-	 * at the time we are processing the command line.
-	 */
-	status = efi_high_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr, 0xfffff000);
-#else
-	status = efi_low_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr);
-#endif
+	options_bytes++;	/* NUL termination */
+
+	status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
 	s1 = (u8 *)cmdline_addr;
-	s2 = (u16 *)options;
-
-	for (i = 0; i < options_size - 1; i++)
-		*s1++ = *s2++;
+	s2 = (const u16 *)options;
 
+	s1 = efi_utf16_to_utf8(s1, s2, options_chars);
 	*s1 = '\0';
 
-	*cmd_line_len = options_size;
+	*cmd_line_len = options_bytes;
 	return (char *)cmdline_addr;
 }
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 50ea412..463c565 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -69,6 +69,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/ucs2_string.h>
+#include <linux/compat.h>
 
 #define EFIVARS_VERSION "0.08"
 #define EFIVARS_DATE "2004-May-17"
@@ -86,6 +87,15 @@ static struct kset *efivars_kset;
 static struct bin_attribute *efivars_new_var;
 static struct bin_attribute *efivars_del_var;
 
+struct compat_efi_variable {
+	efi_char16_t  VariableName[EFI_VAR_NAME_LEN/sizeof(efi_char16_t)];
+	efi_guid_t    VendorGuid;
+	__u32         DataSize;
+	__u8          Data[1024];
+	__u32         Status;
+	__u32         Attributes;
+} __packed;
+
 struct efivar_attribute {
 	struct attribute attr;
 	ssize_t (*show) (struct efivar_entry *entry, char *buf);
@@ -189,45 +199,107 @@ efivar_data_read(struct efivar_entry *entry, char *buf)
 	memcpy(buf, var->Data, var->DataSize);
 	return var->DataSize;
 }
-/*
- * We allow each variable to be edited via rewriting the
- * entire efi variable structure.
- */
-static ssize_t
-efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
-{
-	struct efi_variable *new_var, *var = &entry->var;
-	int err;
 
-	if (count != sizeof(struct efi_variable))
-		return -EINVAL;
-
-	new_var = (struct efi_variable *)buf;
+static inline int
+sanity_check(struct efi_variable *var, efi_char16_t *name, efi_guid_t vendor,
+	     unsigned long size, u32 attributes, u8 *data)
+{
 	/*
 	 * If only updating the variable data, then the name
 	 * and guid should remain the same
 	 */
-	if (memcmp(new_var->VariableName, var->VariableName, sizeof(var->VariableName)) ||
-		efi_guidcmp(new_var->VendorGuid, var->VendorGuid)) {
+	if (memcmp(name, var->VariableName, sizeof(var->VariableName)) ||
+		efi_guidcmp(vendor, var->VendorGuid)) {
 		printk(KERN_ERR "efivars: Cannot edit the wrong variable!\n");
 		return -EINVAL;
 	}
 
-	if ((new_var->DataSize <= 0) || (new_var->Attributes == 0)){
+	if ((size <= 0) || (attributes == 0)){
 		printk(KERN_ERR "efivars: DataSize & Attributes must be valid!\n");
 		return -EINVAL;
 	}
 
-	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
+	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    efivar_validate(name, data, size) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
 
-	memcpy(&entry->var, new_var, count);
+	return 0;
+}
+
+static inline bool is_compat(void)
+{
+	if (IS_ENABLED(CONFIG_COMPAT) && is_compat_task())
+		return true;
+
+	return false;
+}
+
+static void
+copy_out_compat(struct efi_variable *dst, struct compat_efi_variable *src)
+{
+	memcpy(dst->VariableName, src->VariableName, EFI_VAR_NAME_LEN);
+	memcpy(dst->Data, src->Data, sizeof(src->Data));
+
+	dst->VendorGuid = src->VendorGuid;
+	dst->DataSize = src->DataSize;
+	dst->Attributes = src->Attributes;
+}
+
+/*
+ * We allow each variable to be edited via rewriting the
+ * entire efi variable structure.
+ */
+static ssize_t
+efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
+{
+	struct efi_variable *new_var, *var = &entry->var;
+	efi_char16_t *name;
+	unsigned long size;
+	efi_guid_t vendor;
+	u32 attributes;
+	u8 *data;
+	int err;
+
+	if (is_compat()) {
+		struct compat_efi_variable *compat;
+
+		if (count != sizeof(*compat))
+			return -EINVAL;
+
+		compat = (struct compat_efi_variable *)buf;
+		attributes = compat->Attributes;
+		vendor = compat->VendorGuid;
+		name = compat->VariableName;
+		size = compat->DataSize;
+		data = compat->Data;
+
+		err = sanity_check(var, name, vendor, size, attributes, data);
+		if (err)
+			return err;
+
+		copy_out_compat(&entry->var, compat);
+	} else {
+		if (count != sizeof(struct efi_variable))
+			return -EINVAL;
+
+		new_var = (struct efi_variable *)buf;
 
-	err = efivar_entry_set(entry, new_var->Attributes,
-			       new_var->DataSize, new_var->Data, NULL);
+		attributes = new_var->Attributes;
+		vendor = new_var->VendorGuid;
+		name = new_var->VariableName;
+		size = new_var->DataSize;
+		data = new_var->Data;
+
+		err = sanity_check(var, name, vendor, size, attributes, data);
+		if (err)
+			return err;
+
+		memcpy(&entry->var, new_var, count);
+	}
+
+	err = efivar_entry_set(entry, attributes, size, data, NULL);
 	if (err) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", err);
 		return -EIO;
@@ -240,6 +312,8 @@ static ssize_t
 efivar_show_raw(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
+	struct compat_efi_variable *compat;
+	size_t size;
 
 	if (!entry || !buf)
 		return 0;
@@ -249,9 +323,23 @@ efivar_show_raw(struct efivar_entry *entry, char *buf)
 			     &entry->var.DataSize, entry->var.Data))
 		return -EIO;
 
-	memcpy(buf, var, sizeof(*var));
+	if (is_compat()) {
+		compat = (struct compat_efi_variable *)buf;
+
+		size = sizeof(*compat);
+		memcpy(compat->VariableName, var->VariableName,
+			EFI_VAR_NAME_LEN);
+		memcpy(compat->Data, var->Data, sizeof(compat->Data));
+
+		compat->VendorGuid = var->VendorGuid;
+		compat->DataSize = var->DataSize;
+		compat->Attributes = var->Attributes;
+	} else {
+		size = sizeof(*var);
+		memcpy(buf, var, size);
+	}
 
-	return sizeof(*var);
+	return size;
 }
 
 /*
@@ -326,15 +414,39 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
+	struct compat_efi_variable *compat = (struct compat_efi_variable *)buf;
 	struct efi_variable *new_var = (struct efi_variable *)buf;
 	struct efivar_entry *new_entry;
+	bool need_compat = is_compat();
+	efi_char16_t *name;
+	unsigned long size;
+	u32 attributes;
+	u8 *data;
 	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
+	if (need_compat) {
+		if (count != sizeof(*compat))
+			return -EINVAL;
+
+		attributes = compat->Attributes;
+		name = compat->VariableName;
+		size = compat->DataSize;
+		data = compat->Data;
+	} else {
+		if (count != sizeof(*new_var))
+			return -EINVAL;
+
+		attributes = new_var->Attributes;
+		name = new_var->VariableName;
+		size = new_var->DataSize;
+		data = new_var->Data;
+	}
+
+	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    efivar_validate(name, data, size) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
@@ -343,10 +455,13 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (!new_entry)
 		return -ENOMEM;
 
-	memcpy(&new_entry->var, new_var, sizeof(*new_var));
+	if (need_compat)
+		copy_out_compat(&new_entry->var, compat);
+	else
+		memcpy(&new_entry->var, new_var, sizeof(*new_var));
 
-	err = efivar_entry_set(new_entry, new_var->Attributes, new_var->DataSize,
-			       new_var->Data, &efivar_sysfs_list);
+	err = efivar_entry_set(new_entry, attributes, size,
+			       data, &efivar_sysfs_list);
 	if (err) {
 		if (err == -EEXIST)
 			err = -EINVAL;
@@ -369,15 +484,32 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
+	struct compat_efi_variable *compat;
 	struct efivar_entry *entry;
+	efi_char16_t *name;
+	efi_guid_t vendor;
 	int err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if (is_compat()) {
+		if (count != sizeof(*compat))
+			return -EINVAL;
+
+		compat = (struct compat_efi_variable *)buf;
+		name = compat->VariableName;
+		vendor = compat->VendorGuid;
+	} else {
+		if (count != sizeof(*del_var))
+			return -EINVAL;
+
+		name = del_var->VariableName;
+		vendor = del_var->VendorGuid;
+	}
+
 	efivar_entry_iter_begin();
-	entry = efivar_entry_find(del_var->VariableName, del_var->VendorGuid,
-				  &efivar_sysfs_list, true);
+	entry = efivar_entry_find(name, vendor, &efivar_sysfs_list, true);
 	if (!entry)
 		err = -EINVAL;
 	else if (__efivar_entry_delete(entry))
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index b22659c..f0a4364 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -42,7 +42,7 @@ DECLARE_WORK(efivar_work, NULL);
 EXPORT_SYMBOL_GPL(efivar_work);
 
 static bool
-validate_device_path(struct efi_variable *var, int match, u8 *buffer,
+validate_device_path(efi_char16_t *var_name, int match, u8 *buffer,
 		     unsigned long len)
 {
 	struct efi_generic_dev_path *node;
@@ -75,7 +75,7 @@ validate_device_path(struct efi_variable *var, int match, u8 *buffer,
 }
 
 static bool
-validate_boot_order(struct efi_variable *var, int match, u8 *buffer,
+validate_boot_order(efi_char16_t *var_name, int match, u8 *buffer,
 		    unsigned long len)
 {
 	/* An array of 16-bit integers */
@@ -86,18 +86,18 @@ validate_boot_order(struct efi_variable *var, int match, u8 *buffer,
 }
 
 static bool
-validate_load_option(struct efi_variable *var, int match, u8 *buffer,
+validate_load_option(efi_char16_t *var_name, int match, u8 *buffer,
 		     unsigned long len)
 {
 	u16 filepathlength;
 	int i, desclength = 0, namelen;
 
-	namelen = ucs2_strnlen(var->VariableName, sizeof(var->VariableName));
+	namelen = ucs2_strnlen(var_name, EFI_VAR_NAME_LEN);
 
 	/* Either "Boot" or "Driver" followed by four digits of hex */
 	for (i = match; i < match+4; i++) {
-		if (var->VariableName[i] > 127 ||
-		    hex_to_bin(var->VariableName[i] & 0xff) < 0)
+		if (var_name[i] > 127 ||
+		    hex_to_bin(var_name[i] & 0xff) < 0)
 			return true;
 	}
 
@@ -132,12 +132,12 @@ validate_load_option(struct efi_variable *var, int match, u8 *buffer,
 	/*
 	 * And, finally, check the filepath
 	 */
-	return validate_device_path(var, match, buffer + desclength + 6,
+	return validate_device_path(var_name, match, buffer + desclength + 6,
 				    filepathlength);
 }
 
 static bool
-validate_uint16(struct efi_variable *var, int match, u8 *buffer,
+validate_uint16(efi_char16_t *var_name, int match, u8 *buffer,
 		unsigned long len)
 {
 	/* A single 16-bit integer */
@@ -148,7 +148,7 @@ validate_uint16(struct efi_variable *var, int match, u8 *buffer,
 }
 
 static bool
-validate_ascii_string(struct efi_variable *var, int match, u8 *buffer,
+validate_ascii_string(efi_char16_t *var_name, int match, u8 *buffer,
 		      unsigned long len)
 {
 	int i;
@@ -166,7 +166,7 @@ validate_ascii_string(struct efi_variable *var, int match, u8 *buffer,
 
 struct variable_validate {
 	char *name;
-	bool (*validate)(struct efi_variable *var, int match, u8 *data,
+	bool (*validate)(efi_char16_t *var_name, int match, u8 *data,
 			 unsigned long len);
 };
 
@@ -189,10 +189,10 @@ static const struct variable_validate variable_validate[] = {
 };
 
 bool
-efivar_validate(struct efi_variable *var, u8 *data, unsigned long len)
+efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
 {
 	int i;
-	u16 *unicode_name = var->VariableName;
+	u16 *unicode_name = var_name;
 
 	for (i = 0; variable_validate[i].validate != NULL; i++) {
 		const char *name = variable_validate[i].name;
@@ -208,7 +208,7 @@ efivar_validate(struct efi_variable *var, u8 *data, unsigned long len)
 
 			/* Wildcard in the matching name means we've matched */
 			if (c == '*')
-				return variable_validate[i].validate(var,
+				return variable_validate[i].validate(var_name,
 							     match, data, len);
 
 			/* Case sensitive match */
@@ -217,7 +217,7 @@ efivar_validate(struct efi_variable *var, u8 *data, unsigned long len)
 
 			/* Reached the end of the string while matching */
 			if (!c)
-				return variable_validate[i].validate(var,
+				return variable_validate[i].validate(var_name,
 							     match, data, len);
 		}
 	}
@@ -805,7 +805,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 
 	*set = false;
 
-	if (efivar_validate(&entry->var, data, *size) == false)
+	if (efivar_validate(name, data, *size) == false)
 		return -EINVAL;
 
 	/*
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6c100ff..6a4d8e2 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -863,6 +863,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
+/* Iterate through an efi_memory_map */
+#define for_each_efi_memory_desc(m, md)					   \
+	for ((md) = (m)->map;						   \
+	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     (md) = (void *)(md) + (m)->desc_size)
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
@@ -1033,8 +1039,10 @@ struct efivars {
  * and we use a page for reading/writing.
  */
 
+#define EFI_VAR_NAME_LEN	1024
+
 struct efi_variable {
-	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
+	efi_char16_t  VariableName[EFI_VAR_NAME_LEN/sizeof(efi_char16_t)];
 	efi_guid_t    VendorGuid;
 	unsigned long DataSize;
 	__u8          Data[1024];
@@ -1116,7 +1124,7 @@ int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
 struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 				       struct list_head *head, bool remove);
 
-bool efivar_validate(struct efi_variable *var, u8 *data, unsigned long len);
+bool efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len);
 
 extern struct work_struct efivar_work;
 void efivar_run_worker(void);
