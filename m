Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3IZM64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:58:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43841 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756817Ab3IZM6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:58:55 -0400
Date: Thu, 26 Sep 2013 15:58:52 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
Message-ID: <20130926125852.GP2954@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
 <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
 <52436EBE.9010002@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Content-Disposition: inline
In-Reply-To: <52436EBE.9010002@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Wed, Sep 25, 2013 at 04:16:14PM -0700, Stephen Boyd wrote:
> On 09/25/13 07:03, Maxime Ripard wrote:
> > diff --git a/Documentation/devicetree/bindings/timer/allwinner,sun5i-a1=
3-hstimer.txt b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13=
-hstimer.txt
> > new file mode 100644
> > index 0000000..b1f81e9
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstim=
er.txt
> > @@ -0,0 +1,22 @@
> > +Allwinner SoCs High Speed Timer Controller
> > +
> > +Required properties:
> > +
> > +- compatible :	should be "allwinner,sun5i-a13-hstimer" or
> > +		"allwinner,sun7i-a20-hstimer"
> > +- reg : Specifies base physical address and size of the registers.
> > +- interrupts :	The interrupts of these timers (2 for the sun5i IP, 4 f=
or the sun7i
> > +		one)
> > +- clocks: phandle to the source clock (usually the AHB clock)
> > +
> > +Example:
> > +
> > +hstimer@01c60000 {
>=20
> This should just be 'timer@1c60000'

Ok.

> > +	compatible =3D "allwinner,sun7i-a20-hstimer";
> > +        reg =3D <0x01c60000 0x1000>;
> > +        interrupts =3D <0 51 1>,
> > +                     <0 52 1>,
> > +                     <0 53 1>,
> > +                     <0 54 1>;
> > +        clocks =3D <&ahb1_gates 19>;
> > +};
>=20
> Weird mix of tabs and spaces here.

Right.

> > +
> > +static void __iomem *timer_base;
> > +static u32 ticks_per_jiffy;
> > +
> > +/*
> > + * When we disable a timer, we need to wait at least for 2 cycles of
> > + * the timer source clock. We will use for that the clocksource timer
> > + * that is already setup and runs at the same frequency than the other
> > + * timers, and we never will be disabled.
> > + */
> > +static void sun5i_clkevt_sync(void)
> > +{
> > +	u32 old =3D readl(timer_base + TIMER_CNTVAL_LO_REG(1));
> > +
> > +	while ((old - readl(timer_base + TIMER_CNTVAL_LO_REG(1))) < 3)
> > +		cpu_relax();
> > +}
> > +
> [...]
> > +
> > +static int sun5i_clkevt_next_event(unsigned long evt,
> > +				   struct clock_event_device *unused)
> > +{
> > +	sun5i_clkevt_time_stop(0);
> > +	sun5i_clkevt_time_setup(0, evt);
> > +	sun5i_clkevt_time_start(0, false);
>=20
> I suppose the min delta wants to be 3 instead of 1 because if we program
> an evt one tick in the future first we'll wait for two ticks (or is that
> three?) while we stop the timer and then program the timer to fire one
> tick after that. Perhaps we should subtract two ticks from the evt as
> well when we program it here?

Hmmm, indeed.

> > +
> > +	return 0;
> > +}
> > +
> > +static struct clock_event_device sun5i_clockevent =3D {
> > +	.name =3D "sun5i_tick",
> > +	.rating =3D 350,
> > +	.features =3D CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> > +	.set_mode =3D sun5i_clkevt_mode,
> > +	.set_next_event =3D sun5i_clkevt_next_event,
> > +};
> > +
> > +
> > +static irqreturn_t sun5i_timer_interrupt(int irq, void *dev_id)
> > +{
> > +	struct clock_event_device *evt =3D (struct clock_event_device *)dev_i=
d;
> > +
> > +	writel(0x1, timer_base + TIMER_IRQ_ST_REG);
> > +	evt->event_handler(evt);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static struct irqaction sun5i_timer_irq =3D {
> > +	.name =3D "sun5i_timer0",
> > +	.flags =3D IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
>=20
> IRQF_DISABLED is a no-op and can be dropped.

Right.

> > +
> > +static u32 sun5i_timer_sched_read(void)
> > +{
> > +	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
> > +}
> > +
> > +static void __init sun5i_timer_init(struct device_node *node)
> > +{
> [...]
> > +
> > +	sun5i_clockevent.cpumask =3D cpumask_of(0);
>=20
> Can this timer interrupt any CPU or is it hardwired to CPU0? If the
> interrupt can go to any CPU this should be cpu_possible_mask instead.

This is an interrupt that can interrupt any CPU available on the system,
so yes, cpu_possible_mask would make sense.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRC+MAAoJEBx+YmzsjxAgP2gQAJ9PV8vse7cuJITfksJ+3xy3
79OF5AL+8Mwn11qEcBGOBoLinPH/CRf6dNMnPSTopEDb9jQRMNx4w+alKHocDcR6
/4gkLyifVG4wHiWaFgvOD+Knh/o66GaI67K7t/Ae7clFRxf1fGcFC9uEX6fkeVfz
QL4lYIlx1nvxSMep5iO/sxxHiHtE0lDSc3vxIVHXuQNWaKpRukNJOyNuL61Rg3Sv
bujZy7oR5znmvhaoWmE1AupnPBe69rw9I9NkS5EYQMbl+SNCyhAqGkckU5TWF1hf
tarWX7eSO5N0gkqpqnr18xSZEna4zh7jInmyWw3g13YKnoFrWinAndD5DMoyL29B
i68FmYeftccpGM6jw03CuwROfEEOucCxvm1EED8JrdXsqH1OOxeXkI0jEC4Ea9Ue
R+KHdAUiL5vQvRuDDAlpVKWKEbza6N5kZJkAQxOIeI+r50oeojZpMmJ9p7l66U6F
YSUEVhYMBa3q9ZLhU1mAMspw8NNFjfM4rTFFnZhYjWkopS6YXW9g6pVarnAV5vZ6
7K23hRDJImb0xIF/yHIPTtXeHhdiVYLWuKm1w4Nviz/giUJz3f8SqzQEe4uH9GWW
tO0tlMj6nyDufJC7/vHhoeMYDcNua42o6VM3O5Tohk8PnPQBKIn3N5rYlM4v/BTg
99dVtffvxntYHnWQKqe6
=+Vw2
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
