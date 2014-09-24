Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaIXHI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:08:57 -0400
Received: from mout.web.de ([212.227.17.12]:51206 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbaIXHI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:08:56 -0400
Message-ID: <54226DF7.2050806@web.de>
Date: Wed, 24 Sep 2014 09:08:39 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, pbonzini@redhat.com
CC: gleb@kernel.org, mtosatti@redhat.com, nadav.amit@gmail.com,
        kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kvm, mem-hotplug: Add arch specific mmu notifier
 to handle apic access migration.
References: <541FEC79.40209@redhat.com> <1411524563-17003-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1411524563-17003-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ARLON1PICcvutASdrGBrJmuGWTqoPujG2"
X-Provags-ID: V03:K0:Uay5H6R8aQLIj7Q9dOZp2lqKCoBHe8kG+MDoZ8WOfWN1oOmrNOC
 VM5KEt5j99umUUxp4NYotTB7m522XH6i6yuhkfIlyYe6ExUBG5/WT1XA2EqcE53dDOL55jM
 f9FUqQLXb78En5zW48KHPWp1w71FELrdS2dJGe9eSqkwbk9gdBtjZvrvjG2/k7urOIdAmYf
 Vk8KkKGdnBxHWke3j2Ebg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ARLON1PICcvutASdrGBrJmuGWTqoPujG2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-09-24 04:09, Tang Chen wrote:
> Hi Paolo,=20
>=20
> I'm not sure if this patch is following your comment. Please review.
> And all the other comments are followed. If this patch is OK, I'll=20
> send v8 soon.
>=20
> Thanks.
>=20
> We are handling "L1 and L2 share one apic access page" situation when m=
igrating
> apic access page. We should do some handling when migration happens in =
the
> following situations:
>=20
>    1) when L0 is running: Update L1's vmcs in the next L0->L1 entry and=
 L2's
>       vmcs in the next L1->L2 entry.
>=20
>    2) when L1 is running: Force a L1->L0 exit, update L1's vmcs in the =
next
>       L0->L1 entry and L2's vmcs in the next L1->L2 entry.
>=20
>    3) when L2 is running: Force a L2->L0 exit, update L2's vmcs in the =
next
>       L0->L2 entry and L1's vmcs in the next L2->L1 exit.
>=20
> This patch force a L1->L0 exit or L2->L0 exit when shared apic access p=
age is
> migrated using mmu notifier. Since apic access page is only used on int=
el x86,
> this is arch specific code.
> ---
>  arch/arm/include/asm/kvm_host.h     |  6 ++++++
>  arch/arm64/include/asm/kvm_host.h   |  6 ++++++
>  arch/ia64/include/asm/kvm_host.h    |  8 ++++++++
>  arch/mips/include/asm/kvm_host.h    |  7 +++++++
>  arch/powerpc/include/asm/kvm_host.h |  6 ++++++
>  arch/s390/include/asm/kvm_host.h    |  9 +++++++++
>  arch/x86/include/asm/kvm_host.h     |  2 ++
>  arch/x86/kvm/x86.c                  | 11 +++++++++++
>  virt/kvm/kvm_main.c                 |  3 +++
>  9 files changed, 58 insertions(+)
>=20
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm=
_host.h
> index 6dfb404..79bbf7d 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -182,6 +182,12 @@ static inline int kvm_test_age_hva(struct kvm *kvm=
, unsigned long hva)
>  	return 0;
>  }
> =20
> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *k=
vm,
> +							 unsigned long address)
> +{
> +	return;

Redundant return, more cases below.

Jan

> +}
> +
>  struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
>  struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> =20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> index e10c45a..ee89fad 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -192,6 +192,12 @@ static inline int kvm_test_age_hva(struct kvm *kvm=
, unsigned long hva)
>  	return 0;
>  }
> =20
> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *k=
vm,
> +							 unsigned long address)
> +{
> +	return;
> +}
> +
>  struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
>  struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> =20
> diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/k=
vm_host.h
> index db95f57..326ac55 100644
> --- a/arch/ia64/include/asm/kvm_host.h
> +++ b/arch/ia64/include/asm/kvm_host.h
> @@ -574,6 +574,14 @@ static inline struct kvm_pt_regs *vcpu_regs(struct=
 kvm_vcpu *v)
