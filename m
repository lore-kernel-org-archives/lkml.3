Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaHMOmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:42:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:44834 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMOmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:42:32 -0400
Date: Wed, 13 Aug 2014 16:42:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, rafael@kernel.org
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813144219.GQ9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813141217.GU4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHAfZBNe+ETbtd8W"
Content-Disposition: inline
In-Reply-To: <20140813141217.GU4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cHAfZBNe+ETbtd8W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 07:12:17AM -0700, Paul E. McKenney wrote:
> > That's not an excuse for doing horrible things. And inventing new infra
> > that needs to wake all CPUs is horrible.
>=20
> Does your patch even work?=20

Haven't even tried compiling it, but making it work shouldn't be too
hard.

> Looks like it should, and yes, the idle loop
> seems quite a bit simpler than it was a few years ago, but we really
> don't need some strange thing that leaves a CPU idle but not visible as
> such to RCU.

There's slightly more to it though; things like the x86 mwait idle wait
functions tend to do far too much; for instance look at:

drivers/idle/intel_idle.c:intel_idle()

We should push the rcu_idle_{enter,exit}() down to around
mwait_idle_with_hints(), so we don't call half the word with RCU
disabled.

> I have already said that I will be happy to rip out the wakeup code
> when it is no longer needed, and I agree that it would be way better if
> not needed.

I'd prefer to dtrt now and not needing to fix it later.

Auditing all idle functions will be somewhat of a pain, but its entirely
doable. Looking at this stuff, it appears we can clean it up massively;
see how the generic cpuidle code already has the broadcast logic in, so
we can remove that from the drivers by setting the right flags.

We can similarly pull out the leave_mm() call by adding a
CPUIDLE_FLAG_TLB_FLUSH. At which point all we'd need to do is mark the
intel_idle (and all other cpuidle_state::enter functions with __notrace.

> But I won't base a patch on hypotheticals.  You have already
> drawn way too much water from -that- well over the past years!  ;-)

not entirely sure what you're referring to there ;-)

--cHAfZBNe+ETbtd8W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT63lLAAoJEHZH4aRLwOS6sOcP/ibmZvaXEHa4/Rvt5v/PM1uP
guJOL9/l2bORtGFagnE1J5/N1nKFax+fbRr0deWIz2HmBp+Ijl5j6EA+JCoye8ar
Zg8dB3y/lGjSOUaDf2k2uZPszLX6SvVN/W803c4Ahym7KRn1Pmm4CCC/p3RGXNVF
xNTtKHaA4iV0HLBpiJOE0L3TfEjKFmyxkU40v7yo/zydZ46axEh2EWHcULFANVXx
DYi+KYTbzFSau49zpG00Zd+0xLwIwUJQMVAx6vGTeK4ElMZs5N+1i/PXtLrDtuuV
FF6FoT/yqXodEuoQ6JDi4fJPOxh24fjvgda5GhqXE5dilLXNC29Jd9AGuUCi6WUm
BZRAE4l3ScNUVNG3OLkBay+xyXPHUzNqjg3/nozbGqWFDtCw+hMdX8cOLDPqpYnT
szhCC85m/mhr21P9A3FYUy0ipvp++yFv8aE/6HnFtbBslHPJTdlzd1MCz40rohy5
aNd/ejT+RCR3vPqT7FOlbSWa02jsF4eHsFEtwwylQM+3gpE5wAxeprCikjLOzYtA
m3NpIL/t08+7UzjQzCJsUzXZY7HcW3GYawkv8nlLq9aKT/C6P08xMXZnYxdGE4Ys
dccEXA5x/yJnAo1GkEMBnH99X3MHSmvwhLIHMA8m0Ko5mAUcy8qSP7p30QM6sZ2x
1kWa4ce2CCOu/SzvCDFs
=IxDi
-----END PGP SIGNATURE-----

--cHAfZBNe+ETbtd8W--
