Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3A1M3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:29:48 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51445 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab3A1M33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:29:29 -0500
Date: Mon, 28 Jan 2013 23:29:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, Wang YanQing <udknight@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20130128232917.f8e35b592e7f8282227980f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Jan_2013_23_29_17_+1100_8raVfKai4jd=FlxU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jan_2013_23_29_17_+1100_8raVfKai4jd=FlxU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in kernel/smp.c be=
tween commit c7b798525b50 ("smp: Fix SMP function call empty cpu mask race"=
) from the tip tree and commit "smp: make smp_call_function_many() use logi=
c similar to smp_call_function_single()" from the akpm tree.

I fixed it up (maybe - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/smp.c
index 93e576e,51a81b0..0000000
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@@ -30,10 -21,8 +21,9 @@@ enum=20
  };
 =20
  struct call_function_data {
- 	struct call_single_data	csd;
- 	atomic_t		refs;
+ 	struct call_single_data	__percpu *csd;
  	cpumask_var_t		cpumask;
 +	cpumask_var_t		cpumask_ipi;
  };
 =20
  static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@@ -482,85 -397,39 +398,45 @@@ void smp_call_function_many(const struc
  	}
 =20
  	data =3D &__get_cpu_var(cfd_data);
- 	csd_lock(&data->csd);
-=20
- 	/* This BUG_ON verifies our reuse assertions and can be removed */
- 	BUG_ON(atomic_read(&data->refs) || !cpumask_empty(data->cpumask));
-=20
- 	/*
- 	 * The global call function queue list add and delete are protected
- 	 * by a lock, but the list is traversed without any lock, relying
- 	 * on the rcu list add and delete to allow safe concurrent traversal.
- 	 * We reuse the call function data without waiting for any grace
- 	 * period after some other cpu removes it from the global queue.
- 	 * This means a cpu might find our data block as it is being
- 	 * filled out.
- 	 *
- 	 * We hold off the interrupt handler on the other cpu by
- 	 * ordering our writes to the cpu mask vs our setting of the
- 	 * refs counter.  We assert only the cpu owning the data block
- 	 * will set a bit in cpumask, and each bit will only be cleared
- 	 * by the subject cpu.  Each cpu must first find its bit is
- 	 * set and then check that refs is set indicating the element is
- 	 * ready to be processed, otherwise it must skip the entry.
- 	 *
- 	 * On the previous iteration refs was set to 0 by another cpu.
- 	 * To avoid the use of transitivity, set the counter to 0 here
- 	 * so the wmb will pair with the rmb in the interrupt handler.
- 	 */
- 	atomic_set(&data->refs, 0);	/* convert 3rd to 1st party write */
 =20
- 	data->csd.func =3D func;
- 	data->csd.info =3D info;
-=20
- 	/* Ensure 0 refs is visible before mask.  Also orders func and info */
- 	smp_wmb();
-=20
- 	/* We rely on the "and" being processed before the store */
  	cpumask_and(data->cpumask, mask, cpu_online_mask);
  	cpumask_clear_cpu(this_cpu, data->cpumask);
- 	refs =3D cpumask_weight(data->cpumask);
 =20
  	/* Some callers race with other cpus changing the passed mask */
- 	if (unlikely(!refs)) {
- 		csd_unlock(&data->csd);
+ 	if (unlikely(!cpumask_weight(data->cpumask)))
  		return;
- 	}
 =20
 +	/*
 +	 * After we put an entry into the list, data->cpumask
 +	 * may be cleared again when another CPU sends another IPI for
 +	 * a SMP function call, so data->cpumask will be zero.
 +	 */
 +	cpumask_copy(data->cpumask_ipi, data->cpumask);
