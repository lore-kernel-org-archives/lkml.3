Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaENLyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:54:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaENLyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:54:15 -0400
Date: Wed, 14 May 2014 13:54:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514115406.GA11096@twins.programming.kicks-ass.net>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
 <20140514090629.GC30445@twins.programming.kicks-ass.net>
 <20140514113808.GA1278@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8D3PigL67BfDl295"
Content-Disposition: inline
In-Reply-To: <20140514113808.GA1278@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8D3PigL67BfDl295
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 01:38:14PM +0200, Frederic Weisbecker wrote:
> > > +bool irq_work_queue_on(struct irq_work *work, int cpu)
> > > +{
> > > +	/* Only queue if not already pending */
> > > +	if (!irq_work_claim(work))
> > > +		return false;
> > > +
> > > +	/* All work should have been flushed before going offline */
> > > +	WARN_ON_ONCE(cpu_is_offline(cpu));
> >=20
> > 	WARN_ON_ONCE(in_nmi());
>=20
> Well... I think it's actually NMI-safe.

I don't think it is, most apic calls do apic_wait_icr_idle() then the
apic op, if an NMI happens in between and writes to the APIC, the return
context will see a !idle icr and fail.

This is why arch_irq_work_raise() again idles the icr after sending the
IPI.

Also, I think, seeing what benh said earlier, its unsafe for other archs
too.

> > > +	llist_add(&work->llnode, &per_cpu(irq_work_list, cpu));
> > > +	native_send_call_func_single_ipi(cpu);
> >=20
> > At the very leastestest make that:
> >=20
> > 	if (llist_add(&work->llnode, &per_cpu(irq_work_list, cpu)))
> > 		native_send_call_func_single_ipi(cpu);
>=20
> So yeah the issue is that we may have IRQ_WORK_LAZY in the queue. And
> if we have only such work in the queue, nobody has raised before us.
>=20
> So we can't just test with llist_add(). Or if we do, we must then
> separate raised and lazy list.

Then do the remote irq_work_raised thing. But it really stinks you broke
this very nice and simple thing.

> Also note that nohz is the only user for now and irq_work_claim() thus
> prevents from double IPI. Of course if more users come up the issue arise
> again.

DANGER, half arsed engineering at work, seriously? Just write proper
code already.

There's no fucking way the next user will check the implementation to
make sure its 'sane'.

> Maybe I was paranoid but I was worried about the overhead of printk() wak=
eups
> on boot if implemented with IPIs.
>=20
> Of course if I can be proven that it won't bring much damage to use an IP=
I, I'd
> be very happy to remove it.

That's the wrong fucking way around, first proof its needed then do
something about it. As is I think the LAZY thing is horrid.



--8D3PigL67BfDl295
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc1leAAoJEHZH4aRLwOS6QlsP/AkbJzFuBVKCpL08evZAsMJP
CL/bVbbwOjzIX0JpHQjmzkp9NP2c2sRC4sqG1lK8W1NWeX7/Bmfi+4jJK3MH/8a0
bKKmohNJhs/KURSty5aDeS8voPG4/t87wzKQweL70mfHRZvUQhZdTV77Epc3CnO2
aNUV5pGG/s0iWz09B8+3t/2hUhOo24Qy0/hIQza5QKtJz9kh5+SZ/ilipnKAx3SO
rqZ9eHa1346ECrS0d4eUthxKLq0D9Mfw4q4vonqJvCEml3bRwjY4oupp9b0gFDY2
UKbN0Lt7oVy+/4ohvorFEY/QhBJncE9W2Y8BeBYbd9psYfrPXcrFcHKmq1OXo9wC
5uhFp1lVPXw+sDs0seNfUxEKtsj7J1td1kZwxbmSB4Z7d2Vnb4ogKhdwiVLG+1As
WJUYceCmsf44iiHRTn6SgghsXKh6ftkduGOZbUuwl0zQPpXbKi+PJNQ/SxJQ+b/a
ci5JKrMIENCjvcBC5S7Y3Xle/G7xS8K7mfh/eyLyB1J51SBbkyZH8D+XRDyV1ePK
224Iac2bbeiKctminI5usE5qoG7Uvcv/riE/35feGD/iJ6+ighrZfNqe7pdlqYtI
6nbxQAVG++2IG+/N0o/fpWUCGgBiRL16ErgLVM71l1ZIGtdvulJh/XIoMESwxwTo
qXQQZ9Eu3jHqTe58niu3
=SknA
-----END PGP SIGNATURE-----

--8D3PigL67BfDl295--
