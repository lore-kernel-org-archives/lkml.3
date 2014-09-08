Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaIHQS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:18:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:40028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaIHQS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:18:27 -0400
Date: Mon, 8 Sep 2014 18:18:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 07/22] perf: Add api for pmus to write to AUX space
Message-ID: <20140908161822.GV3588@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-8-git-send-email-alexander.shishkin@linux.intel.com>
 <20140908160624.GV19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V39eZ3eeYcE7QFDY"
Content-Disposition: inline
In-Reply-To: <20140908160624.GV19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V39eZ3eeYcE7QFDY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 06:06:24PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 20, 2014 at 03:36:04PM +0300, Alexander Shishkin wrote:
> > diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> > index f5ee3669f8..3b3a915767 100644
> > --- a/kernel/events/ring_buffer.c
> > +++ b/kernel/events/ring_buffer.c
> > @@ -242,6 +242,90 @@ ring_buffer_init(struct ring_buffer *rb, long wate=
rmark, int flags)
> >  	spin_lock_init(&rb->event_lock);
> >  }
> > =20
> > +void *perf_aux_output_begin(struct perf_output_handle *handle,
> > +			    struct perf_event *event)
> > +{
> > +	unsigned long aux_head, aux_tail;
> > +	struct ring_buffer *rb;
> > +
> > +	rb =3D ring_buffer_get(event);
> > +	if (!rb)
> > +		return NULL;
>=20
> Yeah, no need to much with ring_buffer_get() here, do as
> perf_output_begin()/end() and keep the RCU section over the entire
> output. That avoids the atomic and allows you to always use the parent
> event.

Ah, I see what you were trying to do. You were thinking of doing that
perf_aux_output_begin() when setting up the hardware buffer. Then have
the hardware 'fill' it and then call perf_aux_output_end() to commit.

That way you cannot have the RCU section open across and you do indeed
need that refcount -- maybe.

> > +
> > +	if (!rb_has_aux(rb))
> > +		goto err;
> > +
> > +	/*
> > +	 * Nesting is not supported for AUX area, make sure nested
> > +	 * writers are caught early
> > +	 */
> > +	if (WARN_ON_ONCE(local_xchg(&rb->aux_nest, 1)))
> > +		goto err;
> > +
> > +	aux_head =3D local_read(&rb->aux_head);
> > +	aux_tail =3D ACCESS_ONCE(rb->user_page->aux_tail);
> > +
> > +	handle->rb =3D rb;
> > +	handle->event =3D event;
> > +	handle->head =3D aux_head;
> > +	if (aux_head - aux_tail < perf_aux_size(rb))
> > +		handle->size =3D CIRC_SPACE(aux_head, aux_tail, perf_aux_size(rb));
> > +	else
> > +		handle->size =3D 0;
> > +
> > +	if (!handle->size) {
> > +		event->pending_disable =3D 1;
> > +		event->hw.state =3D PERF_HES_STOPPED;
> > +		perf_output_wakeup(handle);
> > +		local_set(&rb->aux_nest, 0);
> > +		goto err;
> > +	}
>=20
> This needs a comment on the /* A */ barrier; see the comments in
> perf_output_put_handle() and perf_output_begin().=20
>=20
> I'm not sure we can use the same control dependency that we do for the
> normal buffers since its the hardware doing the stores, not the regular
> instruction stream.
>=20
> Please document the order in which the hardware writes vs this software
> setup and explain the ordering guarantees provided by the hardware wrt
> regular software.

So given that the hardware will simply not have a pointer to write to
before this completes I think we can say the control dependency is good
enough.

> > +	return handle->rb->aux_priv;
> > +
> > +err:
> > +	ring_buffer_put(rb);
> > +	handle->event =3D NULL;
> > +
> > +	return NULL;
> > +}
> > +
> > +void perf_aux_output_end(struct perf_output_handle *handle, unsigned l=
ong size,
> > +			 bool truncated)
> > +{
> > +	struct ring_buffer *rb =3D handle->rb;
> > +
> > +	local_add(size, &rb->aux_head);
> > +
> > +	smp_wmb();
>=20
> An uncommented barrier is a bug.

Still true, and we need clarification on whether this wmb (a NOP on
x86) is sufficient to order against the hardware or if we need something
stronger someplace, like a full MFENCE or even SYNC.

Arguably we'd want to place that in the driver before calling this, but
we need to get that clarified etc..

--V39eZ3eeYcE7QFDY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDdbOAAoJEHZH4aRLwOS6pDEP/0EZR8vUx6snfibNQHO2x/W/
An3E7bPNgUPMiEOhtNenBXi+YeohJsYvAtGGEQs47AX9yKc+uqShcq6ethfC4Kyz
OCT61v22hWROH1IC40APJqsNJQYjY3IrH/hvH47ZKRTdJ3n2x1TwU169fpaT18mW
M47uYP23RmhH7j8bUMydjg//7oKybacPYjqogeaptnJ4AcwWl0Jy5meKSgslL3Xm
oC7FKC+lR3+bdft3RfRbRmL1LjuKHMA8wthmaAZgViNXUmWLHvRfbGplZoaqyMff
bMw6mPI7Kt1Np7p+HUvzCS8EPCk/bnmI0+LKEH0CGkrFgesyXK6lIWtyXy8Gw7Y1
5TsbO9sdXVFOwYdqu4ekU0AmvCXDdJDwnJKM6cGRDGrfdrvXG+XNRHCRVJlqSVUv
SBB3nNDQ1D6njytjkvAb4GAaxn5SBCxPLRYUr9PwqiBTrnOi1Q78jb0G1zyR8ErX
Q1qUbnKpT6rlEqBrcNuAYMiWt48JLB91lKf+GW3Zq9okrfRy3rbQmCnJtBfix0Dm
cnJ+5ys5JHy1345xNh9vwM6RzpqfOQC1UFxHoIQiliQZ41A4Uq4GLdtaUG7Fqs3Y
K0tM2+O8aJXorfATqmKwBINRXbcq92OkzxOCvb+Z7IcUGarea4kSUVPuEcOY1m4+
Wg6DmJbIeDGD54dfcrsn
=o5Rp
-----END PGP SIGNATURE-----

--V39eZ3eeYcE7QFDY--
