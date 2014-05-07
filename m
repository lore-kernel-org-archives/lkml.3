Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaEGSG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:06:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:39650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaEGSG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:06:27 -0400
Date: Wed, 7 May 2014 20:06:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140507180621.GE13658@twins.programming.kicks-ass.net>
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140507123526.GD13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <20140507123526.GD13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 02:35:26PM +0200, Peter Zijlstra wrote:
>  static void ring_buffer_attach(struct perf_event *event,
>  			       struct ring_buffer *rb)
>  {
> +	struct ring_buffer *old_rb =3D NULL;
>  	unsigned long flags;
> =20
> +	if (event->rb) {
> +		/*
> +		 * Should be impossible, we set this when removing
> +		 * event->rb_entry and wait/clear when adding event->rb_entry.
> +		 */
> +		WARN_ON_ONCE(event->rcu_pending);
> =20
> +		old_rb =3D event->rb;
> +		event->rcu_batches =3D get_state_synchronize_rcu();
> +		event->rcu_pending =3D 1;
> =20
> +		spin_lock_irqsave(&rb->event_lock, flags);
> +		list_del_rcu(&event->rb_entry);
> +		spin_unlock_irqrestore(&rb->event_lock, flags);

This all works a whole lot better if you make that old_rb->event_lock.

> +	}
> =20
> +	if (event->rcu_pending && rb) {
> +		cond_synchronize_rcu(event->rcu_batches);
> +		event->rcu_pending =3D 0;
> +	}
> =20
> +	if (rb) {
> +		spin_lock_irqsave(&rb->event_lock, flags);
> +		list_add_rcu(&event->rb_entry, &rb->event_list);
> +		spin_unlock_irqrestore(&rb->event_lock, flags);
> +	}
> +
> +	rcu_assign_pointer(event->rb, rb);
> +
> +	if (old_rb) {
> +		ring_buffer_put(old_rb);
> +		/*
> +		 * Since we detached before setting the new rb, so that we
> +		 * could attach the new rb, we could have missed a wakeup.
> +		 * Provide it now.
> +		 */
> +		wake_up_all(&event->waitq);
> +	}
>  }

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTanYdAAoJEHZH4aRLwOS6Of0P/3tY+lM/1+yIjCNJ12ZC7jME
pdCkEgo+heCJ0Leaas0EVcYODvY8/ZKu3afn7GwUFqOAYwPdyQTn1AsvemndWgpE
stY8svs2hc4fnEGbs305M3cxsQz4093jNJopX9EuGQt0nms2x68JdPpjd3e7F0uz
exVTveWlfPZQIz/+HAkGRA9C/sOpLMUsSLLTWLvNidMzO/8FBMCne2RfLhSdjJnw
zg+MsCyPSOy32GmO7xPLw7+34JUH6IDzQ0NuCKNbfXY6O+Is3vL1CL26IzVhMkp7
1oNtrLSVPxK45hh0anyZ5mo1mi5kYw/9t1E2nm0opHK9pLhcUhaK+LVOopw/VggI
Y86iAgS0xdYzS5Y9DSKlB7Dz934ZvddrrG8CRiyGsd6Ma9jGBON1daE+cQRE4Ztu
cH5Iz14CXvWn1JhYA7by7nTGxRbZNxjoeS8NoqrNKas0mp87YXh6oDhOx+Kyz0Pb
AYMA2UcrGdL7YTTQ0MC25eghaQtgjFNOVWDFte60+ScBOt3E8KKJCOxFOrtOM6sf
g3OCa9letlbB74zlOk/6g6SzUsWaIZ3ZmT1/Fc6lvIJFpVDkXNdta3syWXJc1Szr
IH0mTSOY9Te+ZfyWDvQciINmUDHotvdMf8W9p8PP8H6zs4k8TKhWFDy6Dy7/QFkF
tChhWV/Ts3rsH7V3+MKe
=5SzA
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
