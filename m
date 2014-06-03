Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaFCOCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:02:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41718 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaFCOCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:02:30 -0400
Date: Tue, 3 Jun 2014 16:02:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140603140223.GA13658@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net>
 <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
 <20140529064827.GI19143@laptop.programming.kicks-ass.net>
 <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
 <20140603104347.GT11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwU9tsYnHnYeRAKj"
Content-Disposition: inline
In-Reply-To: <20140603104347.GT11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwU9tsYnHnYeRAKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 12:43:47PM +0200, Peter Zijlstra wrote:
> We need rq->curr, rq->idle 'sleeps' with polling set and nr clear, but
> it obviously has no effect setting that if its not actually the current
> task.
>=20
> Touching rq->curr needs holding rcu_read_lock() though, to make sure the
> task stays around, still shouldn't be a problem.

> @@ -1581,8 +1604,14 @@ void scheduler_ipi(void)
> =20
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  {
> -	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
> -		smp_send_reschedule(cpu);
> +	struct rq *rq =3D cpu_rq(cpu);
> +
> +	if (llist_add(&p->wake_entry, &rq->wake_list)) {
> +		rcu_read_lock();
> +		if (!set_nr_if_polling(rq->curr))
> +			smp_send_reschedule(cpu);
> +		rcu_read_unlock();
> +	}
>  }

Hrmm, I think that is still broken, see how in schedule() we clear NR
before setting the new ->curr.

So I think I had a loop on rq->curr the last time we talked about this,
but alternatively we could look at clearing NR after setting a new curr.

I think I once looked at why it was done before, of course I can't
actually remember the details :/

--wwU9tsYnHnYeRAKj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjdVvAAoJEHZH4aRLwOS6+0kP/0ySY326L9ftLvKzLXl0XPMJ
Mojju32A7uapFz+XP9T1phPYAC9WZUQspmR+SMpuULRFDUbMg6J97rDFmEYeA6O7
lDB6s8WeFGyK3lzjiKBgXf5ey1H5gqRbM0ngRRjB4fAque919BNJCdGAk7vWvQuE
W9Y5HecU4bhxtbg93iVLj3ERkM3VyPBMfAHT0YYI47646OyQGF5avDgV16kMaIoS
kAHpNsCUpBp3qsF3lzrEubm1FvYgGOAD9iBoH+g/gp7aLYiqyYEJ8bb8DSHgrxYn
uOpaMQLYjqqhW8mZ06YECOGxXauY/3vR3Lp2w1kIeJ7ZIBuLXvetA7c9EjJtGvIE
7scY6IFmSdC7utj30J7hjqefb7u60S7M49wr6k7oGPjLlNWnfm7w0h2gBq/lM/Uc
TpxRcfS+74pHX2zAvAzHaef8umMRCw+bYTj3Vt02ZnxIXixJZrEQ5n4Eb5GnwTly
J46xs29QXgSU1FIySivjHDfwKY4idM6i5wnguAtXdmIcyjrwb3YeAPcJWN3l+njH
TvFoPk1vs0wyjllXWH4nDuU1SbHOjcBeTb2zdFo8nRM5dTDlhF30CRwFVLoui58d
hYcs6hIPJaab/JU99zpgS8jBR0tqfnQ35ArFFmIeftkaCpOYDaADIfsL+cNlur1x
jjQJ7Wc0IilvrleCqCUC
=q++g
-----END PGP SIGNATURE-----

--wwU9tsYnHnYeRAKj--
