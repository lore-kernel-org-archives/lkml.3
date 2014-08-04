Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaHDNpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:45:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:33937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaHDNpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:45:09 -0400
Date: Mon, 4 Aug 2014 15:44:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 1/7] wait: Provide infrastructure to deal with
 nested blocking
Message-ID: <20140804134455.GT19379@twins.programming.kicks-ass.net>
References: <20140804103025.478913141@infradead.org>
 <20140804103537.356311360@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3NSd1CguC5h5Rqw/"
Content-Disposition: inline
In-Reply-To: <20140804103537.356311360@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3NSd1CguC5h5Rqw/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 12:30:26PM +0200, Peter Zijlstra wrote:

> +long wait_woken(wait_queue_t *wait, unsigned mode, long timeout)
> +{
> +	set_current_state(mode);
> +	if (!(wait->flags & WQ_FLAG_WOKEN))
> +		timeout = schedule_timeout(timeout);
> +	else
> +		wait->flags &= ~WQ_FLAG_WOKEN;

I just noticed that poll_schedule_timeout() uses set_mb() for clearing
its triggered variable. But I'm not entirely sure I see why..

> +	__set_current_state(TASK_RUNNING);
> +
> +	return timeout;
> +}
> +EXPORT_SYMBOL(wait_woken);
> +
> +int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	/*
> +	 * Although this function is called under waitqueue lock, LOCK
> +	 * doesn't imply write barrier and the users expect write
> +	 * barrier semantics on wakeup functions.  The following
> +	 * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
> +	 * and is paired with set_mb() in wait_woken().
> +	 */
> +	smp_wmb();
> +	wait->flags |= WQ_FLAG_WOKEN;
> +
> +	return default_wake_function(wait, mode, sync, key);
> +}
> +EXPORT_SYMBOL(woken_wake_function);

So possibly we could also use this for poll_schedule_timeout() and
__pollwake().

--3NSd1CguC5h5Rqw/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT345XAAoJEHZH4aRLwOS6K3UQAJ27DoD6sRp6Sg/ZNPQp54eR
dgcACwFRWx9IWhDTJPh9HosAsNcnfJ4XaNVCE1c7PJtPX+s+onayUYGlYPSzeyAi
q/gdlGMKyz0ki5lkiki9YrgSCQdFe3Srg6A0hbAPnMCPtART5iBBINiWiGLqlrZF
ksXhZCBLF3B0v8aC/ymA5l4DHJXM8ZTdlIlgm2d9GKN7hTvW67CW243RxGeKDFC6
KkeenDjhwLR4hUNQfHTTwRnCdvtbYM+ADYy34R6CO25S0cLV8E/+Y6h+xwaiW+Hy
hkTAbB108r9aD5hcqs/0o55BMj7wqi+3FZ55Q5QXjmbWxctKthJWlAQhLfmRB5TI
g5ef6cHKiF8tENDBs3awxorQzBBDkGCKMo3PBjOuAUBZ90oIqXLEOKdj130tSeH/
BfcOd/E2smh51944D6+6k5OgeN9Cf4VJAxcC8WmvUfCJFl2u5vGxIUj+I78su2L1
mEJrBxjM3Mq6lmJgJl50+O2TI59gG/0lZ6xqAvXyrXyzxbMwKAhys8fVV3FP/v8i
kCW1lP4dT2/2NE9jdGODFhSvYB4N0rOXSG1IohIQOESMP0tI3nU0hMdpcerVEKFp
2jmzpOeBM99gqAu8fW3OEwcqQpPwDEib43j8rRiDP422h2SbR1Dzf80jAgVrUDwa
wiOgPspO0fOeQCgd0DWO
=2uAS
-----END PGP SIGNATURE-----

--3NSd1CguC5h5Rqw/--
