Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaGNLSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:18:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaGNLSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:18:46 -0400
Date: Mon, 14 Jul 2014 13:18:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140714111833.GU19379@twins.programming.kicks-ass.net>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xj5q1jaq0IAHsx/k"
Content-Disposition: inline
In-Reply-To: <1405079782-8139-3-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xj5q1jaq0IAHsx/k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> From: Jiri Olsa <jolsa@redhat.com>
>=20
> When task exits we close:
>   1) all events that are installed in task
>   2) all events owned by task (via file descriptor)
>=20
> But we don't close children events of 2) events. Those children
> events stay until the child task exits and are useless with the
> parent being gone, because we have no way to get to values any
> more.
>=20
> Plus if the event stays installed in task even with the owner task
> gone, it runs the perf callback any time the task forks, for no
> real reason.
>=20
> Closing all children events events when the owner task of the
> parent event is closed.

Do we need this for the other patches, or is this an unrelated change?=20

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/events/core.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>=20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 71a56ae..37797dd 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7535,6 +7535,32 @@ static void perf_event_exit_task_context(struct ta=
sk_struct *child, int ctxn)
>  	put_ctx(child_ctx);
>  }
> =20
> +static void perf_event_exit_children(struct perf_event *parent)
> +{
> +	struct perf_event *child, *tmp;
> +
> +	mutex_lock(&parent->child_mutex);
> +	list_for_each_entry_safe(child, tmp, &parent->child_list,
> +				 child_list) {
> +		struct perf_event_context *child_ctx =3D child->ctx;
> +
> +		/*
> +		 * Child events got removed from child_list under
> +		 * child_mutex and then freed. So it's safe to access
> +		 * childs context in here, because the child holds
> +		 * context ref.
> +		 */
> +		mutex_lock(&child_ctx->mutex);
> +		perf_remove_from_context(child, true);
> +		mutex_unlock(&child_ctx->mutex);
> +
> +		list_del_init(&child->child_list);
> +		put_event(parent);
> +		free_event(child);
> +	}
> +	mutex_unlock(&parent->child_mutex);
> +}
> +
>  /*
>   * When a child task exits, feed back event values to parent events.
>   */
> @@ -7555,6 +7581,7 @@ void perf_event_exit_task(struct task_struct *child)
>  		 */
>  		smp_wmb();
>  		event->owner =3D NULL;
> +		perf_event_exit_children(event);
>  	}
>  	mutex_unlock(&child->perf_event_mutex);

I don't think this is correct, perf_event_init_context() can come in
concurrently and the first place it runs into ->child_mutex is after its
already allocated and created the (first) child event.

This also means that it not only makes exit() very slow for all tasks
that own events -- surmountable I suppose, but also makes clone()/fork()
very slow for all decedents -- not so good.

Now I suppose we can fix this by testing event->owner in
perf_event_init_context() or somesuch, thereby bypassing event creation
when the owner is tearing things down.

But it would be good if we can do all this in a separate series.


--xj5q1jaq0IAHsx/k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw7yJAAoJEHZH4aRLwOS6AhEQAJKlu4YFEWH1iIEvM5DWQkCv
/z2rFWnhmtLfuFEUWRxETnAaUPjitqiTXE9aOu61ogLYWP1fWS72YMok37FVboo9
hKjsjfIEFrzfDto/sTsCLwFQG4xDS3YQ3CJEJxsxLsqjANX5ovET+eisWHh7Klxk
u/Pn3hP3sW9SKm8fcTnSGWMlPs7FFT32FkATdhsgrFWUayMQGp1zLUF7jNCxrSwu
OK1JAUgDZ7X+sFY7DXaA0VBfJINPWWcM4d/BOGW9X1eTuBUfosPwh/0vY9CJ8N7M
A68bO0AEOCOwV6oVuVbtphVn8lCuXwMMZxG7Em6O8+N+TxwMDQcjCoIgTbmbghYh
aoJRrbqtS74P+XXDf4fzFC4lqFIFbFqHlhVjq239Bt9LKm1xxJukg1Ovd0Z4x9UJ
OGfolam7tjojVK+AkcDQe+3NoxU74j6tsSWfswaXiQUOiomQLK70LqAhMF+117RA
ZZnjZcRYfhjdQLdXn5heeGqkcb9RlBmtdbgJ9U+ONMaQeMi8VjgMQJHlbM1AYW8D
tgq7zfVA1txd8CATt37dHTPVuHvrmuwqGXoO1RYC2s21nWuM5jzphwP8FVpaBHxR
HZ83mBKx/K6ANFnMt6goZfGxDgEbjgGdVYF3vzx44AW6Ppt1YeJSEHKaI9Gz9a98
pVLhcT8p/qC3jca893to
=FkRr
-----END PGP SIGNATURE-----

--xj5q1jaq0IAHsx/k--
