Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaEPKPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:15:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:38036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbaEPKPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:15:14 -0400
Date: Fri, 16 May 2014 12:15:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140516101505.GO13658@twins.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516093530.GN11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hTKW8p8tUZ/8vLMe"
Content-Disposition: inline
In-Reply-To: <20140516093530.GN11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hTKW8p8tUZ/8vLMe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 11:35:30AM +0200, Peter Zijlstra wrote:
> On Fri, May 16, 2014 at 11:50:42AM +0800, Lai Jiangshan wrote:
> > After debugging, I found the hotlug-in cpu is atctive but !online in th=
is case.
> > the problem was introduced by 5fbd036b.
> > Some code assumes that any cpu in cpu_active_mask is also online, but 5=
fbd036b breaks
> > this assumption, so the corresponding code with this assumption should =
be changed too.
>=20
> Good find, and yes it does that.
>=20
> > The following patch is just a workaround. After it is applied, the abov=
e WARNING
> > is gone, but I can't hit the wq problem that you found.
>=20
> Seeing how the entirety of hotplug is basically duct tape and twigs, the
> below isn't that bad.


I made that, are you okay with that?

---
Subject: sched: Fix hotplug vs set_cpus_allowed_ptr()
=46rom: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 16 May 2014 11:50:42 +0800

Lai found that:

  WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 native_smp_send_resc=
hedule+0x2d/0x4b()
  ...
  migration_cpu_stop+0x1d/0x22

was caused by set_cpus_allowed_ptr() assuming that cpu_active_mask is
always a sub-set of cpu_online_mask.

This isn't true since 5fbd036b552f ("sched: Cleanup cpu_active
madness").

So set active and online at the same time to avoid this particular
problem.

Fixes: 5fbd036b552f ("sched: Cleanup cpu_active madness")
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/53758B12.8060609@cn.fujitsu.com
---
 kernel/cpu.c        |    6 ++++--
 kernel/sched/core.c |    1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -726,10 +726,12 @@ void set_cpu_present(unsigned int cpu, b
=20
 void set_cpu_online(unsigned int cpu, bool online)
 {
-	if (online)
+	if (online) {
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
-	else
+		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+	} else {
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+	}
 }
=20
 void set_cpu_active(unsigned int cpu, bool active)
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5126,7 +5126,6 @@ static int sched_cpu_active(struct notif
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;

--hTKW8p8tUZ/8vLMe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdeUpAAoJEHZH4aRLwOS6xpEP/A5oUQkApEcof0JegtofN9BS
6KTxM71dhg6b6WJRQF2wy4k66tQt5VwKnG4w/UMdGdvn0yDdnOHiW+a1gFmgjus2
XVO2COdNeIsbSwwxVs+cBUNGb0BVaoOQpB5SCXclC15Mu1pI5O5Rj0i2xUyUA52b
nYQg/Xe8I7mPOt0xFNRJGKnJcdf+vJ4IaKmDaDn8o44svw8GvaFh96YsmxEx0IE/
BbYI8hWpfLCneNkeQh5liIGEqDnsxN+upau9h2CZmOR4/3hepg2h1+MyQ5tIlAPu
6opgqaqSKT5UB4Wauqr75265u/2TB+MhE87SegPH0lDjdsRH7wfAy8uiQJ/Iy/nF
0XTydmD4Pt7nKOVH0RunPELt7zPCkCEc7hZQGLpdbWsNe4hDOlZIiWntu4phFQMe
a4z6Vs0ZelS07cOgkTb0pYn+WmNhY/+8/vjGH/LCbWpSrYQBIaZk3CgJrCeTx6vw
yrdb6cljPAlDCDAY+c1s8X2aZnMDP57D51SR8emvIMNS6N38+UkQluMGPRj+X/St
0D68FMo9Sutt3VKbAGli3N5l+19iyQMkjY8RhtZE8j7C9S40ErHdfizqHDexZ3Xo
ysuaRZWm7OXnIoFM9BE4eRHb9axMjEAsZT8NwhcruNrIA/juI8VtdLSB5XN4ERcS
rMVt7DeWiLOiGm8w5RF/
=nGkw
-----END PGP SIGNATURE-----

--hTKW8p8tUZ/8vLMe--
