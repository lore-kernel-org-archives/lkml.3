Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3F0Isj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:48:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52654 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3F0Isg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:48:36 -0400
Date: Thu, 27 Jun 2013 18:48:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jayachandran C <jchandra@broadcom.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the cpuinit tree with the mips tree
Message-Id: <20130627184826.416dcb8c84d77f8455794829@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_18_48_26_+1000_kIAATPAt5MisSL=x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_18_48_26_+1000_kIAATPAt5MisSL=x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the cpuinit tree got a conflict in
arch/mips/mm/tlbex.c between commits 8c24cb9d180b ("MIPS: Move generated
code to .text for microMIPS") and d45accb44e19 ("MIPS: mm: Use scratch
for PGD when !CONFIG_MIPS_PGD_C0_CONTEXT") from the mips tree and commit
"MIPS: Delete __cpuinit/__CPUINIT usage from MIPS code" from the cpuinit
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

Ralf, your merge commit e6d254aea905 ("Merge branch '3.10-fixes' into
mips-for-linux-next") left some conflict markers in this file which I
have removed as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/mm/tlbex.c
index e77bb44,9e7ae4b..0000000
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@@ -924,28 -947,34 +915,28 @@@ build_get_pgd_vmalloc64(u32 **p, struc
   * TMP and PTR are scratch.
   * TMP will be clobbered, PTR will hold the pgd entry.
   */
- static void __cpuinit __maybe_unused
+ static void __maybe_unused
  build_get_pgde32(u32 **p, unsigned int tmp, unsigned int ptr)
  {
 -	long pgdc =3D (long)pgd_current;
 +	if (pgd_reg !=3D -1) {
 +		/* pgd is in pgd_reg */
 +		uasm_i_mfc0(p, ptr, c0_kscratch(), pgd_reg);
 +		uasm_i_mfc0(p, tmp, C0_BADVADDR); /* get faulting address */
 +	} else {
 +		long pgdc =3D (long)pgd_current;
 =20
 -	/* 32 bit SMP has smp_processor_id() stored in CONTEXT. */
 +		/* 32 bit SMP has smp_processor_id() stored in CONTEXT. */
  #ifdef CONFIG_SMP
 -#ifdef	CONFIG_MIPS_MT_SMTC
 -	/*
 -	 * SMTC uses TCBind value as "CPU" index
 -	 */
 -	uasm_i_mfc0(p, ptr, C0_TCBIND);
 -	UASM_i_LA_mostly(p, tmp, pgdc);
 -	uasm_i_srl(p, ptr, ptr, 19);
 +		uasm_i_mfc0(p, ptr, SMP_CPUID_REG);
 +		UASM_i_LA_mostly(p, tmp, pgdc);
 +		uasm_i_srl(p, ptr, ptr, SMP_CPUID_PTRSHIFT);
 +		uasm_i_addu(p, ptr, tmp, ptr);
  #else
 -	/*
 -	 * smp_processor_id() << 3 is stored in CONTEXT.
 -	 */
 -	uasm_i_mfc0(p, ptr, C0_CONTEXT);
 -	UASM_i_LA_mostly(p, tmp, pgdc);
 -	uasm_i_srl(p, ptr, ptr, 23);
 -#endif
 -	uasm_i_addu(p, ptr, tmp, ptr);
 -#else
 -	UASM_i_LA_mostly(p, ptr, pgdc);
 +		UASM_i_LA_mostly(p, ptr, pgdc);
  #endif
 -	uasm_i_mfc0(p, tmp, C0_BADVADDR); /* get faulting address */
 -	uasm_i_lw(p, ptr, uasm_rel_lo(pgdc), ptr);
 +		uasm_i_mfc0(p, tmp, C0_BADVADDR); /* get faulting address */
 +		uasm_i_lw(p, ptr, uasm_rel_lo(pgdc), ptr);
 +	}
  	uasm_i_srl(p, tmp, tmp, PGDIR_SHIFT); /* get pgd only bits */
  	uasm_i_sll(p, tmp, tmp, PGD_T_LOG2);
  	uasm_i_addu(p, ptr, ptr, tmp); /* add in pgd offset */
@@@ -1417,33 -1445,33 +1407,33 @@@ static void build_r4000_tlb_refill_hand
  	dump_handler("r4000_tlb_refill", (u32 *)ebase, 64);
  }
 =20
 -/*
 - * 128 instructions for the fastpath handler is generous and should
 - * never be exceeded.
 - */
 -#define FASTPATH_SIZE 128
 +extern u32 handle_tlbl[], handle_tlbl_end[];
 +extern u32 handle_tlbs[], handle_tlbs_end[];
 +extern u32 handle_tlbm[], handle_tlbm_end[];
 +extern u32 tlbmiss_handler_setup_pgd[], tlbmiss_handler_setup_pgd_end[];
 =20
- static void __cpuinit build_setup_pgd(void)
 -u32 handle_tlbl[FASTPATH_SIZE] __cacheline_aligned;
 -u32 handle_tlbs[FASTPATH_SIZE] __cacheline_aligned;
 -u32 handle_tlbm[FASTPATH_SIZE] __cacheline_aligned;
 -#ifdef CONFIG_MIPS_PGD_C0_CONTEXT
 -u32 tlbmiss_handler_setup_pgd_array[16] __cacheline_aligned;
 -
 -static void build_r4000_setup_pgd(void)
++static void build_setup_pgd(void)
  {
  	const int a0 =3D 4;
 -	const int a1 =3D 5;
 -	u32 *p =3D tlbmiss_handler_setup_pgd_array;
 -	struct uasm_label *l =3D labels;
 -	struct uasm_reloc *r =3D relocs;
 +	const int __maybe_unused a1 =3D 5;
 +	const int __maybe_unused a2 =3D 6;
 +	u32 *p =3D tlbmiss_handler_setup_pgd;
 +	const int tlbmiss_handler_setup_pgd_size =3D
 +		tlbmiss_handler_setup_pgd_end - tlbmiss_handler_setup_pgd;
 +#ifndef CONFIG_MIPS_PGD_C0_CONTEXT
 +	long pgdc =3D (long)pgd_current;
 +#endif
 =20
 -	memset(tlbmiss_handler_setup_pgd_array, 0, sizeof(tlbmiss_handler_setup_=
pgd_array));
 +	memset(tlbmiss_handler_setup_pgd, 0, tlbmiss_handler_setup_pgd_size *
 +					sizeof(tlbmiss_handler_setup_pgd[0]));
  	memset(labels, 0, sizeof(labels));
  	memset(relocs, 0, sizeof(relocs));
 -
  	pgd_reg =3D allocate_kscratch();
 -
 +#ifdef CONFIG_MIPS_PGD_C0_CONTEXT
  	if (pgd_reg =3D=3D -1) {
 +		struct uasm_label *l =3D labels;
 +		struct uasm_reloc *r =3D relocs;
 +
  		/* PGD << 11 in c0_Context */
  		/*
  		 * If it is a ckseg0 address, convert to a physical
@@@ -1465,38 -1493,19 +1455,38 @@@
  		uasm_i_jr(&p, 31);
  		UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
  	}
 -	if (p - tlbmiss_handler_setup_pgd_array > ARRAY_SIZE(tlbmiss_handler_set=
up_pgd_array))
 -		panic("tlbmiss_handler_setup_pgd_array space exceeded");
 +#else
 +#ifdef CONFIG_SMP
 +	/* Save PGD to pgd_current[smp_processor_id()] */
 +	UASM_i_CPUID_MFC0(&p, a1, SMP_CPUID_REG);
 +	UASM_i_SRL_SAFE(&p, a1, a1, SMP_CPUID_PTRSHIFT);
 +	UASM_i_LA_mostly(&p, a2, pgdc);
 +	UASM_i_ADDU(&p, a2, a2, a1);
 +	UASM_i_SW(&p, a0, uasm_rel_lo(pgdc), a2);
 +#else
 +	UASM_i_LA_mostly(&p, a2, pgdc);
 +	UASM_i_SW(&p, a0, uasm_rel_lo(pgdc), a2);
 +#endif /* SMP */
 +	uasm_i_jr(&p, 31);
 +
 +	/* if pgd_reg is allocated, save PGD also to scratch register */
 +	if (pgd_reg !=3D -1)
 +		UASM_i_MTC0(&p, a0, c0_kscratch(), pgd_reg);
 +	else
 +		uasm_i_nop(&p);
 +#endif
 +	if (p >=3D tlbmiss_handler_setup_pgd_end)
 +		panic("tlbmiss_handler_setup_pgd space exceeded");
 +
  	uasm_resolve_relocs(relocs, labels);
 -	pr_debug("Wrote tlbmiss_handler_setup_pgd_array (%u instructions).\n",
 -		 (unsigned int)(p - tlbmiss_handler_setup_pgd_array));
 +	pr_debug("Wrote tlbmiss_handler_setup_pgd (%u instructions).\n",
 +		 (unsigned int)(p - tlbmiss_handler_setup_pgd));
 =20
 -	dump_handler("tlbmiss_handler",
 -		     tlbmiss_handler_setup_pgd_array,
 -		     ARRAY_SIZE(tlbmiss_handler_setup_pgd_array));
 +	dump_handler("tlbmiss_handler", tlbmiss_handler_setup_pgd,
 +					tlbmiss_handler_setup_pgd_size);
  }
 -#endif
 =20
- static void __cpuinit
+ static void
  iPTE_LW(u32 **p, unsigned int pte, unsigned int ptr)
  {
  #ifdef CONFIG_SMP
@@@ -1734,10 -1743,9 +1724,10 @@@ build_r3000_tlbchange_handler_head(u32=20
  	uasm_i_tlbp(p); /* load delay */
  }
 =20
- static void __cpuinit build_r3000_tlb_load_handler(void)
+ static void build_r3000_tlb_load_handler(void)
  {
  	u32 *p =3D handle_tlbl;
 +	const int handle_tlbl_size =3D handle_tlbl_end - handle_tlbl;
  	struct uasm_label *l =3D labels;
  	struct uasm_reloc *r =3D relocs;
 =20
@@@ -1762,13 -1770,12 +1752,13 @@@
  	pr_debug("Wrote TLB load handler fastpath (%u instructions).\n",
  		 (unsigned int)(p - handle_tlbl));
 =20
 -	dump_handler("r3000_tlb_load", handle_tlbl, ARRAY_SIZE(handle_tlbl));
 +	dump_handler("r3000_tlb_load", handle_tlbl, handle_tlbl_size);
  }
 =20
- static void __cpuinit build_r3000_tlb_store_handler(void)
+ static void build_r3000_tlb_store_handler(void)
  {
  	u32 *p =3D handle_tlbs;
 +	const int handle_tlbs_size =3D handle_tlbs_end - handle_tlbs;
  	struct uasm_label *l =3D labels;
  	struct uasm_reloc *r =3D relocs;
 =20
@@@ -1793,13 -1800,12 +1783,13 @@@
  	pr_debug("Wrote TLB store handler fastpath (%u instructions).\n",
  		 (unsigned int)(p - handle_tlbs));
 =20
 -	dump_handler("r3000_tlb_store", handle_tlbs, ARRAY_SIZE(handle_tlbs));
 +	dump_handler("r3000_tlb_store", handle_tlbs, handle_tlbs_size);
  }
 =20
- static void __cpuinit build_r3000_tlb_modify_handler(void)
+ static void build_r3000_tlb_modify_handler(void)
  {
  	u32 *p =3D handle_tlbm;
 +	const int handle_tlbm_size =3D handle_tlbm_end - handle_tlbm;
  	struct uasm_label *l =3D labels;
  	struct uasm_reloc *r =3D relocs;
 =20
@@@ -1885,10 -1891,9 +1875,10 @@@ build_r4000_tlbchange_handler_tail(u32=20
  #endif
  }
 =20
- static void __cpuinit build_r4000_tlb_load_handler(void)
+ static void build_r4000_tlb_load_handler(void)
  {
  	u32 *p =3D handle_tlbl;
 +	const int handle_tlbl_size =3D handle_tlbl_end - handle_tlbl;
  	struct uasm_label *l =3D labels;
  	struct uasm_reloc *r =3D relocs;
  	struct work_registers wr;
@@@ -2065,13 -2070,12 +2055,13 @@@
  	pr_debug("Wrote TLB load handler fastpath (%u instructions).\n",
  		 (unsigned int)(p - handle_tlbl));
 =20
 -	dump_handler("r4000_tlb_load", handle_tlbl, ARRAY_SIZE(handle_tlbl));
 +	dump_handler("r4000_tlb_load", handle_tlbl, handle_tlbl_size);
  }
 =20
- static void __cpuinit build_r4000_tlb_store_handler(void)
+ static void build_r4000_tlb_store_handler(void)
  {
  	u32 *p =3D handle_tlbs;
 +	const int handle_tlbs_size =3D handle_tlbs_end - handle_tlbs;
  	struct uasm_label *l =3D labels;
  	struct uasm_reloc *r =3D relocs;
  	struct work_registers wr;
@@@ -2120,13 -2124,12 +2110,13 @@@
  	pr_debug("Wrote TLB store handler fastpath (%u instructions).\n",
  		 (unsigned int)(p - handle_tlbs));
 =20
 -	dump_handler("r4000_tlb_store", handle_tlbs, ARRAY_SIZE(handle_tlbs));
 +	dump_handler("r4000_tlb_store", handle_tlbs, handle_tlbs_size);
  }
 =20
- static void __cpuinit build_r4000_tlb_modify_handler(void)
+ static void build_r4000_tlb_modify_handler(void)
  {
  	u32 *p =3D handle_tlbm;
 +	const int handle_tlbm_size =3D handle_tlbm_end - handle_tlbm;
  	struct uasm_label *l =3D labels;
  	struct uasm_reloc *r =3D relocs;
  	struct work_registers wr;
@@@ -2176,10 -2179,10 +2166,10 @@@
  	pr_debug("Wrote TLB modify handler fastpath (%u instructions).\n",
  		 (unsigned int)(p - handle_tlbm));
 =20
 -	dump_handler("r4000_tlb_modify", handle_tlbm, ARRAY_SIZE(handle_tlbm));
 +	dump_handler("r4000_tlb_modify", handle_tlbm, handle_tlbm_size);
  }
 =20
- static void __cpuinit flush_tlb_handlers(void)
+ static void flush_tlb_handlers(void)
  {
  	local_flush_icache_range((unsigned long)handle_tlbl,
  			   (unsigned long)handle_tlbl + sizeof(handle_tlbl));
@@@ -2259,18 -2263,3 +2249,15 @@@ void build_tlb_refill_handler(void
  			build_r4000_tlb_refill_handler();
  	}
  }
- <<<<<<< HEAD
 +
- void __cpuinit flush_tlb_handlers(void)
++void flush_tlb_handlers(void)
 +{
 +	local_flush_icache_range((unsigned long)handle_tlbl,
 +			   (unsigned long)handle_tlbl_end);
 +	local_flush_icache_range((unsigned long)handle_tlbs,
 +			   (unsigned long)handle_tlbs_end);
 +	local_flush_icache_range((unsigned long)handle_tlbm,
 +			   (unsigned long)handle_tlbm_end);
 +	local_flush_icache_range((unsigned long)tlbmiss_handler_setup_pgd,
 +			   (unsigned long)tlbmiss_handler_setup_pgd_end);
 +}
- =3D=3D=3D=3D=3D=3D=3D
- >>>>>>> 3f90b82df110ef9cb33761b56ca85ae0d0372d4a

--Signature=_Thu__27_Jun_2013_18_48_26_+1000_kIAATPAt5MisSL=x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRy/xeAAoJEECxmPOUX5FEY7YP/19QmMxT8yErzm7pRQebrYVG
LjbIncl8MLkkLJrQj2hp/s+WmhmOEVUqTzhTMl8GRghplHUHBQUm9nlIgKp5CLw2
xHi2L7JBcu4sKEofoGh6+2TOd5O9piT4PCzCAULMCOFvBNyx4JFpSlg6QJjhOQI5
OTWONcLnWzbVElUNNMhV9n6Jf2PUA1m4Lr3KD62G9Wg3dM+ptV3VubkvnclaEio2
u0MefMyIhoH6nJwifjvAipMIPH0fT7gqSpQlobcxpvwVlG8j8IcbM1SW1iCM6+pg
KLkQUC2w464soWoapLAJNJuNhlJGEQPHQDxXTqYofwY/V8lyyFdEkcKd9EGXl0/5
2KD1EvQnEmVDZy90c2/+hwfvWKJ1pIhYCIOTLpZ4BrHnE4CUbWclcrR/cBfNxIwZ
fx/O8aTGsxpHsSkwuAUymCDxCB8cq995hCjseUj8HQBup3HuD7gvKCDfZJd8u/Lo
BrGr47ArweZL4qj6zJyQkJyPCI/hI56JKvaPE43//IW9XQZtWhgFXdbStPltZe9L
dUXSxljncw9cBilzdzfmxRcEU3dXrBXCOumK4zdEkX5EszEGmh89cMMjYzvFDRmQ
x6j5Jz8TI47/hVcsVT5RrULEHIGs7RpEqeuvN7riu7peRA6qiRMhXoduEYtUCTnx
CSG5rEQwdZHE8MNHRKZ7
=R5Ba
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_18_48_26_+1000_kIAATPAt5MisSL=x--
