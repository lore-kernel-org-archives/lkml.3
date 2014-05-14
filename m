Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaENOAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:00:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:49715 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaENOAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:00:40 -0400
Date: Wed, 14 May 2014 16:00:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140514140034.GM30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o+hUPwk7FawzfnFh"
Content-Disposition: inline
In-Reply-To: <20140509160455.GA4486@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o+hUPwk7FawzfnFh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 12:04:55PM -0400, Tejun Heo wrote:
> Hello, guys.
>=20
> So, after resuming from suspend, I found my build jobs can not migrate
> away from the CPU it started on and thus just making use of single
> core.  It turns out the scheduler failed to build sched domains due to
> order-3 allocation failure.
>=20
>  systemd-sleep: page allocation failure: order:3, mode:0x104010
>  CPU: 0 PID: 11648 Comm: systemd-sleep Not tainted 3.14.2-200.fc20.x86_64=
 #1
>  Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS =
4105 07/01/2013
>   0000000000000000 000000001bc36890 ffff88009c2d5958 ffffffff816eec92
>   0000000000104010 ffff88009c2d59e8 ffffffff8117a32a 0000000000000000
>   ffff88021efe6b00 0000000000000003 0000000000104010 ffff88009c2d59e8
>  Call Trace:
>   [<ffffffff816eec92>] dump_stack+0x45/0x56
>   [<ffffffff8117a32a>] warn_alloc_failed+0xfa/0x170
>   [<ffffffff8117e8f5>] __alloc_pages_nodemask+0x8e5/0xb00
>   [<ffffffff811c0ce3>] alloc_pages_current+0xa3/0x170
>   [<ffffffff811796a4>] __get_free_pages+0x14/0x50
>   [<ffffffff8119823e>] kmalloc_order_trace+0x2e/0xa0
>   [<ffffffff810c033f>] build_sched_domains+0x1ff/0xcc0
>   [<ffffffff810c123e>] partition_sched_domains+0x35e/0x3d0
>   [<ffffffff811168e7>] cpuset_update_active_cpus+0x17/0x40
>   [<ffffffff810c130a>] cpuset_cpu_active+0x5a/0x70
>   [<ffffffff816f9f4c>] notifier_call_chain+0x4c/0x70
>   [<ffffffff810b2a1e>] __raw_notifier_call_chain+0xe/0x10
>   [<ffffffff8108a413>] cpu_notify+0x23/0x50
>   [<ffffffff8108a678>] _cpu_up+0x188/0x1a0
>   [<ffffffff816e1783>] enable_nonboot_cpus+0x93/0xf0
>   [<ffffffff810d9d45>] suspend_devices_and_enter+0x325/0x450
>   [<ffffffff810d9fe8>] pm_suspend+0x178/0x260
>   [<ffffffff810d8e79>] state_store+0x79/0xf0
>   [<ffffffff81355bdf>] kobj_attr_store+0xf/0x20
>   [<ffffffff81262c4d>] sysfs_kf_write+0x3d/0x50
>   [<ffffffff81266b12>] kernfs_fop_write+0xd2/0x140
>   [<ffffffff811e964a>] vfs_write+0xba/0x1e0
>   [<ffffffff811ea0a5>] SyS_write+0x55/0xd0
>   [<ffffffff816ff029>] system_call_fastpath+0x16/0x1b
>=20
> The allocation is from alloc_rootdomain().
>=20
> 	struct root_domain *rd;
>=20
> 	rd =3D kmalloc(sizeof(*rd), GFP_KERNEL);
>=20
> The thing is the system has plenty of reclaimable memory and shouldn't
> have any trouble satisfying one GFP_KERNEL order-3 allocation;
> however, the problem is that this is during resume and the devices
> haven't been woken up yet, so pm_restrict_gfp_mask() punches out
> GFP_IOFS from all allocation masks and the page allocator has just
> __GFP_WAIT to work with and, with enough bad luck, fails expectedly.
>=20
> The problem has always been there but seems to have been exposed by
> the addition of deadline scheduler support, which added cpudl to
> root_domain making it larger by around 20k bytes on my setup, making
> an order-3 allocation necessary during CPU online.
>=20
> It looks like the allocation is for a temp buffer and there are also
> percpu allocations going on.  Maybe just allocate the buffers on boot
> and keep them around?
>=20
> Kudos to Johannes for helping deciphering mm debug messages.

Does something like the below help any? I noticed those things (cpudl
and cpupri) had [NR_CPUS] arrays, which is always 'fun'.

The below is a mostly no thought involved conversion of cpudl which
boots, I'll also do cpupri and then actually stare at the algorithms to
see if I didn't make any obvious fails.

Juri?

---
 kernel/sched/cpudeadline.c | 29 +++++++++++++++++++----------
 kernel/sched/cpudeadline.h |  6 +++---
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index ab001b5d5048..c34ab09a790b 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -13,6 +13,7 @@
=20
 #include <linux/gfp.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include "cpudeadline.h"
=20
 static inline int parent(int i)
