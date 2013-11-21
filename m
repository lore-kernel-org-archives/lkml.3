Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3KUVCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:02:07 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:38303 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3KUVBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:01:43 -0500
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Cc: penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com,
        jerry.hoemann@hp.com
Subject: [RFC v2 2/2] x86, efi: Early use of boot service memory
Date: Thu, 21 Nov 2013 14:01:26 -0700
Message-Id: <1385067686-73500-3-git-send-email-jerry.hoemann@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform have firmware that violate the UEFI spec and access boot service
code or data segments after the system has called ExitBootServices().
The call to efi_reserve_boot_services is a workaround to avoid using
boot service memory until after the kernel has done SetVirtualAddressMap().
However, this reservation fragments memory which can cause
large allocations early in boot (e.g. crash kernel) to fail.

When reserve_crashkernel fails, kdump is disabled.

This patch creates a quirk list that governs when the workaround,
efi_reserve_boot_services, is called.

For all firmware released prior to 2014, the workaround will be
called unless an entry for the platform is in the quirk list saying
not to do the workaround.

For all firmware released 2014 and later,  the workaround will not
be called unless an entry for the platform is in the quirk list
saying to call the workaround.

A new kernel parameter is implemented which overrides the default
handling described above and provides an explicit method to control
whether or not the workaround is applied.   This argument allows
developers to determine on new systems whether the quirk needs
to be applied or not.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
---
 Documentation/kernel-parameters.txt |  5 +++
 arch/x86/kernel/setup.c             |  5 ++-
 arch/x86/platform/efi/efi.c         | 77 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fcbb736..9b2be92 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -894,6 +894,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			you are really sure that your UEFI does sane gc and
 			fulfills the spec otherwise your board may brick.
 
+	efi_quirk=	[EFI; X86] Manual override for EFI quirk testing.
+			Format: { "reserve" | "noreserve" }
+			"reserve": Force BootService Code/Data to be reserved.
+			"noreserve": Force BootService Code/Data to not be reserved.
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..74389f8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -995,6 +995,9 @@ void __init setup_arch(char **cmdline_p)
 	dmi_scan_machine();
 	dmi_set_dump_stack_arch_desc();
 
+	if (efi_enabled(EFI_BOOT))
+		efi_quirks();
+
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_scan_machine, for the BP.
@@ -1074,7 +1077,7 @@ void __init setup_arch(char **cmdline_p)
 	 * The EFI specification says that boot service code won't be called
 	 * after ExitBootServices(). This is, in fact, a lie.
 	 */
-	if (efi_enabled(EFI_MEMMAP))
+	if (efi_enabled(EFI_MEMMAP) && efi_enabled(EFI_QUIRK_RESERVE_BSCD))
 		efi_reserve_boot_services();
 
 	/* preallocate 4k for mptable mpc */
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..0e2c46e 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -42,6 +42,7 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#include <linux/dmi.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -107,6 +108,22 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
 
+
+int efi_reserve_quirk = 0;
+EXPORT_SYMBOL(efi_reserve_quirk);
+
+static int __init setup_efi_quirk(char *arg)
+{
+	if (arg && strstr(arg, "noreserve"))
+		efi_reserve_quirk = -1;
+	else if (arg && strstr(arg, "reserve"))
+		efi_reserve_quirk = 1;
+
+	return 0;
+}
+early_param("efi_quirk", setup_efi_quirk);
+
+
 static bool efi_no_storage_paranoia;
 
 static int __init setup_storage_paranoia(char *arg)
@@ -422,6 +439,8 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
+static bool efi_boot_services_reservations;
+
 void __init efi_reserve_boot_services(void)
 {
 	void *p;
@@ -449,8 +468,10 @@ void __init efi_reserve_boot_services(void)
 			memblock_dbg("Could not reserve boot range "
 					"[0x%010llx-0x%010llx]\n",
 						start, start+size-1);
-		} else
+		} else {
 			memblock_reserve(start, size);
+			efi_boot_services_reservations = true;
+		}
 	}
 }
 
@@ -467,7 +488,7 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_is_native())
+	if (!efi_is_native() || !efi_boot_services_reservations)
 		return;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -484,6 +505,7 @@ void __init efi_free_boot_services(void)
 			continue;
 
 		free_bootmem_late(start, size);
+		efi_boot_services_reservations = false;
 	}
 
 	efi_unmap_memmap();
@@ -704,6 +726,32 @@ static int __init efi_memmap_init(void)
 	return 0;
 }
 
+static int __init clr_reserve_bootservice_cd(const struct dmi_system_id *id)
+{
+	clear_bit(EFI_QUIRK_RESERVE_BSCD, &x86_efi_facility);
+	return 0;
+}
+
+static int __init set_reserve_bootservice_cd(const struct dmi_system_id *id)
+{
+	set_bit(EFI_QUIRK_RESERVE_BSCD, &x86_efi_facility);
+	return 0;
+}
+
+
+static const struct dmi_system_id efi_fw_quirks[] __initconst = {
+	{
+		.callback = clr_reserve_bootservice_cd,
+		.ident = "HP CB920s x1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TBD HPServer x1"),
+		},
+	},
+	{}
+};
+
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -780,6 +828,31 @@ void __init efi_init(void)
 #endif
 }
 
+void __init efi_quirks(void)
+{
+	int year;
+
+	if (dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL) && year < 2014)
+		set_bit(EFI_QUIRK_RESERVE_BSCD, &x86_efi_facility);
+
+	dmi_check_system(efi_fw_quirks);
+
+	/*
+	 * If user specifies "efi_quirk=reserve" or "efi_quirk=noreserve"
+	 * explicitly, that takes precedence over anything we figured
+	 * out above.
+	 */
+	switch (efi_reserve_quirk) {
+	case -1:
+		clear_bit(EFI_QUIRK_RESERVE_BSCD, &x86_efi_facility);
+		break;
+	case  1:
+		set_bit(EFI_QUIRK_RESERVE_BSCD, &x86_efi_facility);
+		break;
+	}
+}
+
+
 void __init efi_late_init(void)
 {
 	efi_bgrt_init();
-- 
1.7.11.3

