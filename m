Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3DVDzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:55:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47817 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab3DVDzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:55:17 -0400
Message-ID: <1366602889.3408.144.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 35/72] KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use
 gfn_to_hva_cache functions (CVE-2013-1797)
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Andrew Honig <ahonig@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Date: Mon, 22 Apr 2013 04:54:49 +0100
In-Reply-To: <1366276617-3553-36-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
	 <1366276617-3553-36-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rawPXCQtFjTvMmiDkNHd"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rawPXCQtFjTvMmiDkNHd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-04-18 at 10:16 +0100, Luis Henriques wrote:
> 3.5.7.11 -stable review patch.  If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Andy Honig <ahonig@google.com>
>=20
> commit 0b79459b482e85cb7426aa7da683a9f2c97aeae1 upstream.
>=20
> There is a potential use after free issue with the handling of
> MSR_KVM_SYSTEM_TIME.  If the guest specifies a GPA in a movable or remova=
ble
> memory such as frame buffers then KVM might continue to write to that
> address even after it's removed via KVM_SET_USER_MEMORY_REGION.  KVM pins
> the page in memory so it's unlikely to cause an issue, but if the user
> space component re-purposes the memory previously used for the guest, the=
n
> the guest will be able to corrupt that memory.
>=20
> Tested: Tested against kvmclock unit test
>=20
> Signed-off-by: Andrew Honig <ahonig@google.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> [ luis: backported to 3.5:
>   - Adjust context
>   - Removed references to PVCLOCK_GUEST_STOPPED ]
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

This apparently needs to be followed by commit 8f964525a121 'KVM: Allow
cross page reads and writes from cached translations.', as some guests
don't follow the rules.

Ben.

> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++--
>  arch/x86/kvm/x86.c              | 40 +++++++++++++++--------------------=
-----
>  2 files changed, 17 insertions(+), 27 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index db7c1f2..9a50912 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -410,8 +410,8 @@ struct kvm_vcpu_arch {
>  	gpa_t time;
>  	struct pvclock_vcpu_time_info hv_clock;
>  	unsigned int hw_tsc_khz;
> -	unsigned int time_offset;
> -	struct page *time_page;
> +	struct gfn_to_hva_cache pv_time;
> +	bool pv_time_enabled;
> =20
>  	struct {
>  		u64 msr_val;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ad5cf4b..5b4ac78 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1118,7 +1118,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v=
)
>  {
>  	unsigned long flags;
>  	struct kvm_vcpu_arch *vcpu =3D &v->arch;
> -	void *shared_kaddr;
>  	unsigned long this_tsc_khz;
>  	s64 kernel_ns, max_kernel_ns;
>  	u64 tsc_timestamp;
> @@ -1154,7 +1153,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v=
)
> =20
>  	local_irq_restore(flags);
> =20
> -	if (!vcpu->time_page)
> +	if (!vcpu->pv_time_enabled)
>  		return 0;
> =20
>  	/*
> @@ -1212,14 +1211,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *=
v)
>  	 */
>  	vcpu->hv_clock.version +=3D 2;
> =20
> -	shared_kaddr =3D kmap_atomic(vcpu->time_page);
> -
> -	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
> -	       sizeof(vcpu->hv_clock));
> -
> -	kunmap_atomic(shared_kaddr);
> -
> -	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
> +	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
> +				&vcpu->hv_clock,
> +				sizeof(vcpu->hv_clock));
>  	return 0;
>  }
> =20
> @@ -1508,10 +1502,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu =
*vcpu, u64 data)
> =20
>  static void kvmclock_reset(struct kvm_vcpu *vcpu)
>  {
> -	if (vcpu->arch.time_page) {
> -		kvm_release_page_dirty(vcpu->arch.time_page);
> -		vcpu->arch.time_page =3D NULL;
> -	}
> +	vcpu->arch.pv_time_enabled =3D false;
>  }
> =20
>  static void accumulate_steal_time(struct kvm_vcpu *vcpu)
> @@ -1606,6 +1597,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 m=
sr, u64 data)
>  		break;
>  	case MSR_KVM_SYSTEM_TIME_NEW:
>  	case MSR_KVM_SYSTEM_TIME: {
> +		u64 gpa_offset;
>  		kvmclock_reset(vcpu);
> =20
>  		vcpu->arch.time =3D data;
> @@ -1615,21 +1607,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32=
 msr, u64 data)
