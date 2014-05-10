Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaEJHQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 03:16:33 -0400
Received: from mout.web.de ([212.227.15.3]:58762 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbaEJHQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 03:16:30 -0400
Message-ID: <536DD1AC.9070605@web.de>
Date: Sat, 10 May 2014 09:13:48 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, pbonzini@redhat.com
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: x86: Fix CR3 reserved bits
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il> <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il> <1397781312-6885-2-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1397781312-6885-2-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2dcf5g75qMJefIuFaEj6gKD1lurHqOOlU"
X-Provags-ID: V03:K0:5ULiGaFwbl6KH4hQKoOemUmiDPkpfJu1LpjaLVqcYnxKJagoelQ
 zxuSjO2qHOgoZbswovU2NrRKCCnam79r1/K4CaWVrhxsOz+TtN8bRZzGfqqdY2xTgIcrmAh
 6wIfu0l7RZdacQ0q2MBgff0AR8VSsWUq7XvejEdoezwraYmqMWwdMUnZkeUwa/3EbNIRyVX
 jfzQCBK/ugIV/0X4vChRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2dcf5g75qMJefIuFaEj6gKD1lurHqOOlU
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-04-18 02:35, Nadav Amit wrote:
> According to Intel specifications, PAE and non-PAE does not have any re=
served
> bits.  In long-mode, regardless to PCIDE, only the high bits (above the=

> physical address) are reserved.
>=20
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
> :100644 100644 7de069af.. e21aee9... M	arch/x86/include/asm/kvm_host.h
> :100644 100644 205b17e... 1d60374... M	arch/x86/kvm/emulate.c
> :100644 100644 8b8fc0b... f4d9839... M	arch/x86/kvm/x86.c
>  arch/x86/include/asm/kvm_host.h |    6 +-----
>  arch/x86/kvm/emulate.c          |    4 ----
>  arch/x86/kvm/x86.c              |   25 +++++--------------------
>  3 files changed, 6 insertions(+), 29 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> index 7de069af..e21aee9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -50,11 +50,7 @@
>  			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
>  			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
> =20
> -#define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
> -#define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_=
CR3_PCD))
> -#define CR3_PCID_ENABLED_RESERVED_BITS 0xFFFFFF0000000000ULL
> -#define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS |	\
> -				  0xFFFFFF0000000000ULL)
> +#define CR3_L_MODE_RESERVED_BITS 0xFFFFFF0000000000ULL
>  #define CR4_RESERVED_BITS                                             =
  \
>  	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_D=
E\
>  			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE     \
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 205b17e..1d60374 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3386,10 +3386,6 @@ static int check_cr_write(struct x86_emulate_ctx=
t *ctxt)
>  		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
>  		if (efer & EFER_LMA)
>  			rsvd =3D CR3_L_MODE_RESERVED_BITS;
> -		else if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PAE)
> -			rsvd =3D CR3_PAE_RESERVED_BITS;
> -		else if (ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PG)
> -			rsvd =3D CR3_NONPAE_RESERVED_BITS;
> =20
>  		if (new_val & rsvd)
>  			return emulate_gp(ctxt, 0);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8b8fc0b..f4d9839 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -701,26 +701,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned l=
ong cr3)
>  		return 0;
>  	}
> =20
> -	if (is_long_mode(vcpu)) {
> -		if (kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)) {
> -			if (cr3 & CR3_PCID_ENABLED_RESERVED_BITS)
> -				return 1;
> -		} else
> -			if (cr3 & CR3_L_MODE_RESERVED_BITS)
> -				return 1;
> -	} else {
> -		if (is_pae(vcpu)) {
> -			if (cr3 & CR3_PAE_RESERVED_BITS)
> -				return 1;
> -			if (is_paging(vcpu) &&
> -			    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
> -				return 1;
> -		}
> -		/*
> -		 * We don't check reserved bits in nonpae mode, because
> -		 * this isn't enforced, and VMware depends on this.
> -		 */
> -	}
> +	if (is_long_mode(vcpu) && (cr3 & CR3_L_MODE_RESERVED_BITS))
> +		return 1;
> +	if (is_pae(vcpu) && is_paging(vcpu) &&
> +	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
> +		return 1;

This is wrong: is_pae returns true in long mode, but we don't have valid
pdptrs then. Crashes my Jailhouse guest.

I suppose we need a patch on top as this is already in kvm.next, right?

Jan



--2dcf5g75qMJefIuFaEj6gKD1lurHqOOlU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNt0b8ACgkQitSsb3rl5xTB3ACg4qDXw07u5li/64zFDUMdLN29
AdUAoNIcVX1bHXe2pahD7XT0oBVkoUcx
=yUdy
-----END PGP SIGNATURE-----

--2dcf5g75qMJefIuFaEj6gKD1lurHqOOlU--
