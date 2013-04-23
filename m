Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3DWUsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:48:46 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:47541 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3DWUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:48:44 -0400
Date: Tue, 23 Apr 2013 22:42:38 +0200
From: Henrik Austad <henrik@austad.us>
To: ratheesh kannoth <ratheesh.ksz@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: scheduler context
Message-ID: <20130423204238.GA14225@icarus.home.austad.us>
References: <CAGZFCEHb2Cb_LGXtcYmhDvd0d0zjdb3-5D7-6EBjXmHLJESYoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <CAGZFCEHb2Cb_LGXtcYmhDvd0d0zjdb3-5D7-6EBjXmHLJESYoA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ratessh,

Before digging into your questions;
- LKML and linux-rt is probably not the best places to ask these kind of=20
questions. kernelnewbies is an excellent place to go to for quidance, and=
=20
you may get faster response there as well.

Furthermore; I recommend you to pick up a book about kernel development=20
(Linux Kernel Development by R. Love is a great place to start).

> I would like to understand on linux scheduler context. I have read a lot=
=20
> in websites and i could find contradictory statement. There are so many=
=20
> mailing list also ,but with less info. I would really appreciate if=20
> anybody could spend some time answering my question.
>=20
> 1. Which context scheduler run ? ( process context or interrupt context ).

um.. it does not run in interrupt-context. It will be in kernel-context,=20
either on return from interrupt or return to userspace from a syscall.

> 2. scheduler is the guy  who picks up the next candidate to run.  if
> it gets interrupted by hardirq, what will happen ?

On return to userspace, the kernel will check if TIF_NEED_RESCHED is set,=
=20
if so, it will invoke do_schedule() which will then see if there's a better=
=20
candidate to run.

> 3. if scheduler run in process context , how bottom half are scheduled ?

Bottom half can be several things

1) softirqs
2) tasklets
3) kernel threads
4) timers

Softirqs are run as soon as an interrupt handler has finished. These are=20
defined in a set of softirqs when you compile the kernel and are used for=
=20
interrupt-handlers that require a very fast response (network being a=20
candidate). Softirqs can run concurrently on any and all CPUs in the=20
system.

Tasklets are a simplification of softirqs, and it is pretty much (someone's=
=20
probably going to fry my nether regions for this simplification) a=20
work-queue for interrupt handlers. You currently have 2 versions, one=20
high-priorty queue and a normal one. They are handled by 2 corresponding=20
softirqs. Tasklets of the _same_ type can only run on a single CPU at a=20
time (but different tasklets can run concurrently).

Kernel threads are 'normal' threads, normal in the sense that they are=20
schedulable entities. Not normal in the sense that they do not have process=
=20
context (no *mm for instance).

Timers is a way to not only delay execution of some code, but delay it to a=
=20
specific point in time, say in 2 seconds. Once 2 secs has elapsed, the=20
timer will fire and the given function will be executed in the context of=
=20
the timer-softirq context.

> 4. In smp, schedule() function may be called  simultaneously. How it
> is handled ?

You have one runqueue pr. cpu, each queue has a set of runnable tasks, it=
=20
will pick a task from that queue. One task cannot be placed in more than=20
one rq at a time.

> 5. When a bottom half is interrupted  by hard irq, how softirq kernel
> thread saves the state and restart it later ?=20
=2E..what i mean is , an
>    hardirq came and its isr executed. bottom half enabled and bottom
> half gets scheduled . Before bottom half is completed , next irq
>    came and it enables bottom half , and the new bottom half is
> scheduled ....So here , what will happen to old bottom half , will it
> again
>    run later ?

So your question is "what happens to my system if a faulty piece of=20
hardware generates a flood of interrupts?"?

Meet: ksoftirqd

let me try to explain:

The moment you get a hard interrupt, the CPU will vector to the appropriate=
=20
handler, ack the interrupt and do whatever need doing right then. Once=20
done, it will _raise_the_softirq_ and return. The kernel will then start=20
processing the softirqs that need attention.

What happens here is:
- disable local interrupt
- get a list of softirqs that needs to be processed
- clear the list of pending softirqs
- renable interrupts
- process softirqs

Once this is done, it will check to see if there's any _new_ softirqs that=
=20
needs to be handled. If so, it will jump to the start and go through the=20
list one more time.

It will continue to do this for a pre-defined number of times=20
(MAX_SOFTIRQ_RESTART - which is 10) before prodding ksoftirqd to handle it.

So, to connect this to your question - if you get an excessive amount of=20
interrupts whilst in the middle of softirq processing, all you get is a set=
=20
of raised softirqs which will cause __do_softirq() to loop 10 times before=
=20
offloading the work to ksoftirqd.



--=20
Henrik Austad

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlF28j4ACgkQ6k5VT6v45lllggCgxDbiFresG4gMiCqx4BHIURTT
nkgAnAkYL10k3zyS9a4BYq/j9PaThYXW
=G/L1
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
