Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaGOPLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:11:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaGOPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:11:39 -0400
Date: Tue, 15 Jul 2014 17:11:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V6 1/2] perf ignore LBR and extra_rsp
Message-ID: <20140715151130.GK6758@twins.programming.kicks-ass.net>
References: <1405365957-20202-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kza01WAI6/G3rFVM"
Content-Disposition: inline
In-Reply-To: <1405365957-20202-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kza01WAI6/G3rFVM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 12:25:56PM -0700, kan.liang@intel.com wrote:

Close enough.

> +#define EVENT_EXTRA_REG(e, ms, m, vm, i, a) {	\
> +	.event =3D (e),			\
> +	.msr =3D (ms),			\
> +	.config_mask =3D (m),		\
> +	.valid_mask =3D (vm),		\
> +	.idx =3D EXTRA_REG_##i,		\
> +	.extra_msr_access =3D (a),	\
>  	}
> =20
>  #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
> -	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx)
> +	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, idx, true)
> =20
>  #define INTEL_UEVENT_EXTRA_REG(event, msr, vm, idx) \
>  	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
> -			ARCH_PERFMON_EVENTSEL_UMASK, vm, idx)
> +			ARCH_PERFMON_EVENTSEL_UMASK, vm, idx, true)
> =20
>  #define INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(c) \
>  	INTEL_UEVENT_EXTRA_REG(c, \
> @@ -318,7 +320,7 @@ struct extra_reg {
>  			       0xffff, \
>  			       LDLAT)
> =20
> -#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0)
> +#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, RSP_0, false)

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/ker=
nel/cpu/perf_event_intel_uncore.h
> index 90236f0..d860e26 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> @@ -366,11 +366,11 @@
>  				NHMEX_M_PMON_CTL_FLAG_MODE)
>  #define MBOX_INC_SEL_EXTAR_REG(c, r) \
>  		EVENT_EXTRA_REG(MBOX_INC_SEL(c), NHMEX_M0_MSR_PMU_##r, \
> -				MBOX_INC_SEL_MASK, (u64)-1, NHMEX_M_##r)
> +				MBOX_INC_SEL_MASK, (u64)-1, NHMEX_M_##r, true)
>  #define MBOX_SET_FLAG_SEL_EXTRA_REG(c, r) \
>  		EVENT_EXTRA_REG(MBOX_SET_FLAG_SEL(c), NHMEX_M0_MSR_PMU_##r, \
>  				MBOX_SET_FLAG_SEL_MASK, \
> -				(u64)-1, NHMEX_M_##r)
> +				(u64)-1, NHMEX_M_##r, true)
> =20
>  /* NHM-EX Rbox */
>  #define NHMEX_R_MSR_GLOBAL_CTL			0xe00


Since nobody ever treats EVENT_EXTRA_END as an actual event, the value
of .extra_msr_access is irrelevant, this leaves the only 'possible'
value 'true' and we can delete all those changes.

Which, combined with a few whitespace cleanups, gives the below patch.

---
Subject: x86, perf: Protect LBR and extra_regs against KVM lying
=46rom: Kan Liang <kan.liang@intel.com>
Date: Mon, 14 Jul 2014 12:25:56 -0700

With -cpu host, KVM reports LBR and extra_regs support, if the host has
support.

When the guest perf driver tries to access LBR or extra_regs MSR,
it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs suppor=
t.
So check the related MSRs access right once at initialization time to avoid
the error access at runtime.

For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL =
=3D y
(for host kernel).
And CONFIG_PARAVIRT =3D n and CONFIG_KVM_GUEST =3D n (for guest kernel).
Start the guest with -cpu host.
Run perf record with --branch-any or --branch-filter in guest to trigger LBR
Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in guest =
to
trigger offcore_rsp #GP

Cc: andi@firstfloor.org
Signed-off-by: Kan Liang <kan.liang@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1405365957-20202-1-git-send-email-kan.liang@=
intel.com
---

 arch/x86/kernel/cpu/perf_event.c       |    3 +
 arch/x86/kernel/cpu/perf_event.h       |   12 +++---
 arch/x86/kernel/cpu/perf_event_intel.c |   66 ++++++++++++++++++++++++++++=
++++-
 3 files changed, 75 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
+		/* Check if the extra msrs can be safely accessed*/
+		if (!er->extra_msr_access)
+			return -ENXIO;
=20
 		reg->idx =3D er->idx;
 		reg->config =3D event->attr.config1;
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -295,14 +295,16 @@ struct extra_reg {
 	u64			config_mask;
 	u64			valid_mask;
 	int			idx;  /* per_xxx->regs[] reg index */
+	bool			extra_msr_access;
 };
=20
 #define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
-	.event =3D (e),		\
-	.msr =3D (ms),		\
-	.config_mask =3D (m),	\
-	.valid_mask =3D (vm),	\
-	.idx =3D EXTRA_REG_##i,	\
+	.event =3D (e),			\
+	.msr =3D (ms),			\
+	.config_mask =3D (m),		\
+	.valid_mask =3D (vm),		\
+	.idx =3D EXTRA_REG_##i,		\
+	.extra_msr_access =3D true,	\
 	}
=20
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2182,6 +2182,41 @@ static void intel_snb_check_microcode(vo
 	}
 }
