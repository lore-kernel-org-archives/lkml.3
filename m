Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaFMRCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:02:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36401 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaFMRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:02:08 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de
Subject: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Date: Fri, 13 Jun 2014 19:00:18 +0200
Message-Id: <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce EFI_NO_DIRECT flag. If it is set then kernel runs
on EFI platform but it has not direct control on EFI stuff
like EFI runtime, tables, structures, etc. If not this means
that Linux Kernel has direct access to EFI infrastructure
and everything runs as usual.

This functionality is used in Xen dom0 because hypervisor
has full control on EFI stuff and all calls from dom0 to
EFI must be requested via special hypercall which in turn
executes relevant EFI code in behalf of dom0.

v5 - suggestions/fixes:
   - rename EFI_DIRECT to EFI_NO_DIRECT
     (suggested by David Vrabel),
   - limit EFI_NO_DIRECT usage
     (suggested by Jan Beulich and Matt Fleming),
   - improve commit message
     (suggested by David Vrabel).

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/platform/efi/efi.c |   27 +++++++++++++++++++++------
 drivers/firmware/efi/efi.c  |   22 +++++++++++++---------
 include/linux/efi.h         |    3 ++-
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dd1e351..e3d9d76 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -350,6 +350,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	struct efi_info *e = &boot_params.efi_info;
 	unsigned long pmap;
 
+	if (efi_enabled(EFI_NO_DIRECT))
+		return 0;
+
 #ifdef CONFIG_X86_32
 	/* Can't handle data above 4GB at this time */
 	if (e->efi_memmap_hi) {
@@ -617,13 +620,16 @@ static int __init efi_runtime_init(void)
 	 * address of several of the EFI runtime functions, needed to
 	 * set the firmware into virtual mode.
 	 */
-	if (efi_enabled(EFI_64BIT))
-		rv = efi_runtime_init64();
-	else
-		rv = efi_runtime_init32();
 
-	if (rv)
-		return rv;
+	if (!efi_enabled(EFI_NO_DIRECT)) {
+		if (efi_enabled(EFI_64BIT))
+			rv = efi_runtime_init64();
+		else
+			rv = efi_runtime_init32();
+
+		if (rv)
+			return rv;
+	}
 
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
@@ -632,6 +638,9 @@ static int __init efi_runtime_init(void)
 
 static int __init efi_memmap_init(void)
 {
+	if (efi_enabled(EFI_NO_DIRECT))
+		return 0;
+
 	/* Map the EFI memory map */
 	memmap.map = early_memremap((unsigned long)memmap.phys_map,
 					memmap.nr_map * memmap.desc_size);
@@ -1188,6 +1197,9 @@ static void __init __efi_enter_virtual_mode(void)
 
 void __init efi_enter_virtual_mode(void)
 {
+	if (efi_enabled(EFI_NO_DIRECT))
+		return;
+
 	if (efi_setup)
 		kexec_enter_virtual_mode();
 	else
@@ -1220,6 +1232,9 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	efi_memory_desc_t *md;
 	void *p;
 
+	if (!efi_enabled(EFI_MEMMAP))
+		return 0;
+
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if ((md->phys_addr <= phys_addr) &&
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 023937a..8bb1075 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -104,16 +104,20 @@ static struct attribute *efi_subsys_attrs[] = {
 static umode_t efi_attr_is_visible(struct kobject *kobj,
 				   struct attribute *attr, int n)
 {
-	umode_t mode = attr->mode;
-
-	if (attr == &efi_attr_fw_vendor.attr)
-		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
-	else if (attr == &efi_attr_runtime.attr)
-		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
-	else if (attr == &efi_attr_config_table.attr)
-		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	if (attr == &efi_attr_fw_vendor.attr) {
+		if (efi_enabled(EFI_NO_DIRECT) ||
+				efi.fw_vendor == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	} else if (attr == &efi_attr_runtime.attr) {
+		if (efi_enabled(EFI_NO_DIRECT) ||
+				efi.runtime == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	} else if (attr == &efi_attr_config_table.attr) {
+		if (efi.config_table == EFI_INVALID_TABLE_ADDR)
+			return 0;
+	}
 
-	return mode;
+	return attr->mode;
 }
 
 static struct attribute_group efi_subsys_attr_group = {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 41bbf8b..e917c4a 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -916,7 +916,8 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
-#define EFI_ARCH_1		6	/* First arch-specific bit */
+#define EFI_NO_DIRECT		6	/* Can we access EFI directly? */
+#define EFI_ARCH_1		7	/* First arch-specific bit */
 
 #ifdef CONFIG_EFI
 /*
-- 
1.7.10.4

