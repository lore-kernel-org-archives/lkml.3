Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935024AbaDJOpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:45:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaDJOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:45:11 -0400
Date: Thu, 10 Apr 2014 09:44:30 -0500
From: Clark Williams <williams@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
In-Reply-To: <20140409151922.5fa5d999@gandalf.local.home>
References: <20140409151922.5fa5d999@gandalf.local.home>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0Kr_8p_vZhU0dhpEjRL+Wr8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0Kr_8p_vZhU0dhpEjRL+Wr8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Apr 2014 15:19:22 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

=20
> This patch is built on top of the two other patches that I posted
> earlier, which should not be as controversial.
>=20
> If you have any benchmark on large machines I would be very happy if
> you could test this patch against the unpatched version of -rt.
>=20
> Cheers,
>=20
> -- Steve
>

Steven

I wrote a program named whack_mmap_sem which creates a large (4GB)
buffer, then creates 2 x ncpus threads that are affined across all the
available cpus. These threads then randomly write into the buffer,
which should cause page faults galore.

I then built the following kernel configs:

  vanilla-3.13.15  - no RT patches applied
  rt-3.12.15       - PREEMPT_RT patchset
  rt-3.12.15-fixes - PREEMPT_RT + rwsem fixes
  rt-3.12.15-multi - PREEMPT_RT + rwsem fixes + rwsem-multi patch

My test h/w was a Dell R520 with a 6-core Intel(R) Xeon(R) CPU E5-2430
0 @ 2.20GHz (hyperthreaded). So whack_mmap_sem created 24 threads
which all partied in the 4GB address range.

I ran whack_mmap_sem with the argument -w 100000 which means each
thread does 100k writes to random locations inside the buffer and then
did five runs per each kernel. At the end of the run whack_mmap_sem
prints out the time of the run in microseconds.

The means of each group of five test runs are:

  vanilla.log:  1210117
       rt.log:  17210953 (14.2 x slower than vanilla)
 rt-fixes.log:  10062027 (8.3 x slower than vanilla)
 rt-multi.log:  3179582  (2.x x slower than vanilla)


As expected, vanilla kicked RT's butt when hammering on the
mmap_sem. But somewhat unexpectedly, your fixups helped quite a bit
and the multi+fixups got RT back into being almost respectable.

Obviously these are just preliminary results on one piece of h/w but
it looks promising.

Clark

P.S. If you want the source to whack_mmap_sem you can grab it from=20
http://people.redhat.com/williams/whack_mmap_sem. If it looks like its
worth keeping around I can add it to rt-tests.=20


--Sig_/0Kr_8p_vZhU0dhpEjRL+Wr8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlNGrk4ACgkQHyuj/+TTEp07fQCfd0+7wizfvUJJJ+jZTDUyFZhh
7+wAn2ZsxeZD4QWxZRHogj1o+AHTOYZh
=bERs
-----END PGP SIGNATURE-----

--Sig_/0Kr_8p_vZhU0dhpEjRL+Wr8--
