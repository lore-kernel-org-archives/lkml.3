Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbaGOLi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:38:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438AbaGOLiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:38:55 -0400
Date: Tue, 15 Jul 2014 13:38:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140715113841.GC9918@twins.programming.kicks-ass.net>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
 <1405414739-31455-5-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dsOl/BEZn+65LpCE"
Content-Disposition: inline
In-Reply-To: <1405414739-31455-5-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dsOl/BEZn+65LpCE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 04:58:56PM +0800, Yan, Zheng wrote:
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.h           |  1 +
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  | 98 +++++++++++++++++++++---=
------
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |  5 --
>  3 files changed, 71 insertions(+), 33 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_=
event.h
> index d8165f3..cb7cda8 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -450,6 +450,7 @@ struct x86_pmu {
>  	struct event_constraint *pebs_constraints;
>  	void		(*pebs_aliases)(struct perf_event *event);
>  	int 		max_pebs_events;
> +	bool		multi_pebs;

This needs to die.

>  	/*
>  	 * Intel LBR
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/=
cpu/perf_event_intel_ds.c
> index 1db4ce5..e17eb5b 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -11,7 +11,7 @@
>  #define BTS_RECORD_SIZE		24
> =20
>  #define BTS_BUFFER_SIZE		(PAGE_SIZE << 4)
> -#define PEBS_BUFFER_SIZE	PAGE_SIZE
> +#define PEBS_BUFFER_SIZE	(PAGE_SIZE << 4)

See: http://lkml.kernel.org/r/alpine.DEB.2.02.1406301600460.26302@chino.kir=
=2Ecorp.google.com

Also talk about why 64k, mention NMI duration/processing overhead etc..

> @@ -708,14 +705,29 @@ struct event_constraint *intel_pebs_constraints(str=
uct perf_event *event)
>  	return &emptyconstraint;
>  }
> =20
> +/*
> + * Flags PEBS can handle without an PMI.
> + *
> + * TID can only be handled by flushing at context switch.
> + */
> +#define PEBS_FREERUNNING_FLAGS \
> +	(PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_ADDR | \
> +	 PERF_SAMPLE_ID | PERF_SAMPLE_CPU | PERF_SAMPLE_STREAM_ID | \
> +	 PERF_SAMPLE_DATA_SRC | PERF_SAMPLE_IDENTIFIER | \
> +	 PERF_SAMPLE_TRANSACTION)
> +
>  void intel_pmu_pebs_enable(struct perf_event *event)
>  {
>  	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
>  	struct hw_perf_event *hwc =3D &event->hw;
> +	struct debug_store *ds =3D cpuc->ds;
> +	u64 threshold;
> +	bool first_pebs;

flip those two lines

> =20
>  	hwc->config &=3D ~ARCH_PERFMON_EVENTSEL_INT;
>  	hwc->autoreload =3D !event->attr.freq;
> =20
> +	first_pebs =3D !(cpuc->pebs_enabled & ((1ULL << MAX_PEBS_EVENTS) - 1));
>  	cpuc->pebs_enabled |=3D 1ULL << hwc->idx;
> =20
>  	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
> @@ -723,6 +735,20 @@ void intel_pmu_pebs_enable(struct perf_event *event)
>  	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
>  		cpuc->pebs_enabled |=3D 1ULL << 63;
> =20
> +	/*
> +	 * When the event is constrained enough we can use a larger
> +	 * threshold and run the event with less frequent PMI.
> +	 */
> +	if (x86_pmu.multi_pebs && hwc->autoreload &&
> +	    !(event->attr.sample_type & ~PEBS_FREERUNNING_FLAGS)) {
> +		threshold =3D ds->pebs_absolute_maximum -
> +			x86_pmu.max_pebs_events * x86_pmu.pebs_record_size;
> +	} else {
> +		threshold =3D ds->pebs_buffer_base + x86_pmu.pebs_record_size;
> +	}

	threshold =3D 1;
	if ((hwc->flags & PERF_X86_EVENT_PEBS_RELOAD) &&
	    !(event->attr.sample_type & ~PEBS_FREERUNNING_FLAGS))
		threshold =3D x86_pmu.max_pebs_events;

	threshold =3D ds->pebs_buffer_base + threshold * x86_pmu.pebs_record_size;

> +	if (first_pebs || ds->pebs_interrupt_threshold > threshold)
> +		ds->pebs_interrupt_threshold =3D threshold;
> +
>  	/* Use auto-reload if possible to save a MSR write in the PMI */
>  	if (hwc->autoreload)
>  		ds->pebs_event_reset[hwc->idx] =3D

> @@ -880,7 +907,7 @@ static void __intel_pmu_pebs_event(struct perf_event =
*event,
>  	u64 sample_type;
>  	int fll, fst;
> =20
> -	if (!intel_pmu_save_and_restart(event))
> +	if (first_record && !intel_pmu_save_and_restart(event))
>  		return;
> =20
>  	fll =3D event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
> @@ -956,8 +983,22 @@ static void __intel_pmu_pebs_event(struct perf_event=
 *event,
>  	if (has_branch_stack(event))
>  		data.br_stack =3D &cpuc->lbr_stack;
> =20
> -	if (perf_event_overflow(event, &data, &regs))
> -		x86_pmu_stop(event, 0);
> +	if (first_record) {
> +		if (perf_event_overflow(event, &data, &regs))
> +			x86_pmu_stop(event, 0);
> +	} else {
> +		struct perf_output_handle handle;
> +		struct perf_event_header header;
> +
> +		perf_prepare_sample(&header, &data, event, &regs);
> +
> +		if (perf_output_begin(&handle, event, header.size))
> +			return;
> +
> +		perf_output_sample(&handle, &header, &data, event);
> +
> +		perf_output_end(&handle);
> +	}

That is disgusting, have a look at drain_bts_buffer() and try again.

>  }
> =20
>  static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
> @@ -998,17 +1039,18 @@ static void intel_pmu_drain_pebs_core(struct pt_re=
gs *iregs)
>  	WARN_ONCE(n > 1, "bad leftover pebs %d\n", n);
>  	at +=3D n - 1;
> =20
> -	__intel_pmu_pebs_event(event, iregs, at);
> +	__intel_pmu_pebs_event(event, iregs, at, true);
>  }
> =20
>  static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
>  {
>  	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
>  	struct debug_store *ds =3D cpuc->ds;
> -	struct perf_event *event =3D NULL;
> +	struct perf_event *event;
>  	void *at, *top;
>  	u64 status =3D 0;
>  	int bit;
> +	bool multi_pebs, first_record;

These should not be needed, but its also at the wrong place if it were.

>  	if (!x86_pmu.pebs_active)
>  		return;

> @@ -1042,17 +1086,15 @@ static void intel_pmu_drain_pebs_nhm(struct pt_re=
gs *iregs)
> =20
>  			if (!event->attr.precise_ip)
>  				continue;
> -
> -			if (__test_and_set_bit(bit, (unsigned long *)&status))
> -				continue;
> -
> -			break;
> +			if (!__test_and_set_bit(bit, (unsigned long *)&status)) {
> +				first_record =3D true;
> +			} else {
> +				if (!multi_pebs)
> +					continue;
> +				first_record =3D false;
> +			}
> +			__intel_pmu_pebs_event(event, iregs, at, first_record);
>  		}
> -
> -		if (!event || bit >=3D x86_pmu.max_pebs_events)
> -			continue;
> -
> -		__intel_pmu_pebs_event(event, iregs, at);

Distinct lack of properly handling the multi overflow case.

>  	}
>  }
> =20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel=
/cpu/perf_event_intel_lbr.c
> index d6d5fcf..430f1ad 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -184,10 +184,6 @@ void intel_pmu_lbr_reset(void)
>  void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched=
_in)
>  {
>  	struct cpu_hw_events *cpuc =3D &__get_cpu_var(cpu_hw_events);
> -
> -	if (!x86_pmu.lbr_nr)
> -		return;
> -
>  	/*
>  	 * It is necessary to flush the stack on context switch. This happens
>  	 * when the branch stack does not tag its entries with the pid of the
> @@ -408,7 +404,6 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf=
_event *event)
> =20
>  	if (br_type & PERF_SAMPLE_BRANCH_COND)
>  		mask |=3D X86_BR_JCC;
> -
>  	/*
>  	 * stash actual user request into reg, it may
>  	 * be used by fixup code for some CPU

WTF?

--dsOl/BEZn+65LpCE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxRLBAAoJEHZH4aRLwOS6BN8QAK00EQ/eKSLWJUSs9ntE2Qzg
Zi98bRbIwgPbYNA6Teekh5EgdnMXfrltqd8CqchfsvJWfRTe3CweOCQoj6J+BNqK
eQ4Noz25HtntZo4abgb2hDWxJf2RB2uSdMPpW+tkEiM4xxTnYSDwz5Do9dJr05pl
9lh6aGHeV6RLZnq6FGHV83i9djwPH130K11CFRKoVsaUq0+UWxqZo2Lh1Nv6QKtC
egwJlACbRiIQk/XiM37aBA9ixFhlbo8PH2auXSNb+/xgi0391UbiLeuLLdcSq+sd
ZqfCkXMvIj+gFDN7nDbKUK/EIi3ftkF1C6SYWrWuN1+g6DYpvQJBId+JsK8ln/0O
wjHetn8x7J3AXoA2ZtOWY6tyLGHFCsu38Rm6JPgJjSWItNAzzRS9huidoXhop9zv
ySRGStA6m1sd6s34VlPtEv40stWaSSJax8OWYmm1ZRNV2v5y6xl19LRtplZmnFoe
Lgg2h0oCPqqnFj/2UL2i9KWuAEfnRH3pJrySUEEMpx5bPOr4HNogrV7I7/EnxDe7
7iMGuMg4d3lcUewN3gCGVq+c6hojxJ3gLTAr/yS9U4jGq0JSP/0oZzrvQ8COyl8K
v9knZupNv7V3mTgvvLOetxAaBlo7B8T2n4VucWjY7oqxnKBoVly9QutFgcNkebkq
eGOAma8s7kUS2fjfz9WM
=p6n3
-----END PGP SIGNATURE-----

--dsOl/BEZn+65LpCE--
