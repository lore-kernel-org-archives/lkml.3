Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaGGPUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:20:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaGGPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:20:43 -0400
Date: Mon, 7 Jul 2014 17:20:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: tglx@linutronix.de, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
Message-ID: <20140707152023.GU6758@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130154.213923590@chello.nl>
 <539F6AD5.4070301@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wCvMePosDEf3szVw"
Content-Disposition: inline
In-Reply-To: <539F6AD5.4070301@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wCvMePosDEf3szVw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 06:08:21PM -0400, Waiman Long wrote:
> On 06/15/2014 08:47 AM, Peter Zijlstra wrote:
> >+struct pv_node {
> >+	struct mcs_spinlock	mcs;
> >+	struct mcs_spinlock	__offset[3];
> >+	int cpu, head;
> >+};
>=20
> I am wondering why you need the separate cpu and head variables. I thought
> one will be enough here. The wait code put the cpu number in head, the the
> kick_cpu code kick the one in cpu which is just the cpu # of the tail.

The @cpu is the current cpu, the @head is the encoded pointer to the
queue head, they aren't necessarily the same.

The @head thing is not unlike your next pointer, just backwards.

> >+#define INVALID_HEAD	-1
> >+#define NO_HEAD		nr_cpu_ids
> >+
>=20
> I think it is better to use a constant like -2 for NO_HEAD instead of an
> external variable.

Sure..

> >+void __pv_init_node(struct mcs_spinlock *node)
> >+{
> >+	struct pv_node *pn =3D (struct pv_node *)node;
> >+
> >+	BUILD_BUG_ON(sizeof(struct pv_node)>  5*sizeof(struct mcs_spinlock));
> >+
> >+	pn->cpu =3D smp_processor_id();
> >+	pn->head =3D INVALID_HEAD;
> >+}
> >+
> >+static inline struct pv_node *pv_decode_tail(u32 tail)
> >+{
> >+	return (struct pv_node *)decode_tail(tail);
> >+}
> >+
> >+void __pv_link_and_wait_node(u32 old, struct mcs_spinlock *node)
> >+{
> >+	struct pv_node *ppn, *pn =3D (struct pv_node *)node;
> >+	unsigned int count;
> >+
> >+	if (!(old&  _Q_TAIL_MASK)) {
> >+		pn->head =3D NO_HEAD;
> >+		return;
> >+	}
> >+
> >+	ppn =3D pv_decode_tail(old);
> >+	ACCESS_ONCE(ppn->mcs.next) =3D node;
> >+
> >+	while (ppn->head =3D=3D INVALID_HEAD)
> >+		cpu_relax();
> >+
> >+	pn->head =3D ppn->head;
>=20
> A race can happen here as pn->head can be changed to the head cpu by the
> head waiter while being changed by this function at the same time. It is
> safer to use cmpxchg to make sure that there is no accidental overwriting=
 of
> the head CPU number.

Ok, so I'm not entirely sure I see the race, although its entirely
possible, this is far too fragile. But I couldn't get rid of the race
with cmpxchg/xchg either.

So the idea is 'simple'; have link_and_wait propagate the 'head'
'pointer' from the old to the new tail, and have wait_head set the
'head' pointer on the current tail every time the top waiter goes to
sleep.

There's the obvious race where both happen at the same time and you're
not sure which 'head' 'pointer' won. To solve that what I did was:

init:
  INVALID_HEAD

link_and_wait:
  INVALID_HEAD -> pprev->head , NO_HEAD

wait_head:
  !INVALID_HEAD -> new head

This way wait_head must wait for link_and_wait to finish before writing
the new head value. Furthermore, if we race such that we obtained the
'old' tail and link_and_wait propagated the 'old' head to the 'new'
tail, wait_head will detect this by verifying the tail pointer after
writing the new head.

We don't need atomics here afaict, but we have wait loops, which of
course suck arse for virt :/

I'm not too fond of this scheme; but I thought I'd try and get rid of
that O(n) loop you had for finding the head, we simply cannot assume
'small' number of vcpus.

> >+void __pv_queue_unlock(struct qspinlock *lock)
> >+{
> >+	int val =3D atomic_read(&lock->val);
> >+
> >+	native_queue_unlock(lock);
> >+
> >+	if (val&  _Q_LOCKED_SLOW)
> >+		___pv_kick_head(lock);
> >+}
> >+
>=20
> Again a race can happen here between the reading and writing of the lock
> value. I can't think of a good way to do that without using cmpxchg.

Indeed so, xchg it is I suppose :/

> >@@ -358,6 +533,7 @@ void queue_spin_lock_slowpath(struct qsp
> >  	 *
> >  	 * *,x,y ->  *,0,0
> >  	 */
> >+	pv_wait_head(lock);
> >  	while ((val =3D smp_load_acquire(&lock->val.counter))&
> >  			_Q_LOCKED_PENDING_MASK)
> >  		cpu_relax();
> >@@ -391,6 +567,7 @@ void queue_spin_lock_slowpath(struct qsp
> >  		cpu_relax();
> >
> >  	arch_mcs_spin_unlock_contended(&next->locked);
> >+	pv_kick_node(next);
>=20
> pv_kick_node is an expensive operation and it can significantly slow down
> the locking operation if we have to do it for every subsequent task in the
> queue.

You might by now have noticed that I don't particularly care too much
about (para)virt performance :-) Also, I'm very much trying to get
'simple' things working before making them more complex.

--wCvMePosDEf3szVw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTurq3AAoJEHZH4aRLwOS6dpQQALKav7HS2BltBbnYqYk13J3l
SoNREXkVA3tBHOrjoJZs5trWHnWEfaJHigmu+T6CtE+PD8p2zdXNMDDjMqJLUpua
mLIpj41KTX/kWEdjamCgEmRNkuanXO0zu4F/1QDtSNh4HM4f5MeQXg4z59IedL8n
ElhK0A2m1n1C/dPB3Rq8ZnmYqLVMe0Avz5lsfbCIwBAPtgvQ2Akr8Z6wuBDKQ0A4
2Z1Tl5iIHmYIMqccsXqh6G2eik63ckNywT5AB526Uuid5G/6WC/2nLGR4h3UEO8i
HNO9Q4Cy5rie2FzLjyWouANz+3qjn9oKfbUOGIwtZVsKzO4aLESxbly4N5TCQYUN
vWnoLZwz4lizfXfEimMtJ1hLnf4vlwfzjp7+XAVeji6LU5ayG1V6KOO03rTFIWMu
+ppNj10IHNFt12ODCPhYIFm0dKBZ7HsWadVNU37ST5ZmK//jP/WwqDnYQm89B0j8
ZNi1pwy7HtRLSMX2aEWLA7a08MKAjlKL4suvXCRT5EnsKwHIo7MxRU56/XrawTnX
MV4bGN9lm101Ar8RQWlL/AZIPsz7uom/pkwmANqS1KQRyOpMuiDA524k2L34k+fd
GZGmmmE+qkikkkcUyyfGeHcHVVD0BXeP+aHycA0wNMteUF1TLhz/z6HN7Zl7n0E1
ivPuHfgUPD5Q8nTCTwPr
=+uHb
-----END PGP SIGNATURE-----

--wCvMePosDEf3szVw--