=20
+/*
+ * Under certain circumstances, access certain MSR may cause #GP.
+ * The function tests if the input MSR can be safely accessed.
+ */
+static bool check_msr(unsigned long msr, u64 mask)
+{
+	u64 val_old, val_new, val_tmp;
+
+	/*
+	 * Read the current value, change it and read it back to see if it
+	 * matches, this is needed to detect certain hardware emulators
+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
+	 */
+	if (rdmsrl_safe(msr, &val_old))
+		return false;
+
+	/*
+	 * Only change the bits which can be updated by wrmsrl.
+	 */
+	val_tmp =3D val_old ^ mask;
+	if (wrmsrl_safe(msr, val_tmp) ||
+	    rdmsrl_safe(msr, &val_new))
+		return false;
+
+	if (val_new !=3D val_tmp)
+		return false;
+
+	/* Here it's sure that the MSR can be safely accessed.
+	 * Restore the old value and return.
+	 */
+	wrmsrl(msr, val_old);
+
+	return true;
+}
+
 static __init void intel_sandybridge_quirk(void)
 {
 	x86_pmu.check_microcode =3D intel_snb_check_microcode;
@@ -2271,7 +2306,8 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
-	int version;
+	struct extra_reg *er;
+	int version, i;
=20
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -2577,6 +2613,34 @@ __init int intel_pmu_init(void)
 		}
 	}
=20
+	/*
+	 * Access LBR MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support LBR MSR
+	 * Check all LBT MSR here.
+	 * Disable LBR access if any LBR MSRs can not be accessed.
+	 */
+	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
+		x86_pmu.lbr_nr =3D 0;
+	for (i =3D 0; i < x86_pmu.lbr_nr; i++) {
+		if (!(check_msr(x86_pmu.lbr_from + i, 0xffffUL) &&
+		      check_msr(x86_pmu.lbr_to + i, 0xffffUL)))
+			x86_pmu.lbr_nr =3D 0;
+	}
+
+	/*
+	 * Access extra MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support offcore event
+	 * Check all extra_regs here.
+	 */
+	if (x86_pmu.extra_regs) {
+		for (er =3D x86_pmu.extra_regs; er->msr; er++) {
+			er->extra_msr_access =3D check_msr(er->msr, 0x1ffUL);
+			/* Disable LBR select mapping */
+			if ((er->idx =3D=3D EXTRA_REG_LBR) && !er->extra_msr_access)
+				x86_pmu.lbr_sel_map =3D NULL;
+		}
+	}
+
 	/* Support full width counters using alternative MSR range */
 	if (x86_pmu.intel_cap.full_width_write) {
 		x86_pmu.max_period =3D x86_pmu.cntval_mask;

--kza01WAI6/G3rFVM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxUSiAAoJEHZH4aRLwOS6FgQQAIViNwdf/cV1S2C5QU8xEWeC
LlZJOA06HwZ83gVZWhuciPEQ5/FS9uaGfSbp7Oh/zhK7WfDsl32HcZFsN6o59Rkj
CghWSlC6iy+9iiMRTl10FaTigmRLmkKOtc/iNHUoefJ4awCVp3k03ynoRXzeyzoU
PtelqprTGIKJqJ9VU2bMKi167JFvyOey8P2cnuJufovqC0gNUNk7Q1nGFO3/eFex
lgIydtZOPBjHR6tMlynpKbF0xQtYWGPiE6aJ7x4wf9Kliwdz74lgyY7yqn0s5/DC
7zW1WPehT0ceqhB0uFfCZPfEJwIgvpa3jtSAnjiyzhAIUDC0ldEtY+ehSArdS8W4
2nAZRzXq2Q+eRg+XogcnQEzdLoN+/AX9V8Ehj/7tUuR/HCUD8ZRhlnb3TqLUH5rt
ZoPqHkEpuG1InHkzN7G/dI9qA2UZsPiWMx5fo3jCGQenJ4tFydH6TlBsjG+iedP5
7LZo91x6SigK9KNymUP0dIartqk+oNCfSJI1DnUWkg3+iq2J+5HSQPu+06AEyPj4
9jyR13Y9HGqtWNMgjlg7AGzJd4mns/+0JGpURfNu53PQ9YnFo6EwSNfu3MSR69Uq
3fAvjhv+7Eqqbf15h0oom64O9jU0np7PKSL3ROLqoVW1btELnhKE90AuMYUb0Xyk
2Nzp+uXY93mnVTTUmFtW
=KQvm
-----END PGP SIGNATURE-----

--kza01WAI6/G3rFVM--
