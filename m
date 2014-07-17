Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaGQMfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:35:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:39948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaGQMfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:35:32 -0400
Date: Thu, 17 Jul 2014 14:35:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Bruno Wolff III <bruno@wolff.to>, Josh Boyer <jwboyer@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140717123502.GL19379@twins.programming.kicks-ass.net>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
 <20140717030947.GA17889@wolff.to>
 <53C79013.1020808@arm.com>
 <20140717090452.GH19379@twins.programming.kicks-ass.net>
 <53C7B247.2070309@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aUGckSYYync4w83/"
Content-Disposition: inline
In-Reply-To: <53C7B247.2070309@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aUGckSYYync4w83/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 01:23:51PM +0200, Dietmar Eggemann wrote:
> On 17/07/14 11:04, Peter Zijlstra wrote:
> >On Thu, Jul 17, 2014 at 10:57:55AM +0200, Dietmar Eggemann wrote:
> >>There is also the possibility that the memory for sched_group sg is not
> >>(completely) zeroed out:
> >>
> >>   sg =3D kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
> >>			GFP_KERNEL, cpu_to_node(j));
> >>
> >>
> >>   struct sched_group {
> >>	...
> >>	 * NOTE: this field is variable length. (Allocated dynamically
> >>	 * by attaching extra space to the end of the structure,
> >>	 * depending on how many CPUs the kernel has booted up with)
> >>	 */
> >>	unsigned long cpumask[0];
> >
> >well kZalloc should Zero the entire allocated size, and the specified
> >size very much includes the cpumask size as per:
> >   sizeof(struct sched_group) + cpumask_size()
>=20
> Yes, I think so too.
>=20
> >
> >But yeah, I'm also a bit puzzled why this goes bang. Makes we worry we
> >scribble it somewhere or so.
> >
>=20
> But then, this must be happening in build_sched_domains() between
> __visit_domain_allocation_hell()->__sdt_alloc() and build_sched_groups().
>=20
>=20
> Couldn't catch this phenomena by adding a fake SMT level (just a copy of =
the
> real MC level) to my ARM TC2 (dual cluster dual/triple core, no
> hyper-threading) to provoke sd degenerate. It does not show the issue and=
 MC
> level gets degenerated nicely. Might not be the real example since SMT and
> MC are using the same cpu mask here).

Yeah, obviously my machines didn't trigger this either, and afaik none
of Ingo's did either.

In any case, can someone who can trigger this run with the below; its
'clean' for me, but supposedly you'll trigger a FAIL somewhere.

It includes the cpumask_clear() so your machines should boot, albeit
with a noisy dmesg :-)

---
 kernel/sched/core.c | 16 ++++++++++++++++
 lib/vsprintf.c      |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7bc599dc4aa4..1c140057db12 100644
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

--aUGckSYYync4w83/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTx8L2AAoJEHZH4aRLwOS6xTAQAK5SInguWO3SFFd7DMDYACMu
fBlm738CXThqxrq1qoFJt8SacX4H/rZttYBWj0F4Wcgrno3GB4+3/ycpUMZwK2dD
lLH5R+GQa5yHNsfYF8jymBNKs2/JNcmllKnd7fsKFUtZTb0o9wwBjWh/4BIsj1Px
iyxxDp42dWI8XKIC9s28BcnYP5sYeDOa7XdjTPwLgrVGpzvc06rNKZHK9WF11qRX
T7lY7zi1cLx9woxSMAtb4RAVHlgxIJM9FdejItY1SPwatsrMjaCB8GVzZneqoq6J
ojOC4MdSqJZR+P1Ir5PByPKSfYBJ49smICH+SnFYib4vOV84eCBK4/LqI158g7j9
dpcJX/iRuJ5ncwRxZeCIdpCbVF3ZWZpz91wa+US8Dom1hTa+B8HnV/dXfmcq6QkY
iCDd6YtsSmcuo1Zu4LGed8vxIGt3h1q+/WNueqMozzUy7/tOqumFV3JD+AFbbesm
KGivrfHw4vWAiyI9PNkQ6FoN1w5QSSgORNnt4oTgNelT+gdGliaB6BXHp4aP1Bh3
5WEh6XoFarTwLzINWeB/RLUHU9oK7nyR6evzTd5t84Phz6a6UJeGALfhTA/vgNWe
6EjHx7vB9KjrdAWl/kEdGHkTnJJkuHW3je9cv9GLGZMbyWcnlwoOchESbtVRuCWw
QT2qS5cQ74Q2ewLX7FBX
=5o8K
-----END PGP SIGNATURE-----

--aUGckSYYync4w83/--
