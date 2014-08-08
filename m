Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaHHQue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:50:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbaHHQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:50:31 -0400
Date: Fri, 8 Aug 2014 18:50:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808165004.GH9918@twins.programming.kicks-ass.net>
References: <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
 <20140808162714.GG9918@twins.programming.kicks-ass.net>
 <20140808124340.376376ed@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EC31x7qjULtwJxzf"
Content-Disposition: inline
In-Reply-To: <20140808124340.376376ed@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EC31x7qjULtwJxzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 12:43:40PM -0400, Steven Rostedt wrote:
> On Fri, 8 Aug 2014 18:27:14 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > On Fri, Aug 08, 2014 at 10:58:58AM -0400, Steven Rostedt wrote:
> >=20
> > > > > No, they are also used by optimized kprobes. This is why optimized
> > > > > kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussi=
on ].
> > > >=20
> > > > How do those work? Is that one where the INT3 relocates the instruc=
tion
> > > > stream into an alternative 'text' and that JMPs back into the origi=
nal
> > > > stream at the end?
> > >=20
> > > No, it's where we replace the 'int3' with a jump to a trampoline that
> > > simulates an INT3. Speeds things up quite a bit.
> >=20
> > OK, so the trivial 'fix' for that is to patch the probe site like:
> >=20
> > 	preempt_disable();		INC	GS:%__preempt_count
> > 	call trampoline;		CALL	0xDEADBEEF
> > 	preempt_enable();		DEC	GS:%__preempt_count
> > 					JNZ	1f
> > 					CALL	___preempt_schedule
> > 				1f:
> >=20
> > At which point the preempt_disable/enable() are the read side primitives
> > and call_rcu_sched/synchronize_sched are sufficient to release it.
> >=20
> > With the per-cpu preempt count stuff we have on x86 that is 4
> > instructions for the preempt_*() stuff -- they're 'big' instructions
> > though, since 3 have memops and 2 have a segment prefix.
> >=20
> >=20
>=20
> Now the question is, how do you do that atomically? And safely.
> Currently, all we replace at the call sites is a nop that is added by
> gcc -pg and us replacing the call mcount with it. That looks much more
> complex than our current solution.

Same way kprobes already does it. You can place that kprobe anywhere as
long as the function is long enough. The JMP you write for the optimized
kprobes is often longer than the instruction its patching.

So you start by writing the INT3 which is atomic, after that you 'copy'
the original text you're going to destroy into the tail of the
trampoline, followed by a 'return' JMP.

Then you write the tail end of the above sequence, and finally you
'fixup' the first instruction by removing the INT3.

But yes, I'm not sure that's going to work for the mcount thing, but it
will work for kprobes just fine, since its already doing this afaik.

--EC31x7qjULtwJxzf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5P+8AAoJEHZH4aRLwOS60GAP/jqQDVOJLULP/vLMsTwwKMRZ
D+/LmT7HSFnoVHGL/DKN3WbqWrbevZ0Lnl+VxMGQ42516nz7fYLmjfUoBAOqmDqH
NbTbHriRNsaYvZYkX4bTanDO0BiDGTaniCatP+mNpW+bhjf+cCk1DAi6iax2ppW+
O8Qqq6V5pQaGtp17ftmE03WcQU97t8soOv0XWwSyNJaifocv+sFIjWREfSSPPSeX
1qT3ylz5RJibdJlALrqRl/irYaeC5F+938e9X84ce7UgZYBG74DKCdVvfwR7Wx51
++CAhHxgn3/9lHCKqFjruUrxVCYMSdINInuz4lAsmxejVFdkQaaK+JrqwFMH1VJd
yWJVIsnFH/BryZSYRvxygDhD9GBr13gcS5pFi50PcGqibbsk/RcTWgKpxrP3mcLL
7jTU3B44q53bT/WKqOTiiWdZwlEszHPlWctj5g0y296DtabDsT3NlgB9EZi0+T7D
f8HkGJz5FMq26sPVFHuPOKzjMADEK4/R6hV01rRgVy1N6JMzgxIB9wBsAxlHYtsi
8du+IMrf3PJsC0mhNUPlIl69M6pwdF2PBcGjF5/yqOE9rQE7+/sKucEp2R3M5hoX
EAaLB+PYuxWA7mlPN69pix1rFu/X328v1Yr6F2TOKO6y3JmuGcnbHsx6gWa3gdjO
aZ26OSWtrmS7Z6pc3G7z
=lVba
-----END PGP SIGNATURE-----

--EC31x7qjULtwJxzf--
