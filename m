Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaEBLQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:16:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaEBLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:16:12 -0400
Date: Fri, 2 May 2014 13:15:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140502111552.GV11096@twins.programming.kicks-ass.net>
References: <20140429190108.GB30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
 <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu>
 <20140501150948.GR11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pQhZXvAqiZgbeUkD"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2014 at 02:49:01PM -0400, Vince Weaver wrote:
>=20
> OK, humor me a bit here.
>=20
> I'm looking at the buggy trace and comparing against a "good" trace where=
=20
> the bug doesn't happen.
>=20
> It is a rance condition of sorts, because it's just a 10us or so=20
> interleaving of calls that causes the bug to happen or not.
>=20
> In the good trace:
>=20
> 	[parent] __perf_event_task_sched_out (and hence perf_swevent_del)
> 	[child]  perf_release
>=20
> In the buggy trace:
>=20
> 	[child] perf_release
> 	[parent] __perf_event_task_sched_out (perf_swevent_del never happens)
>=20
>=20
> perf_swevent_del calls
> 	hlist_del_rcu(event->hlist_entry)
> to remove the event from the swevent hlist.
>=20
> Now in theory perf_release() calls sw_perf_event_destroy() which you
> would think would also call the above.  Instead it does
> 	 swevent_hlist_put_cpu(event, cpu);
> which does all kinds of weird hash stuff that I don't follow.
>=20
> Should the above two be equivelent?  Is it reference counting in there=20
> with if (!--swhash->hlist_refcount) causing the issue?

perf_release()
  put_event()
    perf_remove_from_context()
      __perf_remove_from_context()
        event_sched_out()
	  ->del()

is the path that would call ->del() and hlist_del_rcu().

Now perf_remove_from_context() only calls __perf_remove_from_context()
when the task is active somewhere, otherwise it simply calls
list_del_event().

Both perf_remove_from_context() and perf_event_context_sched_out() (as
called from __perf_event_task_sched_out) hold ctx->lock, so they should
be serialized against each other.

Clearly I'm missing something though, will go stare at the trace now.

--pQhZXvAqiZgbeUkD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTY35oAAoJEHZH4aRLwOS6Ya4P/1mdw678TR1ZaX94JLn/ZnCh
BCtvdB1JPQ6ixctFCOF0X//7gftviaczDHQ89VsQPH/F0qmFk54jqgcap02TnZzv
sahvUGPVoBGpybqfQ0Bd57GXbGOXZ/sN3BQxP75dDSHg4xQESHHY17aluEUyQQd2
zjDB8/wKPgwob//J0ncUY+rpbkqUJGm9M9Kwiy6kIonPxak+qY95S0CVPNNvP/a3
rGmAezituraQ3iqjiNDOG1V3srZ14rVHCVh5mRZYhNB8dEKdh+INS8yuQ5cQIooH
vKZNcCvdPwRgono6oTp3xRGpd3tGdks8Nb9VqHw0f4gwLWEFQZePNLJT7A/BSD6Q
0GGRgM/ZAJ8w3mMNnacnFO4FzE8++nZjRc/14QG5+04Ks42cNCj48Q874e9qMll3
NDAgEbBtZ7jZLUc5W/xOyf2JSZhgTecUdyy8LRd7WwOAguthmN6jDfV60n8Ef52I
oLhA9CfsLLWPOJH2yR000VwnlANBEnZZgWANwK+ZdNP+Nbk/RzyO6RAtFauskjY8
WaytEgbzNShRji3PIb5FjzfMhPQJC6Kmcvz35fuoqUtuDU/croBioRpzTpRwKB8C
BS+zPsLtFaENuW4S/fx/T8pB+M+ehlo9IU9QRRkWEZX2FpyeL4dfBFG6Ekift2/4
BPjAxCb0Kp6eKhJ/r4p9
=5QKK
-----END PGP SIGNATURE-----

--pQhZXvAqiZgbeUkD--
