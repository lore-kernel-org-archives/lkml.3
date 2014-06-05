Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaFEHr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:47:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:50684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFEHr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:47:57 -0400
Date: Thu, 5 Jun 2014 09:47:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20140605074753.GG3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-5-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HKEL+t8MFpg/ASTE"
Content-Disposition: inline
In-Reply-To: <1401917658-26065-5-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HKEL+t8MFpg/ASTE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 11:34:13PM +0200, Stephane Eranian wrote:
> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>=20
> This patch adds a new shared_regs style structure to the
> per-cpu x86 state (cpuc). It is used to coordinate access
> between counters which must be used with exclusion across
> HyperThreads on Intel processors. This new struct is not
> needed on each PMU, thus is is allocated on demand.
>=20
> Reviewed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_event.h       |   40 ++++++++++++++++++--
>  arch/x86/kernel/cpu/perf_event_intel.c |   63 ++++++++++++++++++++++++++=
+++---
>  2 files changed, 94 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_=
event.h
> index 413799f..5da0a2b 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -65,10 +65,11 @@ struct event_constraint {
>  /*
>   * struct hw_perf_event.flags flags
>   */
> -#define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling =
*/
> -#define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
> -#define PERF_X86_EVENT_PEBS_ST_HSW	0x4 /* haswell style st data sampling=
 */
> -#define PERF_X86_EVENT_COMMITTED	0x8 /* event passed commit_txn */
> +#define PERF_X86_EVENT_PEBS_LDLAT	0x01 /* ld+ldlat data address sampling=
 */
> +#define PERF_X86_EVENT_PEBS_ST		0x02 /* st data address sampling */
> +#define PERF_X86_EVENT_PEBS_ST_HSW	0x04 /* haswell style st data samplin=
g */
> +#define PERF_X86_EVENT_COMMITTED	0x08 /* event passed commit_txn */
> +#define PERF_X86_EVENT_EXCL		0x10 /* HT exclusivity on counter */
> =20
>  struct amd_nb {
>  	int nb_id;  /* NorthBridge id */
> @@ -119,6 +120,27 @@ struct intel_shared_regs {
>  	unsigned                core_id;	/* per-core: core id */
>  };
> =20
> +enum intel_excl_state_type {
> +	INTEL_EXCL_UNUSED    =3D 0, /* counter is unused */
> +	INTEL_EXCL_SHARED    =3D 1, /* counter can be used by both threads */
> +	INTEL_EXCL_EXCLUSIVE =3D 2, /* counter can be used by one thread only */
> +};
> +
> +struct intel_excl_states {
> +	enum intel_excl_state_type init_state[X86_PMC_IDX_MAX];
> +	enum intel_excl_state_type state[X86_PMC_IDX_MAX];
> +};
> +
> +struct intel_excl_cntrs {
> +	spinlock_t	lock;
> +	unsigned long	lock_flags;
> +
> +	struct intel_excl_states states[2];
> +
> +	int		refcnt;		/* per-core: #HT threads */
> +	unsigned	core_id;	/* per-core: core id */
> +};

This must be a raw_spin_lock_t, its taken from pmu::add() which is
called under perf_event_context::lock, which is raw_spinlock_t, as its
taken under rq::lock, which too is raw_spinlock_t.

I should really get around to fixing these errors and include the
lockdep infrastructure for this.

--HKEL+t8MFpg/ASTE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkCCpAAoJEHZH4aRLwOS6QjcP/AlZJ3UHymqbnt/JwbG1e2Jn
t/sL7oQ6HvLfXvdZ8hpqWC7QaSCMhZMSI48fHFwmMX1D0ycFgiV5V/UJ27oGKLyU
7bzANOq3pUHhbIbkLhjQIPkFZTkURwEWxFsAn+N0MpkwNpKjIQ+dSn5Qhsg6OTCH
1at1BnCIu/dxe0xPOHdQhAhDR51D9KZ1hypDHJ0boZuGERtDm+Ama1PKZoKiKwHP
K0jWObi7K/71G1R43nGgqyuZR7Nf8oAJTvDhf0pYkqqVdGVz6BNmbIgJt+qNIr3M
bzA7eM7FqE2nx4C6AbVItulaDGIoZ8A+zDmHkorb/jFapEjEo5kEziaEvyzgjsh7
beUhtVWvLAv9LN6rbRkXfDPkAFS50Gvwm7c3FImFoRVc/zus4v0oVDA3j/A5Vj/Y
bTFQen6lcUS5FaCS8pL2alMw3RvDzkvH89w74nMmAjLINhaQ4mUKGcFRhg61myR7
OMeOOcm5QKjt/aRyfZXJGig3iBJqrHORw66mMWaaTtVuQ4fezNjtuXdE/wyBXKf9
e/zJiaBMELs+W0jXjx1582r1fwiZ12M8foJFan2os6jLLP3N59VjmB42H6/dN88M
j0Ct0dQSmIh5JzTgF9Eb7RnBvASOIvEhNqiAmPHwGQVNZpqntuagzLfqlG9sfniy
c0ZXNXJPAQGhDBeE07yo
=h+1i
-----END PGP SIGNATURE-----

--HKEL+t8MFpg/ASTE--