>  	return (struct kvm_pt_regs *) ((unsigned long) v + KVM_STK_OFFSET) - =
1;
>  }
> =20
> +#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *k=
vm,
> +							 unsigned long address)
> +{
> +	return;
> +}
> +#endif /* KVM_ARCH_WANT_MMU_NOTIFIER */
> +
>  typedef int kvm_vmm_entry(void);
>  typedef void kvm_tramp_entry(union context *host, union context *guest=
);
> =20
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/k=
vm_host.h
> index 7a3fc67..c392705 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -767,5 +767,12 @@ extern int kvm_mips_trans_mtc0(uint32_t inst, uint=
32_t *opc,
>  extern void kvm_mips_dump_stats(struct kvm_vcpu *vcpu);
>  extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
> =20
> +#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *k=
vm,
> +							 unsigned long address)
> +{
> +	return;
> +}
> +#endif /* KVM_ARCH_WANT_MMU_NOTIFIER */
> =20
>  #endif /* __MIPS_KVM_HOST_H__ */
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include=
/asm/kvm_host.h
> index 98d9dd5..c16a573 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -61,6 +61,12 @@ extern int kvm_age_hva(struct kvm *kvm, unsigned lon=
g hva);
>  extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  extern void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t=
 pte);
> =20
> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *k=
vm,
> +							 unsigned long address)
> +{
> +	return;
> +}
> +
>  #define HPTEG_CACHE_NUM			(1 << 15)
>  #define HPTEG_HASH_BITS_PTE		13
>  #define HPTEG_HASH_BITS_PTE_LONG	12
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> index 773bef7..693290f 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -450,4 +450,13 @@ void kvm_arch_async_page_present(struct kvm_vcpu *=
vcpu,
> =20
>  extern int sie64a(struct kvm_s390_sie_block *, u64 *);
>  extern char sie_exit;
> +
> +#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *k=
vm,
> +							 unsigned long address)
> +{
> +	return;
> +}
> +#endif /* KVM_ARCH_WANT_MMU_NOTIFIER */
> +
>  #endif
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> index 66480fd..408b944 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1047,6 +1047,8 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *v=
cpu);
>  int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu);
> +void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
> +					   unsigned long address);
> =20
>  void kvm_define_shared_msr(unsigned index, u32 msr);
>  void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c064ca6..e042ef6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6011,6 +6011,17 @@ void kvm_vcpu_reload_apic_access_page(struct kvm=
_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
> =20
> +void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
> +					   unsigned long address)
> +{
> +	/*
> +	 * The physical address of apic access page is stored in VMCS.
> +	 * Update it when it becomes invalid.
> +	 */
> +	if (address =3D=3D gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHI=
FT))
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
> +}
> +
>  /*
>   * Returns 1 to let __vcpu_run() continue the guest execution loop wit=
hout
>   * exiting to the userspace.  Otherwise, the value will be returned to=
 the
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0f8b6f6..5427973d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -295,6 +295,9 @@ static void kvm_mmu_notifier_invalidate_page(struct=
 mmu_notifier *mn,
>  		kvm_flush_remote_tlbs(kvm);
> =20
>  	spin_unlock(&kvm->mmu_lock);
> +
> +	kvm_arch_mmu_notifier_invalidate_page(kvm, address);
> +
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
> =20
>=20



--ARLON1PICcvutASdrGBrJmuGWTqoPujG2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlQibfsACgkQitSsb3rl5xT8zwCffVMfEEgYMJKHqju6OYGqhIWa
dFgAn3pScTJVnXJfpnkC2uZ9psO06zYK
=b7GR
-----END PGP SIGNATURE-----

--ARLON1PICcvutASdrGBrJmuGWTqoPujG2--
