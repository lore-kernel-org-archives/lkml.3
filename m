Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaIHQGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:06:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:39980 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaIHQGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:06:30 -0400
Date: Mon, 8 Sep 2014 18:06:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 07/22] perf: Add api for pmus to write to AUX space
Message-ID: <20140908160624.GV19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-8-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nlCFIKAIgVU3A7bj"
Content-Disposition: inline
In-Reply-To: <1408538179-792-8-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nlCFIKAIgVU3A7bj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:04PM +0300, Alexander Shishkin wrote:
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index f5ee3669f8..3b3a915767 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -242,6 +242,90 @@ ring_buffer_init(struct ring_buffer *rb, long waterm=
ark, int flags)
>  	spin_lock_init(&rb->event_lock);
>  }
> =20
> +void *perf_aux_output_begin(struct perf_output_handle *handle,
> +			    struct perf_event *event)
> +{
> +	unsigned long aux_head, aux_tail;
> +	struct ring_buffer *rb;
> +
> +	rb =3D ring_buffer_get(event);
> +	if (!rb)
> +		return NULL;

Yeah, no need to much with ring_buffer_get() here, do as
perf_output_begin()/end() and keep the RCU section over the entire
output. That avoids the atomic and allows you to always use the parent
event.

> +
> +	if (!rb_has_aux(rb))
> +		goto err;
> +
> +	/*
> +	 * Nesting is not supported for AUX area, make sure nested
> +	 * writers are caught early
> +	 */
> +	if (WARN_ON_ONCE(local_xchg(&rb->aux_nest, 1)))
> +		goto err;
> +
> +	aux_head =3D local_read(&rb->aux_head);
> +	aux_tail =3D ACCESS_ONCE(rb->user_page->aux_tail);
> +
> +	handle->rb =3D rb;
> +	handle->event =3D event;
> +	handle->head =3D aux_head;
> +	if (aux_head - aux_tail < perf_aux_size(rb))
> +		handle->size =3D CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
> +	else
> +		handle->size =3D 0;
> +
> +	if (!handle->size) {
> +		event->pending_disable =3D 1;
> +		event->hw.state =3D PERF_HES_STOPPED;
> +		perf_output_wakeup(handle);
> +		local_set(&rb->aux_nest, 0);
> +		goto err;
> +	}

This needs a comment on the /* A */ barrier; see the comments in
perf_output_put_handle() and perf_output_begin().=20

I'm not sure we can use the same control dependency that we do for the
normal buffers since its the hardware doing the stores, not the regular
instruction stream.

Please document the order in which the hardware writes vs this software
setup and explain the ordering guarantees provided by the hardware wrt
regular software.

> +	return handle->rb->aux_priv;
> +
> +err:
> +	ring_buffer_put(rb);
> +	handle->event =3D NULL;
> +
> +	return NULL;
> +}
> +
> +void perf_aux_output_end(struct perf_output_handle *handle, unsigned lon=
g size,
> +			 bool truncated)
> +{
> +	struct ring_buffer *rb =3D handle->rb;
> +
> +	local_add(size, &rb->aux_head);
> +
> +	smp_wmb();

An uncommented barrier is a bug.

> +	rb->user_page->aux_head =3D local_read(&rb->aux_head);
> +
> +	perf_output_wakeup(handle);
> +	handle->event =3D NULL;
> +
> +	local_set(&rb->aux_nest, 0);
> +	ring_buffer_put(rb);
> +}

Also, should perf_aux_output_end() not generate an event into the
regular buffer?

--nlCFIKAIgVU3A7bj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDdQAAAoJEHZH4aRLwOS6J0MP/1h5pu7mrh/SwQRnef/6Ydsm
1tlPi527s70ya6sJ3ynxKvCos5Ma9EKXVP2BJNnGTXZQxlH9wVdHSB1eGnr8Z2KJ
TedjAOaTAwWZqMJRoG67hOGIkP0NucwXkCbOf3DxXl3nulRh+xkhwxLIF7c+YMNK
7iNojWuu0yw+xJzaDjnPOmcgFgxEd6IJJeqnk058zq4rmEZbh2tGJLV3z+MCsSUN
8Xeo+uTZQ1/Zjy6A6v0HeiUjb67D9TYbpiB8inP6WfsNQg4RE1nqpd6WB2JHTbsm
e/rEQzV6r7BqbSX0UOGXkEQckjH7OBwK7H0OClskyUNtj6dd3NDQ0fdwv3AnGC4q
3Nc638uWWsdknOxrAOw2hISslGWlTb6e//moTLrRdgcHVMxfAZEC4cy5LQfw+WGR
hbkg+3DtWYR9BuQ7fNpi1mUmZE3cV/LJ2asLvxbRjFfofPqi9lD67swD76pGuvcc
JU/Rd+tm5pnV9XqhlURSUCAf98kvRgCueHzrOA/YANkP0A3ouui2xdP9LWSIF68e
HZZYW9FqmOCm0FDg6/nSjbZMIMllq25mnZPoeWgvRqsor71vDljapMIoPZvtPaGZ
hkQPPPdsc3n2HvGMniwsXtEC0yBODSzQsOFxXmROgWqSSUYJ9lW0URI7ZDxlLv6o
2A88R55f9AUX+gdJJuOw
=I8PL
-----END PGP SIGNATURE-----

--nlCFIKAIgVU3A7bj--
