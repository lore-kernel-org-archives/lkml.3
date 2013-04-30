Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab3D3VzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:55:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760241Ab3D3VzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:55:16 -0400
Date: Tue, 30 Apr 2013 16:54:58 -0500
From: Clark Williams <williams@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, rostedt@goodmis.org
Subject: Re: Suspend resume problem (WAS Re: [ANNOUNCE] 3.8.10-rt6)
Message-ID: <20130430165458.719d5556@riff.lan>
In-Reply-To: <20130430141824.196bd758@riff.lan>
References: <20130429201202.GB7979@linutronix.de>
	<20130429161925.2a6ea78a@riff.lan>
	<20130430170948.GB4688@linutronix.de>
	<20130430141824.196bd758@riff.lan>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XYWMb.gDaYFO9.HqtKQqVRe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XYWMb.gDaYFO9.HqtKQqVRe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Apr 2013 14:18:24 -0500
Clark Williams <williams@redhat.com> wrote:

> On Tue, 30 Apr 2013 19:09:48 +0200
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>=20
> > * Clark Williams | 2013-04-29 16:19:25 [-0500]:
> >=20
> > >On Mon, 29 Apr 2013 22:12:02 +0200
> > >Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > >>     - suspend / resume seems to program program the timer wrong and =
wait
> > >>       ages until it continues.
> > >
> > >It has to be something we're doing when we apply RT to v3.8.x, since
> > >v3.8.x suspends/resumes with no issues and I was able to suspend and
> > >resume fine with the 3.6-rt series.=20
> >=20
> > I think I figured out what is going on or atleast I think I did.
> >=20
> > This log snippet is from the resume path (from suspend to mem):
> >=20
> > [   15.052115] Enabling non-boot CPUs ...
> > [   15.052115] smpboot: Booting Node 0 Processor 1 APIC 0x1
> > [   14.841378] Initializing CPU#1
> > [   42.840017] [sched_delayed] sched: RT throttling activated
> > [   42.842144] CPU1 is up
> > [   42.842536] smpboot: Booting Node 0 Processor 2 APIC 0x2
> >=20
> > Two things happen here:
> > - the time goes backwards from 15.X to 14.X. This is okay because the
> >   14.X is the timestamp from the secondary CPU not - yet synchronized
> >   with the bootcpu
> > - the printk with "CPU1 is up" is comming from the boot CPU and
> >   according to the timestamp about 28secs passed by. But this did not
> >   really happen as the whole procedure took less time.
> >=20
> > The next thing that happens is that RCU assumes nobody is doing any
> > progress (for almost 28secs) and triggers NMIs & printks to get some
> > attention. I have a trace where
> > - CPU0: arch_trigger_all_cpu_backtrace_handler() =3D> printk()
> >         has "lock" and is spinning for logbuf_lock
> >=20
> > - CPU1: print_cpu_stall() =3D> printk() (spinning for the lock) =3D> NM=
I =3D>
> >   arch_trigger_all_cpu_backtrace_handler()
> >         it may have logbuf_lock and is spinning for "lock"
> >=20
> > I can't tell if CPU1 got the logbuf_lock at this time but it seemed that
> > it made no progress until I ended it.
> > This NMI releated deadlock is a problem which should also trigger
> > mainline, right?
> >=20
> > Now, the time jump on the other hand is the real issue here and is
> > RT-only. It looks like we get a big number of timer updates via
> > tick_do_update_jiffies64() because according to ktime_get() that much
> > time really passed by.
> >=20
> > The sollution seems as simple as
> >=20
> > From c27eb2e0ab0b5acd96a4b62288976f1b72789b3e Mon Sep 17 00:00:00 2001
> > From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Date: Tue, 30 Apr 2013 18:53:55 +0200
> > Subject: [PATCH] time/timekeeping: shadow tk->cycle_last together with
> >  clock->cycle_last
> >=20
> > Commit ("timekeeping: Store cycle_last value in timekeeper struct as
> > well") introduced a tk-> based cycle_last values which needs to be reset
> > on resume path as well or else ktime_get() will think that time
> > increased a lot.
> >=20
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  kernel/time/timekeeping.c |    1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index 99f943b..688817f 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -777,6 +777,7 @@ static void timekeeping_resume(void)
> >  	}
> >  	/* re-base the last cycle value */
> >  	tk->clock->cycle_last =3D tk->clock->read(tk->clock);
> > +	tk->cycle_last =3D tk->clock->cycle_last;
> >  	tk->ntp_error =3D 0;
> >  	timekeeping_suspended =3D 0;
> >  	timekeeping_update(tk, false, true);
> > --=20
> > 1.7.10.4
> >=20
> > So Clark, does this patch fix your problem?
> >
>=20
> It does seem to! I've got both patches applied right now (your patch to
> vprintk_emit() and the above patch) and it fixes the long delay on my
> lab box. When I get done today (or have a break in the action) I'll try
> it on my laptop to verify.=20
>=20
> Thanks Sebastian,
> Clark

Tested on my laptop which now resumes.=20

Many thanks.

Clark

--Sig_/XYWMb.gDaYFO9.HqtKQqVRe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGAPbYACgkQHyuj/+TTEp1+9wCgyJMsmYR8k+dsVUAjXsZglSO1
FVUAoOSzCOcQPuBBmC2ESwss85DV9ylQ
=kT4R
-----END PGP SIGNATURE-----

--Sig_/XYWMb.gDaYFO9.HqtKQqVRe--
