Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbaGOL5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:57:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56333 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758039AbaGOL5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:57:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Lv Zheng <lv.zheng@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: Re: linux-next: manual merge of the pm tree with the ia64 tree
Date: Tue, 15 Jul 2014 14:15:27 +0200
Message-ID: <2083565.B2UV9LfG6j@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140715135620.2e68ee57@canb.auug.org.au>
References: <20140715135620.2e68ee57@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 15, 2014 01:56:20 PM Stephen Rothwell wrote:
> 
> --Sig_/Cs291xJCrI1kc_+PiCdNT0M
> Content-Type: text/plain; charset=US-ASCII
> Content-Transfer-Encoding: quoted-printable
> 
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> drivers/acpi/acpi_extlog.c between commits 2dfb7d51a61d ("trace, RAS:
> Add eMCA trace event interface") and d6cae935ec5b ("trace, eMCA: Add a
> knob to adjust where to save event log") from the ia64 tree and commit
> 0a00fd5e20fd ("ACPICA: Restore error table definitions to reduce code
> differences between Linux and ACPICA upstream") from the pm tree.
> 
> I fixed it up (hopefully - see below) and can carry the fix as
> necessary (no action is required).

Thanks for fixing this up!

Lv, can you please check if acpi_extlog.c is fine in linux-next?

Rafael


> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/acpi/acpi_extlog.c
> index 0ad6f389d922,340d09518f8e..000000000000
> --- a/drivers/acpi/acpi_extlog.c
> +++ b/drivers/acpi/acpi_extlog.c
> @@@ -139,12 -137,8 +139,12 @@@ static int extlog_print(struct notifier
>   	struct mce *mce =3D (struct mce *)data;
>   	int	bank =3D mce->bank;
>   	int	cpu =3D mce->extcpu;
> - 	struct acpi_generic_status *estatus, *tmp;
> - 	struct acpi_generic_data *gdata;
>  -	struct acpi_hest_generic_status *estatus;
>  -	int rc;
> ++	struct acpi_hest_generic_status *estatus, *tmp;
> ++	struct acpi_hest_generic_data *gdata;
>  +	const uuid_le *fru_id =3D &NULL_UUID_LE;
>  +	char *fru_text =3D "";
>  +	uuid_le *sec_type;
>  +	static u32 err_seq;
>  =20
>   	estatus =3D extlog_elog_entry_check(cpu, bank);
>   	if (estatus =3D=3D NULL)
> @@@ -154,29 -148,8 +154,29 @@@
>   	/* clear record status to enable BIOS to update it again */
>   	estatus->block_status =3D 0;
>  =20
> - 	tmp =3D (struct acpi_generic_status *)elog_buf;
>  -	rc =3D print_extlog_rcd(NULL, (struct acpi_hest_generic_status *)elog_bu=
> f, cpu);
> ++	tmp =3D (struct acpi_hest_generic_status *)elog_buf;
>  +
>  +	if (!ras_userspace_consumers()) {
>  +		print_extlog_rcd(NULL, tmp, cpu);
>  +		goto out;
>  +	}
>  +
>  +	/* log event via trace */
>  +	err_seq++;
> - 	gdata =3D (struct acpi_generic_data *)(tmp + 1);
> ++	gdata =3D (struct acpi_hest_generic_data *)(tmp + 1);
>  +	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
>  +		fru_id =3D (uuid_le *)gdata->fru_id;
>  +	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
>  +		fru_text =3D gdata->fru_text;
>  +	sec_type =3D (uuid_le *)gdata->section_type;
>  +	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
>  +		struct cper_sec_mem_err *mem =3D (void *)(gdata + 1);
>  +		if (gdata->error_data_length >=3D sizeof(*mem))
>  +			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
>  +					       (u8)gdata->error_severity);
>  +	}
>  =20
>  +out:
>   	return NOTIFY_STOP;
>   }
>  =20
> 
> --Sig_/Cs291xJCrI1kc_+PiCdNT0M
> Content-Type: application/pgp-signature; name=signature.asc
> Content-Disposition: attachment; filename=signature.asc
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2
> 
> iQIcBAEBCAAGBQJTxKZpAAoJEMDTa8Ir7ZwVmnIP/2g7urRq6/whsLXGDEKOlYv+
> ZhKntRYDFYCTcP3BVWoVMxVkg3FrnH4nbM72qYxQEz5CIFTxLXC6mMyBCmkq6q/7
> P1fAwUE5RbcCy9p4Iyz43qCATSSpKY5Q/Yam2KixbRWZC2UTRGE+Ku1vqNZnY1WH
> Uzf7Cb1ShsGhKDZyitrNLHCaMMv1Ds2RES+P2ry6kx8mXms5S/nTB0v/a41Osz/r
> xPSRt715NJaHKHYuuOdag4ZWOgrbZjEVuvsxyoRZT9uj+6dQc+r7VnpHQ6kMnCpt
> 1X+0rqi3czijnDlZm1FuK/18Peib0+JNbM4vYEanhMxKT1GDxhwuO7t8b3J+19Z1
> /Z6eOsaRn+rxUb5TEvSkDRFiev2itbTcYK5vKQ03RfzeGB2wPxTMvOxRMungVlFZ
> z3i5IVe+awMs5VOWIL4BkJMaQWCqfXtG9iPC22QnFLWHaoZp6d06mFXdUbkNZwhw
> 3u1SaeuoN+mKo+1GnJOfry8MCYQnqmyRbf2tH5Mk+w9THfkHc+C911p1ff0Lw/gF
> T3flTK7sRyaPtpQrGCK8W74++b75Y/98XQ4N4bb2MJrym7yT3kh2avQMpQKNG3GO
> pTJKpKwvp5H3hbYl+CpOJ4i5EAlvG11qstwcih+nFPXebcEfspHRoeHInxgg+zDT
> Sj9YngNGGQR1//SaTD67
> =oSfG
> -----END PGP SIGNATURE-----
> 
> --Sig_/Cs291xJCrI1kc_+PiCdNT0M--
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
