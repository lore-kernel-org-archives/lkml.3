Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaELH51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:57:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaELH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:57:26 -0400
Date: Mon, 12 May 2014 09:56:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Architecture support for remote irq work
 raise
Message-ID: <20140512075650.GJ30445@twins.programming.kicks-ass.net>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
 <1399851237-2226-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RGWD7DVgroTnY8ja"
Content-Disposition: inline
In-Reply-To: <1399851237-2226-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RGWD7DVgroTnY8ja
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 01:33:53AM +0200, Frederic Weisbecker wrote:
> We are going to extend irq work to support remote queuing.
>=20
> So lets add a cpu argument to arch_irq_work_raise(). The architectures
> willing to support that must then provide the backend to raise irq work
> IPIs remotely.
>=20
> Initial support is provided for x86 and ARM since they are easily
> extended. The other archs that overwrite arch_irq_work_raise() seem
> to use local clock interrupts and therefore need deeper rewrite of their
> irq work support to implement remote raising.
>=20

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Why not borrow the smp_call_function IPI for the remote bits? We could
limit the 'safe from NMI' to the local works. And we validate this by
putting a WARN_ON(in_nmi()) in irq_work_queue_on().

At some later stage we could look at maybe merging the smp_function_call
and irq_work into a single thing, where we have the irq_work interface
as async and the smp_function_call() as sync interface.

But for now a quick 'hack' would be to call __irq_work_run() from
generic_smp_call_function_single_interrupt().

That would leave arch_irq_work_raise() as the special NMI safe local IPI
hook.

--RGWD7DVgroTnY8ja
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcH7CAAoJEHZH4aRLwOS6WXQP/icjBgQMBa3Yqz1lZIE2kgxm
YP+LAB90YuHdDSqb9hwsRs+ROrYehQFXAKMiZ/75PNz61by8ncnzOezUQIJ3QHAF
cDr/i8fQZ5WvQD4O8GY4FbIJt0IzlrsZvSJny08P20Zi4iEjHUSG3zUuVW2acJMx
IQfYPaO5gTsI1SE3oxCNjIvdwytm015EC2TTTDWK7U53m4VDm39uzuS2fYH5l9qK
2YId4cShUATfHENY5af/lOLxc2lc5M88IYNh3OG0wU1yC2WC7glc5DATTPd/8YC+
PXp6EDz3mJE0TcWRWmJcFmjM7Q4kWrEpYL/FpKsdGfTnL3t5iWBgqMr6S0GQGXOA
vR0Gpx4OifwAAxDoRfLyJCiCTrwja9MlIPardvr/5+oNPfxD670Ar/g/tHt5L2KA
EYx/BEjJLIWnphBh5hDkKlfEVKKiyTw1Bf+t1jbNwZJmw48c77KOuvhVxTV//M7k
Ke1m0qzYIXezKI+C6EW5C9XjuPFppF0YwFlOod/tqjpIU8MNR0/1deWv7YrUY3kr
8wFdAMQKMT7o2qgrwy4S0ArBnp5N26FgDNzBFFvGxLOC8Ebiip7Wo1oY5DfeWZrj
guIGWQ20iLMK+xftQvW5WwA/1sZ5lDV2BvlYdbCc97veOB8ZDsz+9y4VC8Zxrecr
+uQ5PKyozL3a7Dz3kTtZ
=0ZVQ
-----END PGP SIGNATURE-----

--RGWD7DVgroTnY8ja--
