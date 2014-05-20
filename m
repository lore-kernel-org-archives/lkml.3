Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaETOCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:02:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:02:04 -0400
Date: Tue, 20 May 2014 16:01:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
Message-ID: <20140520140155.GS13658@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <87lhu215ky.wl%klamm@yandex-team.ru>
 <20140519103247.GX30445@twins.programming.kicks-ass.net>
 <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140520131526.GE11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PdAWLd+WEPmMbsbx"
Content-Disposition: inline
In-Reply-To: <20140520131526.GE11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PdAWLd+WEPmMbsbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 03:15:26PM +0200, Peter Zijlstra wrote:
> Which leads us to what I think is a BUG in the current hrtimer code (and
> one wonders why we never hit that), because we drop the cpu_base->lock
> over calling hrtimer::function, hrtimer_start_range_ns() can in fact
> come in and (re)enqueue the timer, if hrtimer::function then returns
> HRTIMER_RESTART, we'll hit that BUG_ON() before trying to enqueue the
> timer once more.

> ---
>  kernel/hrtimer.c     |  9 ++++++---
>  kernel/sched/core.c  | 10 ++++++----
>  kernel/sched/fair.c  | 42 +++---------------------------------------
>  kernel/sched/sched.h |  2 +-
>  4 files changed, 16 insertions(+), 47 deletions(-)
>=20
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 3ab28993f6e0..28942c65635e 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1273,11 +1273,14 @@ static void __run_hrtimer(struct hrtimer *timer, =
ktime_t *now)
>  	 * Note: We clear the CALLBACK bit after enqueue_hrtimer and
>  	 * we do not reprogramm the event hardware. Happens either in
>  	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
> +	 *
> +	 * Note: Because we dropped the cpu_base->lock above,
> +	 * hrtimer_start_range_ns() can have popped in and enqueued the timer
> +	 * for us already.
>  	 */
> -	if (restart !=3D HRTIMER_NORESTART) {
> -		BUG_ON(timer->state !=3D HRTIMER_STATE_CALLBACK);
> +	if (restart !=3D HRTIMER_NORESTART &&
> +	    !(timer->state & HRTIMER_STATE_ENQUEUED))
>  		enqueue_hrtimer(timer, base);
> -	}
> =20
>  	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
> =20

Hmm,. doesn't this also mean its entirely unsafe to call
hrtimer_forward*() from the timer callback, because it might be changing
the time of an already enqueued timer, which would corrupt the rb-tree
order.

Lemme go find a nice way out of this mess, I think I'm responsible for
creating it in the first place :-(

--PdAWLd+WEPmMbsbx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTe2BTAAoJEHZH4aRLwOS61JEP+gIYpc0RphAZNeNGOouL6JOs
oaHT02Khk/RFOCeAhnijtQ0hFppOf5uDJH5FdktYYIcTfM6YrdfN9g3jJ/HjipYw
ugZ5wr+OlWh5+cOf4BrzBzGfrS03yWfqt0SIDHh/cIW+Q8SGzHNQ+CzFtjwdmM/t
Gp5nuvfbE9LGUU/qeFyVPyYx7BW0cTeQnPaLyFzo/7lzyBBJ0Mzypc15+/NRGLUE
AvCyuqAH4tU9T7IcenwTMde0lNeyDzqnOQWqSw1tVO9Ydh218211yPLc0FD0kT+f
Ivxw0sRBTNEPGb6HviozydSkVYz/IgrF0p9SuVCi0iX8K9lMdJ2AfKhS2Y1NcV+C
huFDBCczGOZWzyXj2D9E0pVaIr6Ci8A2ygneXgvKDtki1aV+XrZynnAGQahCMkVu
yDNdGQy92jtQ5DdBEt2bHntY20nF1VnOGbAAph5EO3zHZCUEUvrhwUH1zS6JhDwv
E+I66U5KaAjZd/JMvkp10FbiW4sVddbtdSUJJxLIRP7Ff4L14/jrOeec+BLOHPP0
6XZ9QgWxtfsb478gFKc2425TpqOZrBjCqqZJAdDtvIeNyIgS0nzymg6K1XrWHnuT
qoecJh/v+wCdoQJ7338bs/x9qOtwtuXLKMaoK4bKevY5KunSt1ycNXSpEqOR0+A5
K4IFiJWEaT3KDMSSdEJx
=7Yrm
-----END PGP SIGNATURE-----

--PdAWLd+WEPmMbsbx--
