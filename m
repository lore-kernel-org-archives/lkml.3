Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaBOTrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:47:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40718 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaBOTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:47:51 -0500
Date: Sat, 15 Feb 2014 11:46:55 -0800
Message-Id: <201402151946.s1FJktK0028092@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 EFI fixes for v3.14-rc3
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Triplett <josh@joshtriplett.org>, Lejun Zhu <lejun.zhu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Madper Xie <cxie@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 15 Feb 2014 11:47:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few more EFI-related fixes.

The following changes since commit 4640c7ee9b8953237d05a61ea3ea93981d1bc961:

  x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off (2014-02-13 08:40:52 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 31fce91e7afc25c666276f65f019bc13fd27e216:

  Merge remote-tracking branch 'efi/urgent' into x86/urgent (2014-02-14 11:11:18 -0800)

----------------------------------------------------------------

Borislav Petkov (1):
      x86/efi: Fix 32-bit fallout

H. Peter Anvin (1):
      Merge remote-tracking branch 'efi/urgent' into x86/urgent

Matt Fleming (1):
      x86/efi: Check status field to validate BGRT header

 arch/x86/include/asm/efi.h       | 2 ++
 arch/x86/platform/efi/efi-bgrt.c | 2 +-
 arch/x86/platform/efi/efi.c      | 5 ++---
 arch/x86/platform/efi/efi_32.c   | 6 ++++++
 arch/x86/platform/efi/efi_64.c   | 9 +++++++++
 5 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 3b978c472d08..3d6b9f81cc68 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -132,6 +132,8 @@ extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
+extern void __init runtime_code_page_mkexec(void);
+extern void __init efi_runtime_mkexec(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index 4df9591eadad..f15103dff4b4 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -42,7 +42,7 @@ void __init efi_bgrt_init(void)
 
 	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
 		return;
-	if (bgrt_tab->version != 1)
+	if (bgrt_tab->version != 1 || bgrt_tab->status != 1)
 		return;
 	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
 		return;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d62ec87a2b26..1a201ac7cef8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -792,7 +792,7 @@ void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 		set_memory_nx(addr, npages);
 }
 
-static void __init runtime_code_page_mkexec(void)
+void __init runtime_code_page_mkexec(void)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -1069,8 +1069,7 @@ void __init efi_enter_virtual_mode(void)
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 
-	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
-		runtime_code_page_mkexec();
+	efi_runtime_mkexec();
 
 	kfree(new_memmap);
 
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 249b183cf417..0b74cdf7f816 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -77,3 +77,9 @@ void efi_call_phys_epilog(void)
 
 	local_irq_restore(efi_rt_eflags);
 }
+
+void __init efi_runtime_mkexec(void)
+{
+	if (__supported_pte_mask & _PAGE_NX)
+		runtime_code_page_mkexec();
+}
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6284f158a47d..0c2a234fef1e 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -233,3 +233,12 @@ void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 {
 	efi_setup = phys_addr + sizeof(struct setup_data);
 }
+
+void __init efi_runtime_mkexec(void)
+{
+	if (!efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
+	if (__supported_pte_mask & _PAGE_NX)
+		runtime_code_page_mkexec();
+}
