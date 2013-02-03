Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3BCPQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:16:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34862 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266Ab3BCPQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 10:16:41 -0500
Message-ID: <1359904557.1822.2.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 105/128] efi: Make efi_enabled a function to query EFI
 facilities
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        Matt Fleming <matt.fleming@intel.com>, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sun, 03 Feb 2013 16:15:57 +0100
In-Reply-To: <20130203144653.313760856@decadent.org.uk>
References: <20130203144653.313760856@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4o2c639SSDGsjZRR0fMc"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4o2c639SSDGsjZRR0fMc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-02-03 at 15:48 +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Matt Fleming <matt.fleming@intel.com>
>=20
> commit 83e68189745ad931c2afd45d8ee3303929233e7f upstream.
[...]
> [bwh: Backported to 3.2:
>  - Adjust context (a lot)
>  - Add efi_is_native() function from commit 5189c2a7c776
>    ('x86: efi: Turn off efi_enabled after setup on mixed fw/kernel')
>  - Make efi_init() bail out when booted non-native, as it would previousl=
y
>    not be called in this case
>  - Drop inapplicable changes to start_kernel()]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

As you can see this needed quite a lot of work to backport, and I
haven't been able to test it yet.  So I would particularly appreciate
careful review of this.

Ben.

> ---
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -90,6 +90,7 @@ extern void __iomem *efi_ioremap(unsigne
>  #endif /* CONFIG_X86_32 */
> =20
>  extern int add_efi_memmap;
> +extern unsigned long x86_efi_facility;
>  extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
>  extern void efi_memblock_x86_reserve_range(void);
>  extern void efi_call_phys_prelog(void);
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -603,7 +603,7 @@ static void native_machine_emergency_res
>  			break;
> =20
>  		case BOOT_EFI:
> -			if (efi_enabled)
> +			if (efi_enabled(EFI_RUNTIME_SERVICES))
>  				efi.reset_system(reboot_mode ?
>  						 EFI_RESET_WARM :
>  						 EFI_RESET_COLD,
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -750,15 +750,16 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>  #ifdef CONFIG_EFI
>  	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
> -#ifdef CONFIG_X86_32
> -		     "EL32",
> -#else
> -		     "EL64",
> -#endif
> -	 4)) {
> -		efi_enabled =3D 1;
> -		efi_memblock_x86_reserve_range();
> +		     "EL32", 4)) {
> +		set_bit(EFI_BOOT, &x86_efi_facility);
> +	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
> +		     "EL64", 4)) {
> +		set_bit(EFI_BOOT, &x86_efi_facility);
> +		set_bit(EFI_64BIT, &x86_efi_facility);
>  	}
> +
> +	if (efi_enabled(EFI_BOOT))
> +		efi_memblock_x86_reserve_range();
>  #endif
> =20
>  	x86_init.oem.arch_setup();
> @@ -831,7 +832,7 @@ void __init setup_arch(char **cmdline_p)
> =20
>  	finish_e820_parsing();
> =20
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_BOOT))
>  		efi_init();
> =20
>  	dmi_scan_machine();
> @@ -914,7 +915,7 @@ void __init setup_arch(char **cmdline_p)
>  	 * The EFI specification says that boot service code won't be called
>  	 * after ExitBootServices(). This is, in fact, a lie.
>  	 */
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_MEMMAP))
>  		efi_reserve_boot_services();
> =20
>  	/* preallocate 4k for mptable mpc */
> @@ -1048,7 +1049,7 @@ void __init setup_arch(char **cmdline_p)
> =20
>  #ifdef CONFIG_VT
>  #if defined(CONFIG_VGA_CONSOLE)
> -	if (!efi_enabled || (efi_mem_type(0xa0000) !=3D EFI_CONVENTIONAL_MEMORY=
))
> +	if (!efi_enabled(EFI_BOOT) || (efi_mem_type(0xa0000) !=3D EFI_CONVENTIO=
NAL_MEMORY))
>  		conswitchp =3D &vga_con;
>  #elif defined(CONFIG_DUMMY_CONSOLE)
>  	conswitchp =3D &dummy_con;
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -49,9 +49,6 @@
>  #define EFI_DEBUG	1
>  #define PFX 		"EFI: "
> =20
> -int efi_enabled;
> -EXPORT_SYMBOL(efi_enabled);
> -
>  struct efi __read_mostly efi =3D {
>  	.mps        =3D EFI_INVALID_TABLE_ADDR,
>  	.acpi       =3D EFI_INVALID_TABLE_ADDR,
> @@ -70,9 +67,25 @@ struct efi_memory_map memmap;
>  static struct efi efi_phys __initdata;
>  static efi_system_table_t efi_systab __initdata;
> =20
> +static inline bool efi_is_native(void)
> +{
> +	return IS_ENABLED(CONFIG_X86_64) =3D=3D efi_enabled(EFI_64BIT);
> +}
> +
> +unsigned long x86_efi_facility;
> +
> +/*
> + * Returns 1 if 'facility' is enabled, 0 otherwise.
> + */
> +int efi_enabled(int facility)
> +{
> +	return test_bit(facility, &x86_efi_facility) !=3D 0;
> +}
> +EXPORT_SYMBOL(efi_enabled);
> +
>  static int __init setup_noefi(char *arg)
>  {
> -	efi_enabled =3D 0;
> +	clear_bit(EFI_BOOT, &x86_efi_facility);
>  	return 0;
>  }
>  early_param("noefi", setup_noefi);
> @@ -440,6 +453,9 @@ void __init efi_init(void)
>  	int i =3D 0;
>  	void *tmp;
> =20
> +	if (!efi_is_native())
> +		return;
> +
>  #ifdef CONFIG_X86_32
>  	efi_phys.systab =3D (efi_system_table_t *)boot_params.efi_info.efi_syst=
ab;
>  #else
> @@ -467,6 +483,8 @@ void __init efi_init(void)
>  		       efi.systab->hdr.revision >> 16,
>  		       efi.systab->hdr.revision & 0xffff);
> =20
> +	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
> +
>  	/*
>  	 * Show what we know for posterity
>  	 */
> @@ -529,6 +547,8 @@ void __init efi_init(void)
>  	early_iounmap(config_tables,
>  			  efi.systab->nr_tables * sizeof(efi_config_table_t));
> =20
> +	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
> +
>  	/*
>  	 * Check out the runtime services table. We need to map
>  	 * the runtime services table so that we can grab the physical
> @@ -552,6 +572,8 @@ void __init efi_init(void)
>  		 * virtual mode.
>  		 */
>  		efi.get_time =3D phys_efi_get_time;
> +
> +		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
>  	} else
>  		printk(KERN_ERR "Could not map the EFI runtime service "
>  		       "table!\n");
> @@ -571,6 +593,8 @@ void __init efi_init(void)
>  	if (add_efi_memmap)
>  		do_add_efi_memmap();
> =20
> +	set_bit(EFI_MEMMAP, &x86_efi_facility);
> +
>  #ifdef CONFIG_X86_32
>  	x86_platform.get_wallclock =3D efi_get_time;
>  	x86_platform.set_wallclock =3D efi_set_rtc_mmss;
> @@ -747,6 +771,7 @@ void __init efi_enter_virtual_mode(void)
>  	efi.query_capsule_caps =3D virt_efi_query_capsule_caps;
>  	if (__supported_pte_mask & _PAGE_NX)
>  		runtime_code_page_mkexec();
> +	clear_bit(EFI_MEMMAP, &x86_efi_facility);
>  	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
>  	memmap.map =3D NULL;
>  	kfree(new_memmap);
> @@ -760,6 +785,9 @@ u32 efi_mem_type(unsigned long phys_addr
>  	efi_memory_desc_t *md;
>  	void *p;
> =20
> +	if (!efi_enabled(EFI_MEMMAP))
> +		return 0;
> +
>  	for (p =3D memmap.map; p < memmap.map_end; p +=3D memmap.desc_size) {
>  		md =3D p;
>  		if ((md->phys_addr <=3D phys_addr) &&
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -255,7 +255,7 @@ acpi_physical_address __init acpi_os_get
>  		return acpi_rsdp;
>  #endif
> =20
> -	if (efi_enabled) {
> +	if (efi_enabled(EFI_CONFIG_TABLES)) {
>  		if (efi.acpi20 !=3D EFI_INVALID_TABLE_ADDR)
>  			return efi.acpi20;
>  		else if (efi.acpi !=3D EFI_INVALID_TABLE_ADDR)
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -432,7 +432,7 @@ void __init dmi_scan_machine(void)
>  	char __iomem *p, *q;
>  	int rc;
> =20
> -	if (efi_enabled) {
> +	if (efi_enabled(EFI_CONFIG_TABLES)) {
>  		if (efi.smbios =3D=3D EFI_INVALID_TABLE_ADDR)
>  			goto error;
> =20
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -1222,7 +1222,7 @@ efivars_init(void)
>  	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
>  	       EFIVARS_DATE);
> =20
> -	if (!efi_enabled)
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
>  		return 0;
> =20
>  	/* For now we'll register the efi directory at /sys/firmware/efi */
> @@ -1260,7 +1260,7 @@ err_put:
>  static void __exit
>  efivars_exit(void)
>  {
> -	if (efi_enabled) {
> +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>  		unregister_efivars(&__efivars);
>  		kobject_put(efi_kobj);
>  	}
> --- a/drivers/firmware/iscsi_ibft_find.c
> +++ b/drivers/firmware/iscsi_ibft_find.c
> @@ -99,7 +99,7 @@ unsigned long __init find_ibft_region(un
>  	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
>  	 * only use ACPI for this */
> =20
> -	if (!efi_enabled)
> +	if (!efi_enabled(EFI_BOOT))
>  		find_ibft_in_mem();
> =20
>  	if (ibft_addr) {
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -354,7 +354,8 @@ bool radeon_card_posted(struct radeon_de
>  {
>  	uint32_t reg;
> =20
> -	if (efi_enabled && rdev->pdev->subsystem_vendor =3D=3D PCI_VENDOR_ID_AP=
PLE)
> +	if (efi_enabled(EFI_BOOT) &&
> +	    rdev->pdev->subsystem_vendor =3D=3D PCI_VENDOR_ID_APPLE)
>  		return false;
> =20
>  	/* first check CRTCs */
> --- a/drivers/platform/x86/ibm_rtl.c
> +++ b/drivers/platform/x86/ibm_rtl.c
> @@ -255,7 +255,7 @@ static int __init ibm_rtl_init(void) {
>  	if (force)
>  		pr_warn("module loaded by force\n");
>  	/* first ensure that we are running on IBM HW */
> -	else if (efi_enabled || !dmi_check_system(ibm_rtl_dmi_table))
> +	else if (efi_enabled(EFI_BOOT) || !dmi_check_system(ibm_rtl_dmi_table))
>  		return -ENODEV;
> =20
>  	/* Get the address for the Extended BIOS Data Area */
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -459,7 +459,7 @@ static int __devinit isci_pci_probe(stru
>  		return -ENOMEM;
>  	pci_set_drvdata(pdev, pci_info);
> =20
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		orom =3D isci_get_efi_var(pdev);
> =20
>  	if (!orom)
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -364,17 +364,30 @@ extern int __init efi_setup_pcdp_console
>  #endif
> =20
>  /*
> - * We play games with efi_enabled so that the compiler will, if possible=
, remove
> - * EFI-related code altogether.
> + * We play games with efi_enabled so that the compiler will, if
> + * possible, remove EFI-related code altogether.
>   */
> +#define EFI_BOOT		0	/* Were we booted from EFI? */
> +#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
> +#define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
> +#define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
> +#define EFI_MEMMAP		4	/* Can we use EFI memory map? */
> +#define EFI_64BIT		5	/* Is the firmware 64-bit? */
> +
>  #ifdef CONFIG_EFI
>  # ifdef CONFIG_X86
> -   extern int efi_enabled;
> +extern int efi_enabled(int facility);
>  # else
> -#  define efi_enabled 1
> +static inline int efi_enabled(int facility)
> +{
> +	return 1;
> +}
>  # endif
>  #else
> -# define efi_enabled 0
> +static inline int efi_enabled(int facility)
> +{
> +	return 0;
> +}
>  #endif
> =20
>  /*
> --- a/init/main.c
> +++ b/init/main.c
> @@ -606,7 +606,7 @@ asmlinkage void __init start_kernel(void
>  	pidmap_init();
>  	anon_vma_init();
>  #ifdef CONFIG_X86
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
>  #endif
>  	thread_info_cache_init();
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-4o2c639SSDGsjZRR0fMc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQ5/Lee/yOyVhhEJAQpv8RAAu1plT3BM3f1ZRHSdx7/1d7beq+QUk2ZL
VMYJjSJ/PG1IxzrD0UfC9dolMOjMSyipLxD+tzFtjPYhO7lU2A+HnofZ5mPnNMmQ
QxOV945S2EHERlH2mgNDeW8pRKc1DLskVCK8YCvLZttEupdGd+3p6em0Vo7J2KNv
9CK+53lznN0qwfTtcpjal7dSiYOIdYnWwCOfPMkmd2Dn64zNs2y/DcstOXkkkyrz
Hvi/4yFf9aesR7gFB3ObpJXeVzhfO24VOTAWmZK27fTb7RbHXiRCKXb+5vajXK7U
gjObS4+LwdXvFttkHmrsNvcQlCH7TLeAcfyniNyRA24CJznEUo0SLafCjH3MlQZO
BAxVywwz3UDlKoWv0hPLN7WFkdNxjTZDiD9ErKUAIwmGa+5TmEms7lMzGF+I79j1
cRaqw2w0mClkQUyKtcwH0xbtS8Ay+uAQ8hlDXTg099jReVHpqVkI1N1T/S5YkyCC
15aWmB2sGFlb/v8C5uHXwc3XlNSHyxnJNAriJ2xQGuU+ElB5SNO18686+YT+ayO9
0Qcb4edrOSNTLjcEBBmDocJJ/LmA5hFHHmYDzcbMzAZ0A/yMSHEQpUWVSlpXzxeV
NtYp2UsG+eKyTGd6WtH0dG10mivitEsLaSklu2eu8EdGD70I8wY6sBjER8yzFbps
jIfHqWuF9sQ=
=lzku
-----END PGP SIGNATURE-----

--=-4o2c639SSDGsjZRR0fMc--
