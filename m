Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbaHHQ13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:27:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:52500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaHHQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:27:27 -0400
Date: Fri, 8 Aug 2014 18:27:14 +0200
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
Message-ID: <20140808162714.GG9918@twins.programming.kicks-ass.net>
References: <20140807172753.GG3588@twins.programming.kicks-ass.net>
 <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RcPFyPFpHIboIe6N"
Content-Disposition: inline
In-Reply-To: <20140808105858.171da847@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RcPFyPFpHIboIe6N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 10:58:58AM -0400, Steven Rostedt wrote:

> > > No, they are also used by optimized kprobes. This is why optimized
> > > kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].
> >=20
> > How do those work? Is that one where the INT3 relocates the instruction
> > stream into an alternative 'text' and that JMPs back into the original
> > stream at the end?
>=20
> No, it's where we replace the 'int3' with a jump to a trampoline that
> simulates an INT3. Speeds things up quite a bit.

OK, so the trivial 'fix' for that is to patch the probe site like:

	preempt_disable();		INC	GS:%__preempt_count
	call trampoline;		CALL	0xDEADBEEF
	preempt_enable();		DEC	GS:%__preempt_count
					JNZ	1f
					CALL	___preempt_schedule
				1f:

At which point the preempt_disable/enable() are the read side primitives
and call_rcu_sched/synchronize_sched are sufficient to release it.

With the per-cpu preempt count stuff we have on x86 that is 4
instructions for the preempt_*() stuff -- they're 'big' instructions
though, since 3 have memops and 2 have a segment prefix.



--RcPFyPFpHIboIe6N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5PpiAAoJEHZH4aRLwOS6LJEQALRSVru67Ha13YHftzBuKcUw
r0spJRdK31yBTsCD0A37OsVN4nd1um0ss4IEfDS5hISY9fz7VZQG4p8NqEQJgGAu
vNhu2pXVo67t8dmL+sVdhAp4XG855GW0Yf4uNVuhxZZt0luiGrcNQSIpFcijxpmc
Q4CTzBgcjBhUiXgOjgS7dgtJQVeligP3j3MsQVLYw4FhEhAfCGGuUTNkjLsIB696
Swp1xwO5h6LkyPVnD2DeM/OnDclGAK4dSEMaQ88xiEaiY7oDPtf9pLxPyISLGmMn
eODFGVKWQYIdn9GdUixDi+s+dKx2c/alWsTG6cvvj3Zu0wLLBqNF7awsH448w2EY
rQXM7sGB0S48HoAay9ACjaBJFmsWfXamZDJ02fTVn8WeQyRUrJYUgA4iG2EfbrKL
0W8xd2nkNF2U90uAjwJ0Cml7vhiIQ1OxErjY2RmLLaJpxDHL+0blPZi1k0paMYB5
kCB47nkUP1tzlBsbjPe/OF6uXAPMgSuWCZES3oIjqEopidfAW2jQV46ai2GcqSNK
nYJOOG3vNEPi/x5ICXVfOVjb/9T2LN+GWoxZPlDdagPajkjuBQWiecvSjfvd91XD
9H4x9952AQU5wstBKHFNEnhIoTSBrXMr5zxkOsG/FlfslkWVzBRXxI26ki6QIGn+
LXjOQIqOfW3G5d4l8Wju
=frrL
-----END PGP SIGNATURE-----

--RcPFyPFpHIboIe6N--
