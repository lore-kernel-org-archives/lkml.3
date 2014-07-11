Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaGKTzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:55:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18115 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbaGKTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:55:08 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: [PATCH 2/2] arch/x86/xen: Silence compiler warnings
Date: Fri, 11 Jul 2014 21:54:21 +0200
Message-Id: <1405108461-3223-3-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405108461-3223-1-git-send-email-daniel.kiper@oracle.com>
References: <1405108461-3223-1-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiler complains in the following way when x86 32-bit kernel
with Xen support is build:

  CC      arch/x86/xen/enlighten.o
arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
arch/x86/xen/enlighten.c:1726:3: warning: right shift count >= width of type [enabled by default]

Such line contains following EFI initialization code:

boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);

There is no issue if x86 64-bit kernel is build. However, 32-bit case
generate warning (even if that code will not be executed because Xen
does not work on 32-bit EFI platforms) due to __pa() returning unsigned long
type which has 32-bits width. So move whole EFI initialization stuff
to separate function and build its body conditionally to avoid above
mentioned warning on x86 32-bit architecture.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/enlighten.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bc89647..6abec74 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1516,12 +1516,32 @@ static void __init xen_pvh_early_guest_init(void)
 #endif
 }
 
+static void __init xen_efi_init(void)
+{
+#ifdef CONFIG_XEN_EFI
+	efi_system_table_t *efi_systab_xen;
+
+	efi_systab_xen = xen_efi_probe();
+
+	if (efi_systab_xen == NULL)
+		return;
+
+	strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
+			sizeof(boot_params.efi_info.efi_loader_signature));
+	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
+	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
+
+	set_bit(EFI_BOOT, &efi.flags);
+	set_bit(EFI_PARAVIRT, &efi.flags);
+	set_bit(EFI_64BIT, &efi.flags);
+#endif
+}
+
 /* First C function to be called on Xen boot */
 asmlinkage __visible void __init xen_start_kernel(void)
 {
 	struct physdev_set_iopl set_iopl;
 	int rc;
-	efi_system_table_t *efi_systab_xen;
 
 	if (!xen_start_info)
 		return;
@@ -1717,18 +1737,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	xen_setup_runstate_info(0);
 
-	efi_systab_xen = xen_efi_probe();
-
-	if (efi_systab_xen) {
-		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
-				sizeof(boot_params.efi_info.efi_loader_signature));
-		boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
-		boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
-
-		set_bit(EFI_BOOT, &efi.flags);
-		set_bit(EFI_PARAVIRT, &efi.flags);
-		set_bit(EFI_64BIT, &efi.flags);
-	}
+	xen_efi_init();
 
 	/* Start the world */
 #ifdef CONFIG_X86_32
-- 
1.7.10.4