- 	raw_spin_lock_irqsave(&call_function.lock, flags);
- 	/*
- 	 * Place entry at the _HEAD_ of the list, so that any cpu still
- 	 * observing the entry in generic_smp_call_function_interrupt()
- 	 * will not miss any other list entries:
- 	 */
- 	list_add_rcu(&data->csd.list, &call_function.queue);
- 	/*
- 	 * We rely on the wmb() in list_add_rcu to complete our writes
- 	 * to the cpumask before this write to refs, which indicates
- 	 * data is on the list and is ready to be processed.
- 	 */
- 	atomic_set(&data->refs, refs);
- 	raw_spin_unlock_irqrestore(&call_function.lock, flags);
-=20
- 	/*
- 	 * Make the list addition visible before sending the ipi.
- 	 * (IPIs must obey or appear to obey normal Linux cache
- 	 * coherency rules -- see comment in generic_exec_single).
- 	 */
- 	smp_mb();
+ 	for_each_cpu(cpu, data->cpumask) {
+ 		struct call_single_data *csd =3D per_cpu_ptr(data->csd, cpu);
+ 		struct call_single_queue *dst =3D
+ 					&per_cpu(call_single_queue, cpu);
+ 		unsigned long flags;
+=20
+ 		csd_lock(csd);
+ 		csd->func =3D func;
+ 		csd->info =3D info;
+=20
+ 		raw_spin_lock_irqsave(&dst->lock, flags);
+ 		list_add_tail(&csd->list, &dst->list);
+ 		raw_spin_unlock_irqrestore(&dst->lock, flags);
+ 	}
 =20
  	/* Send a message to all CPUs in the map */
 -	arch_send_call_function_ipi_mask(data->cpumask);
 +	arch_send_call_function_ipi_mask(data->cpumask_ipi);
 =20
- 	/* Optionally wait for the CPUs to complete */
- 	if (wait)
- 		csd_lock_wait(&data->csd);
+ 	if (wait) {
+ 		for_each_cpu(cpu, data->cpumask) {
+ 			struct call_single_data *csd =3D
+ 					per_cpu_ptr(data->csd, cpu);
+ 			csd_lock_wait(csd);
+ 		}
+ 	}
  }
  EXPORT_SYMBOL(smp_call_function_many);
 =20

--Signature=_Mon__28_Jan_2013_23_29_17_+1100_8raVfKai4jd=FlxU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBm8dAAoJEECxmPOUX5FExCIQAKAl66R7GvprtFWE2fLEzd8b
YJH+dymDQykyBaoBee8IkcXnA24i4S5vdSwhnkNJ7ishtONJKs04Bfl4Jq/n5PAm
scnI1PN7hJmpTEDijCBmCTWO35FO6XrdUQu+NwfX1uFPyNn4DuiUn2CwvI8tctS7
lDl4sQyIz+rm/E8URJYYAQu8wKJiSYtylxmqnU/2fHlBpN/lbM7PkQytSFR4XsPi
G5jY3l/gAU2fahpuwbRyaJNj8D4dDyO6i/Wy2Cgd3qpYgP6P+0Bv++YVxhVLMu5K
qc2E+alDis+ineqk2vwq8a9aIa0DT5966l3muf/9Bt1Sozz6qWNHpyJXKy1bu275
9jeAzRXw8ZIajPYupbCynuNyX/FgRY23ZmbAOgqzlYkkB7ACYsIYNZEwbf8GJFht
FTebr6UcT2bwCqfNo6oEWPpgzQs6Uco8XvJgiuxCxAb+65nwqbnTTVD+TDHLAdmD
tMHzGDssfdifRy5Gepo5IYaimZLSLOgwCgFqbjlUF4nfqc2NcNih5RrgdmfE6JDA
xE/HcbtuGDacB3jI8r+1xh4YzO+iUqA3VvR0KBv7mxyqumxChbAWT3uyVJKZdiCM
lR1PzTP1VBCUxsbfbtSGj+nyK/N5d3OOWSwwx3LW5B75G+WoeqrbhLNc2PaeLqab
+xFtaJWp5uGfKmknUqg9
=p0Nr
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jan_2013_23_29_17_+1100_8raVfKai4jd=FlxU--
