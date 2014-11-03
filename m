Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaKCNoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:44:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41294 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbaKCNof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:44:35 -0500
Message-ID: <1415022261.27313.25.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 087/102] nEPT: Nested INVEPT
From: Ben Hutchings <ben@decadent.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jun Nakajima <jun.nakajima@intel.com>,
        Xinhao Xu <xinhao.xu@intel.com>, Yang Zhang <yang.z.zhang@intel.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, "Nadav Har'El" <nyh@il.ibm.com>
Date: Mon, 03 Nov 2014 13:44:21 +0000
In-Reply-To: <5455F35E.1040304@redhat.com>
References: <lsq.1414880883.12343835@decadent.org.uk>
	 <5455F35E.1040304@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-s4FlQK7Z14Gkq/lSM6A4"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s4FlQK7Z14Gkq/lSM6A4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-11-02 at 10:03 +0100, Paolo Bonzini wrote:
> You can just use the same scheme as your patch 88/102:

Why is that?  Why should I not use the upstream version?

Ben.

> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 685b8448d6e2..bd8cc9055fe2 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -6740,6 +6740,12 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
> =20
> +static int handle_invept(struct kvm_vcpu *vcpu)
> +{
> +	kvm_queue_exception(vcpu, UD_VECTOR);
> +	return 1;
> +}
> +
>  /*
>   * The exit handlers return 1 if the exit was handled fully and guest ex=
ecution
>   * may resume.  Otherwise they set the kvm_run parameter to indicate wha=
t needs
> @@ -6785,6 +6791,7 @@ static int (*const kvm_vmx_exit_handlers[])(struct =
kvm_vcpu *vcpu) =3D {
>  	[EXIT_REASON_PAUSE_INSTRUCTION]       =3D handle_pause,
>  	[EXIT_REASON_MWAIT_INSTRUCTION]	      =3D handle_invalid_op,
>  	[EXIT_REASON_MONITOR_INSTRUCTION]     =3D handle_invalid_op,
> +	[EXIT_REASON_INVEPT]                  =3D handle_invept,
>  };
> =20
>  static const int kvm_vmx_max_exit_handlers =3D
> @@ -7020,6 +7027,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu=
 *vcpu)
>  	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
>  	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
>  	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
> +	case EXIT_REASON_INVEPT:
>  		/*
>  		 * VMX instructions trap unconditionally. This allows L1 to
>  		 * emulate them for its L2 guest, i.e., allows 3-level nesting!
>=20
>=20
> Paolo
>=20
> On 01/11/2014 23:28, Ben Hutchings wrote:
> > 3.2.64-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Nadav Har'El <nyh@il.ibm.com>
> >=20
> > commit bfd0a56b90005f8c8a004baf407ad90045c2b11e upstream.
> >=20
> > If we let L1 use EPT, we should probably also support the INVEPT instru=
ction.
> >=20
> > In our current nested EPT implementation, when L1 changes its EPT table
> > for L2 (i.e., EPT12), L0 modifies the shadow EPT table (EPT02), and in
> > the course of this modification already calls INVEPT. But if last level
> > of shadow page is unsync not all L1's changes to EPT12 are intercepted,
> > which means roots need to be synced when L1 calls INVEPT. Global INVEPT
> > should not be different since roots are synced by kvm_mmu_load() each
> > time EPTP02 changes.
> >=20
> > Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> > Signed-off-by: Nadav Har'El <nyh@il.ibm.com>
> > Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
> > Signed-off-by: Xinhao Xu <xinhao.xu@intel.com>
> > Signed-off-by: Yang Zhang <yang.z.zhang@Intel.com>
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > [bwh: Backported to 3.2:
> >  - Adjust context, filename
> >  - Add definition of nested_ept_get_cr3(), added upstream by commit
> >    155a97a3d7c7 ("nEPT: MMU context for nested EPT")]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -279,6 +279,7 @@ enum vmcs_field {
> >  #define EXIT_REASON_APIC_ACCESS         44
> >  #define EXIT_REASON_EPT_VIOLATION       48
> >  #define EXIT_REASON_EPT_MISCONFIG       49
> > +#define EXIT_REASON_INVEPT              50
> >  #define EXIT_REASON_WBINVD		54
> >  #define EXIT_REASON_XSETBV		55
> > =20
> > @@ -397,6 +398,7 @@ enum vmcs_field {
> >  #define VMX_EPT_EXTENT_INDIVIDUAL_ADDR		0
> >  #define VMX_EPT_EXTENT_CONTEXT			1
> >  #define VMX_EPT_EXTENT_GLOBAL			2
> > +#define VMX_EPT_EXTENT_SHIFT			24
> > =20
> >  #define VMX_EPT_EXECUTE_ONLY_BIT		(1ull)
> >  #define VMX_EPT_PAGE_WALK_4_BIT			(1ull << 6)
> > @@ -404,6 +406,7 @@ enum vmcs_field {
> >  #define VMX_EPTP_WB_BIT				(1ull << 14)
> >  #define VMX_EPT_2MB_PAGE_BIT			(1ull << 16)
> >  #define VMX_EPT_1GB_PAGE_BIT			(1ull << 17)
> > +#define VMX_EPT_INVEPT_BIT			(1ull << 20)
> >  #define VMX_EPT_EXTENT_INDIVIDUAL_BIT		(1ull << 24)
> >  #define VMX_EPT_EXTENT_CONTEXT_BIT		(1ull << 25)
> >  #define VMX_EPT_EXTENT_GLOBAL_BIT		(1ull << 26)
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -2869,6 +2869,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu
> >  	mmu_sync_roots(vcpu);
> >  	spin_unlock(&vcpu->kvm->mmu_lock);
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
> > =20
> >  static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
> >  				  u32 access, struct x86_exception *exception)
> > @@ -3131,6 +3132,7 @@ void kvm_mmu_flush_tlb(struct kvm_vcpu *
> >  	++vcpu->stat.tlb_flush;
> >  	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_mmu_flush_tlb);
> > =20
> >  static void paging_new_cr3(struct kvm_vcpu *vcpu)
> >  {
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -602,6 +602,7 @@ static void nested_release_page_clean(st
> >  	kvm_release_page_clean(page);
> >  }
> > =20
> > +static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu);
> >  static u64 construct_eptp(unsigned long root_hpa);
> >  static void kvm_cpu_vmxon(u64 addr);
> >  static void kvm_cpu_vmxoff(void);
> > @@ -1899,6 +1900,7 @@ static u32 nested_vmx_secondary_ctls_low
> >  static u32 nested_vmx_pinbased_ctls_low, nested_vmx_pinbased_ctls_high=
;
> >  static u32 nested_vmx_exit_ctls_low, nested_vmx_exit_ctls_high;
> >  static u32 nested_vmx_entry_ctls_low, nested_vmx_entry_ctls_high;
> > +static u32 nested_vmx_ept_caps;
> >  static __init void nested_vmx_setup_ctls_msrs(void)
> >  {
> >  	/*
> > @@ -5550,6 +5552,74 @@ static int handle_vmptrst(struct kvm_vcp
> >  	return 1;
> >  }
> > =20
> > +/* Emulate the INVEPT instruction */
> > +static int handle_invept(struct kvm_vcpu *vcpu)
> > +{
> > +	u32 vmx_instruction_info, types;
> > +	unsigned long type;
> > +	gva_t gva;
> > +	struct x86_exception e;
> > +	struct {
> > +		u64 eptp, gpa;
> > +	} operand;
> > +	u64 eptp_mask =3D ((1ull << 51) - 1) & PAGE_MASK;
> > +
> > +	if (!(nested_vmx_secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT) ||
> > +	    !(nested_vmx_ept_caps & VMX_EPT_INVEPT_BIT)) {
> > +		kvm_queue_exception(vcpu, UD_VECTOR);
> > +		return 1;
> > +	}
> > +
> > +	if (!nested_vmx_check_permission(vcpu))
> > +		return 1;
> > +
> > +	if (!kvm_read_cr0_bits(vcpu, X86_CR0_PE)) {
> > +		kvm_queue_exception(vcpu, UD_VECTOR);
> > +		return 1;
> > +	}
> > +
> > +	vmx_instruction_info =3D vmcs_read32(VMX_INSTRUCTION_INFO);
> > +	type =3D kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
> > +
> > +	types =3D (nested_vmx_ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
> > +
> > +	if (!(types & (1UL << type))) {
> > +		nested_vmx_failValid(vcpu,
> > +				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> > +		return 1;
> > +	}
> > +
> > +	/* According to the Intel VMX instruction reference, the memory
> > +	 * operand is read even if it isn't needed (e.g., for type=3D=3Dgloba=
l)
> > +	 */
> > +	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
> > +			vmx_instruction_info, &gva))
> > +		return 1;
> > +	if (kvm_read_guest_virt(&vcpu->arch.emulate_ctxt, gva, &operand,
> > +				sizeof(operand), &e)) {
> > +		kvm_inject_page_fault(vcpu, &e);
> > +		return 1;
> > +	}
> > +
> > +	switch (type) {
> > +	case VMX_EPT_EXTENT_CONTEXT:
> > +		if ((operand.eptp & eptp_mask) !=3D
> > +				(nested_ept_get_cr3(vcpu) & eptp_mask))
> > +			break;
> > +	case VMX_EPT_EXTENT_GLOBAL:
> > +		kvm_mmu_sync_roots(vcpu);
> > +		kvm_mmu_flush_tlb(vcpu);
> > +		nested_vmx_succeed(vcpu);
> > +		break;
> > +	default:
> > +		BUG_ON(1);
> > +		break;
> > +	}
> > +
> > +	skip_emulated_instruction(vcpu);
> > +	return 1;
> > +}
> > +
> >  /*
> >   * The exit handlers return 1 if the exit was handled fully and guest =
execution
> >   * may resume.  Otherwise they set the kvm_run parameter to indicate w=
hat needs
> > @@ -5591,6 +5661,7 @@ static int (*kvm_vmx_exit_handlers[])(st
> >  	[EXIT_REASON_PAUSE_INSTRUCTION]       =3D handle_pause,
> >  	[EXIT_REASON_MWAIT_INSTRUCTION]	      =3D handle_invalid_op,
> >  	[EXIT_REASON_MONITOR_INSTRUCTION]     =3D handle_invalid_op,
> > +	[EXIT_REASON_INVEPT]                  =3D handle_invept,
> >  };
> > =20
> >  static const int kvm_vmx_max_exit_handlers =3D
> > @@ -5775,6 +5846,7 @@ static bool nested_vmx_exit_handled(stru
> >  	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
> >  	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
> >  	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
> > +	case EXIT_REASON_INVEPT:
> >  		/*
> >  		 * VMX instructions trap unconditionally. This allows L1 to
> >  		 * emulate them for its L2 guest, i.e., allows 3-level nesting!
> > @@ -6436,6 +6508,12 @@ static void vmx_set_supported_cpuid(u32
> >  		entry->ecx |=3D bit(X86_FEATURE_VMX);
> >  }
> > =20
> > +static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
> > +{
> > +	/* return the page table to be shadowed - in our case, EPT12 */
> > +	return get_vmcs12(vcpu)->ept_pointer;
> > +}
> > +
> >  /*
> >   * prepare_vmcs02 is called when the L1 guest hypervisor runs its nest=
ed
> >   * L2 guest. L1 has a vmcs for L2 (vmcs12), and this function "merges"=
 it
> >=20

--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-s4FlQK7Z14Gkq/lSM6A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFeGuue/yOyVhhEJAQoOZxAAgR/FWlah6wWbrjJHlWptM55K3kD1/obq
q9bHsxP7bFfJZoo1NwnAuMMXu3PqLDHfKL3NsWViRvBWPpJQ4AiunaDI9ae3izaY
wJaewv+a9/t4CFB4Al877xeRcuvhAUFUKrSa1gxE0C0UawWRe/3iF7j+W3eV9c1R
eVDZvVfWMaKP3XEdCWd3BbX0YxiRF7Rqfj2CFwvxtHS8gxABgLGx33Pk01cxFBKn
nPcNkNImf22oT3S6g3EdXeuo5Ce/+H7bbd5KIJBtJSdB/ufUk1pw0s9WnLkeis1d
XtZ0eljdCAsCIDC98hcVoYSR/7Wywa8gf0u02vkaEsu84qxXsfGab/Mx/04bg2wm
Y14aqEFzMs14kGEqJH0eIEhf3FRilknW0egLkmhx5bZUdnSrXCYYKyvcIkR4apVI
moN/PGfOgQClstvYaT2RRukXwE2jybxrqerAePlut8eIYCjezNysQ/tfVftapvzq
Htat5NANoOjx7ygxnBbyKJaRLE/J3ykcgqxZ1Yxowrn0FPuJhUYsmh23qka2wV67
/ZjwQXI72L/uRz/US9V3fFTWT4cSLVqjN60aMdrHVgT2VHWWdVroLlg4jry33OGi
N0HauhjIapPUR3xC03X/4JieaAilhS5XMqDVpgHz3VIpAjvyrpokwID09qxMpnMN
BdI+zaJ7PTc=
=7BEo
-----END PGP SIGNATURE-----

--=-s4FlQK7Z14Gkq/lSM6A4--
