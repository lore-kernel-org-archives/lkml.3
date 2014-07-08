Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaGHJ3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:29:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:53840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaGHJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:29:32 -0400
Date: Tue, 8 Jul 2014 11:29:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Message-ID: <20140708092923.GC6758@twins.programming.kicks-ass.net>
References: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R6pG8OF89Zv1WQ+4"
Content-Disposition: inline
In-Reply-To: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R6pG8OF89Zv1WQ+4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 06:34:25AM -0700, kan.liang@intel.com wrote:
> @@ -555,7 +577,11 @@ static inline void __x86_pmu_enable_event(struct hw_=
perf_event *hwc,
>  {
>  	u64 disable_mask =3D __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
> =20
> -	if (hwc->extra_reg.reg)
> +	if (hwc->extra_reg.reg &&
> +		((hwc->extra_reg.idx =3D=3D EXTRA_REG_RSP_0) ?
> +			x86_pmu.extra_msr_access[0] : true) &&
> +		((hwc->extra_reg.idx =3D=3D EXTRA_REG_RSP_1) ?
> +			x86_pmu.extra_msr_access[1] : true))
>  		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
>  	wrmsrl(hwc->config_base, (hwc->config | enable_mask) & ~disable_mask);
>  }

> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu=
/perf_event_intel.c
> index adb02aa..3d18765 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c

> +	/*
> +	 * Access extra MSR may cause #GP under certain circumstances.
> +	 * E.g. KVM doesn't support offcore event
> +	 * Check all extra_regs here.
> +	 */
> +	if (x86_pmu.extra_regs) {
> +		x86_pmu.extra_msr_access[0] =3D
> +			check_msr(x86_pmu.extra_regs[EXTRA_REG_RSP_0].msr);
> +
> +		/* Not all platforms have EXTRA_REG_RSP_1 */
> +		if (x86_pmu.extra_regs[EXTRA_REG_RSP_1].idx =3D=3D EXTRA_REG_RSP_1)
> +			x86_pmu.extra_msr_access[1] =3D
> +			check_msr(x86_pmu.extra_regs[EXTRA_REG_RSP_1].msr);
> +		/*
> +		 * If there is no EXTRA_REG_RSP_1 support,
> +		 * just set the flag to be true.
> +		 * So it is ignored at the runtime check.
> +		 */
> +		else
> +			x86_pmu.extra_msr_access[1] =3D true;
> +	}

This too is wrong in many ways; there's more than 2 extra_msrs on many
systems.

And the place you check is abysmal, if we know at init time that we
don't have those MSRs, WTF do you allow event creation that would use
them, only to then misbehave?

--R6pG8OF89Zv1WQ+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu7nyAAoJEHZH4aRLwOS6TZQP/RFX1Gr0YriYNpfowue5SgOg
Kl90NjUWAmbLDYsksH9ale4O6P+bUmP22R7jStQ3f5rqmoBa5HKB9NXkEpvDKWiG
K9IRrKZUUPcqjmp9UaZgBkJ8MKMWV7oPeWuvt41VWgVICQtGdSGYjo7iXdryLRNS
E/xTLGQ0R8ZmBqJainoOQ/Letg9qhD0arVOawgh54BMRtEClucuwUDGAZiRKzGjg
s9/Gvlht5GwsTFK/215sBbWqVsT1MdA9OPGIjVpWc3xCqqmTHeCJIG8C3gJo0PE1
RPOZAEcev63dlbxqqcdu2uEnmHx9/9QfMkhH3+9dvXe7SU1hKpZZftBcPNaefTkn
rgUvC4tV+h+TNfvXm0l07P1XyqKCuAzJ8qU5ERxIZkSePfPSoPojom3ZSyUdHTKl
C2fWIkdtyxbyEo3UvLmH6D7HxOzHM8dlMqFhVKWGeZtZunpMIeZvNRp5lUNGj/qB
qHK2Kb5WZauUd+ja3LxmfErtyAniHZ6OGeGKechmdDvQLL2VE/8V4HO3PIoZrLsh
bL1TbQuxeS0VAHV4OGPYXUsnzu4Sm4qASvZ0abV+1qc8KF8VHj9bssLMI9z0/Q4e
R1H4SNL08mpEsYSnFBAuL1ty9Sw4W0SygNXeoDLRNIVIbsjg7IrWcd617HTTUUJF
R97Ab7FVuxOvhaQbX0Yp
=8fTl
-----END PGP SIGNATURE-----

--R6pG8OF89Zv1WQ+4--
