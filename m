Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaFLIRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:17:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:58188 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaFLIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:17:38 -0400
Date: Thu, 12 Jun 2014 10:17:31 +0200
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
Subject: Re: [PATCH v11 14/16] pvqspinlock: Add qspinlock para-virtualization
 support
Message-ID: <20140612081731.GM3213@twins.programming.kicks-ass.net>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
 <1401464642-33890-15-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/hP/389S7qb5BOej"
Content-Disposition: inline
In-Reply-To: <1401464642-33890-15-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/hP/389S7qb5BOej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 11:44:00AM -0400, Waiman Long wrote:
> @@ -19,13 +19,46 @@ extern struct static_key virt_unfairlocks_enabled;
>   * that the clearing the lock bit is done ASAP without artificial delay
>   * due to compiler optimization.
>   */
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +static __always_inline void __queue_spin_unlock(struct qspinlock *lock)
> +#else
>  static inline void queue_spin_unlock(struct qspinlock *lock)
> +#endif
>  {
>  	barrier();
>  	ACCESS_ONCE(*(u8 *)lock) =3D 0;
>  	barrier();
>  }
> =20
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +/*
> + * The lock byte can have a value of _Q_LOCKED_SLOWPATH to indicate
> + * that it needs to go through the slowpath to do the unlocking.
> + */
> +#define _Q_LOCKED_SLOWPATH	(_Q_LOCKED_VAL | 2)
> +
> +extern void queue_spin_unlock_slowpath(struct qspinlock *lock);
> +
> +static inline void queue_spin_unlock(struct qspinlock *lock)
> +{
> +	barrier();
> +	if (static_key_false(&paravirt_spinlocks_enabled)) {
> +		/*
> +		 * Need to atomically clear the lock byte to avoid racing with
> +		 * queue head waiter trying to set _QLOCK_LOCKED_SLOWPATH.
> +		 */
> +		if (likely(cmpxchg((u8 *)lock, _Q_LOCKED_VAL, 0)
> +				=3D=3D _Q_LOCKED_VAL))
> +			return;
> +		else
> +			queue_spin_unlock_slowpath(lock);
> +
> +	} else {
> +		__queue_spin_unlock(lock);
> +	}
> +	barrier();
> +}
> +#endif /* CONFIG_PARAVIRT_SPINLOCKS */

Ideally we'd make all this use alternatives or so, such that the actual
function remains short enough to actually inline;

static inline void queue_spin_unlock(struct qspinlock *lock)
{
	pv_spinlock_alternative(
		ACCESS_ONCE(*(u8 *)lock) =3D 0,
		pv_queue_spin_unlock(lock));
}

Or however that trickery works.

--/hP/389S7qb5BOej
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmWIbAAoJEHZH4aRLwOS6bxkP/346Ge/eWpSRcj4J1OoVeI77
Fv20cB/j7mOQ1iAzhi7KaqElqTQhdosjcsvpnMYWWz2K4nfVxqVN2J4Kz77RBDDl
w0ZLrGi3R1I4FLFDVZY28iHd1rxYgAn69HixI48EPIRYr1LKGL0aLghMXxNHXJXa
Tt3s72iT2fQnroNH0JsJDwnAsMzCQxztvkGdSo8KA/B7Bv2b2GOx4k/VfnNP7toD
tV5z8Aci6SJAKqn+MOlUFcOL3pW1rqNcY31DVKXzAotlBfgKb32y3aLxdArWghra
fyKrGsXmv+staGqR0uPfiKK+nXfaMTIkXDugxu4mJG/xvIAWDvtHB7jrDEWX5Bc7
0ugzKrVigNg0jA23WSwJJrVCxm+rIsUnd36YrQIo+99G/WM/cmzlS0zVNtTfmsj4
E329JrX4mC0+fDTYntZPgeFJUKIdPAHlXObcIHaYSusRKNpCXbaQLfAZ+PddcxpT
pEVhuk45zebkQj/CSXYzuaK8Fwp5oMU/1fwZVrxVCpBbMbHmrRekigjs2WKQE7c2
hQ8ZFM+81gbBPlkiAS2yL/s5jher3vjtOxMTKm41Oz7lOEr2Gi6V/lcy970P48tb
AATXyjgajz0nOvmkFScXPwc1xp+2iEhWCMtJV744/R9QhtwRSlvkl8fg4+gNQKEz
aN/q/TDwcHlwbkzkFGlK
=l3Vj
-----END PGP SIGNATURE-----

--/hP/389S7qb5BOej--
