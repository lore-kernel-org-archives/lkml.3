Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbaGOKOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:14:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbaGOKOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:14:31 -0400
Date: Tue, 15 Jul 2014 12:14:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 3/7] perf, x86: use the PEBS auto reload mechanism
 when possible
Message-ID: <20140715101418.GZ9918@twins.programming.kicks-ass.net>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
 <1405414739-31455-4-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fh+fyCUbzktHKe74"
Content-Disposition: inline
In-Reply-To: <1405414739-31455-4-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fh+fyCUbzktHKe74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 04:58:55PM +0800, Yan, Zheng wrote:
> When a fixed period is specified, this patch make perf use the PEBS
> auto reload mechanism. This makes normal profiling faster, because
> it avoids one costly MSR write in the PMI handler.
>=20
> Signef-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c          | 15 +++++++++------
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |  7 +++++++
>  include/linux/perf_event.h                |  1 +
>  3 files changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_=
event.c
> index 8868e9b..ae723c8 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -979,13 +979,16 @@ int x86_perf_event_set_period(struct perf_event *ev=
ent)
> =20
>  	per_cpu(pmc_prev_left[idx], smp_processor_id()) =3D left;
> =20
> -	/*
> -	 * The hw event starts counting from this event offset,
> -	 * mark it to be able to extra future deltas:
> -	 */
> -	local64_set(&hwc->prev_count, (u64)-left);
> +	if (!hwc->autoreload ||
> +	    local64_read(&hwc->prev_count) !=3D (u64)-left) {

Do you really need that line break? I suspect it comes it at or below 80
if you concat.

> +		/*
> +		 * The hw event starts counting from this event offset,
> +		 * mark it to be able to extra future deltas:
> +		 */
> +		local64_set(&hwc->prev_count, (u64)-left);
> =20
> -	wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
> +		wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
> +	}
> =20
>  	/*
>  	 * Due to erratum on certan cpu we need
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/=
cpu/perf_event_intel_ds.c
> index 980970c..1db4ce5 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -714,6 +714,7 @@ void intel_pmu_pebs_enable(struct perf_event *event)
>  	struct hw_perf_event *hwc =3D &event->hw;
> =20
>  	hwc->config &=3D ~ARCH_PERFMON_EVENTSEL_INT;
> +	hwc->autoreload =3D !event->attr.freq;
> =20
>  	cpuc->pebs_enabled |=3D 1ULL << hwc->idx;
> =20
> @@ -721,6 +722,11 @@ void intel_pmu_pebs_enable(struct perf_event *event)
>  		cpuc->pebs_enabled |=3D 1ULL << (hwc->idx + 32);
>  	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
>  		cpuc->pebs_enabled |=3D 1ULL << 63;
> +
> +	/* Use auto-reload if possible to save a MSR write in the PMI */
> +	if (hwc->autoreload)
> +		ds->pebs_event_reset[hwc->idx] =3D
> +			(u64)-hwc->sample_period & x86_pmu.cntval_mask;

The rule is to add { } for any multi-line block, not the strict single
stmt as per the C language.

>  }
> =20
>  void intel_pmu_pebs_disable(struct perf_event *event)
> @@ -739,6 +745,7 @@ void intel_pmu_pebs_disable(struct perf_event *event)
>  		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
> =20
>  	hwc->config |=3D ARCH_PERFMON_EVENTSEL_INT;
> +	hwc->autoreload =3D false;
>  }
> =20
>  void intel_pmu_pebs_enable_all(void)
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 5d665e8..37a2b70 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -149,6 +149,7 @@ struct hw_perf_event {
> =20
>  	u64				freq_time_stamp;
>  	u64				freq_count_stamp;
> +	bool				autoreload;

No, that's not the right place. If you'd looked at the structure you'd
have seen that this is the place for generic members, ones that apply to
all events, this is PEBS only, PEBS is limited to hardware events,
there's a section for that.

When you've found that, you'll note we have a flags field in there,
there's spare bits in there, use one.

--Fh+fyCUbzktHKe74
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxP76AAoJEHZH4aRLwOS6uxEQAK8GIL0Agos59KoviMmfmPFe
r6/nrz+PvMByVKQMzBIz03172kZCACBlF4VpUAETob5QDuWAISCDdpGF4mM/lxW+
RfQgFul7A8MLO5fA1XGdWAELA/c+v95CYgB4dw/eguKuIto4Lz+GLRgfVima/X2M
A7zF0OXwVY2TpG+TJ79rYFLdpF0bd84wPlHRVNIFBg0bHDO8YX1c1tyfkLbCFzu/
Yqr8prPN27xWtFJ1YXt67fq7IulBDT8v6IRCSBynae3q+V0HuNLiGJE9CP6+yQYh
7jKmtWtpRgzUDcirTtiRAp6EPIA4VjczN30OO7LqUpyFEeXSKGLuz1ykq8C++y6k
I6oLxCBfBiG5HtHvXc8z+Qe9lHcbwLAsnaSHxMdIfOL/q7TcQoawKRTZTm9pkrIV
09faRXFy0FOoqpupVFaYQOL9KHSmj4qkA9XJinC27OruJJMB/F5/59gq/BNp4iO1
vqND00E7edTWtG3y3bw5HzFxWL0K6gDHxlhoCmFDlETE9ApF46l+RfOqdso8Vb9b
it8oYbvKaD7ASvolwk8YnqwX2WA/82kPcC4AXuQCK0XSVqNd/NYiCQ8TjioDCSjQ
95xLOq9iFbsdL3U8REvQC9dhdjsjuS3hsQuHKGR3lSdSOfWj1Sb07WrFdQpmr1Ho
/5AVL9O6/WRpE5pQW1Kr
=octD
-----END PGP SIGNATURE-----

--Fh+fyCUbzktHKe74--
