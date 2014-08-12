Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaHLGN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:13:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbaHLGNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:13:07 -0400
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 4/5] efi x86: clear EFI_RUNTIME_SERVICES bit in case failures other than SetVirtualAddressMap
Date: Tue, 12 Aug 2014 14:10:21 +0800
Message-Id: <1407823822-23829-4-git-send-email-dyoung@redhat.com>
In-Reply-To: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If enter virtual mode failed due to some reason other than the efi call
the EFI_RUNTIME_SERVICES bit in efi.flags should be cleared thus users
of efi runtime services can check the bit and handle the case instead of
assume efi runtime is ok.

Per Matt, if efi call SetVirtualAddressMap fails we will be not sure it's safe
to make any assumptions about the state of the system. so kernel panics instead
of clears EFI_RUNTIME_SERVICES bit.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index eae91be..c42f49b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -724,6 +724,7 @@ static void __init kexec_enter_virtual_mode(void)
 	 */
 	if (!efi_is_native()) {
 		efi_unmap_memmap();
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
 
@@ -797,6 +798,7 @@ static void __init __efi_enter_virtual_mode(void)
 	new_memmap = efi_map_regions(&count, &pg_shift);
 	if (!new_memmap) {
 		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
 
@@ -804,8 +806,10 @@ static void __init __efi_enter_virtual_mode(void)
 
 	BUG_ON(!efi.systab);
 
-	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
+	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift)) {
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
+	}
 
 	efi_sync_low_kernel_mappings();
 	efi_dump_pagetable();
@@ -882,8 +886,10 @@ static void __init __efi_enter_virtual_mode(void)
 
 void __init efi_enter_virtual_mode(void)
 {
-	if (efi_enabled(EFI_PARAVIRT))
+	if (efi_enabled(EFI_PARAVIRT)) {
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
+	}
 
 	if (efi_setup)
 		kexec_enter_virtual_mode();
-- 
1.8.3.1

