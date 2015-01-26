Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbbAZOkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:40:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36231 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755431AbbAZOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:40:07 -0500
Date: Mon, 26 Jan 2015 15:35:41 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] clocksource: sun5i: Add clock notifiers
Message-ID: <20150126143541.GG31568@lukather>
References: <1422265856-27631-1-git-send-email-maxime.ripard@free-electrons.com>
 <1422265856-27631-6-git-send-email-maxime.ripard@free-electrons.com>
 <54C62368.7050600@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9ZOS6odDaRI+0hI"
Content-Disposition: inline
In-Reply-To: <54C62368.7050600@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9ZOS6odDaRI+0hI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Mon, Jan 26, 2015 at 12:22:16PM +0100, Daniel Lezcano wrote:
> On 01/26/2015 10:50 AM, Maxime Ripard wrote:
> >The parent clock of the sun5i timer is the AHB clock, which rate might c=
hange
> >because of other devices requirements.
> >
> >This is for example the case on the Allwinner A31, where the DMA control=
ler
> >needs a minimum rate higher than the default, that is enforced after the=
 timer
> >driver has probed.
> >
> >Add clock notifiers to make sure we reflect the clock rate changes in th=
e timer
> >rates.
>=20
> Mmh, I am wondering if that shouldn't go to the time framework ...
>=20
> Looking at the notifier callbacks that call generic time framework
> functions.

I don't think the framework currently has a clock handle so far?

> Can you have a look at commit b3e90722 ? and double check your
> changes ?

I'm exactly in the opposite situation.

The parent clock of this timer is *not* the CPU clock, and it might
even be in a completely different clock tree.

However, our DMA controller has the same parent clock than the timer,
and it needs some frequency adjustement. Otherwise, DMA would just not
work.

So I'm completely fine with any rate change as far as the timer is
concerned, the driver just need to be notified to be able to reflect
this rate change.