@@ -37,10 +38,7 @@ static inline int dl_time_before(u64 a, u64 b)
=20
 static void cpudl_exchange(struct cpudl *cp, int a, int b)
 {
-	int cpu_a =3D cp->elements[a].cpu, cpu_b =3D cp->elements[b].cpu;
-
 	swap(cp->elements[a], cp->elements[b]);
-	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
 }
=20
 static void cpudl_heapify(struct cpudl *cp, int idx)
@@ -140,7 +138,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int i=
s_valid)
 	WARN_ON(!cpu_present(cpu));
=20
 	raw_spin_lock_irqsave(&cp->lock, flags);
-	old_idx =3D cp->cpu_to_idx[cpu];
+	old_idx =3D cp->elements[cpu].idx;
 	if (!is_valid) {
 		/* remove item */
 		if (old_idx =3D=3D IDX_INVALID) {
@@ -155,8 +153,8 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int i=
s_valid)
 		cp->elements[old_idx].dl =3D cp->elements[cp->size - 1].dl;
 		cp->elements[old_idx].cpu =3D new_cpu;
 		cp->size--;
-		cp->cpu_to_idx[new_cpu] =3D old_idx;
-		cp->cpu_to_idx[cpu] =3D IDX_INVALID;
+		cp->elements[new_cpu].idx =3D old_idx;
+		cp->elements[cpu].idx =3D IDX_INVALID;
 		while (old_idx > 0 && dl_time_before(
 				cp->elements[parent(old_idx)].dl,
 				cp->elements[old_idx].dl)) {
@@ -173,7 +171,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int i=
s_valid)
 		cp->size++;
 		cp->elements[cp->size - 1].dl =3D 0;
 		cp->elements[cp->size - 1].cpu =3D cpu;
-		cp->cpu_to_idx[cpu] =3D cp->size - 1;
+		cp->elements[cpu].idx =3D cp->size - 1;
 		cpudl_change_key(cp, cp->size - 1, dl);
 		cpumask_clear_cpu(cpu, cp->free_cpus);
 	} else {
@@ -195,10 +193,21 @@ int cpudl_init(struct cpudl *cp)
 	memset(cp, 0, sizeof(*cp));
 	raw_spin_lock_init(&cp->lock);
 	cp->size =3D 0;
-	for (i =3D 0; i < NR_CPUS; i++)
-		cp->cpu_to_idx[i] =3D IDX_INVALID;
-	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
+
+	cp->elements =3D kcalloc(num_possible_cpus(),
+			       sizeof(struct cpudl_item),
+			       GFP_KERNEL);
+	if (!cp->elements)
+		return -ENOMEM;
+
+	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
+		kfree(cp->elements);
 		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(i)
+		cp->elements[i].idx =3D IDX_INVALID;
+
 	cpumask_setall(cp->free_cpus);
=20
 	return 0;
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index a202789a412c..538c9796ad4a 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -5,17 +5,17 @@
=20
 #define IDX_INVALID     -1
=20
-struct array_item {
+struct cpudl_item {
 	u64 dl;
 	int cpu;
+	int idx;
 };
=20
 struct cpudl {
 	raw_spinlock_t lock;
 	int size;
-	int cpu_to_idx[NR_CPUS];
-	struct array_item elements[NR_CPUS];
 	cpumask_var_t free_cpus;
+	struct cpudl_item *elements;
 };
=20
=20

--o+hUPwk7FawzfnFh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc3cCAAoJEHZH4aRLwOS65dIP+wf6t//e9s7ecOeIhmtFdwy3
dsumUO5BMUd+FSXq8bvH4paSEsKKHssCy8CtXtlq920gFRVljeK2Hq9yYW1wqJYV
XUiheSGRp1pwPdF1nOJbbrH+DaPNGhXRDIc7nCgQayCy8sGQcIuF5Dw34MK5WyaW
oQXZXGeC9mD04yYpICuTfwC9Vd7z66t6oosFWOR2yiA1Vl4jV2/W/uztvSt0ndTR
IWbUZVaLx9j0I+p8vscCwNrns7yZGLDMlXFsAWdbi4gRz7LwnPzXLTcCR+jSc5mN
KuPPnbGFkx/humNhrpfPMJEpNPY/ycIBS06V9reOcL/giXDnOpTfd77ayCsI3iHg
Nn4lmBI85SDo7Ra5mZ+sgUKyCyjvgqqsfTeZdsExS4ScstQb2FOme1ZAsXkJKF+k
6jLK5RTABLgactEYPMFnCw7flTqjY/Cq5fw5if7RWWrd/Qq47Xy0B4cr7nO91Qhf
hyf1uxPtuk6V1gRFVfKytOGYN1q+Bn+1/ccflmbeeoKtPvJ/+48dnRKQUca5oS4T
xZCs8DkpcKJrzvmZo/2+Dpfh0Q2ID9Eq4LgrebKvlTHSBGPFuCdCimAl7WyVm9wj
zeUhUNkfiErajzkx+Gt9DTVgLpgVPNga6AU1uZ0fhDNeyfxYcOkEBxyyVr1/d0cA
sUsQNWQYe6DlCkOqp1+G
=JpnV
-----END PGP SIGNATURE-----

--o+hUPwk7FawzfnFh--
