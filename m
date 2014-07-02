Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaGBLNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:13:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:60154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaGBLNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:13:34 -0400
Date: Wed, 2 Jul 2014 13:13:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 15/16] perf, x86: disable FREEZE_LBRS_ON_PMI when LBR
 operates in callstack mode
Message-ID: <20140702111326.GD6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-16-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lXGjgdROvQphKPvG"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-16-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lXGjgdROvQphKPvG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:50:52PM +0800, Yan, Zheng wrote:
> LBR callstack is designed for PEBS, It does not work well with
> FREEZE_LBRS_ON_PMI for non PEBS event. If FREEZE_LBRS_ON_PMI is set for
> non PEBS event, PMIs near call/return instructions may cause superfluous
> increase/decrease of LBR_TOS.
>=20
> This patch modifies __intel_pmu_lbr_enable() to not enable
> FREEZE_LBRS_ON_PMI when LBR operates in callstack mode. We currently
> don't use LBR callstack to capture kernel space callchain, so disabling
> FREEZE_LBRS_ON_PMI should not be a problem.
>=20
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel=
/cpu/perf_event_intel_lbr.c
> index f059b98..dd14f67 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -138,7 +138,14 @@ static void __intel_pmu_lbr_enable(void)
>  		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
> =20
>  	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> -	debugctl |=3D (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
> +	debugctl |=3D DEBUGCTLMSR_LBR;
> +	/*
> +	 * LBR callstack does not work well with FREEZE_LBRS_ON_PMI.
> +	 * If FREEZE_LBRS_ON_PMI is set, PMI near call/return instructions
> +	 * may cause superfluous increase/decrease of LBR_TOS.
> +	 */
> +	if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
> +		debugctl |=3D DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
>  	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);

Something like so perhaps? Its slightly bigger, but less messy.

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/c=
pu/perf_event_intel_lbr.c
index 9dd2459a4c73..a55670529b9e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -132,14 +132,18 @@ static void intel_pmu_lbr_filter(struct cpu_hw_events=
 *cpuc);
=20
 static void __intel_pmu_lbr_enable(void)
 {
-	u64 debugctl;
 	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
+	u64 debugctl, lbr_select =3D 0;
=20
-	if (cpuc->lbr_sel)
-		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
+	if (cpuc->lbr_sel) {
+		lbr_select =3D cpuc->lbr_sel->config;
+		wrmsrl(MSR_LBR_SELECT, lbr_config);
+	}
=20
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	debugctl |=3D (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
+	debugctl |=3D DEBUGCTLMSR_LBR;
+	if (!(lbr_select & LBR_CALL_STACK))
+		debugctl |=3D DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
=20

--lXGjgdROvQphKPvG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs+lWAAoJEHZH4aRLwOS6so8P/3wYP9piRktRKZxfFibKtEWF
mKhtRjNYi9cEgklrnTz4NQ6ylIdns5RYDR4XFQyI4e+2O9gmxDEd9fwl+6eibug/
FBSwIgaz5EhvtwN0uUPIl7xiGbHbw2Gi1Iqg0cV6uhwh7re/joLvm4Jx3rFtYFNJ
lB8GheLErBoJrhM3IP0i0dpX8Yndghn5dbQt1UJG6to9QiC8qw+PEUrQ0MH2aHWA
mY0MC0iQWJETGpRw9x+aXC0VyuDtI9beCZvdQA+JAxzC7E2Z/wnNqCpzJ58efJ9C
JaF49VXtqLAftKpwbN+8Dv16WHS5GDja3TgxiYv4I2ub2192SPbpvlDrGbg/dqgd
agT3KmFQwp5vBiSqEwzO2yj14qtq9kyB9oxdlPM8gHOSjC9lRkDXRtdVfdhLv5fF
ft7RYdID0Gf+wQzBnnrMJSm695plxNgNNREfsA2HzzmVqc9rjllRc0wrl0nccqa/
AWsEWDZ4lwMqS3n3aehPCCjJfNvs6Bq7T6XTbH/1YzwWG0hsRg3IkS/fOOyKoOUi
z+Xn5ErwwHyYOs0XSz5HRe8JGrYaIfI1LZFy9OmxRTMO2lM/LlAat513x8cLcleN
tqB0iB9tfYmD3TrJDwnULlIa9n9zmbpF7pP+5OVU+lyYok6vprWydPgEeB4UQT0l
zdzzdnuWKfHYNWs5Tuj0
=SlUN
-----END PGP SIGNATURE-----

--lXGjgdROvQphKPvG--
