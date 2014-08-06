Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaHFQbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:31:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaHFQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:31:06 -0400
Date: Wed, 6 Aug 2014 18:30:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140806163035.GG19379@twins.programming.kicks-ass.net>
References: <1406843709-23396-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140801150926.GA845@redhat.com>
 <20140801183251.GJ4784@linux.vnet.ibm.com>
 <20140801194417.GA27141@linux.vnet.ibm.com>
 <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="giIAyftFIZSAHkbR"
Content-Disposition: inline
In-Reply-To: <20140806120958.GZ8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--giIAyftFIZSAHkbR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 05:09:59AM -0700, Paul E. McKenney wrote:

> > Or you could shoot all CPUs with resched_cpu() which would have them
> > cycle through schedule() even if there's nothing but the idle thread to
> > run. That guarantees they'll go to sleep again in a !trampoline.
>=20
> Good point, that would be an easier way to handle the idle threads than
> messing with rcu_tasks_kthread()'s affinity.  Thank you!

One issue though, resched_cpu() doesn't wait for that to complete. We'd
need something that would guarantee the remote CPU has actually
completed execution.

> > But I still very much hate the polling stuff...
> >=20
> > Can't we abuse the preempt notifiers? Say we make it possible to install
> > preemption notifiers cross-task, then the task-rcu can install a
> > preempt-out notifier which completes the rcu-task wait.
> >=20
> > After all, since we tagged it it was !running, and being scheduled out
> > means it ran (once) and therefore isn't on a trampoline anymore.
>=20
> Maybe I am being overly paranoid, but couldn't the task be preempted
> in a trampoline, be resumed, execute one instruction (still in the
> tramopoline) and be preempted again?

Ah, what I failed to state was we should check the sleep condition. So
'voluntary' schedule() calls.

Of course if we'd made something specific to the trampoline thing and
not 'task'-rcu we could simply check if the IP was inside a trampoline
or not.

> > And the tick, which checks to see if the task got to userspace can do
> > the same, remove the notifier and then complete.
>=20
> My main concern with this sort of approach is that I have to deal
> with full-up concurrency (200 CPUs all complete tasks concurrently,
> for example), which would make for a much larger and more complex patch.
> Now, I do admit that it is quite possible that I will end up there anyway,
> for example, if more people start using RCU-tasks, but I see no need to
> hurry this process.  ;-)

You mean cacheline contention on the struct completion? I'd first make
it simple and only fix it if/when it becomes a problem.

200 CPUs contending on a single cacheline _once_ is annoying, but
probably still lots cheaper than polling state for at least that many
tasks.

--giIAyftFIZSAHkbR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4lgrAAoJEHZH4aRLwOS63Y0QAKnZ6k9+7z8qmYPZLI+ECmgl
tRibRE5wtC12oV+y/nbo5oWU29i7CcgbmYgAszwFobi/LStypeuimjESO+H57UT/
pJirAHfPaaRIc9Y88vcpMz/RehGEK0//FPaCQ360Ke1w9H3MJPLRUGt+d11uly6o
x/UHWLrZ4stwGH22H31GhyhtIptLi4Dn/EAGeAUElqSxCC0zMXAqZTVu6ZXBPTc4
55J0LduMBingbK0pNoq307XLNC3p8KVjmZsNyY3Qb+PViK9E/TT9mRJig72vF57y
svIVRvJZBMJ0ADKOGPN+81ySZ0dww229Nt9x2fYK2JlUyZqxRSP1hZjvkAqFymND
7jaUITk7pPcMtHVlwwYnfiN1MiFGuyOAOIrcWymtTzVGyWus5J+z20bQVmL9qrpl
RuIHzfN1NMTXGJNFHBLMForU4qaEMHE3Yh1PgBs7PBns5+58hPtO0mHBabNAYzHj
Jr+gnP8ri+5lQHuH6A7+DdYJ2c+Pfsr/d/wFyjZhIAOAYSLC4GJk9ud3TdXThrc7
959Gyl2gvdUbLDIH7AjayRB1c++pRZgg9V/MLEOOYXTLfSwOJRj+G3G+JIMqeFLR
ebv2oZf0jab4iJY3or69d0kWi0/uTWh9UN/LjC946IwsUmupx15swi33oZjkCuL7
101yGhC6Ok2Opv4yKaO8
=lu43
-----END PGP SIGNATURE-----

--giIAyftFIZSAHkbR--
