Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaENJGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:06:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:48281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaENJGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:06:35 -0400
Date: Wed, 14 May 2014 11:06:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514090629.GC30445@twins.programming.kicks-ass.net>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kz6eUT30PReluLpA"
Content-Disposition: inline
In-Reply-To: <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kz6eUT30PReluLpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 12:25:54AM +0200, Frederic Weisbecker wrote:
> irq work currently only supports local callbacks. However its code
> is mostly ready to run remote callbacks and we have some potential user.
>=20
> The full nohz subsystem currently open codes its own remote irq work
> on top of the scheduler ipi when it wants a CPU to reevaluate its next
> tick. However this ad hoc solution bloats the scheduler IPI.
>=20
> Lets just extend the irq work subsystem to support remote queuing on top
> of the generic SMP IPI to handle this kind of user. This shouldn't add
> noticeable overhead.
>=20
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/irq_work.h |  2 ++
>  kernel/irq_work.c        | 19 ++++++++++++++++++-
>  kernel/smp.c             |  4 ++++
>  3 files changed, 24 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
> index 19ae05d..ae44aa2 100644
> --- a/include/linux/irq_work.h
> +++ b/include/linux/irq_work.h
> @@ -33,6 +33,8 @@ void init_irq_work(struct irq_work *work, void (*func)(=
struct irq_work *))
>  #define DEFINE_IRQ_WORK(name, _f) struct irq_work name =3D { .func =3D (=
_f), }
> =20
>  bool irq_work_queue(struct irq_work *work);
> +bool irq_work_queue_on(struct irq_work *work, int cpu);
> +
>  void irq_work_run(void);
>  void irq_work_sync(struct irq_work *work);
> =20
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index a82170e..9f9be55 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -56,11 +56,28 @@ void __weak arch_irq_work_raise(void)
>  }
> =20
>  /*
> - * Enqueue the irq_work @entry unless it's already pending
> + * Enqueue the irq_work @work on @cpu unless it's already pending
>   * somewhere.
>   *
>   * Can be re-enqueued while the callback is still in progress.
>   */
> +bool irq_work_queue_on(struct irq_work *work, int cpu)
> +{
> +	/* Only queue if not already pending */
> +	if (!irq_work_claim(work))
> +		return false;
> +
> +	/* All work should have been flushed before going offline */
> +	WARN_ON_ONCE(cpu_is_offline(cpu));

	WARN_ON_ONCE(in_nmi());

> +
> +	llist_add(&work->llnode, &per_cpu(irq_work_list, cpu));
> +	native_send_call_func_single_ipi(cpu);

At the very leastestest make that:

	if (llist_add(&work->llnode, &per_cpu(irq_work_list, cpu)))
		native_send_call_func_single_ipi(cpu);

But ideally, also test the IRQ_WORK_LAZY support, its weird to have that
only be supported for the other queue.

Hmm, why do we need that LAZY crap, that completely wrecks a perfectly
simple thing.

The changelog (bc6679aef673f), not the printk() usage make much sense,
printk() can't cause an IPI storm... printk() isn't fast enough to storm
anything.

> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(irq_work_queue_on);

--Kz6eUT30PReluLpA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTczIQAAoJEHZH4aRLwOS66sQQAJ6SVnxJRXxQtr+LoEwXNN/6
zlpPJ4To45XxuRMNtSyIuZXwnEeItJtdprZ9KiHAgfCLHoX+FQ/LAVpGOMb/9tc6
5hi+6saPF3VlqWJR6dH8AVBa292+qPQlhcP7Duvn0DYz6lL5ECLUPFqCKVqI+U/R
JBnVFp69Y2RoxAmgjJfCAu/zVmpgpUZ92ev85RcfXoqlpHpopEkJYrd1NR1KhkMF
V5oLVBVkqBxiYYe6RtBAP+bKWXTcOTmodSqBKCyUS271NmUFZBsdlII4eLfJrnpM
Zn8UW1JVp+h3eJyP8QmLd+Heq6+3BZhh3fRbqwOwB/Tr9kMM6BgbCu5kUm9wu74J
9ruQydXrEoVbAntCZSfMlT4wm/s6jHDkp24gvEn0nX97dgrAlC/MBELiwHCfqg+q
OFSsUypfDuIULDzk3VSjGeBD5TgSiv/L71MKSb4bGOeIV2L6li4qIZ7H34/9dTBf
zAaRMwbtsFqdcl0i+YcYMr0YxKN4YkwPDVQBla3ODaMswHxPaxcQzoIQm8aJNMH9
c94iJeuom7xZ1pBl8cA1bpUF+tDDgUOwbCoXOIsRmmnO9jpFr/GPmWhNw3UzJNu/
KnnNlVBYrk9mVqtfUGt7uMNeCdzPaA8kKy3TL1bTDGDf4ZQE+hpAxuWhtQsjgtsw
szZlDOOc0tUYT81ycnjf
=x1Vz
-----END PGP SIGNATURE-----

--Kz6eUT30PReluLpA--
