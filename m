Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbbABKjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:39:01 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:10256 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750737AbbABKi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:38:59 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 02 Jan 2015 10:38:58 +0000
Message-ID: <54A67541.7040707@imgtec.com>
Date: Fri, 2 Jan 2015 10:38:57 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>
CC: Paul Burton <paul.burton@imgtec.com>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        John Crispin <blogic@openwrt.org>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: mips: kernel: traps:  Remove some unused functions
References: <1420134507-540-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420134507-540-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="AdNFbwDBQv4LJPsSwtAbWOCfHf7BhK1to"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: da4c5968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AdNFbwDBQv4LJPsSwtAbWOCfHf7BhK1to
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/01/15 17:48, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> do_bp() do_ftlb() do_dsp() do_mcheck() do_mdmx() do_msa() do_msa_fpe()
>=20
> This was partially found by using a static code analysis program called=
 cppcheck.

To elaborate on Leonid's comment, These functions are used from
arch/mips/kernel/genex.S. See BUILD_HANDLER assembly macro. Each one
builds a handle_* assembly function which saves appropriate exception
state and calls do_*() with return address pointing to
ret_from_exception. The handle_* functions are set as handlers for
various exceptions by set_except_vector() in arch/mips/kernel/traps.c.

Cheers
James

>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital=
=2Ese>
> ---
>  arch/mips/kernel/traps.c |  185 --------------------------------------=
--------
>  1 file changed, 185 deletions(-)
>=20
> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index 22b19c2..59c8e0d 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -854,85 +854,6 @@ static void do_trap_or_bp(struct pt_regs *regs, un=
signed int code,
>  	}
>  }
> =20
> -asmlinkage void do_bp(struct pt_regs *regs)
> -{
> -	unsigned int opcode, bcode;
> -	enum ctx_state prev_state;
> -	unsigned long epc;
> -	u16 instr[2];
> -	mm_segment_t seg;
> -
> -	seg =3D get_fs();
> -	if (!user_mode(regs))
> -		set_fs(KERNEL_DS);
> -
> -	prev_state =3D exception_enter();
> -	if (get_isa16_mode(regs->cp0_epc)) {
> -		/* Calculate EPC. */
> -		epc =3D exception_epc(regs);
> -		if (cpu_has_mmips) {
> -			if ((__get_user(instr[0], (u16 __user *)msk_isa16_mode(epc)) ||
> -			    (__get_user(instr[1], (u16 __user *)msk_isa16_mode(epc + 2)))))=

> -				goto out_sigsegv;
> -			opcode =3D (instr[0] << 16) | instr[1];
> -		} else {
> -			/* MIPS16e mode */
> -			if (__get_user(instr[0],
> -				       (u16 __user *)msk_isa16_mode(epc)))
> -				goto out_sigsegv;
> -			bcode =3D (instr[0] >> 6) & 0x3f;
> -			do_trap_or_bp(regs, bcode, "Break");
> -			goto out;
> -		}
> -	} else {
> -		if (__get_user(opcode,
> -			       (unsigned int __user *) exception_epc(regs)))
> -			goto out_sigsegv;
> -	}
> -
> -	/*
> -	 * There is the ancient bug in the MIPS assemblers that the break
> -	 * code starts left to bit 16 instead to bit 6 in the opcode.
> -	 * Gas is bug-compatible, but not always, grrr...
> -	 * We handle both cases with a simple heuristics.  --macro
> -	 */
> -	bcode =3D ((opcode >> 6) & ((1 << 20) - 1));
> -	if (bcode >=3D (1 << 10))
> -		bcode >>=3D 10;
> -
> -	/*
> -	 * notify the kprobe handlers, if instruction is likely to
> -	 * pertain to them.
> -	 */
> -	switch (bcode) {
> -	case BRK_KPROBE_BP:
> -		if (notify_die(DIE_BREAK, "debug", regs, bcode,
> -			       regs_to_trapnr(regs), SIGTRAP) =3D=3D NOTIFY_STOP)
> -			goto out;
> -		else
> -			break;
> -	case BRK_KPROBE_SSTEPBP:
> -		if (notify_die(DIE_SSTEPBP, "single_step", regs, bcode,
> -			       regs_to_trapnr(regs), SIGTRAP) =3D=3D NOTIFY_STOP)
> -			goto out;
> -		else
> -			break;
> -	default:
> -		break;
> -	}
> -
> -	do_trap_or_bp(regs, bcode, "Break");
> -
> -out:
> -	set_fs(seg);
> -	exception_exit(prev_state);
> -	return;
> -
> -out_sigsegv:
> -	force_sig(SIGSEGV, current);
> -	goto out;
> -}
> -
>  asmlinkage void do_tr(struct pt_regs *regs)
>  {
>  	u32 opcode, tcode =3D 0;
> @@ -1297,46 +1218,6 @@ out:
>  	exception_exit(prev_state);
>  }
> =20
> -asmlinkage void do_msa_fpe(struct pt_regs *regs)
> -{
> -	enum ctx_state prev_state;
> -
> -	prev_state =3D exception_enter();
> -	die_if_kernel("do_msa_fpe invoked from kernel context!", regs);
> -	force_sig(SIGFPE, current);
> -	exception_exit(prev_state);
> -}
> -
> -asmlinkage void do_msa(struct pt_regs *regs)
> -{
> -	enum ctx_state prev_state;
> -	int err;
> -
> -	prev_state =3D exception_enter();
> -
> -	if (!cpu_has_msa || test_thread_flag(TIF_32BIT_FPREGS)) {
> -		force_sig(SIGILL, current);
> -		goto out;
> -	}
> -
> -	die_if_kernel("do_msa invoked from kernel context!", regs);
> -
> -	err =3D enable_restore_fp_context(1);
> -	if (err)
> -		force_sig(SIGILL, current);
> -out:
> -	exception_exit(prev_state);
> -}
> -
> -asmlinkage void do_mdmx(struct pt_regs *regs)
> -{
> -	enum ctx_state prev_state;
> -
> -	prev_state =3D exception_enter();
> -	force_sig(SIGILL, current);
> -	exception_exit(prev_state);
> -}
> -
>  /*
>   * Called with interrupts disabled.
>   */
> @@ -1370,36 +1251,6 @@ asmlinkage void do_watch(struct pt_regs *regs)
>  	exception_exit(prev_state);
>  }
> =20
> -asmlinkage void do_mcheck(struct pt_regs *regs)
> -{
> -	const int field =3D 2 * sizeof(unsigned long);
> -	int multi_match =3D regs->cp0_status & ST0_TS;
> -	enum ctx_state prev_state;
> -
> -	prev_state =3D exception_enter();
> -	show_regs(regs);
> -
> -	if (multi_match) {
> -		printk("Index	: %0x\n", read_c0_index());
> -		printk("Pagemask: %0x\n", read_c0_pagemask());
> -		printk("EntryHi : %0*lx\n", field, read_c0_entryhi());
> -		printk("EntryLo0: %0*lx\n", field, read_c0_entrylo0());
> -		printk("EntryLo1: %0*lx\n", field, read_c0_entrylo1());
> -		printk("\n");
> -		dump_tlb_all();
> -	}
> -
> -	show_code((unsigned int __user *) regs->cp0_epc);
> -
> -	/*
> -	 * Some chips may have other causes of machine check (e.g. SB1
> -	 * graduation timer)
> -	 */
> -	panic("Caught Machine Check exception - %scaused by multiple "
> -	      "matching entries in the TLB.",
> -	      (multi_match) ? "" : "not ");
> -}
> -
>  asmlinkage void do_mt(struct pt_regs *regs)
>  {
>  	int subcode;
> @@ -1436,14 +1287,6 @@ asmlinkage void do_mt(struct pt_regs *regs)
>  }
> =20
> =20
> -asmlinkage void do_dsp(struct pt_regs *regs)
> -{
> -	if (cpu_has_dsp)
> -		panic("Unexpected DSP exception");
> -
> -	force_sig(SIGILL, current);
> -}
> -
>  asmlinkage void do_reserved(struct pt_regs *regs)
>  {
>  	/*
> @@ -1609,34 +1452,6 @@ asmlinkage void cache_parity_error(void)
>  	panic("Can't handle the cache error!");
>  }
> =20
> -asmlinkage void do_ftlb(void)
> -{
> -	const int field =3D 2 * sizeof(unsigned long);
> -	unsigned int reg_val;
> -
> -	/* For the moment, report the problem and hang. */
> -	if (cpu_has_mips_r2 &&
> -	    ((current_cpu_data.processor_id & 0xff0000) =3D=3D PRID_COMP_MIPS=
)) {
> -		pr_err("FTLB error exception, cp0_ecc=3D0x%08x:\n",
> -		       read_c0_ecc());
> -		pr_err("cp0_errorepc =3D=3D %0*lx\n", field, read_c0_errorepc());
> -		reg_val =3D read_c0_cacheerr();
> -		pr_err("c0_cacheerr =3D=3D %08x\n", reg_val);
> -
> -		if ((reg_val & 0xc0000000) =3D=3D 0xc0000000) {
> -			pr_err("Decoded c0_cacheerr: FTLB parity error\n");
> -		} else {
> -			pr_err("Decoded c0_cacheerr: %s cache fault in %s reference.\n",
> -			       reg_val & (1<<30) ? "secondary" : "primary",
> -			       reg_val & (1<<31) ? "data" : "insn");
> -		}
> -	} else {
> -		pr_err("FTLB error exception\n");
> -	}
> -	/* Just print the cacheerr bits for now */
> -	cache_parity_error();
> -}
> -
>  /*
>   * SDBBP EJTAG debug exception handler.
>   * We skip the instruction and return to the next instruction.
>=20


--AdNFbwDBQv4LJPsSwtAbWOCfHf7BhK1to
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUpnVBAAoJEGwLaZPeOHZ68nYQAImaZt9B6MqrKXuAxJS4JSD2
vJQjXFFPV6+Tv/38taq4CVxsVeIvzxQJz3txOxA63hfatoOICMMCz4FbjO58U8YK
vtMqcp8M6hYCsqG4WHRTsI8n5TXvUTyeG6uFZ3kY8Ovf25EQQuuW5pofdQ/UFUwp
sySeXqjVU3k6OmSyu56ABsd6iiKCJuAkKCJw1X7h1eRTO6OR4LIO871+44EYc8C1
hixekmVXKvjTuTg4ImEcscITiaqxq834Y+BqFpbOzZq//ePpCGcPi73hfMm47wWN
SALJa0gOzrGVCA2n23Pp/lNc4geQIGDURAM2xLtjUiCxJCb2JG7MMf7GPBRkuRdQ
8b6SN/oHpWFciG6N4Op+uIg8GqzsanTN9ygmZh9YE0GFqzJzSAxHbQqXxaf6YCna
XpFmWE5QBuMGbZTj5p7bMUEo0hl+sfFPNRf7N2s64htmjNWNHOGjjVoKZAF4SCJL
d3qqmSu84RIWQlIgOvJX/enYv8owKaE6AT639rKA2c+DZBEUx1UvI3Y+EfQUINTV
nFILpIPr7GCRcK14mjmo88FjLawa3ZQHfD1VSqi688iSS6KboK1+IReL77DFONOP
EPJHINB8AIWuSWFkav/UxCcHUvy9k+U7DAf9hiiLeVzF9cgAVrP33JJDz5Ttlq97
3x0L4x+mH+uHEaO+PIwi
=yhQ3
-----END PGP SIGNATURE-----

--AdNFbwDBQv4LJPsSwtAbWOCfHf7BhK1to--
