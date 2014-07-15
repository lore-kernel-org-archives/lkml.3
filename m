Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbaGOL5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:57:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753AbaGOL53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:57:29 -0400
Date: Tue, 15 Jul 2014 13:57:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 5/7] perf, x86: drain PEBS buffer during context switch
Message-ID: <20140715115717.GE9918@twins.programming.kicks-ass.net>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
 <1405414739-31455-6-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6DRyk0WLoccTprpY"
Content-Disposition: inline
In-Reply-To: <1405414739-31455-6-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6DRyk0WLoccTprpY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 04:58:57PM +0800, Yan, Zheng wrote:
> +void intel_pmu_drain_pebs_buffer(void)
> +{
> +	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
> +	struct debug_store *ds =3D cpuc->ds;
> +	struct pt_regs regs;
> +
> +	if (!x86_pmu.pebs_active)
> +		return;
> +	if (ds->pebs_index <=3D ds->pebs_buffer_base)
> +		return;

Both implementations of drain_pebs() already do that.

> +	x86_pmu.drain_pebs(&regs);
> +}

> @@ -759,8 +787,19 @@ void intel_pmu_pebs_disable(struct perf_event *event)
>  {
>  	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
>  	struct hw_perf_event *hwc =3D &event->hw;
> +	struct debug_store *ds =3D cpuc->ds;
> +	bool multi_pebs =3D false;
> +
> +	if (ds->pebs_interrupt_threshold >
> +	    ds->pebs_buffer_base + x86_pmu.pebs_record_size)
> +		multi_pebs =3D true;
> =20
>  	cpuc->pebs_enabled &=3D ~(1ULL << hwc->idx);
> +	if (cpuc->pebs_sched_cb_enabled &&
> +	    !(cpuc->pebs_enabled & ((1ULL << MAX_PEBS_EVENTS) - 1))) {

You seem fond of that expression, maybe make it an inline somewhere to
avoid all this repetition.

> +		perf_sched_cb_disable(event->ctx->pmu);
> +		cpuc->pebs_sched_cb_enabled =3D false;
> +	}
> =20
>  	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
>  		cpuc->pebs_enabled &=3D ~(1ULL << (hwc->idx + 32));
> @@ -772,6 +811,9 @@ void intel_pmu_pebs_disable(struct perf_event *event)
> =20
>  	hwc->config |=3D ARCH_PERFMON_EVENTSEL_INT;
>  	hwc->autoreload =3D false;
> +
> +	if (multi_pebs)
> +		intel_pmu_drain_pebs_buffer();
>  }

Is that condition worth the effort? Seeing how you already need to load
the DS state to compute multi_pebs in the first place.

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel=
/cpu/perf_event_intel_lbr.c
> index 430f1ad..a3df61d 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -199,8 +199,6 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>  {
>  	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
> =20
> -	if (!x86_pmu.lbr_nr)
> -		return;
>  	/*
>  	 * Reset the LBR stack if we changed task context to
>  	 * avoid data leaks.

More random hunks?

--6DRyk0WLoccTprpY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxRcdAAoJEHZH4aRLwOS67UQQAIQJFJasfe/Hu1vsUsR0sS1m
FwSUa3tVd9k1/Nn0F1kOhtsGzr6izNHurh58+DZMxnvtMiLrhI9rRpl8LZtrYbLf
fxR+/zBaBh+GdDVP/xY35oqUoU7hWASQB/lCqAeoVq6UxpQ/r0XCXU2gTiBbOWZ2
lnTn5MBZXBg0KGd/kzp9kjXt7IfQQL7ZbACjGQknN2Rzs2KLTCa3fm2RiUiOzoPu
MyeUINzgu/r84DQZZoD2YuWUjnQLbp9JAI6qVh6nTW/FFIUSOy/cNyt3PhA7G8oE
W6SMegS2dNVfVV79KdWx1o0oOOMi+TTwKRWsn51U9bTJxS9IB8ABsTRuqymChciB
Fe0o/1vAcqL3YROyFfUSqRCNH69ih5r8QHOXH2TOQS6UX0BZLFvNZRn82YwtZwIp
fw58NeFEDyu7rJ4s8R/rsfXxAJCiglv+ZIPbGAJXf2AX5nvVLguvCk+dDoxc7hNf
5l+vOx0Ovq6aEj0/w/wn8Jw3KP7gxe2279qne4OhFETbWBVVQOzSJTNdj+PY7sKb
diWs9J7PNa+rbXY4Im+w/CKWEYifbpvAjuVpNN2Nf57GxsLxrjvPUZGUrbFdZNOx
kUBqNYc9DSmjQVJdRrsM3yvdG2KfdKQkXtl6p5iwMp7CI3effWpY7xLq6wGmS0K8
1Qcm2UyFVhNyZUu2f3aQ
=e7cv
-----END PGP SIGNATURE-----

--6DRyk0WLoccTprpY--