>  		if (!(data & 1))
>  			break;
> =20
> -		/* ...but clean it before doing the actual write */
> -		vcpu->arch.time_offset =3D data & ~(PAGE_MASK | 1);
> +		gpa_offset =3D data & ~(PAGE_MASK | 1);
> =20
>  		/* Check that the address is 32-byte aligned. */
> -		if (vcpu->arch.time_offset &
> -				(sizeof(struct pvclock_vcpu_time_info) - 1))
> +		if (gpa_offset & (sizeof(struct pvclock_vcpu_time_info) - 1))
>  			break;
> =20
> -		vcpu->arch.time_page =3D
> -				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
> +		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
> +		     &vcpu->arch.pv_time, data & ~1ULL))
> +			vcpu->arch.pv_time_enabled =3D false;
> +		else
> +			vcpu->arch.pv_time_enabled =3D true;
> =20
> -		if (is_error_page(vcpu->arch.time_page)) {
> -			kvm_release_page_clean(vcpu->arch.time_page);
> -			vcpu->arch.time_page =3D NULL;
> -		}
>  		break;
>  	}
>  	case MSR_KVM_ASYNC_PF_EN:
> @@ -2616,7 +2605,7 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_v=
cpu *vcpu,
>  static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
>  {
>  	struct pvclock_vcpu_time_info *src =3D &vcpu->arch.hv_clock;
> -	if (!vcpu->arch.time_page)
> +	if (!vcpu->arch.pv_time_enabled)
>  		return -EINVAL;
>  	src->flags |=3D PVCLOCK_GUEST_STOPPED;
>  	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
> @@ -6216,6 +6205,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask, GFP_KERNEL))
>  		goto fail_free_mce_banks;
> =20
> +	vcpu->arch.pv_time_enabled =3D false;
>  	kvm_async_pf_hash_reset(vcpu);
>  	kvm_pmu_init(vcpu);
> =20

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-rawPXCQtFjTvMmiDkNHd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXS0iee/yOyVhhEJAQr/ug/9GaZZKooIXNGmcmYJdAO8wHXar6n/L6AE
1Is34eyngBHEiiEmOvzTxldQBsaqRsDgp3djt+cU06w0TqOl4K9xSByYhrkuFzvq
YPpY/ZcyEVPa3r0dwTEWYPwzsSzlGSeUeAmALuY8ge0avmk8/cbGKjk4Jhe+4RKw
0xp1Foz0bw7GqtFrDgErWeVyHWUZPZ1dC528xwCy030LSaDcpsO4jk7H7X8eGMj7
haW7OeW7sXz76aFOwUq0p08aybdgwJcdvZ4kcHWakXOQqf26U+m5QGnQazcJkKyV
K0JzqSTpBBtIu9h1vSVn9wgy2MVNeWAb6avp7OZcb3HjWptVZcQNpStGvAKRakQw
Ai7IUQeWJlQfj7tSuv7Ku+JSfawBHXzGNmR6hjL8PeGCoylIRsUJmKtlJp+iZbEQ
09lw6hdtFa/b5WEvWMieoOq7oxIYxTMWLN9CP6ga2oBleMJ3Ce5MVm2l5SjWbxXe
eJ9GyJI6Ge9Ld5Ymj5o9j7iVpx8bEmspfOP0CRXut/WF7TGLLDHHvnG7zJ0WdAFl
/hXwNkBIYWm95wFO0BMj5U0sr+ouxq0VqPux4/Fmbwd3v50HdV7oDzW7ztaR+89z
kb3gtOsi7h+ZcK+lfOCdDNcMF5Rs9+ovPsM7ag77zPNTcjH/Rpo1fZL0RPQfrSZR
kbgyeud9FTA=
=RGpQ
-----END PGP SIGNATURE-----

--=-rawPXCQtFjTvMmiDkNHd--
