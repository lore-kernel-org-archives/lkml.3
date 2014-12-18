Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaLROBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:01:32 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46220 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaLROBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:01:30 -0500
Date: Thu, 18 Dec 2014 10:01:12 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Preeti Murthy <preeti.lkml@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] tick/powerclamp: Remove tick_nohz_idle abuse
Message-ID: <20141218140106.GA6323@developer>
References: <alpine.DEB.2.11.1412181110110.17382@nanos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412181110110.17382@nanos>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Thomas,

On Thu, Dec 18, 2014 at 11:51:01AM +0100, Thomas Gleixner wrote:
> commit 4dbd27711cd9 "tick: export nohz tick idle symbols for module
> use" was merged via the thermal tree without an explicit ack from the
> relevant maintainers.
>=20

This is a shame. Rui, do you have any comments on this?

> The exports are abused by the intel powerclamp driver which implements
> a fake idle state from a sched FIFO task. This causes all kinds of
> wreckage in the NOHZ core code which rightfully assumes that
> tick_nohz_idle_enter/exit() are only called from the idle task itself.
>=20

OK.

> Recent changes in the NOHZ core lead to a failure of the powerclamp
> driver and now people try to hack completely broken and backwards
> workarounds into the NOHZ core code. This is completely unacceptable.
>=20

I see.

> The real solution is to fix the powerclamp driver by rewriting it with
> a sane concept, but that's beyond the scope of this.
>=20

Do you have suggestions on what exactly is the expected rewriting or the
correct sane concepts?

> So the only solution for now is to remove the calls into the core NOHZ
> code from the powerclamp trainwreck along with the exports.
>=20
> Fixes: d6d71ee4a14a "PM: Introduce Intel PowerClamp Driver"

If I got it right, the driver is currently broken due to changes in NOHZ
core. So, does this patch fix power clamp behavior ?

If I got your proposal right, in the end power clamp will be still
broken, but at least won't be abusing NOHZ. Is that what you are
proposing?

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_p=
owerclamp.c
> index b46c706e1cac..e98b4249187c 100644
> --- a/drivers/thermal/intel_powerclamp.c
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -435,7 +435,6 @@ static int clamp_thread(void *arg)
>  		 * allowed. thus jiffies are updated properly.
>  		 */
>  		preempt_disable();
> -		tick_nohz_idle_enter();
>  		/* mwait until target jiffies is reached */
>  		while (time_before(jiffies, target_jiffies)) {
>  			unsigned long ecx =3D 1;
> @@ -451,7 +450,6 @@ static int clamp_thread(void *arg)
>  			start_critical_timings();
>  			atomic_inc(&idle_wakeup_counter);
>  		}
> -		tick_nohz_idle_exit();
>  		preempt_enable();
>  	}
>  	del_timer_sync(&wakeup_timer);
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 4d54b7540585..1363d58f07e9 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -847,7 +847,6 @@ void tick_nohz_idle_enter(void)
> =20
>  	local_irq_enable();
>  }
> -EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
> =20
>  /**
>   * tick_nohz_irq_exit - update next tick event from interrupt exit
> @@ -974,7 +973,6 @@ void tick_nohz_idle_exit(void)
> =20
>  	local_irq_enable();
>  }
> -EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
> =20
>  static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
>  {
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkt38AAoJEMLUO4d9pOJW5HcH/j5ApX5dycLmn5v3lW6HFOkA
MOV9kStLnaJts0iZ05XmA/O+h4Fj04E45MqxjLtfrZhFa+O6SHTgwkMX91l3evAL
K7WaYvIiCTDbOPvBkQo8FB5+JokuY4U2fr3QA5G7zUVuPcajNfY/uBaiTCoK167n
Jw+x2gx8mDiL7gqFhC/AYx1Eu3vAiXJvuG/vGxGZiIgvQ38/XZVwDNk3B4lnc4ty
i24J6qZjhOTPd9coxLA8H0NePci1LW4nZf9ea5N6Q2oSqND7M4bGWKeqICX5tS0x
ygitzkRMrN3mO0IzhWLJK7VqvCis/Hg0TKmMBNpqrTxORkBFgPtSEf8IW7MOgN0=
=ZmqT
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
