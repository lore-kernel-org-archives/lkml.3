Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbaGNKyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:54:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaGNKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:53:51 -0400
Date: Mon, 14 Jul 2014 12:53:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
Message-ID: <20140714105341.GT9918@twins.programming.kicks-ass.net>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHrxbAcqt/LxKPZN"
Content-Disposition: inline
In-Reply-To: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHrxbAcqt/LxKPZN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 03:59:43AM -0700, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
>=20
> x86, perf: Protect LBR and extra_regs against KVM lying
>=20
> With -cpu host, KVM reports LBR and extra_regs support, if the host has s=
upport.
> When the guest perf driver tries to access LBR or extra_regs MSR,
> it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs supp=
ort.
> So check the related MSRs access right once at initialization time to avo=
id the error access at runtime.
>=20
> For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL =
=3D y (for host kernel).
> And CONFIG_PARAVIRT =3D n and CONFIG_KVM_GUEST =3D n (for guest kernel).
> Start the guest with -cpu host.
> Run perf record with --branch-any or --branch-filter in guest to trigger =
LBR #GP.
> Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in gues=
t to trigger offcore_rsp #GP

This is still not properly wrapped at 78 chars.

> Signed-off-by: Kan Liang <kan.liang@intel.com>
>=20
> V2: Move the check code to initialization time.
> V3: Add flag for each extra register.
>     Check all LBR MSRs at initialization time.
> V4: Remove lbr_msr_access. For LBR msr, simply set lbr_nr to 0 if check_m=
sr failed.
>     Disable all extra msrs in creation places if check_msr failed.
> V5: Fix check_msr broken
>     Don't check any more MSRs after the first fail
>     Return error when checking fail to stop creating the event
>     Remove the checking code path which never get

These things should go below the --- so they get thrown away when
applying the patch, its of no relevance once applied.

> ---
>  arch/x86/kernel/cpu/perf_event.c       |  3 +++
>  arch/x86/kernel/cpu/perf_event.h       | 45 ++++++++++++++++++++++++++++=
++++++
>  arch/x86/kernel/cpu/perf_event_intel.c | 38 +++++++++++++++++++++++++++-
>  3 files changed, 85 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_=
event.c
> index 2bdfbff..a7c5e4b 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf=
_event *event)
>  			continue;
>  		if (event->attr.config1 & ~er->valid_mask)
>  			return -EINVAL;
> +		/* Check if the extra msrs can be safely accessed*/
> +		if (!x86_pmu.extra_msr_access[er->idx])
> +			return -EFAULT;

This is not a correct usage of -EFAULT. Event creation did not fail
because we took a fault dereferencing a user provided pointer. Possibly
ENXIO is appropriate.

