Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaG1JId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:08:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:58014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaG1JIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:08:32 -0400
Date: Mon, 28 Jul 2014 11:08:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@kernel.org, jason.low2@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/master 4/7] locking/mutex: Refactor optimistic
 spinning code
Message-ID: <20140728090821.GO6758@twins.programming.kicks-ass.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
 <1406524724-17946-4-git-send-email-davidlohr@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VOikT1vHjjoKyvem"
Content-Disposition: inline
In-Reply-To: <1406524724-17946-4-git-send-email-davidlohr@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VOikT1vHjjoKyvem
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 27, 2014 at 10:18:41PM -0700, Davidlohr Bueso wrote:
> @@ -180,6 +266,126 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
>  	 */
>  	return retval;
>  }
> +
> +/*
> + * Atomically try to take the lock when it is available */

comment fail.

> +static inline bool mutex_try_to_acquire(struct mutex *lock)
> +{
> +	return !mutex_is_locked(lock) &&
> +		(atomic_cmpxchg(&lock->count, 1, 0) == 1);
> +}

> +static bool mutex_optimistic_spin(struct mutex *lock,
> +				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
> +{


> +	/*
> +	 * If we fell out of the spin path because of need_resched(),
> +	 * reschedule now, before we try-lock the mutex. This avoids getting
> +	 * scheduled out right after we obtained the mutex.
> +	 */
> +	if (need_resched())
> +		schedule_preempt_disabled();
> +
> +	return false;
> +}


> +	if (mutex_optimistic_spin(lock, ww_ctx, use_ww_ctx)) {
> +		/* got it, yay! */
> +		preempt_enable();
> +		return 0;
>  	}
> +
>  	/*
>  	 * If we fell out of the spin path because of need_resched(),
>  	 * reschedule now, before we try-lock the mutex. This avoids getting
> @@ -475,7 +512,7 @@ slowpath:
>  	 */
>  	if (need_resched())
>  		schedule_preempt_disabled();
> +
>  	spin_lock_mutex(&lock->wait_lock, flags);

We now have two if (need_resched) schedule_preempt_disable() instances,
was that on purpose?

--VOikT1vHjjoKyvem
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1hMFAAoJEHZH4aRLwOS6hjYP/jZZFKPtO7SyV9EQaPE8JN7g
A093YAaTDcCqkEUq5llEvO1yFLANt+FM12HmJQT2QEHfzWYc8RCx0f8U+QVF74dL
rWzvSRFSq640y8EvWwAWmLDHcqkS9nXVv/KDJXgixGh8OBzjP/F65VNspMpO7+XM
H0bpeuqHCW4FZE2NFFcN90iHRdQ0kQ4Poi70PirVJYE0KIN0dHUhO7CyHgkJRB3a
wVRrE+vQwrt61ydlO118v+CRapf9ejB2u5QljxWZHZrYCyfw3F97231a0dVpV3G/
LGxV0PfgTaumORNwy1qvUVKXB/0cK2gSSa/IAYX3H1wi7oe+4xgZTjf24Ib/i/1B
M5BTstAjKI59biDmRf6hXN3W5zaR4BhR0E1Do4F/72Jv2xsFUWmERCNyayXEzola
u/fMh8kw6DSH6mbsdsWAPwDOZ1PIbZayZMlkD2wM/8c1QEcI8vyYEo0bbpcqKtgu
DAmG/wFv0pjgRtrTCJRpglTRz2cJwT19oTt0ZJxWEG+k80MUfIb8GlZCjhy1O39j
S/12TQWr7xTeDLkyXGPMGeklOlCfM8uOrlDNQSTTdI+vrScXP3X3SPUlVfsN7vtZ
luLu4ZrEDIkAyrFXoi+9ZpGaBA5KYa7Pik8g0oC7NiXWReQg/GChxCuGFMA2txev
xsY6YiJl8g0nD8iRHPkE
=8KDn
-----END PGP SIGNATURE-----

--VOikT1vHjjoKyvem--
