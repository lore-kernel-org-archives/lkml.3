Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaEJNim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 09:38:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:53070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaEJNij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 09:38:39 -0400
Date: Sat, 10 May 2014 15:38:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 06/19] qspinlock: prolong the stay in the pending bit
 path
Message-ID: <20140510133829.GD30445@twins.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-7-git-send-email-Waiman.Long@hp.com>
 <20140508185854.GN2844@laptop.programming.kicks-ass.net>
 <536D79C7.2000701@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EIrXVFSPgsocVIgL"
Content-Disposition: inline
In-Reply-To: <536D79C7.2000701@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EIrXVFSPgsocVIgL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 08:58:47PM -0400, Waiman Long wrote:
> On 05/08/2014 02:58 PM, Peter Zijlstra wrote:
> >On Wed, May 07, 2014 at 11:01:34AM -0400, Waiman Long wrote:
> >>@@ -221,11 +222,37 @@ static inline int trylock_pending(struct qspinloc=
k *lock, u32 *pval)
> >>  	 */
> >>  	for (;;) {
> >>  		/*
> >>-		 * If we observe any contention; queue.
> >>+		 * If we observe that the queue is not empty,
> >>+		 * return and be queued.
> >>  		 */
> >>-		if (val&  ~_Q_LOCKED_MASK)
> >>+		if (val&  _Q_TAIL_MASK)
> >>  			return 0;
> >>
> >>+		if (val =3D=3D (_Q_LOCKED_VAL|_Q_PENDING_VAL)) {
> >>+			/*
> >>+			 * If both the lock and pending bits are set, we wait
> >>+			 * a while to see if that either bit will be cleared.
> >>+			 * If that is no change, we return and be queued.
> >>+			 */
> >>+			if (!retry)
> >>+				return 0;
> >>+			retry--;
> >>+			cpu_relax();
> >>+			cpu_relax();
> >>+			*pval =3D val =3D atomic_read(&lock->val);
> >>+			continue;
> >>+		} else if (val =3D=3D _Q_PENDING_VAL) {
> >>+			/*
> >>+			 * Pending bit is set, but not the lock bit.
> >>+			 * Assuming that the pending bit holder is going to
> >>+			 * set the lock bit and clear the pending bit soon,
> >>+			 * it is better to wait than to exit at this point.
> >>+			 */
> >>+			cpu_relax();
> >>+			*pval =3D val =3D atomic_read(&lock->val);
> >>+			continue;
> >>+		}
> >Didn't I give a much saner alternative to this mess last time?
>=20
> I don't recall you have any suggestion last time. Anyway, if you think the
> code is too messy, I think I can give up the first if statement which is
> more an optimistic spinning kind of code for short critical section. The =
2nd
> if statement is still need to improve chance of using this code path due =
to
> timing reason. I will rerun my performance test to make sure it won't have
> too much performance impact.

lkml.kernel.org/r/20140417163640.GT11096@twins.programming.kicks-ass.net

--EIrXVFSPgsocVIgL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbivVAAoJEHZH4aRLwOS6GCUP/0mR3CvV3nBeKaGb2km8GwV2
wQRx1OVYmoC4+8ikFGSXUbm3++1JLokQfTKPB5fMrIqP8kKnEdMSMmjE9cq3E/ZZ
UTcp75PI0x3b/ABfQx9nXrmAOeGiXvX5DULDpg7t2JJMsQXiMKI9nk6FTLioh6eZ
Vngn1rst/uJ5O99IaiDo2AMLtG80cc5NFkfkKFIw624ANPupkC/pVNqP+JKv8AuS
ppiNp6yzKwTh/7y1+okBvRszTRzrWVVEjBWK1M5OwfYsAuvkBfA7oKNKpEmgBs3+
KC+fzmihlkC/feN5Fx9X+Gb9VohMlRaf6rd9IaLX7NQ0hkR2yTn/dJGFsJ3mKunR
FYw+YAYqfr05T+aJQ6zq7CbQDzaSE5Gqqb2d4ur/b1o9IFREH44WZ6z/HvYMlwnx
77JCkTcM2jADakiz0GLG62uNAE+ulfKz4JdQYbWyDjLWiEMUh/8+pO0Efji1OIEA
lhkc7eTTochtORbLOSYh1AzVuqPGxTWfxdIekmrYeg5qQq/ZiI2O44ys0ohqZUAt
oJLr91TMJgHPQXtigftADjCHI7piysa1PG7+FwzoZQ3HC2DbTj6oUV8ZmW/sH0nw
Gxb77wGgz1MvXrBuIO7fXbjkGuvBTdTojkoHsuTsiNzAgdIYjxJKOfowyVZiMq6A
VGFdDNWijZSRTUXwPzWK
=p8dI
-----END PGP SIGNATURE-----

--EIrXVFSPgsocVIgL--
