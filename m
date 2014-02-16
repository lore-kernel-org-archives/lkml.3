Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaBPJCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 04:02:33 -0500
Received: from mout.web.de ([212.227.15.3]:63973 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaBPJCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 04:02:30 -0500
Message-ID: <53007E9D.2050205@web.de>
Date: Sun, 16 Feb 2014 10:02:21 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
References: <52E6AFFE.3030004@siemens.com>
In-Reply-To: <52E6AFFE.3030004@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rvkW1aclxGFlPWAHHWtT4rlMLAIPtPTuf"
X-Provags-ID: V03:K0:8wkHBvRdJrkUqd0OU7SpVEGeqwUmYRds3u4GNJ2maUPi2zvtgbS
 3XkcEKewaZbF89trAuotaWbGdWydXGi6OVjBmCeIR5/yIhKbQgHZTSOLs8aE8vyYXG2XrUd
 Kz6sD038by2CnQwDOk7JvhhFjiF6zmkNTYxs+1BjdmVEiXhczZTclJrZG2qIIh/sBws4Ae1
 U5r7M7UOtVsH5npfMHPbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rvkW1aclxGFlPWAHHWtT4rlMLAIPtPTuf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-27 20:14, Jan Kiszka wrote:
> apic_icr_write and its users in smpboot.c were apparently written under=

> the assumption that this code would only run during early boot. But
> nowadays we also execute it when onlining a CPU later on while the
> system is fully running. That will make wakeup_cpu_via_init_nmi and,
> thus, also native_apic_icr_write run in plain process context. If we
> migrate the caller to a different CPU at the wrong time or interrupt it=

> and write to ICR/ICR2 to send unrelated IPIs, we can end up sending
> INIT, SIPI or NMIs to wrong CPUs.
>=20
> Fix this by disabling interrupts during the write to the ICR halves and=

> disable preemption around waiting for ICR availability and using it.
>=20
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/kernel/apic/apic.c |  4 ++++
>  arch/x86/kernel/smpboot.c   | 11 +++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 7f26c9a..06f90b8 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -283,8 +283,12 @@ u32 native_safe_apic_wait_icr_idle(void)
> =20
>  void native_apic_icr_write(u32 low, u32 id)
>  {
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>  	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
>  	apic_write(APIC_ICR, low);
> +	local_irq_restore(flags);
>  }
> =20
>  u64 native_apic_icr_read(void)
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a32da80..37e11e5 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -701,11 +701,15 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long st=
art_ip, int apicid,
>  	int id;
>  	int boot_error;
> =20
> +	preempt_disable();
> +
>  	/*
>  	 * Wake up AP by INIT, INIT, STARTUP sequence.
>  	 */
> -	if (cpu)
> -		return wakeup_secondary_cpu_via_init(apicid, start_ip);
> +	if (cpu) {
> +		boot_error =3D wakeup_secondary_cpu_via_init(apicid, start_ip);
> +		goto out;
> +	}
> =20
>  	/*
>  	 * Wake up BSP by nmi.
> @@ -725,6 +729,9 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long star=
t_ip, int apicid,
>  		boot_error =3D wakeup_secondary_cpu_via_nmi(id, start_ip);
>  	}
> =20
> +out:
> +	preempt_enable();
> +
>  	return boot_error;
>  }
> =20
>=20

What's the status of this? Waiting for further review, or is it queued
somewhere by now? Would be good to have in 3.14, and then also in stable
kernels.

Jan


--rvkW1aclxGFlPWAHHWtT4rlMLAIPtPTuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMAfqAACgkQitSsb3rl5xSxfACfaP3Qpz++STBZpe6cw2EnYEyU
BhYAn0LW/E18PgPtfjItPV/fazoHELKO
=/ScW
-----END PGP SIGNATURE-----

--rvkW1aclxGFlPWAHHWtT4rlMLAIPtPTuf--
