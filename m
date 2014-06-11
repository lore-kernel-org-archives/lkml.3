Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaFKK0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:26:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:53902 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaFKK0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:26:16 -0400
Date: Wed, 11 Jun 2014 12:26:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
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
Subject: Re: [PATCH v11 06/16] qspinlock: prolong the stay in the pending bit
 path
Message-ID: <20140611102606.GK3213@twins.programming.kicks-ass.net>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
 <1401464642-33890-7-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IB2Qao3B4XdnqHmg"
Content-Disposition: inline
In-Reply-To: <1401464642-33890-7-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IB2Qao3B4XdnqHmg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 11:43:52AM -0400, Waiman Long wrote:
> ---
>  kernel/locking/qspinlock.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index fc7fd8c..7f10758 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -233,11 +233,25 @@ void queue_spin_lock_slowpath(struct qspinlock *loc=
k, u32 val)
>  	 */
>  	for (;;) {
>  		/*
> -		 * If we observe any contention; queue.
> +		 * If we observe that the queue is not empty or both
> +		 * the pending and lock bits are set, queue
>  		 */
> -		if (val & ~_Q_LOCKED_MASK)
> +		if ((val & _Q_TAIL_MASK) ||
> +		    (val =3D=3D (_Q_LOCKED_VAL|_Q_PENDING_VAL)))
>  			goto queue;
> =20
> +		if (val =3D=3D _Q_PENDING_VAL) {
> +			/*
> +			 * Pending bit is set, but not the lock bit.
> +			 * Assuming that the pending bit holder is going to
> +			 * set the lock bit and clear the pending bit soon,
> +			 * it is better to wait than to exit at this point.
> +			 */
> +			cpu_relax();
> +			val =3D atomic_read(&lock->val);
> +			continue;
> +		}
> +
>  		new =3D _Q_LOCKED_VAL;
>  		if (val =3D=3D new)
>  			new |=3D _Q_PENDING_VAL;


So, again, you just posted a new version without replying to the
previous discussion; so let me try again, what's wrong with the proposal
here:

  lkml.kernel.org/r/20140417163640.GT11096@twins.programming.kicks-ass.net



--IB2Qao3B4XdnqHmg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmC69AAoJEHZH4aRLwOS6bBUP/1db3Nz0FLv1UoCAI1jBUNnx
Dw3uq3On9bx5aa6qOMaLmJynH9gU0jALn9PvOXtFTs+EgzdAxLtVaCFAZvH8vx2+
Ic8q+t+NPgBdNNHUmF7dfInDUSovrvy7CEeuIIGfBWRnecnMepcSsguwtaf/OwO+
ifDuDOXXN/gr0BwXbGd4rlnZkWz9XI0ztQa+eRrdxjL+H2J3nUjxBW5PuceQIxBQ
48yHUOHsreEN99jvZuWtT/36wK5PQ+vohlQUCT4ci7pjNmmGqKevqEn8kF0fVAjA
x3PEvbh6rk/pnkX7A/dAeIfoe+FEXKBkceyXlq6th2dPAHS7iYYEQ+ZG5INYF56U
8RenG1D7/pv+oXdq1O+jbHfefcwoIfkCbpqFNf9zAzCYlsj58kdyOSu5m8lZ8jYk
Mp2+hcveYKLQ+7BSeEY5XWMLzbR89TRCd2Ub94LPbRWzkXOtjgVSEdT5iNTr6qGh
kSgN0S8EmPQGCPYc56Akw/RFp3W2N3NA3YtoYauRbcv6Pf+Ejzgt0Vf7ptDxwaCS
eb3uXS/xC1fwF1Z5e+vDA1wZMlIDWOUCLKEyBjF57U0fdKH+eu6cO/SIgh2jiddw
7CP5NdBiEWA12Rl86aLNwY3B8HScCoPLorecMj1k5EipJrZi2ASsDMhnIXfMB8um
ykQUSeNaoC6wfNSOydk4
=5Cal
-----END PGP SIGNATURE-----

--IB2Qao3B4XdnqHmg--
