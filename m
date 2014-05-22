Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaEVNJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:09:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:45357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaEVNJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:09:37 -0400
Date: Thu, 22 May 2014 15:09:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140522130931.GV13658@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wnBGVoaGQwxWUIo6"
Content-Disposition: inline
In-Reply-To: <20140522125818.GV30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wnBGVoaGQwxWUIo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 02:58:18PM +0200, Peter Zijlstra wrote:
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4ea7b3f1a087..a5da85fb3570 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -546,12 +546,38 @@ static bool set_nr_and_not_polling(struct task_struct *p)
>  	struct thread_info *ti = task_thread_info(p);
>  	return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLING_NRFLAG);
>  }
> +
> +/*
> + * Atomically set TIF_NEED_RESCHED if TIF_POLLING_NRFLAG is set.
> + */
> +static bool set_nr_if_polling(struct task_struct *p)
> +{
> +	struct thread_info *ti = task_thread_info(p);
> +	typeof(ti->flags) old, val = ti->flags;
> +
> +	for (;;) {
> +		if (!(val & _TIF_POLLING_NRFLAG))
> +			return false;
> +		if (val & _TIF_NEED_RESCHED)
> +			return true;

Hmm, I think this is racy, false would be safer. If its already set we
might already be past the sched_ttwu_pending() invocation, while if its
clear and we're the one to set it, we're guaranteed not.

> +		old = cmpxchg(&ti->flags, val, val | _TIF_NEED_RESCHED);
> +		if (old == val)
> +			return true;
> +		val = old;
> +	}
> +}

--wnBGVoaGQwxWUIo6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTffcLAAoJEHZH4aRLwOS6B6UP/jA0mCwUbk0wGw4LP+d7DT1z
szsmQwWRa/4U01WhCzeerQa8/8nONevHdkhgaIQeCfncI/a46hLgSZtKj9Y71jON
IGEbOYviKDDPzC5YsBI55nDLf3QTiyYMQAVh+hsiqLptfwkhm89w0UU8I6UR7zmh
4w6CVN4/ytuXOT+rcaZhKnU+5f+aT2avJLH+GLBJt0IW2hYZ7OUihZzVW3M5bMPh
GnAN3XtfgYHKOrj/d1quCymSNAXp34JDxbz/UY0PSin9wDiRS5JvKz6boLUsRnqp
7y/w6ZiL/Sg5jBH4vZGlUsU5Hkz9IMe2MGjgj6R+JDdUFiih+CK9N+JVpEHSKN4k
d39DmSHeStegdDYQK+0VNzFV6FhoL9P3KpbDy0cPH2OgFABeAGC5HDuPVKy3oT2O
GmANJiyrInomFG1JLi0wSkdW4o8ELWf0XN6xCbZhqE1l1DzdvDabb+hj/7U5cQnc
XBznDNxQJV9K3XRzkQmzWpaPFewyVjQhVwuikrxnRJoK0FQW5k108BYBdeCjcf6i
1qwO91PJpkju1fn5t6WlK06cOZONWIDCOupYt4hF2VqcEPi7tbsz3dUDGvcC+tf8
LdklZIyJmLXNItlFZrickZ7gv52ew7s/9YLLxD1NLlqTcPELtt4aeAaWpByVzwjp
37kHxy0LCHXpYA8rysb6
=TkRa
-----END PGP SIGNATURE-----

--wnBGVoaGQwxWUIo6--
