Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaEHQJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:09:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaEHQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:09:52 -0400
Date: Thu, 8 May 2014 18:09:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140508160940.GE30445@twins.programming.kicks-ass.net>
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140507123526.GD13658@twins.programming.kicks-ass.net>
 <20140507180621.GE13658@twins.programming.kicks-ass.net>
 <20140508153727.GD8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XQSDX3NWE02rtiZq"
Content-Disposition: inline
In-Reply-To: <20140508153727.GD8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XQSDX3NWE02rtiZq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 08:37:27AM -0700, Paul E. McKenney wrote:
> On Wed, May 07, 2014 at 08:06:21PM +0200, Peter Zijlstra wrote:
> > On Wed, May 07, 2014 at 02:35:26PM +0200, Peter Zijlstra wrote:
> > >  static void ring_buffer_attach(struct perf_event *event,
> > >  			       struct ring_buffer *rb)
> > >  {
> > > +	struct ring_buffer *old_rb =3D NULL;
> > >  	unsigned long flags;
> > > =20
> > > +	if (event->rb) {
> > > +		/*
> > > +		 * Should be impossible, we set this when removing
> > > +		 * event->rb_entry and wait/clear when adding event->rb_entry.
> > > +		 */
> > > +		WARN_ON_ONCE(event->rcu_pending);
> > > =20
> > > +		old_rb =3D event->rb;
> > > +		event->rcu_batches =3D get_state_synchronize_rcu();
> > > +		event->rcu_pending =3D 1;
> > > =20
> > > +		spin_lock_irqsave(&rb->event_lock, flags);
> > > +		list_del_rcu(&event->rb_entry);
> > > +		spin_unlock_irqrestore(&rb->event_lock, flags);
> >=20
> > This all works a whole lot better if you make that old_rb->event_lock.
> >=20
> > > +	}
> > > =20
> > > +	if (event->rcu_pending && rb) {
> > > +		cond_synchronize_rcu(event->rcu_batches);
>=20
> There is not a whole lot of code between the get_state_synchronize_rcu()
> and the cond_synchronize_rcu(), so I would expect this to do a
> synchronize_rcu() almost all the time.  Or am I missing something here?

=46rom the Changelog:

 2) an event that has a buffer attached, the buffer is destroyed
    (munmap) and then the event is attached to a new/different buffer
    using PERF_EVENT_IOC_SET_OUTPUT.

    This case is more complex because the buffer destruction does:
      ring_buffer_attach(.rb =3D NULL)
    followed by the ioctl() doing:
      ring_buffer_attach(.rb =3D foo);

    and we still need to observe the grace period between these two
    calls due to us reusing the event->rb_entry list_head.

--XQSDX3NWE02rtiZq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa6xEAAoJEHZH4aRLwOS6udwQAITowoldlm+Q6wl5xNBGYQzB
ImCIEBmjtFv6U7sVIZrQ+BGR1Zm59tN8MWDj+/5p5Ri2jbC5pMudRbTCd/tnAwXf
BSlQdtN+G38QyVHmiQVvpZt1/VPBTxKkwTaRIM4yY218BTQvwBBaSg/y7G1Jke9x
NWywTa6Kb/pNnlKLyayNnrGFnLRv0DkbseJ2gjah1H3xs+JTyLjTiXn8JOhcO9XY
ig7LKLKPzf9krKCkrHa4RgcJJPx9UZHJELlCXGlCtuPX6fIkpl8bxiDFluPIGYWF
KErXbGtv4d1wDl+KLYwKsMiW69KEJCKp5QTAHMcUfGfQ/XMX5BqY+29EVAMIQjIl
i9ED91NhmMGaABiDbd/w5UIkz5ftGNY5OY4dvp2ryR8oL77r0CiLsiMKxbjHGydZ
xcS/9NMpZfzjRCU6Yby5rrIv5hKYqKFnCRRx8+3Sr6RkqFxJt7bsH0WMYJKQxjCV
dBSWlh0XOxJkCIy9c/C2yXB9etZLVR0aPrsM6Sgh1aA6PCJPPGamgFj+itW4HxWI
Vj6venSp9NMqHIaj76FMI2176+7uQOAiTzYmNMaoybksm01073P+8svxvkqgKBkM
uiqMpMYcyl5aXIIyh9IRyhjk/Nt+maAMyaElLQCiD0JbFKEJYXycMveRwaZGJ6OL
/YKatosYdNc37IUhjntz
=eMwG
-----END PGP SIGNATURE-----

--XQSDX3NWE02rtiZq--
