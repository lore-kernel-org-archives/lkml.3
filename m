Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaFYFRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:17:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaFYFRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:17:35 -0400
Date: Wed, 25 Jun 2014 07:17:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
Message-ID: <20140625051721.GG3588@twins.programming.kicks-ass.net>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
 <1402413309-3415-3-git-send-email-fweisbec@gmail.com>
 <53A9E0A5.5040402@wwwdotorg.org>
 <20140625051234.GD6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0qt3EE9wi45a2ZFX"
Content-Disposition: inline
In-Reply-To: <20140625051234.GD6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0qt3EE9wi45a2ZFX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 07:12:34AM +0200, Peter Zijlstra wrote:
> On Tue, Jun 24, 2014 at 02:33:41PM -0600, Stephen Warren wrote:
> > On 06/10/2014 09:15 AM, Frederic Weisbecker wrote:
> > > irq work currently only supports local callbacks. However its code
> > > is mostly ready to run remote callbacks and we have some potential us=
er.
> > >=20
> > > The full nohz subsystem currently open codes its own remote irq work
> > > on top of the scheduler ipi when it wants a CPU to reevaluate its next
> > > tick. However this ad hoc solution bloats the scheduler IPI.
> > >=20
> > > Lets just extend the irq work subsystem to support remote queuing on =
top
> > > of the generic SMP IPI to handle this kind of user. This shouldn't add
> > > noticeable overhead.
> >=20
> > I'm running next-20140624 on an ARM system, and this patch causes CPU
> > hot(un)plug to Oops for me; the following fires:
> >=20
> > void irq_work_run(void)
> > {
> > 	BUG_ON(!in_irq());
> >=20
> > I found that Linus's master (8b8f5d971584 "Merge tag 'compress-3.16-rc3'
> > of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core")
> > works fine. I found that this commit inside the tip(?) tree works fine
> > (478850160636 "irq_work: Implement remote queueing"). However, if I
> > merge the two together, I hit that BUG_ON.
> >=20
> > I think the issue is:
> >=20
> > This commit adds a call from
> > generic_smp_call_function_single_interrupt() to irq_work_run().
> >=20
> > Srivatsa's patch adds a call from hotplug_cfd() to
> > flush_smp_call_function_queue() to, which I imagine happens in
> > non-interrupt context. Note that this patch moves most of the body of
> > generic_smp_call_function_single_interrupt() into
> > flush_smp_call_function_queue().
>=20
> Right you are.. I think I'll just remove the BUG_ON(), Frederic?

Something a little so like:

---
Subject: irq_work: Remove BUG_ON in irq_work_run_list()
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Wed Jun 25 07:13:07 CEST 2014

Because of a collision with 8d056c48e486 ("CPU hotplug, smp: flush any
pending IPI callbacks before CPU offline"), which ends up calling
hotplug_cfd()->flush_smp_call_function_queue()->run_irq_work(), which
is not from IRQ context.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/irq_work.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -130,8 +130,6 @@ static void irq_work_run_list(struct lli
 	struct irq_work *work;
 	struct llist_node *llnode;
=20
-	BUG_ON(!irqs_disabled());
-
 	if (llist_empty(list))
 		return;
=20

--0qt3EE9wi45a2ZFX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqlthAAoJEHZH4aRLwOS6xk0QAJCK47tMhKOlUaaRNEUNLypm
52TLHGGN+hupyx3e749ClkNmJRhq9OMHVecWXbTdVEz5sSn5mOM/OcXSIiV9wl1M
5G59TCZ5J9k2Kb/5B7+97EcvdXCPFAl5sGbU6cYaZl7O8JazdVaVpwwr64ECczeF
hp1tKgUD9UhZ2LplbTNH9yJJimRxYm/QkREcq5fcn8mZfCw65ixXi2nl9SkZGkNg
eqNzz1/tsreAmAcSjB/zs+uLYIKtUWHP0bQYztRGE6P7ucQfipYgaxWKVNLS099i
QUzvo4P+RGf6eMn1BgU4k9pZZktSn3lQk0nqg56r5MGvtYXRdKio0lBoj5HENybW
ifCyWgIt81ALjsXJKLExJrQzhqassbxlLRV39V8cnzoL2rX3rv1Snr5O8a4ZF+iS
Jv8iA3N77J40cc8yGwnvuiXKZLrCxpYpu1RD0cdQRW2jTmECzzpIUiqMRF95SZLM
LF29SRketyFK/kCLPZHdhmN9J/qhmIuEFdfSmFBjm3+rGrzsi3JtSTOELMRvNR/a
tD7gPrt/RVKYRjwaVKJ1Xsy3Hw6ec1eQjsFpFXg1EvMyKiwBQ0w94WZwgvVjEUA7
6eV2msAwmWU+H2t7iXVIyi2tEVJBOaLRNjES7KBtmunAwNAX0TNerVk4ZaHDJKsv
VLFMqzquCTJry1FT+Tp7
=0nVJ
-----END PGP SIGNATURE-----

--0qt3EE9wi45a2ZFX--
