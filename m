Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676AbaGRKQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:16:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:44391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965603AbaGRKQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:16:43 -0400
Date: Fri, 18 Jul 2014 12:16:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140718101633.GP9918@twins.programming.kicks-ass.net>
References: <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
 <20140717030947.GA17889@wolff.to>
 <53C79013.1020808@arm.com>
 <20140717090452.GH19379@twins.programming.kicks-ass.net>
 <53C7B247.2070309@arm.com>
 <20140717123502.GL19379@twins.programming.kicks-ass.net>
 <20140718053449.GA2039@wolff.to>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HxOxd3Hfl5FMJYiY"
Content-Disposition: inline
In-Reply-To: <20140718053449.GA2039@wolff.to>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HxOxd3Hfl5FMJYiY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 12:34:49AM -0500, Bruno Wolff III wrote:
> On Thu, Jul 17, 2014 at 14:35:02 +0200,
>  Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >In any case, can someone who can trigger this run with the below; its
> >'clean' for me, but supposedly you'll trigger a FAIL somewhere.
>=20
> I got a couple of fail messages.
>=20
> dmesg output is available in the bug as the following attachment:
> https://bugzilla.kernel.org/attachment.cgi?id=3D143361

Thanks!

[    0.252059] __sdt_alloc: allocated f255b020 with cpus:=20
[    0.252147] __sdt_alloc: allocated f255b0e0 with cpus:=20
[    0.252229] __sdt_alloc: allocated f255b120 with cpus:=20
[    0.252311] __sdt_alloc: allocated f255b160 with cpus:=20

[    0.252395] __sdt_alloc: allocated f255b1a0 with cpus:=20
[    0.252477] __sdt_alloc: allocated f255b1e0 with cpus:=20
[    0.252559] __sdt_alloc: allocated f255b220 with cpus:=20
[    0.252641] __sdt_alloc: allocated f255b260 with cpus:=20

[    0.253013] __sdt_alloc: allocated f255b2a0 with cpus:=20
[    0.253097] __sdt_alloc: allocated f255b2e0 with cpus:=20
[    0.253184] __sdt_alloc: allocated f255b320 with cpus:=20
[    0.253265] __sdt_alloc: allocated f255b360 with cpus:=20

[    0.253354] build_sched_groups: got group f255b020 with cpus:=20
[    0.253436] build_sched_groups: got group f255b120 with cpus:=20
[    0.253519] build_sched_groups: got group f255b1a0 with cpus:=20
[    0.253600] build_sched_groups: got group f255b2a0 with cpus:=20
[    0.253681] build_sched_groups: got group f255b2e0 with cpus:=20

[    0.253762] build_sched_groups: got group f255b320 with cpus:=20
[    0.253843] build_sched_groups: got group f255b360 with cpus:=20
[    0.254004] build_sched_groups: got group f255b0e0 with cpus:=20
[    0.254087] build_sched_groups: got group f255b160 with cpus:=20
[    0.254170] build_sched_groups: got group f255b1e0 with cpus:=20
[    0.254252] build_sched_groups: FAIL
[    0.254331] build_sched_groups: got group f255b1a0 with cpus: 0
[    0.255004] build_sched_groups: FAIL
[    0.255084] build_sched_groups: got group f255b1e0 with cpus: 1

So from previous msgs we know:

	CPU0	CPU1	CPU2	CPU3

D0	*		*		SMT
		*		*

D2	*	*	*	*	DIE


This gives us (from __sdt_alloc):

	020	0e0	120	160	SMT
	1a0	1e0	220	260	MC
	2a0	2e0	320	360	DIE

Given that you have a DIE domain, and MC is found degenerate, I'll
conclude that you do not have the shared L3 possible for your machine
and only have the dual socket, with 2 threads per socket.

So the domains _should_ look like:

D0	0,2	1,3	0,2	1,3
D1	0,2	1,3	0,2	1,3
D2	0,1,2,3 0,1,2,3	0,1,2,3	0,1,2,3

Assuming that, build_sched_groups(), which gets called for each cpu, for
each domain, we get:

D0g	020(0)		120(2)
D1g	1a0(0,2)
D2g	2a0(0,2)

So far so good, at this point we're in build_sched_groups, we have a
=2Ecpu=3D0 @span=3D0-3 @covered=3D0,2 @i=3D0 and we're just about to start =
the
loop for @i=3D1.

	1 is not set in covered

	get_group(i=3D1, sdd, &sg)
	  @sd =3D *per_cpu_ptr(sdd->sd, 1); /* should be D2 for CPU1 */
	  @child =3D sd->child; /* should be D1 for CPU1: 1,3 */
	  @cpu =3D 1
	  @sg =3D *per_cpu_ptr(sdd->sg, 1); /* should be: 2e0 */

But instead we get 320 !?

The 2e0 group would cover 1,3, thereby increasing @cover to 0-3 and
we're done for CPU0. Instead things go on to return 360, more WTF!

