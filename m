Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaEZP74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:59:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaEZP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:59:55 -0400
Date: Mon, 26 May 2014 17:59:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] irq_work: Split raised and lazy lists
Message-ID: <20140526155944.GL30445@twins.programming.kicks-ass.net>
References: <1401028191-29756-1-git-send-email-fweisbec@gmail.com>
 <1401028191-29756-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkVhr1N513l62upp"
Content-Disposition: inline
In-Reply-To: <1401028191-29756-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkVhr1N513l62upp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 25, 2014 at 04:29:47PM +0200, Frederic Weisbecker wrote:
> An irq work can be handled from two places: from the tick if the work
> carries the "lazy" flag and the tick is periodic, or from a self IPI.
>=20
> We merge all these works in a single list and we use some per cpu latch
> to avoid raising a self-IPI when one is already pending.
>=20
> Now we could do away with this ugly latch if only the list was only made =
of
> non-lazy works. Just enqueueing a work on the empty list would be enough
> to know if we need to raise an IPI or not.
>=20
> Also we are going to implement remote irq work queuing. Then the per CPU
> latch will need to become atomic in the global scope. That's too bad
> because, here as well, just enqueueing a work on an empty list of
> non-lazy works would be enough to know if we need to raise an IPI or not.
>=20
> So lets take a way out of this: split the works in two distinct lists,
> one for the works that can be handled by the next tick and another
> one for those handled by the IPI. Just checking if the latter is empty
> when we queue a new work is enough to know if we need to raise an IPI.

That ^

>  bool irq_work_queue(struct irq_work *work)
>  {
> +	unsigned long flags;
> +
>  	/* Only queue if not already pending */
>  	if (!irq_work_claim(work))
>  		return false;
> =20
> -	/* Queue the entry and raise the IPI if needed. */
> -	preempt_disable();
> +	/* Check dynticks safely */
> +	local_irq_save(flags);

Does not mention this ^

'sup?

--SkVhr1N513l62upp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTg2ToAAoJEHZH4aRLwOS6pZQP/2BwEJ6yevcpD7IIbiYLJ0zu
xwqxLQUoxSmkZzd1jpRF544UtJkFdzPoH24tfmD/vKt8Vhx5te5c+zyNH14LuxjY
lV0slwNZgcyZqjeo7kodZDt50LmUUkVVI0ELSMV9sBaOOiT1a+A1qHkfE3WsX4IH
UeMkp+qaqN8sdF3Oabe6FgoID3brhw8h9b/GOfy82kh0D9k8/10PpstNxUN8hn5A
HSihrWFNjiWMpoVJU6Ts9EGxcgZKWbCpkLcKXLpPAj2fROubRuETtJn9j6VKcbv0
/BLCleIFM5WB9pWMRs64nus3rXEEA/gJTx7PICX+FpeEqFgFlNVwoLK5g13gwT3M
uZGfgeJVbidcVmLeH8OlL392i+FHrQOMsM5p30co6OUjEjoNiSgqwstsv0+dGQvj
h8TQ7P2WOnG7pUA9kds0UFpvBH5sUaOG69b0YM5AThtCfX/cxT4mrJAdLRswNN9l
6JKb6B91We/UR2/vzxykwutUc76NCEVtJENPSUPzUYhwn+paQJbWCuj7lkcaYprY
yDBXx/hKLvTc0A5VN0AH5nkmcg8fXhcKoKgtCqXLpAwnD3K18wki8tsjEhLHZzRg
+ctGzd4NUcL2o209tCzxJiaWccLA71UYG9YuAxRZC7Q0gdTtE+xFQw37wRoGoQEA
02lmqhsH8e6t+P+fv1yC
=uIJN
-----END PGP SIGNATURE-----

--SkVhr1N513l62upp--
