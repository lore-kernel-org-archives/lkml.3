Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaEGTHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:07:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaEGTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:07:09 -0400
Date: Wed, 7 May 2014 21:06:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/4 v2] nohz: Fix idle/iowait counts going backwards
Message-ID: <20140507190647.GY30445@twins.programming.kicks-ass.net>
References: <1399470094-8070-1-git-send-email-dvlasenk@redhat.com>
 <1399470094-8070-3-git-send-email-dvlasenk@redhat.com>
 <20140507142321.GA2844@laptop.programming.kicks-ass.net>
 <536A642B.7080309@redhat.com>
 <20140507165638.GU30445@twins.programming.kicks-ass.net>
 <536A7A59.8050708@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sBcizk6cgRZY6rnJ"
Content-Disposition: inline
In-Reply-To: <536A7A59.8050708@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sBcizk6cgRZY6rnJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 08:24:25PM +0200, Denys Vlasenko wrote:
> On 05/07/2014 06:56 PM, Peter Zijlstra wrote:
> > On Wed, May 07, 2014 at 06:49:47PM +0200, Denys Vlasenko wrote:
> >> On 05/07/2014 04:23 PM, Peter Zijlstra wrote:
> >>> On Wed, May 07, 2014 at 03:41:33PM +0200, Denys Vlasenko wrote:
> >>>> With this change, "iowait-ness" of every idle period is decided
> >>>> at the moment it starts:
> >>>> if this CPU's run-queue had tasks waiting on I/O, then this idle
> >>>> period's duration will be added to iowait_sleeptime.
> >>>>
> >>>> This fixes the bug where iowait and/or idle counts could go backward=
s,
> >>>> but iowait accounting is not precise (it can show more iowait
> >>>> that there really is).
> >>>>
> >>>
> >>> NAK on this, the thing going backwards is a symptom of the bug, not an
> >>> actual bug itself.
> >>
> >> This patch does fix that bug.
> >=20
> > Which bug, there's two here:
> >=20
> >  1) that NOHZ and !NOHZ iowait accounting aren't identical
>=20
> They can hardly be identical, considering how different these modes are.

They can, we've managed it for pretty much everything else, although its
not always easy.

And if you look at the patch I send, that provides the exact moment the
task wakes up, so you can round that to the nearest jiffy boundary and
account appropriately as if it were accounted on the per-cpu timer tick.

Now, there's likely fun corner cases which need more TLC, see
kernel/sched/proc.c for the fun times we had with the global load avg.

> And they don't have to be identical, in fact.

Yes they have to; per definition. CONFIG_NOHZ should have no user
visible difference (except of course the obvious of less interrupts and
ideally energy usage).

> >  2) that iowait accounting in general is a steaming pile of crap
>=20
> If you want to nuke iowait (for example, make its counter constant 0),
> I personally won't object. Can't guarantee others won't...

I won't object to a constant 0, but then we have to do it irrespective
of NOHZ. But not necessarily, I think we can have a coherent definition
of iowait, just most likely not per-cpu.

So for UP we have the very simple definition that any idle cycle while
there is a task waiting for io is accounted to iowait.

This definition can be 'trivially' extended to a global iowait,
expensive to compute though.

However, one can argue its not correct to do that trivial extension,
since if there's only 1 task waiting for io, it could at most tie up 1
CPUs worth of idle time (but very emphatically not a specific cpu).

So somewhere in that space is I think a viable way to account iowait,
but the straight fwd implementation (in as far as the eventual
definition will be straight fwd to begin with) will likely be
prohibitively expensive to compute.

Then again, if you look at kernel/sched/proc.c (again) and look at the
bloody mess we had to make for the global load avg accounting to work
for NOHZ there might (or might just not) be a shimmer of hope we can
pull this off in a scalable manner.

Like said, 'fun' problem :-)

--sBcizk6cgRZY6rnJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaoRHAAoJEHZH4aRLwOS6vHsP/AivG2DiHECPd+PLqS35GT0B
Ul9+DmdInBvtzV6Likoom2sCJnyrbHG/idxKnDlEXQq7bil6WVJ0KYUDqEHY5wpq
3SIsdd4QdXzzfKqpd0grccQwBoDG1E3tADfbBYjmeqJ2KnbTL3EwYZqSe0AFkyIw
PUebo2caTUOvAul/6ubZZHGYQL7ZFw8nZ1y3G5x+iB5EoJE3pMSnlFbPWIyhTuLE
OIBwB06fc+xeHn2ViW4f6ZX7DWPsa3mDFhEeHG9UK3pkVW4OiSUo/+cbmFdS4w1v
uBBJEL0V1FqCQLeJQT1E2rOJ6ffxr6qqgI608P5QwqZRYTMj5HTb+x/u7OZ3Enee
p3DTI8wQfXzs+esHjWs2aTKTJHmfDicjAQEBTuWv+v2/N4yeVOipTsc4rxD7ylhz
es89uPgFkTf7Jdb0U+IDhoaIQx7MCgHgNGLgyG+kLP7A0eoUHBzYIqScG7rmGN2m
pfv9G8cgLz9PywZkCo/qgN1zJHSF8Skd/xyeeIWe/JAt8gtiKMIrjJmSOodH8vLf
GwEmP4WrYyzW+tF4WXUONOes8ypvxprlI/VBhW3cHnxfymYD5TxI7RJg7Kz5Q2EH
/IQ1ebcsgNXec+CHApq0cZ/n8Rrq8/CtTISpkju+I8gO8ABfPrA1Tvr0RMCTPuSs
7AZsF/jaiB7GubiHdvj1
=ZkTA
-----END PGP SIGNATURE-----

--sBcizk6cgRZY6rnJ--
