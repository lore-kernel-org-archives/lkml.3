Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3GAKS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:18:59 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45694 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3GAKS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:18:57 -0400
Date: Mon, 1 Jul 2013 12:18:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v3.11
Message-ID: <20130701101853.GA17400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

   HEAD: d3768d885c6ccbf8a137276843177d76c49033a7 x86, efi: retry ExitBootServices() on failure

Two fixes that should in principle increase robustness of our interaction 
with the EFI firmware, and a cleanup.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      efi: Convert runtime services function ptrs

Matthew Garrett (1):
      UEFI: Don't pass boot services regions to SetVirtualAddressMap()

Zach Bobroff (1):
      x86, efi: retry ExitBootServices() on failure


 arch/x86/boot/compressed/eboot.c | 20 +++++++++++++++++---
 arch/x86/include/asm/efi.h       | 28 ++++++++++++++--------------
 arch/x86/platform/efi/efi.c      |  7 +++++++
 include/linux/efi.h              | 28 ++++++++++++++--------------
 4 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 35ee62f..7c6e5d9 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1037,18 +1037,20 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 	efi_memory_desc_t *mem_map;
 	efi_status_t status;
 	__u32 desc_version;
+	bool called_exit = false;
 	u8 nr_entries;
 	int i;
 
 	size = sizeof(*mem_map) * 32;
 
 again:
-	size += sizeof(*mem_map);
+	size += sizeof(*mem_map) * 2;
 	_size = size;
 	status = low_alloc(size, 1, (unsigned long *)&mem_map);
 	if (status != EFI_SUCCESS)
 		return status;
 
+get_map:
 	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
 				mem_map, &key, &desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
@@ -1074,8 +1076,20 @@ again:
 	/* Might as well exit boot services now */
 	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
 				handle, key);
-	if (status != EFI_SUCCESS)
-		goto free_mem_map;
+	if (status != EFI_SUCCESS) {
+		/*
+		 * ExitBootServices() will fail if any of the event
+		 * handlers change the memory map. In which case, we
+		 * must be prepared to retry, but only once so that
+		 * we're guaranteed to exit on repeated failures instead
+		 * of spinning forever.
+		 */
+		if (called_exit)
+			goto free_mem_map;
+
+		called_exit = true;
+		goto get_map;
+	}
 
 	/* Historic? */
 	boot_params->alt_mem_k = 32 * 1024;
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 2fb5d58..5b33686 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -52,40 +52,40 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 		     u64 arg4, u64 arg5, u64 arg6);
 
 #define efi_call_phys0(f)			\
-	efi_call0((void *)(f))
+	efi_call0((f))
 #define efi_call_phys1(f, a1)			\
-	efi_call1((void *)(f), (u64)(a1))
+	efi_call1((f), (u64)(a1))
 #define efi_call_phys2(f, a1, a2)			\
-	efi_call2((void *)(f), (u64)(a1), (u64)(a2))
+	efi_call2((f), (u64)(a1), (u64)(a2))
 #define efi_call_phys3(f, a1, a2, a3)				\
-	efi_call3((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3))
+	efi_call3((f), (u64)(a1), (u64)(a2), (u64)(a3))
 #define efi_call_phys4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+	efi_call4((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4))
 #define efi_call_phys5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+	efi_call5((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5))
 #define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
 #define efi_call_virt0(f)				\
-	efi_call0((void *)(efi.systab->runtime->f))
+	efi_call0((efi.systab->runtime->f))
 #define efi_call_virt1(f, a1)					\
-	efi_call1((void *)(efi.systab->runtime->f), (u64)(a1))
+	efi_call1((efi.systab->runtime->f), (u64)(a1))
 #define efi_call_virt2(f, a1, a2)					\
-	efi_call2((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
+	efi_call2((efi.systab->runtime->f), (u64)(a1), (u64)(a2))
 #define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call3((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3))
 #define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call4((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4))
 #define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call5((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5))
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call6((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 55856b2..339e11f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1026,6 +1026,13 @@ void __init efi_enter_virtual_mode(void)
 			va = efi_ioremap(md->phys_addr, size,
 					 md->type, md->attribute);
 
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+			if (!va)
+				pr_err("ioremap of 0x%llX failed!\n",
+				       (unsigned long long)md->phys_addr);
+			continue;
+		}
+
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2bc0ad7..21ae6b3 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -287,20 +287,20 @@ typedef struct {
 
 typedef struct {
 	efi_table_hdr_t hdr;
-	unsigned long get_time;
-	unsigned long set_time;
-	unsigned long get_wakeup_time;
-	unsigned long set_wakeup_time;
-	unsigned long set_virtual_address_map;
-	unsigned long convert_pointer;
-	unsigned long get_variable;
-	unsigned long get_next_variable;
-	unsigned long set_variable;
-	unsigned long get_next_high_mono_count;
-	unsigned long reset_system;
-	unsigned long update_capsule;
-	unsigned long query_capsule_caps;
-	unsigned long query_variable_info;
+	void *get_time;
+	void *set_time;
+	void *get_wakeup_time;
+	void *set_wakeup_time;
+	void *set_virtual_address_map;
+	void *convert_pointer;
+	void *get_variable;
+	void *get_next_variable;
+	void *set_variable;
+	void *get_next_high_mono_count;
+	void *reset_system;
+	void *update_capsule;
+	void *query_capsule_caps;
+	void *query_variable_info;
 } efi_runtime_services_t;
 
 typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
