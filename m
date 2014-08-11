Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaHKMBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:01:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:33792 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaHKMBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:01:18 -0400
Date: Mon, 11 Aug 2014 14:01:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 01/20] perf: Add PERF_EVENT_STATE_EXIT state for events
 with exited task
Message-ID: <20140811120102.GY9918@twins.programming.kicks-ass.net>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
 <1407747014-18394-2-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XLyzyL/lMSI9vtRf"
Content-Disposition: inline
In-Reply-To: <1407747014-18394-2-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XLyzyL/lMSI9vtRf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 10:49:55AM +0200, Jiri Olsa wrote:
> ---
>  include/linux/perf_event.h |  1 +
>  kernel/events/core.c       | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 707617a8c0f6..54f3a6241386 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -268,6 +268,7 @@ struct pmu {
>   * enum perf_event_active_state - the states of a event
>   */
>  enum perf_event_active_state {
> +	PERF_EVENT_STATE_EXIT		=3D -3,
>  	PERF_EVENT_STATE_ERROR		=3D -2,
>  	PERF_EVENT_STATE_OFF		=3D -1,
>  	PERF_EVENT_STATE_INACTIVE	=3D  0,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 14086e45c5c4..dde0eefa410a 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3499,7 +3499,8 @@ perf_read_hw(struct perf_event *event, char __user =
*buf, size_t count)
>  	 * error state (i.e. because it was pinned but it couldn't be
>  	 * scheduled on to the CPU at some point).
>  	 */
> -	if (event->state =3D=3D PERF_EVENT_STATE_ERROR)
> +	if ((event->state =3D=3D PERF_EVENT_STATE_ERROR) ||
> +	    (event->state =3D=3D PERF_EVENT_STATE_EXIT))
>  		return 0;
> =20
>  	if (count < event->read_size)
> @@ -3526,9 +3527,13 @@ static unsigned int perf_poll(struct file *file, p=
oll_table *wait)
>  {
>  	struct perf_event *event =3D file->private_data;
>  	struct ring_buffer *rb;
> -	unsigned int events =3D POLL_HUP;
> +	unsigned int events =3D POLLHUP;

Should not that be an independent bugfix? It is a silly little thing
indeed, but it does change behaviour.

>  	poll_wait(file, &event->waitq, wait);
> +
> +	if (event->state =3D=3D PERF_EVENT_STATE_EXIT)
> +		return POLLHUP;
> +

So, seeing how events is already POLLHUP here, why not return that?

>  	/*
>  	 * Pin the event->rb by taking event->mmap_mutex; otherwise
>  	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
> @@ -7484,6 +7489,9 @@ __perf_event_exit_task(struct perf_event *child_eve=
nt,
>  	if (child_event->parent) {
>  		sync_child_event(child_event, child);
>  		free_event(child_event);
> +	} else {
> +		child_event->state =3D PERF_EVENT_STATE_EXIT;
> +		perf_event_wakeup(child_event);
>  	}
>  }

In any case, ACK on this patch, I'll assume you want to take the lot
through acme seeing how its mostly tools bits.

--XLyzyL/lMSI9vtRf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6LB+AAoJEHZH4aRLwOS6NOwQAJRk2zbwcaQU8dnSBf9yK/qO
O5eVKKHWjFc+rbISrpRD/KKc9BT9nntGBhFAeifXB8D24na6hO1iwkLH3qLZYCIH
s+AK3PK4rSoJAikgwakBfjBx4s8pX/LIAicZtseEjqYwCtOKEQ+mWvREnDjtJ+JW
6KNDaqqFth3xvgDFNDWPtzG+slPXLhUVhiVInVi10aA11IqvAJxg/k/BwMNFFgRw
Q8MF/mip2pHAArGsSdnSZntyy+aWuOZMDW2D24F6YWMzttm5YRhwB/E/2Xn2HcMl
RFwdiQ3gN2lsScooDOfc6uLixVjYw1mt2BvHgK/vr6QoAADk68S/nE7T4ereDR58
6F3QSF09P8lcrJlbcM0DHl8xuzWBfsFskJB3U1w8GfUKtir8lRQ+bNzLNA8xcgrY
KxujMYiqyr6Nl5uShz4IxJYPQldvua1mllYhhlvfRvkH3YqnoJ7s6aso9OSpXlNI
uE6wYBK5UTsWDcylXYecmJ3fj5u+Qm2RAMAw9HgfPTvDutJIOlY8s8Et0xQtTpZM
kycUbkYQJRC44/EU1qWy4tGJIK4mj5FXwcv8MWhvt3DPXVqIUt9u1aImnnvIgrpe
ErktLejNYvSSdiV6WE1i8V3kf1bnse6B30kyK3k1jdoUMwqO3G7HLtjadwbuaJjE
+evb74aJb/qgxIfl14K8
=5Wdb
-----END PGP SIGNATURE-----

--XLyzyL/lMSI9vtRf--
