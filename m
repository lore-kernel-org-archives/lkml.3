Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaLXP3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:29:41 -0500
Received: from mout.web.de ([212.227.17.11]:54376 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaLXP3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:29:39 -0500
Message-ID: <549ADBD2.6040702@web.de>
Date: Wed, 24 Dec 2014 16:29:22 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>, pbonzini@redhat.com, bsd@redhat.com
CC: yang.z.zhang@intel.com, wanpeng.li@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] KVM: ioapic: Record edge-triggered interrupts delivery
 status.
References: <1419390869-1636-1-git-send-email-fanwenyi0529@gmail.com>
In-Reply-To: <1419390869-1636-1-git-send-email-fanwenyi0529@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="of7rTMvcQnktjhIVnpTRaRfm7PerVmuAE"
X-Provags-ID: V03:K0:3zBPboMIUTVLeEPdM6QtMoY62pOnsdrWmUdoa3W3vc6uQkm1AOW
 fUTx6mVjd+5nyMw8TN9UWan+bIdRq8BrMjGVgduwt5m/BlZ3+EP81RkvFqNRO+umgJULPRc
 aDU08ZuUzcMxmI4GViaJ0EFxXcqJVpFAFpQpau50hxqVfSzvg1pknpRW6wlB0FqGScYNNVs
 obWkZNC/e2BBdK2rBi0xA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--of7rTMvcQnktjhIVnpTRaRfm7PerVmuAE
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-12-24 04:14, Wincy Van wrote:
> This patch fixes the bug discussed in
> https://www.mail-archive.com/kvm@vger.kernel.org/msg109813.html
>=20
> This patch uses a new field named irr_delivered to record the
> delivery status of edge-triggered interrupts, and clears the
> delivered interrupts in kvm_get_ioapic. So it has the same effect
> of commit 0bc830b05c667218d703f2026ec866c49df974fc
> ("KVM: ioapic: clear IRR for edge-triggered interrupts at delivery")
> while avoids the bug of Windows guests.
>=20
> Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
> ---
>  arch/x86/kvm/ioapic.c |    7 ++++++-
>  arch/x86/kvm/ioapic.h |    1 +
>  2 files changed, 7 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index b1947e0..a2e9d96 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -206,6 +206,8 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic=
, unsigned int irq,
> =20
>  	old_irr =3D ioapic->irr;
>  	ioapic->irr |=3D mask;
> +	if (edge)
> +		ioapic->irr_delivered &=3D ~mask;
>  	if ((edge && old_irr =3D=3D ioapic->irr) ||
>  	    (!edge && entry.fields.remote_irr)) {
>  		ret =3D 0;
> @@ -349,7 +351,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic=
, int irq, bool line_status)
>  	irqe.shorthand =3D 0;
> =20
>  	if (irqe.trig_mode =3D=3D IOAPIC_EDGE_TRIG)
> -		ioapic->irr &=3D ~(1 << irq);
> +		ioapic->irr_delivered |=3D 1 << irq;
> =20
>  	if (irq =3D=3D RTC_GSI && line_status) {
>  		/*
> @@ -597,6 +599,7 @@ static void kvm_ioapic_reset(struct kvm_ioapic *ioa=
pic)
>  	ioapic->base_address =3D IOAPIC_DEFAULT_BASE_ADDRESS;
>  	ioapic->ioregsel =3D 0;
>  	ioapic->irr =3D 0;
> +	ioapic->irr_delivered =3D 0;
>  	ioapic->id =3D 0;
>  	memset(ioapic->irq_eoi, 0x00, IOAPIC_NUM_PINS);
>  	rtc_irq_eoi_tracking_reset(ioapic);
> @@ -654,6 +657,7 @@ int kvm_get_ioapic(struct kvm *kvm, struct kvm_ioap=
ic_state *state)
> =20
>  	spin_lock(&ioapic->lock);
>  	memcpy(state, ioapic, sizeof(struct kvm_ioapic_state));
> +	state->irr &=3D ~ioapic->irr_delivered;
>  	spin_unlock(&ioapic->lock);
>  	return 0;
>  }
> @@ -667,6 +671,7 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioap=
ic_state *state)
>  	spin_lock(&ioapic->lock);
>  	memcpy(ioapic, state, sizeof(struct kvm_ioapic_state));
>  	ioapic->irr =3D 0;
> +	ioapic->irr_delivered =3D 0;
>  	update_handled_vectors(ioapic);
>  	kvm_vcpu_request_scan_ioapic(kvm);
>  	kvm_ioapic_inject_all(ioapic, state->irr);
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 3c91955..a5cdfc0 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -77,6 +77,7 @@ struct kvm_ioapic {
>  	struct rtc_status rtc_status;
>  	struct delayed_work eoi_inject;
>  	u32 irq_eoi[IOAPIC_NUM_PINS];
> +	u32 irr_delivered;
>  };
> =20
>  #ifdef DEBUG
>=20

Does this introduce a state which requires save/restore on migration? If
so, then you need to extend the existing interface - in a
backward-compatible way. If not, please leave a remark on the reason.

Jan



--of7rTMvcQnktjhIVnpTRaRfm7PerVmuAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlSa29IACgkQitSsb3rl5xT+zQCgi4x+WLEPAhdEeeklpkVYCvTQ
x/8AoKQiqxb13h+mV7KWXM8IDkwm3Sko
=Rvee
-----END PGP SIGNATURE-----

--of7rTMvcQnktjhIVnpTRaRfm7PerVmuAE--