> A couple of comments below.
>=20
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >---
> >  drivers/clocksource/timer-sun5i.c | 72 +++++++++++++++++++++++++++++++=
++++++--
> >  1 file changed, 70 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/tim=
er-sun5i.c
> >index 377e50450781..5841a956f5f0 100644
> >--- a/drivers/clocksource/timer-sun5i.c
> >+++ b/drivers/clocksource/timer-sun5i.c
> >@@ -41,9 +41,13 @@
> >  struct sun5i_timer {
> >  	void __iomem		*base;
> >  	struct clk		*clk;
> >+	struct notifier_block	clk_rate_cb;
> >  	u32			ticks_per_jiffy;
> >  };
> >
> >+#define to_sun5i_timer(x) \
> >+	container_of(x, struct sun5i_timer, clk_rate_cb)
> >+
> >  struct sun5i_timer_clksrc {
> >  	struct sun5i_timer	timer;
> >  	struct clocksource	clksrc;
> >@@ -152,6 +156,30 @@ static cycle_t sun5i_clksrc_read(struct clocksource=
 *clksrc)
> >  	return ~readl(cs->timer.base + TIMER_CNTVAL_LO_REG(1));
> >  }
> >
> >+static int sun5i_rate_cb_clksrc(struct notifier_block *nb,
> >+				unsigned long event, void *data)
> >+{
> >+	struct clk_notifier_data *ndata =3D data;
> >+	struct sun5i_timer *timer =3D to_sun5i_timer(nb);
> >+	struct sun5i_timer_clksrc *cs =3D container_of(timer,
> >+						     struct sun5i_timer_clksrc, timer);
> >+
> >+	switch (event) {
> >+	case PRE_RATE_CHANGE:
> >+		clocksource_unregister(&cs->clksrc);
> >+		break;
> >+
> >+	case POST_RATE_CHANGE:
> >+		clocksource_register_hz(&cs->clksrc, ndata->new_rate);
> >+		break;
>=20
> Why clocksource_unregister couldn't be in the POST_RATE_CHANGE ?

Wouldn't that leave a (small, I agree) window where the timer would
run at a rate different to the one it has been registered with?

> >+	default:
> >+		break;
> >+	}
> >+
> >+	return NOTIFY_DONE;
> >+}
> >+
> >  static int __init sun5i_setup_clocksource(struct device_node *node,
> >  					  void __iomem *base,
> >  					  struct clk *clk, int irq)
> >@@ -174,6 +202,14 @@ static int __init sun5i_setup_clocksource(struct de=
vice_node *node,
> >
> >  	cs->timer.base =3D base;
> >  	cs->timer.clk =3D clk;
> >+	cs->timer.clk_rate_cb.notifier_call =3D sun5i_rate_cb_clksrc;
> >+	cs->timer.clk_rate_cb.next =3D NULL;
> >+
> >+	ret =3D clk_notifier_register(clk, &cs->timer.clk_rate_cb);
> >+	if (ret) {
> >+		pr_err("Unable to register clock notifier.\n");
> >+		goto err_disable_clk;
> >+	}
> >
> >  	writel(~0, base + TIMER_INTVAL_LO_REG(1));
> >  	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
> >@@ -188,11 +224,13 @@ static int __init sun5i_setup_clocksource(struct d=
evice_node *node,
> >  	ret =3D clocksource_register_hz(&cs->clksrc, rate);
> >  	if (ret) {
> >  		pr_err("Couldn't register clock source.\n");
> >-		goto err_disable_clk;
> >+		goto err_remove_notifier;
> >  	}
> >
> >  	return 0;
> >
> >+err_remove_notifier:
> >+	clk_notifier_unregister(clk, &cs->timer.clk_rate_cb);
> >  err_disable_clk:
> >  	clk_disable_unprepare(clk);
> >  err_free:
> >@@ -200,6 +238,26 @@ err_free:
> >  	return ret;
> >  }
> >
> >+static int sun5i_rate_cb_clkevt(struct notifier_block *nb,
> >+				unsigned long event, void *data)
> >+{
> >+	struct clk_notifier_data *ndata =3D data;
> >+	struct sun5i_timer *timer =3D to_sun5i_timer(nb);
> >+	struct sun5i_timer_clkevt *ce =3D container_of(timer,
> >+						     struct sun5i_timer_clkevt, timer);
> >+	unsigned long flags;
> >+
> >+	if (event =3D=3D POST_RATE_CHANGE) {
> >+		local_irq_save(flags);
> >+		clockevents_update_freq(&ce->clkevt, ndata->new_rate);
> >+		local_irq_restore(flags);
>=20
> local_irq_save and local_irq_restore are already in the
> clockevents_update_freq function.

Ok.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/9ZOS6odDaRI+0hI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxlC9AAoJEBx+YmzsjxAgFk8QAL4kaEMha/qWQTJeXPUc0A+Q
PDunPjnMogMj9hbo+DXzYheU/1shfbS/MbOeTjXYSLVzUwya7UzYkc9Cx3m9GJ69
sPgh6Ul1LETQWk7cm1A7lZkXX9upY1B/4yTxOev/ef0yv23pnPJ7cF4omp0/Yf3F
P5/rA9GCsaYLhUgAvdNvtUYS5jTEN7R5kfwlhOuxv7kp4MgMhB3bcMxtdbeW6Qct
JJ523ABMaiCgiv4OAabDR8yKKTvcKwwPsRJSsXzT+1Hn5T2kvOiLKnhZtYWaQniP
zxFhORcLPaX3yq+SgPuymxUyouhqqenNjGdGKy4zTxSTpnB38ft0HuenRD8Nlj75
wsBFn4gP2AOu5mfVTiHhImjvaMaBkCLrOvEVkhYj3z0NUrDOkzr+EH1iVsuAy60L
ujzJsElluNrw1S0dhdGJx00Tw/MjmrizJmYaTwmDzyc8N6fCJYGMCsWpnJGTBjk4
NL3T4Q3MFAcOsaSQCF5oQ7xsz32zIGq/1kXN4412Ea28vDX2eemo1I/Qglff3EEu
GbBNHbva+R4DhXfFiWNV9IzzJmXQ6BXyGJgTF+4/O30SNvSQtT6TXCn9cfTJSMrf
dfCM7fwpaN5BKwqYVGHx0Bo8nla9MozFhYQTXihLMEpZu95Ig/cFJ6WqQB/Ck/b1
BZqfQoEPGXxlur8TJoip
=rkON
-----END PGP SIGNATURE-----

--/9ZOS6odDaRI+0hI--
