Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaE2H5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:57:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:46651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaE2H53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:57:29 -0400
Date: Thu, 29 May 2014 09:57:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140529075723.GA30445@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
 <20140514163535.GS30445@twins.programming.kicks-ass.net>
 <538676A7.6090306@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s4HLDwisrcEsLE1A"
Content-Disposition: inline
In-Reply-To: <538676A7.6090306@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s4HLDwisrcEsLE1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 07:52:07PM -0400, Sasha Levin wrote:
> On 05/14/2014 12:35 PM, Peter Zijlstra wrote:
> > On Wed, May 14, 2014 at 12:32:26PM -0400, Sasha Levin wrote:
> >> > -----BEGIN PGP SIGNED MESSAGE-----
> >> > Hash: SHA1
> >> >=20
> >> > On 05/14/2014 12:29 PM, Peter Zijlstra wrote:
> >>> > > On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
> >>>> > >> Hi all,
> >>>> > >>=20
> >>>> > >> While fuzzing with trinity inside a KVM tools guest running the=
 latest -next kernel I've stumbled on the following spew. Maybe related to =
the very recent change in freeing on task exit?
> >>>> > >>=20
> >>>> > >> [ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP =
DEBUG_PAGEALLOC [ 2509.830379] Dumping ftrace buffer: [ 2509.830379]    (ft=
race buffer empty) [ 2509.830379] Modules linked in: [ 2509.830379] CPU: 47=
 PID: 43306 Comm: trinity-c126 Tainted: G        W     3.15.0-rc5-next-2014=
0512-sasha-00019-ga20bc00-dirty #456
> >>> > >=20
> >>> > > Any particular trinity setup? And would you happen to have the se=
ed of that run?
> >> >=20
> >> > Nothing special about trinity options. 400 threads and blacklisting =
some of the
> >> > destructive syscalls (umount, reboot, etc).
> >> >=20
> >> > I don't have the seed, but that problem did reproduce again tonight =
so I can test
> >> > out debug code if you have something in mind.
> > Nah, I drew a pretty big blank, which is why I wanted to see if I could
> > reproduce. If you could share your trinity cmdline I'd be much obliged.
> > While I did manage to clone (the repo moved since last time) and build
> > it, I'm not really that handy with it and want to avoid destroying my
> > machine if possible ;-)
>=20
> Anything I could do to help out with this? It reproduces pretty easily on=
 my
> configuration so I'd be happy to test out whatever might help.

Yeah, it takes me days to test anything, and my last guess panned out to
nothing, at which point I decided I needed to look at the things I'd
neglected for a bit :/

Could you see if the below makes any difference? I'll try and get back
to tracking this.

---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efb1e7858ac..851dc9dc5643 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7497,8 +7497,10 @@ static void perf_event_exit_task_context(struct task=
_struct *child, int ctxn)
 	 */
 	mutex_lock(&child_ctx->mutex);
=20
+	rcu_read_lock();
 	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
+	rcu_read_unlock();
=20
 	mutex_unlock(&child_ctx->mutex);
=20

--s4HLDwisrcEsLE1A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThuhjAAoJEHZH4aRLwOS66KQP/0pm0Xu5cwSC3nALpx76wWA6
t4Hd/dXwS07OtgUFvmIxAOwNdKpdaXBNr9W3NrKi4/L995OrOGTLGjAgP6J4OF8h
MCvRAStjRKKphf/pThqBA23CpqLUVYj5rK1mCrd6Hpn7ryWqY0c7N8VJYuEC52GD
vVzJ2bqW5nEZNAgD3hIU5Y8Akub7WkYqoEghhlYxSl0eMslTOwwd7/uEfjFisXm2
oOXkleQqHioNAj7f9IBqqUKSFEwGUVesszGSYS7icwNu0ltwSgJDYGylLPwTc/dP
4rA9EH4l/QsetBi0/rdHEYyIiIyFBspXJcYMyFIUSjaCzU9pbOe6cHP6BQMfBN8Q
UUCR9dl2LwRS51fm1xGeYJyTAe6JxXQeMxGnjPnItIRJvy+aLo43V4miJrYCOFDr
1eyrFiEgRIKGeubb9oesp4DRiz805w+6QnwE19FixoL5GCiDxhbysmsRajSYnrMW
lPanYhMhjwVJQ62TUgPjrpCUJU7jK6ItM3W3lpsu1UXQAdzMbnG37Gsx1nJqvnAD
PuGM7a7+oUmT+wX4S0j/+kS7zhypidHGJ5Sb9q1hAZeS7MtpNSHjZtIMdgvttiCn
UyLw8C6NE5PyPX3px7fRj/CCZjtBL0w7ZpLmJr6eRyydhXAyjZTFarwGqC7DikrB
kalVhqDgKaw5R/ti/K54
=0UCY
-----END PGP SIGNATURE-----

--s4HLDwisrcEsLE1A--
