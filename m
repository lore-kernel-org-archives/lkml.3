Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaHLHzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:55:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:38228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaHLHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:55:39 -0400
Date: Tue, 12 Aug 2014 09:55:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com, tkhai@yandex.ru,
        tim.c.chen@linux.intel.com, mingo@kernel.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 3/6] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
Message-ID: <20140812075523.GN9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
 <1407312379.8424.38.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lyeex8+3KW0QCOB8"
Content-Disposition: inline
In-Reply-To: <1407312379.8424.38.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lyeex8+3KW0QCOB8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 12:06:19PM +0400, Kirill Tkhai wrote:
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -331,9 +331,13 @@ static inline struct rq *__task_rq_lock(struct task_=
struct *p)
>  	lockdep_assert_held(&p->pi_lock);
> =20
>  	for (;;) {
> +		while (unlikely(task_migrating(p)))
> +			cpu_relax();
> +
>  		rq =3D task_rq(p);
>  		raw_spin_lock(&rq->lock);
> -		if (likely(rq =3D=3D task_rq(p)))
> +		if (likely(rq =3D=3D task_rq(p) &&
> +			   !task_migrating(p)))
>  			return rq;
>  		raw_spin_unlock(&rq->lock);
>  	}
> @@ -349,10 +353,14 @@ static struct rq *task_rq_lock(struct task_struct *=
p, unsigned long *flags)
>  	struct rq *rq;
> =20
>  	for (;;) {
> +		while (unlikely(task_migrating(p)))
> +			cpu_relax();
> +
>  		raw_spin_lock_irqsave(&p->pi_lock, *flags);
>  		rq =3D task_rq(p);
>  		raw_spin_lock(&rq->lock);
> -		if (likely(rq =3D=3D task_rq(p)))
> +		if (likely(rq =3D=3D task_rq(p) &&
> +			   !task_migrating(p)))
>  			return rq;
>  		raw_spin_unlock(&rq->lock);
>  		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);

I know I suggested that; but I changed it like the below. The advantage
is of not having two task_migrating() tests on the likely path.

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -331,15 +331,15 @@ static inline struct rq *__task_rq_lock(
 	lockdep_assert_held(&p->pi_lock);
=20
 	for (;;) {
-		while (unlikely(task_migrating(p)))
-			cpu_relax();
-
 		rq =3D task_rq(p);
 		raw_spin_lock(&rq->lock);
 		if (likely(rq =3D=3D task_rq(p) &&
 			   !task_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
+
+		while (unlikely(task_migrating(p)))
+			cpu_relax();
 	}
 }
=20
@@ -353,9 +353,6 @@ static struct rq *task_rq_lock(struct ta
 	struct rq *rq;
=20
 	for (;;) {
-		while (unlikely(task_migrating(p)))
-			cpu_relax();
-
 		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq =3D task_rq(p);
 		raw_spin_lock(&rq->lock);
@@ -364,6 +361,9 @@ static struct rq *task_rq_lock(struct ta
 			return rq;
 		raw_spin_unlock(&rq->lock);
 		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
+
+		while (unlikely(task_migrating(p)))
+			cpu_relax();
 	}
 }
=20

--Lyeex8+3KW0QCOB8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6chrAAoJEHZH4aRLwOS6VBsP/3ZY+0rPd6Opp9ivbno/JaZO
b6zIq14BleDfOUFwlDOBfHoOVD9Ggy5tGcjkX4zUMN2t0+ibHHoKcShmaixEsurx
pj3/X/9iaojyBven6jB8BEiY15r3qRKKSJXQIXJ87zmxW70HjuQfFUNBd7wshbBj
AtQUDVT5Zhzbh82leClcTa6FI+KlAB6WHOC1GVQxQGKNHen1S+K6z8b9Wm3QqFF+
chYxvEFdt+OD4uRr7xJbThXwzvsx9T2nN1RGuRthrzsxL3KLBveEtCEopqo1ZcaN
X2Lf1SuwL2Y07oR6aed7bnFJnwOWkFPor64H0jWE1w4lYcAIpOMl8nW5ZmJlklJS
C9QWIOOYU5ZcwGZq5nmdq/i95JAiS9XXScpOjzXCWEK1IeJylJcAGSZvaVT/Z3MF
bt2TTsDEsabEBuO32xJ1WYFx9M9Z8rJR7RrQuvkKpC+x/x2QHaWXuMXxHFJnuAsJ
teCu90qAn2q+QWH4B5lPvivFrroQkPCm5dYLBZ3rCZdyimoD2Sys8xF3dbQjNfMn
fHNIzZl6+4+4NH8ZrdkyUkFQOtrNe0N5hCKaJ40IfE0lZFfE1bh4c/Jl9VzJUANR
pm3ZO7RN7A1mFBbj5B2v5dvPtc1iWCBfwj86QzD8F1E5IRHDoZzStJVMq9Qtdfcx
9R2Ti2JvxBV0X7ZXsLXM
=j3lA
-----END PGP SIGNATURE-----

--Lyeex8+3KW0QCOB8--
