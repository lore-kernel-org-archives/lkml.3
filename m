Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaHFNGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:06:30 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:46512 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaHFNG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:06:28 -0400
Date: Wed, 6 Aug 2014 14:06:23 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Dave Young <dyoung@redhat.com>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, matt.fleming@intel.com,
        ard.biesheuvel@linaro.org, msalter@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140806130623.GI4179@bivouac.eciton.net>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 04:38:25PM +0800, Dave Young wrote:
> 
> Adding a noefi boot param like in X86 to disable efi runtime services support.
> 
> This will be useful for debugging uefi problems. Also it will be useful
> for later kexec/kdump work. Kexec on uefi support in X86 depends on a fixed vm
> area specific for uefi runtime 1:1 mapping, kernel will switch to a different
> page table for any uefi runtime callback in virtual mode. In arm64 similar
> work probably is necessary. But kexec boot will just works with 'noefi' with
> the limitaion of lacking runtime services. The runtime services is not critical
> for kdump kernel for now. So as for kexec/kdump just leave the 1:1 mapping a
> future work.

Since this is really turning an x86-specific feature into a generic
one, could it be moved to core code?
Maybe an efi.mask, reusing the efi_enabled defines, with an
efi_disabled macro?

Also, since this patch (and its x86 predecessor) is not really
"noefi", could this be integrated with the "efi=" patch
(http://permalink.gmane.org/gmane.linux.kernel.efi/4405),
as an efi=noruntime option?

On x86, due to CSM, "noefi" was a useful fallback for completely
broken (U)EFI implementations - but on an arm* UEFI system, there will
be no fallback. Could it be wrapped in a kernel hacking config option?

Partial code description, not even compile tested:
---
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 14db1f6..a295a5c 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -386,7 +386,7 @@ static int __init arm64_enter_virtual_mode(void)
 	int count = 0;
 	unsigned long flags;
 
-	if (!efi_enabled(EFI_BOOT)) {
+	if (!efi_enabled(EFI_BOOT) || efi_disabled(EFI_RUNTIME_SERVICES)) {
 		pr_info("EFI services will not be available.\n");
 		return -1;
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 87fc96b..b59a7c6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -77,14 +77,6 @@ static efi_config_table_type_t arch_tables[] __initdata = {
 
 u64 efi_setup;		/* efi setup_data physical address */
 
-static bool disable_runtime __initdata = false;
-static int __init setup_noefi(char *arg)
-{
-	disable_runtime = true;
-	return 0;
-}
-early_param("noefi", setup_noefi);
-
 int add_efi_memmap;
 EXPORT_SYMBOL(add_efi_memmap);
 
@@ -764,7 +756,7 @@ void __init efi_init(void)
 	if (!efi_runtime_supported())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
-		if (disable_runtime || efi_runtime_init())
+		if (efi_disabled(EFI_RUNTIME_SERVICES) || efi_runtime_init())
 			return;
 	}
 	if (efi_memmap_init())
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index dc79346..ffc4a45 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -43,6 +43,15 @@ EXPORT_SYMBOL(efi);
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
+static int __init setup_noefi(char *arg)
+{
+#if defined(CONFIG_X86) || defined(CONFIG_EFI_DEBUG)
+	set_bit(EFI_RUNTIME_SERVICES, &efi.mask);
+#endif
+	return 0;
+}
+early_param("noefi", setup_noefi);
+
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 41bbf8b..9533d0e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -826,6 +826,7 @@ extern struct efi {
 	efi_set_virtual_address_map_t *set_virtual_address_map;
 	struct efi_memory_map *memmap;
 	unsigned long flags;
+	unsigned long mask;
 } efi;
 
 static inline int
@@ -926,6 +927,10 @@ static inline bool efi_enabled(int feature)
 {
 	return test_bit(feature, &efi.flags) != 0;
 }
+static inline bool efi_disabled(int feature)
+{
+	return test_bit(feature, &efi.mask) == 0;
+}
 #else
 static inline bool efi_enabled(int feature)
 {
---

/
    Leif

> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/arm64/kernel/efi.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/arm64/kernel/efi.c
> ===================================================================
> --- linux-2.6.orig/arch/arm64/kernel/efi.c
> +++ linux-2.6/arch/arm64/kernel/efi.c
> @@ -31,6 +31,14 @@ static efi_runtime_services_t *runtime;
>  
>  static u64 efi_system_table;
>  
> +static bool disable_runtime __initdata = false;
> +static int __init setup_noefi(char *arg)
> +{
> +	disable_runtime = true;
> +	return 0;
> +}
> +early_param("noefi", setup_noefi);
> +
>  static int uefi_debug __initdata;
>  static int __init uefi_debug_setup(char *str)
>  {
> @@ -391,11 +399,14 @@ static int __init arm64_enter_virtual_mo
>  		return -1;
>  	}
>  
> -	pr_info("Remapping and enabling EFI services.\n");
> -
> -	/* replace early memmap mapping with permanent mapping */
>  	mapsize = memmap.map_end - memmap.map;
>  	early_memunmap(memmap.map, mapsize);
> +
> +	if (disable_runtime)
> +		return -ENODEV;
> +
> +	pr_info("Remapping and enabling EFI services.\n");
> +	/* replace early memmap mapping with permanent mapping */
>  	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
>  						   mapsize);
>  	memmap.map_end = memmap.map + mapsize;
