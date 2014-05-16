Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbaEPKno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:43:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:38210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbaEPKnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:43:43 -0400
Date: Fri, 16 May 2014 12:43:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140516104336.GR13658@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
 <20140515104055.e91844a5b75529edc560349a@gmail.com>
 <20140515085156.GG30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRo3kt64Wi40AlcO"
Content-Disposition: inline
In-Reply-To: <20140515085156.GG30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRo3kt64Wi40AlcO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


OK I made that..

---

Subject: sched/cpudl: Replace NR_CPUS arrays
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Wed May 14 16:13:56 CEST 2014

Tejun reported that his resume was failing due to order-3 allocations
=66rom sched_domain building.

Replace the NR_CPUS arrays in there with a dynamically allocated
array.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/cpudeadline.c |   33 ++++++++++++++++++++++++---------
 kernel/sched/cpudeadline.h |    6 +++---
 2 files changed, 27 insertions(+), 12 deletions(-)

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
@@ -39,8 +40,10 @@ static void cpudl_exchange(struct cpudl
 {
 	int cpu_a =3D cp->elements[a].cpu, cpu_b =3D cp->elements[b].cpu;
=20
-	swap(cp->elements[a], cp->elements[b]);
-	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
+	swap(cp->elements[a].cpu, cp->elements[b].cpu);
+	swap(cp->elements[a].dl , cp->elements[b].dl );
+
+	swap(cp->elements[cpu_a].idx, cp->elements[cpu_b].idx);
 }
=20
 static void cpudl_heapify(struct cpudl *cp, int idx)
@@ -140,7 +143,7 @@ void cpudl_set(struct cpudl *cp, int cpu
 	WARN_ON(!cpu_present(cpu));
=20
 	raw_spin_lock_irqsave(&cp->lock, flags);
-	old_idx =3D cp->cpu_to_idx[cpu];
+	old_idx =3D cp->elements[cpu].idx;
 	if (!is_valid) {
 		/* remove item */
 		if (old_idx =3D=3D IDX_INVALID) {
@@ -155,8 +158,8 @@ void cpudl_set(struct cpudl *cp, int cpu
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
@@ -173,7 +176,7 @@ void cpudl_set(struct cpudl *cp, int cpu
 		cp->size++;
 		cp->elements[cp->size - 1].dl =3D 0;
 		cp->elements[cp->size - 1].cpu =3D cpu;
-		cp->cpu_to_idx[cpu] =3D cp->size - 1;
+		cp->elements[cpu].idx =3D cp->size - 1;
 		cpudl_change_key(cp, cp->size - 1, dl);
 		cpumask_clear_cpu(cpu, cp->free_cpus);
 	} else {
@@ -195,10 +198,21 @@ int cpudl_init(struct cpudl *cp)
 	memset(cp, 0, sizeof(*cp));
 	raw_spin_lock_init(&cp->lock);
 	cp->size =3D 0;
-	for (i =3D 0; i < NR_CPUS; i++)
-		cp->cpu_to_idx[i] =3D IDX_INVALID;
-	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
+
+	cp->elements =3D kcalloc(nr_cpu_ids,
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
@@ -211,4 +225,5 @@ int cpudl_init(struct cpudl *cp)
 void cpudl_cleanup(struct cpudl *cp)
 {
 	free_cpumask_var(cp->free_cpus);
+	kfree(cp->elements);
 }
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


--QRo3kt64Wi40AlcO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdevYAAoJEHZH4aRLwOS6Jw8P/0S1Yedh7SMr7DlAGMd2WYo0
ZKbbVXHGSpJqJH3tyv9iJXMs1SQR4Ii4WEDPiql8V2GEhJth3VZAXA43xck5QqfZ
2CzbkLbV01I8skCBk9fN/DVttS9Wrtu8LBHST+B2c06sd0cpyDRCFmI7hy01BTco
13SaCmUwrp5WckWpWdU49KhjweSSxMgSXX6v08dd+YCbwmW8EdDCjfIseYS9ZA6C
uhqsEkXrkq3dRvjmAwNkbVmQFSD7Rb7OsaNlRz6fc6v5LILejU92h5aUCt4H+hg/
rnZespmJMmIITx+koT+QYCKF2A7fbmPOvcC/qn3SNTYgkS26wIKny5H9rkfkgCyp
OqF/94WrVxyThzcfLj99nwkjbTiZQYll2VQ/+0UUu5uqvtRdd708+m1TNKA+ZtZJ
09baH6yRBhJuCNzBTmYDe5jLvKWQztg7k1xC2uncWv7fbjvwqdvntDl5Va16k8uw
cpBaryx5X0q8kRPg7Wf2c8uopM08Rb9U1z/FkCv2DdaGYNKd77xT7wSSKaq1WGPH
7cx/x6dRVTVpG0hPKNGskr2pHFQwoh4lINycJuL5TiNmL+8KTRyGgrc/qr5Hl0DD
ziPVs52jbPkqzNW8U6eJPdHA1vmKmzEHn4hyhCszFfmmD+P4vDxnsW94OpnOz5Xd
YHeL1zm5H8gMtBoYGfgd
=YnWc
-----END PGP SIGNATURE-----

--QRo3kt64Wi40AlcO--
