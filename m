Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbaKYUzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:55:03 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61966 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750869AbaKYUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:55:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Hanjun Guo <hanjun.guo@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: manual merge of the tip tree with the pm tree
Date: Tue, 25 Nov 2014 22:16:13 +0100
Message-ID: <1793317.oUQRzfcXxI@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141125164640.05d99ea5@canb.auug.org.au>
References: <20141125164640.05d99ea5@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 25, 2014 04:46:40 PM Stephen Rothwell wrote:
> 
> --Sig_/T.+7iMvUwEH92u+UTGF86Po
> Content-Type: text/plain; charset=US-ASCII
> Content-Transfer-Encoding: quoted-printable
> 
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> drivers/acpi/processor_core.c between commit 9d48ea9f967b ("ACPI /
> processor: Convert apic_id to phys_id to make it arch agnostic") from
> the pm tree and commits 5922b6f497ed ("ACPI: Fix minor syntax issues in
> processor_core.c") and 717ed6192d16 ("ACPI: Add interfaces to parse
> IOAPIC ID for IOAPIC hotplug") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Since the material in my acpi-processor branch is only a cleanup, I'm
dropping it from linux-next.  We'll rebase it and apply it later when
the IOAPIC hotplug stuff settles.

Rafael


> diff --cc drivers/acpi/processor_core.c
> index 0f6f73ed41f2,f124cbb491d9..000000000000
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@@ -67,19 -86,12 +86,12 @@@ static int map_lsapic_id(struct acpi_su
>   static int map_madt_entry(int type, u32 acpi_id)
>   {
>   	unsigned long madt_end, entry;
> - 	static struct acpi_table_madt *madt;
> - 	static int read_madt;
>  -	int apic_id =3D -1;
>  +	int phys_id =3D -1;	/* CPU hardware ID */
> + 	struct acpi_table_madt *madt;
>  =20
> - 	if (!read_madt) {
> - 		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
> - 					(struct acpi_table_header **)&madt)))
> - 			madt =3D NULL;
> - 		read_madt++;
> - 	}
> -=20
> + 	madt =3D get_madt_table();
>   	if (!madt)
>  -		return apic_id;
>  +		return phys_id;
>  =20
>   	entry =3D (unsigned long)madt;
>   	madt_end =3D entry + madt->header.length;
> @@@ -125,13 -137,12 +137,12 @@@ static int map_mat_entry(acpi_handle ha
>   	}
>  =20
>   	header =3D (struct acpi_subtable_header *)obj->buffer.pointer;
> - 	if (header->type =3D=3D ACPI_MADT_TYPE_LOCAL_APIC) {
> + 	if (header->type =3D=3D ACPI_MADT_TYPE_LOCAL_APIC)
>  -		map_lapic_id(header, acpi_id, &apic_id);
>  +		map_lapic_id(header, acpi_id, &phys_id);
> - 	} else if (header->type =3D=3D ACPI_MADT_TYPE_LOCAL_SAPIC) {
> + 	else if (header->type =3D=3D ACPI_MADT_TYPE_LOCAL_SAPIC)
>  -		map_lsapic_id(header, type, acpi_id, &apic_id);
>  +		map_lsapic_id(header, type, acpi_id, &phys_id);
> - 	} else if (header->type =3D=3D ACPI_MADT_TYPE_LOCAL_X2APIC) {
> + 	else if (header->type =3D=3D ACPI_MADT_TYPE_LOCAL_X2APIC)
>  -		map_x2apic_id(header, type, acpi_id, &apic_id);
>  +		map_x2apic_id(header, type, acpi_id, &phys_id);
> - 	}
>  =20
>   exit:
>   	kfree(buffer.pointer);
> @@@ -197,10 -208,103 +208,103 @@@ int acpi_map_cpuid(int phys_id, u32 acp
>  =20
>   int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
>   {
>  -	int apic_id;
>  +	int phys_id;
>  =20
>  -	apic_id =3D acpi_get_apicid(handle, type, acpi_id);
>  +	phys_id =3D acpi_get_phys_id(handle, type, acpi_id);
>  =20
>  -	return acpi_map_cpuid(apic_id, acpi_id);
>  +	return acpi_map_cpuid(phys_id, acpi_id);
>   }
>   EXPORT_SYMBOL_GPL(acpi_get_cpuid);
> +=20
> + #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
> + static int get_ioapic_id(struct acpi_subtable_header *entry, u32 gsi_base,
> + 			 u64 *phys_addr, int *ioapic_id)
> + {
> + 	struct acpi_madt_io_apic *ioapic =3D (struct acpi_madt_io_apic *)entry;
> +=20
> + 	if (ioapic->global_irq_base !=3D gsi_base)
> + 		return 0;
> +=20
> + 	*phys_addr =3D ioapic->address;
> + 	*ioapic_id =3D ioapic->id;
> + 	return 1;
> + }
> +=20
> + static int parse_madt_ioapic_entry(u32 gsi_base, u64 *phys_addr)
> + {
> + 	struct acpi_subtable_header *hdr;
> + 	unsigned long madt_end, entry;
> + 	struct acpi_table_madt *madt;
> + 	int apic_id =3D -1;
> +=20
> + 	madt =3D get_madt_table();
> + 	if (!madt)
> + 		return apic_id;
> +=20
> + 	entry =3D (unsigned long)madt;
> + 	madt_end =3D entry + madt->header.length;
> +=20
> + 	/* Parse all entries looking for a match. */
> + 	entry +=3D sizeof(struct acpi_table_madt);
> + 	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
> + 		hdr =3D (struct acpi_subtable_header *)entry;
> + 		if (hdr->type =3D=3D ACPI_MADT_TYPE_IO_APIC &&
> + 		    get_ioapic_id(hdr, gsi_base, phys_addr, &apic_id))
> + 			break;
> + 		else
> + 			entry +=3D hdr->length;
> + 	}
> +=20
> + 	return apic_id;
> + }
> +=20
> + static int parse_mat_ioapic_entry(acpi_handle handle, u32 gsi_base,
> + 				  u64 *phys_addr)
> + {
> + 	struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER, NULL };
> + 	struct acpi_subtable_header *header;
> + 	union acpi_object *obj;
> + 	int apic_id =3D -1;
> +=20
> + 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
> + 		goto exit;
> +=20
> + 	if (!buffer.length || !buffer.pointer)
> + 		goto exit;
> +=20
> + 	obj =3D buffer.pointer;
> + 	if (obj->type !=3D ACPI_TYPE_BUFFER ||
> + 	    obj->buffer.length < sizeof(struct acpi_subtable_header))
> + 		goto exit;
> +=20
> + 	header =3D (struct acpi_subtable_header *)obj->buffer.pointer;
> + 	if (header->type =3D=3D ACPI_MADT_TYPE_IO_APIC)
> + 		get_ioapic_id(header, gsi_base, phys_addr, &apic_id);
> +=20
> + exit:
> + 	kfree(buffer.pointer);
> + 	return apic_id;
> + }
> +=20
> + /**
> +  * acpi_get_ioapic_id - Get IOAPIC ID and physical address matching @gsi_=
> base
> +  * @handle:	ACPI object for IOAPIC device
> +  * @gsi_base:	GSI base to match with
> +  * @phys_addr:	Pointer to store physical address of matching IOAPIC record
> +  *
> +  * Walk resources returned by ACPI_MAT method, then ACPI MADT table, to s=
> earch
> +  * for an ACPI IOAPIC record matching @gsi_base.
> +  * Return IOAPIC id and store physical address in @phys_addr if found a m=
> atch,
> +  * otherwise return <0.
> +  */
> + int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr)
> + {
> + 	int apic_id;
> +=20
> + 	apic_id =3D parse_mat_ioapic_entry(handle, gsi_base, phys_addr);
> + 	if (apic_id =3D=3D -1)
> + 		apic_id =3D parse_madt_ioapic_entry(gsi_base, phys_addr);
> +=20
> + 	return apic_id;
> + }
> + #endif /* CONFIG_ACPI_HOTPLUG_IOAPIC */
> 
> --Sig_/T.+7iMvUwEH92u+UTGF86Po
> Content-Type: application/pgp-signature
> Content-Description: OpenPGP digital signature
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2
> 
> iQIcBAEBCAAGBQJUdBfGAAoJEMDTa8Ir7ZwVeAMP/jT/rc43RxXIRBIBOb9oWDuE
> NTEMECD6ziGKOS2fqz+BqdAEDLi+wdYn3ba52U8SHTXBFN63lQc5ISQ+EUpeR7Pb
> jp5i9BiiL2RPPNSjQNZ8x1EZSnnGkIo9DwfH3uq75SwTDT+a8kMH618QGb0oDasY
> duafSmDbvVSxPZevxWtCsdLjU52ssB64PKUiugCBJyhup4JQW8wWdZ30w7AkUbUQ
> sBFtR01BXtLZ/wNX971821APvs/c/rZHE6a6cZoasN98E4p38k0pGcLrcUGiqdIO
> ORckMzsQghFj1gAMxzyHRg1c09ORuE19AZlAHF4W2nKJ18tW66/QG8+HCk+Z3R8z
> zkfOm5QFuQbYLoMyhyZ2HTZrxK2hkBVo6GNCmCpYBL0QpK/N2QU02A9lcNfFkYqm
> LX+IERxyEd1z1oNust3svRr5NKU3BEbdfXblAYtUIORTws+YDkZrc7SyksdCSIOa
> az7mmTxDcR/uQ8K/7SVO/D3nlutZm8MkYb5gFCbBaI7O5rmRACDMgYGlh0vCZ2dL
> tes0YBlsTBPWcHxb+/y6IsFs6HEZrPKPAQUu4wPJmcRb8PuJ95gxwUODSmf2duxL
> HJOWkci/j/ViNmJ/paVuI5MpJyHUMBf6oo/ze1IkL/4PKK2b4+drvyCY9KwV7Mjn
> dLsMDuJV/i959NkJa4EE
> =+Uu8
> -----END PGP SIGNATURE-----
> 
> --Sig_/T.+7iMvUwEH92u+UTGF86Po--
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
