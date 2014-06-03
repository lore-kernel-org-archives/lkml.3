Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946AbaFCQ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:56:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020AbaFCQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:37:57 -0400
Date: Tue, 3 Jun 2014 18:37:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] irq_work: Implement remote queueing
Message-ID: <20140603163745.GC30445@twins.programming.kicks-ass.net>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
 <1401812947.3645.231.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QH7PnJlwq6+Q/jfo"
Content-Disposition: inline
In-Reply-To: <1401812947.3645.231.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QH7PnJlwq6+Q/jfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 09:29:07AM -0700, Eric Dumazet wrote:
> > +bool irq_work_queue_on(struct irq_work *work, int cpu)
> > +{
> > +	/* All work should have been flushed before going offline */
> > +	WARN_ON_ONCE(cpu_is_offline(cpu));
> > +
> > +	/* Arch remote IPI send/receive backend aren't NMI safe */
> > +	WARN_ON_ONCE(in_nmi());
> > +
> > +	/* Only queue if not already pending */
> > +	if (!irq_work_claim(work))
> > +		return false;
> > +
> > +	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
> > +		native_send_call_func_single_ipi(cpu);
> > +
> > +	return true;
> > +}
> > +EXPORT_SYMBOL_GPL(irq_work_queue_on);
> > +
>=20
> I am curious, this should only compile on x86, right ?

Oh, you tease, you forgot to say why you think this.

Are you referring to the in_nmi() usage? that's from
include/linux/hardirq.h, hardly x86 specific.

--QH7PnJlwq6+Q/jfo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjfnZAAoJEHZH4aRLwOS62J8P/idIfWl36rZPEyk4FrgANudl
mwpGd8mP9mA5mrxu8LXOD9w/Cs6JC4hRohSveIePpSJrBUaTmhbtAOPxzASmskwl
4a+IYKXR8pxv7IIjKv4sKwnyFpEQPWT+ecEKmgjMRYKPLgCnzZw0cj0OHmRKCJSW
nyn37+f2DYfh3fgcr3QQQQ8A6DCIRE1BbLSma4Tel8APo+PyjikNu70rt+tkIwOt
zwhG8oCfffC6NI/iuhAvRAEw9tTNsSZxxVJSdGSCV1ESjk4e0rA6JwjH7IE0JMNV
GpJe8PtGm20yR5/JHHqkwLNqM2AjirDU3yr6C2P7GasA8p4E18tLC3+PGXSJdGdC
zCuEclIsismsQAouxjfcCbUrWc0c06Yr7ngeYxGzDD9grjVe133r5IEOvNFlprCn
nmwYg31RanfeUE9NtgFvup60NOgi74NFhie6VqYX2125Q9pY/OaUK4oKMIX0LEkp
rkhXw2bhhnv1/aJWEdNQsq9R5gsEwJCdfb+3GD7uzSMEUMUMtg1PPIUPW9lxt4Lr
6BaC3sSXLRb2lgcZwEj8PcdChdZJFe+CNNe7IFeJRFiofk0yJm1nPaJmWbCT/z/J
xNe5BhOKWMi5EXh8fTK4eZtBgYgc9L9cCGnSbQKtWou9nYS1aSxwINyXRaUq/K4e
UoQkO8l+qXDsFEBFtpzb
=5kNe
-----END PGP SIGNATURE-----

--QH7PnJlwq6+Q/jfo--