>  		reg->idx =3D er->idx;
>  		reg->config =3D event->attr.config1;
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_=
event.h
> index 3b2f9bd..992c678 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -464,6 +464,12 @@ struct x86_pmu {
>  	 */
>  	struct extra_reg *extra_regs;
>  	unsigned int er_flags;
> +	/*
> +	 * EXTRA REG MSR can be accessed
> +	 * The extra registers are completely unrelated to each other.
> +	 * So it needs a flag for each extra register.
> +	 */
> +	bool		extra_msr_access[EXTRA_REG_MAX];

So why not in struct extra_reg again? You didn't give a straight answer
there.

> +/*
> + * Under certain circumstances, access certain MSR may cause #GP.
> + * The function tests if the input MSR can be safely accessed.
> + */
> +static inline bool check_msr(unsigned long msr)
> +{

This reads like a generic function;

> +	u64 val_old, val_new, val_tmp;
> +
> +	/*
> +	 * Read the current value, change it and read it back to see if it
> +	 * matches, this is needed to detect certain hardware emulators
> +	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
> +	 */
> +	if (rdmsrl_safe(msr, &val_old))
> +		goto msr_fail;
> +	/*
> +	 * Only chagne it slightly,
> +	 * since the higher bits of some MSRs cannot be updated by wrmsrl.
> +	 * E.g. MSR_LBR_TOS
> +	 */
> +	val_tmp =3D val_old ^ 0x3UL;

but this is not generally true; not all MSRs can write the 2 LSB, can
they? One option would be to extend the function with a u64 mask.

> +	if (wrmsrl_safe(msr, val_tmp) ||
> +		rdmsrl_safe(msr, &val_new))
> +		goto msr_fail;
> +
> +	if (val_new !=3D val_tmp)
> +		goto msr_fail;
> +
> +	/* Here it's sure that the MSR can be safely accessed.
> +	 * Restore the old value and return.
> +	 */
> +	wrmsrl(msr, val_old);
> +
> +	return true;
> +
> +msr_fail:
> +	return false;
> +}

Also, by now this function is far too large to be inline and in a
header.

> +	/*
> +	 * Access LBR MSR may cause #GP under certain circumstances.
> +	 * E.g. KVM doesn't support LBR MSR
> +	 * Check all LBT MSR here.
> +	 * Disable LBR access if any LBR MSRs can not be accessed.
> +	 */
> +	if (x86_pmu.lbr_nr) {
> +		if (check_msr(x86_pmu.lbr_tos)) {
> +			for (i =3D 0; i < x86_pmu.lbr_nr; i++) {
> +				if (!(check_msr(x86_pmu.lbr_from + i) &&
> +				      check_msr(x86_pmu.lbr_to + i))) {
> +					x86_pmu.lbr_nr =3D 0;
> +					break;
> +				}
> +			}
> +		} else
> +			x86_pmu.lbr_nr =3D 0;

That's needlessly complex and indented.

	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos)
		x86_pmu.lbr_nr =3D 0;

	for (i =3D 0; i < x86_pmu.lbr_nr; i++) {
		if (!(check_msr(x86_pmu.lbr_from + i) &&
		      check_msr(x86_pmu.lbr_to   + i)))
			x86_pmu.lbr_nr =3D 0;
	}

You don't need to wrap the for loop in a lbr_nr test and you don't need
a break to terminate. Once you set lbr_nr =3D 0, the for loop will
terminate on its own. If it was already 0 it would've never started.


--eHrxbAcqt/LxKPZN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw7a1AAoJEHZH4aRLwOS6RDQP/RFVFbJ1IwX5YMj1cfeP1aVL
lV30TpUz+tB6ncsYLRbau9gTjoPp4y+P1mo1/T9n9BZY8qySzs7CyQDcL7ckaySh
7pM5olJI1M++YDX29sGeM+kntR9bBglZmzghdDlr+Jb9VN7oaWclQUucfLJZ1v6j
ChhBOikmz+d8Rh4dp1fWGSMdnfoR1wFTTAgRtwb1zhb0lEu5Hgvq4387DqQFk2hq
Pu5AdOV/Wh0KzTQpmBm4Mzc6YRnBVLMqMNEWvJG2/RCzzaWQT1xr84AAqlmUZtmj
9Qe1S1Vj5J0XS1DlUHiyjER/NDmoCUJjPc22J33mQFHxKJMBqvyPFIv8RNxoi+8n
7Y1S+y694YAKm4KnIacTEYDD4S1rReUqvOu8oHpT/wRqvbH5s+TzbaGbDddn9GeU
L5jX5myYtqvccaT9SiffFTi4OuiLa2SjLFl66GwQLEnjmm/eAAQPWPqLJ53lwFqN
dghk8t9oZHrHE5GsY2NJaD8wcRCcJvYfWqt9VH0vwoAQsnvAfyoWfOqz8Nj/hXhq
dmPEDh0gonHvPTavrZj6dbr+Pufkrxe7f8s3zO1IgOXolbPHjY/rCSA+ZnNUpku4
10po6vWsZW7JfFKGJkgiIHUiBnRS17mbYGJliT9mIKlGxL9GEeGFcKTFGoM6vAQQ
7JgMl8WGQW+GX6MLAZtX
=4Y/X
-----END PGP SIGNATURE-----

--eHrxbAcqt/LxKPZN--