So it looks like the actual domain tree is broken, and not what we
assumed it was.

Could I bother you to run with the below instead? It should also print
out the sched domain masks so we don't need to guess about them.

(make sure you have CONFIG_SCHED_DEBUG=3Dy otherwise it will not build)

> I also booted with early printk=3Dkeepsched_debug as requested by Dietmar.

can you make that: sched_debug ?

---
 kernel/sched/core.c | 22 ++++++++++++++++++++++
 lib/vsprintf.c      |  5 +++++
 2 files changed, 27 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7bc599dc4aa4..4babcbbc11b6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5857,6 +5857,17 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
=20
 		group =3D get_group(i, sdd, &sg);
+
+		if (!cpumask_empty(sched_group_cpus(sg)))
+			printk("%s: FAIL\n", __func__);
+
+		printk("%s: got group %p with cpus: %pc\n",
+				__func__,
+				sg,
+				sched_group_cpus(sg));
+
+		cpumask_clear(sched_group_cpus(sg));
+
 		cpumask_setall(sched_group_mask(sg));
=20
 		for_each_cpu(j, span) {
@@ -6418,6 +6429,11 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			if (!sg)
 				return -ENOMEM;
=20
+			printk("%s: allocated %p with cpus: %pc\n",
+					__func__,
+					sg,
+					sched_group_cpus(sg));
+
 			sg->next =3D sg;
=20
 			*per_cpu_ptr(sdd->sg, j) =3D sg;
@@ -6474,6 +6490,12 @@ struct sched_domain *build_sched_domain(struct sched=
_domain_topology_level *tl,
 	if (!sd)
 		return child;
=20
+	printk("%s: cpu: %d level: %s cpu_map: %pc tl->mask: %pc\n",
+			__func__,
+			cpu, tl->name,
+			cpu_map,
+			tl->mask(cpu));
+
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
 	if (child) {
 		sd->level =3D child->level + 1;
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6fe2c84eb055..ac22c46fd6d0 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -28,6 +28,7 @@
 #include <linux/ioport.h>
 #include <linux/dcache.h>
 #include <linux/cred.h>
+#include <linux/cpumask.h>
 #include <net/addrconf.h>
=20
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1250,6 +1251,7 @@ int kptr_restrict __read_mostly;
  *           (default assumed to be phys_addr_t, passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
+ * - 'c' For a cpumask list
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1389,6 +1391,8 @@ char *pointer(const char *fmt, char *buf, char *end, =
void *ptr,
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'c':
+		return buf + cpulist_scnprintf(buf, end - buf, ptr);
 	}
 	spec.flags |=3D SMALL;
 	if (spec.field_width =3D=3D -1) {
@@ -1635,6 +1639,7 @@ int format_decode(const char *fmt, struct printf_spec=
 *spec)
  *   case.
  * %*ph[CDN] a variable-length hex string with a separator (supports up to=
 64
  *           bytes of the input)
+ * %pc print a cpumask as comma-separated list
  * %n is ignored
  *
  * ** Please update Documentation/printk-formats.txt when making changes **

--HxOxd3Hfl5FMJYiY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTyPQBAAoJEHZH4aRLwOS69ZkP/2/bRHHfYEf600J+lJp/GKQs
1hcNZEII6nA5bopLZzii0XQnDBG+cBPZiKP1SeCgW8Jv5dvn+JJTVyxLPWZWdIrC
t8W7k106mVi8h/j+y99mssxpwpgOmj49IrllfQl9jTMr+qPP+OPPTjst6ccfurV3
a1SqGv++/XZs0VHSbL7MaAyUjLmfEsaN7cptXIM9jAOyfOxJsyrF4JKrZKLzNI6Z
NPzXQsFJaqrF1qeMAtkz3DZDrJJCTIiaBs9d39+LNfmbG0BL4j5fHzobvlzGAnL7
6F8pjvLxXYjp4cz5dyM6+tsq3D1uo0ZT3lba0EOHTaSCpeZRAvYWHXr34izp2H+e
pFFOHsIYwdvd90+git8hjV7CPa1HLcmKRkZqYnN60w+4frEDUqijRP0SoStBDBTX
cHg/frJby3xfa4Ub1pd3vtEMVUxCwzKEnnlBk7wkyaC/VFfIev0dr5cx4PfF71UO
he5ziwKlptfAncmVd9o7PMBevKdVo+VYgjeH3jyzg9h46Z9b5xzgjm8mtMyzMOoQ
wquTeGQMoa1URQUgZMq0WrN0Zt+uI6vDfBkCKgla0Ds0n2tgOf1TH190BTC9iemn
JlZyOquZv82+rVFI+vFtNpV3lF5Qt1/Iwj7whvdgam+2P0tpcAPpBHyik+9NQCxr
jx6Km5fFY4sGD4ch5r0e
=SpGI
-----END PGP SIGNATURE-----

--HxOxd3Hfl5FMJYiY--
