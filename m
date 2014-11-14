Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161600AbaKNRWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:22:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52264 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161017AbaKNRWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:22:09 -0500
Date: Fri, 14 Nov 2014 11:21:57 -0600
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Nishanth Menon <nm@ti.com>, <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-omap@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20141114172157.GI11538@saruman>
Reply-To: <balbi@ti.com>
References: <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos>
 <20140919191649.GQ14505@atomide.com>
 <alpine.DEB.2.10.1409191233590.4213@nanos>
 <20141002034345.GH3122@atomide.com>
 <20141106204629.GF31454@atomide.com>
 <alpine.DEB.2.11.1411131053050.3935@nanos>
 <20141113174030.GM26481@atomide.com>
 <20141114161901.GG11538@saruman>
 <20141114170816.GW26481@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRtZRu2mMGBZ6YQ7"
Content-Disposition: inline
In-Reply-To: <20141114170816.GW26481@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wRtZRu2mMGBZ6YQ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 09:08:17AM -0800, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [141114 08:20]:
> > On Thu, Nov 13, 2014 at 09:40:31AM -0800, Tony Lindgren wrote:
> > > +/**
> > > + *	handle_wakeirq_thread - call device runtime pm calls on wake-up i=
nterrupt
> > > + *	@wakeirq: device specific wake-up interrupt
> > > + *	@dev_id: struct device entry
> > > + */
> > > +irqreturn_t handle_wakeirq_thread(int wakeirq, void *dev_id)
> > > +{
> > > +	struct device *dev =3D dev_id;
> > > +	irqreturn_t ret =3D IRQ_NONE;
> > > +
> > > +	if (pm_runtime_suspended(dev)) {
> > > +		pm_runtime_mark_last_busy(dev);
> > > +		pm_request_resume(dev);
> >=20
> > this assumes that every driver's ->resume() callback has a:
> >=20
> > 	if (pending)
> > 		handle_pending_irqs();
> >=20
> > which might not be very nice. I'd rather follow what Thomas suggested
> > and always pass device irq so this can mark it pending. Keep in mind
> > that we *don't* need a pm_runtime_get_sync() in every IRQ handler
> > because of that. Adding it is but the easiest way to get things working
> > and, quite frankly, very silly.
> >=20
> > what we want is rather:
> >=20
> > 	irqreturn_t my_handler(int irq, void *dev_id)
> > 	{
> > 		struct device *dev =3D dev_id;
> >=20
> > 		if (pm_runtime_suspended(dev)) {
> > 			pending_irqs_to_be_handled_from_runtime_resume =3D true;
> > 			pm_runtime_get(dev);
> > 			clear_irq_source(dev);
> > 			return IRQ_HANDLED;
> > 		}
> > 	}
> >=20
> > or something similar.
>=20
> Yeah I'll take a look.

note that at the end of the day, the outcome will be pretty similar, but
with the added benefit that current users of pm_runtime_irq_safe() can
be updated as time allows, rather than in one go.

> > > +		ret =3D IRQ_HANDLED;
> > > +	}
> >=20
> > you're not masking the wake irq here which means that when this handler
> > returns, wake irq will be unmasked by core IRQ subsystem leaving it
> > unmasked after ->resume().
>=20
> It currently assumes the consumer driver takes care of it. But I get
> your point, we should be able to automate this further.

right, consumer calls disable_irq() and that's fine, should be there
anyway, but currently you still have a window where wakeirq will be
unmasked, if you look at irq_finalize_oneshot(), it's easy to see that
it will unmask wakeirq after ->thread_fn() runs:

686 static void irq_finalize_oneshot(struct irq_desc *desc,
687                                  struct irqaction *action)
688 {

[...]

726         if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_dat=
a) &&
727		irqd_irq_masked(&desc->irq_data))
728			unmask_threaded_irq(desc);
729=20
730 out_unlock:
731	raw_spin_unlock_irq(&desc->lock);
732	chip_bus_sync_unlock(desc);
733 }

[...]

800 static irqreturn_t irq_thread_fn(struct irq_desc *desc,
801                 struct irqaction *action)
802 {
803         irqreturn_t ret;
804=20
805         ret =3D action->thread_fn(action->irq, action->dev_id);
806         irq_finalize_oneshot(desc, action);
807         return ret;
808 }

so, ->thread_fn() returns and wakeirq is unmasked. You don't know when
your ->runtime_resume() will be scheduled, which means that wakeirq
could be unmasked for quite a while and it could refire depending on PCB
layout.

The problem should be minimal, but it's there anyway. Also, you know
that once the runtime is resumed, you don't want wakeirq to be unmasked,
so why not just mask it from handle_wake_irq() ?

Another thing, this assumes that drivers are using pm_runtime and,
furthermore, it assumes that drivers' ->runtime_resume() will properly
handle pending IRQs. This is definitely not the case for most drivers.

Note that quite a few of them aren't either using pm_runtime or have
blank/NULL runtime callbacks.

Due to these, I think Thomas' suggestion of setting device IRQ pending
is the best solution. That takes care of all cases. If drivers are using
pm_runtime, then they are required to check if device is still
pm_runtime_suspended from IRQ handler, for those who aren't, they can
assume device is ready to handle IRQs once the IRQ handler is called.

> And right now there's also a dependency on dev->power.irq_safe so
> RPM_ASYNC is not set. And this all should ideally work even with runtime
> PM not set as it's also needed for resume from suspend.

exactly.

--=20
balbi

--wRtZRu2mMGBZ6YQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZjo1AAoJEIaOsuA1yqREO4oQAIdjlSa9ofEBV7L4T7IR7CW2
H8WHsFk13Ta407wVcm2mX3BbkxSlCk5+52nFEvUHTD6llSjYrP8Kio6YXs3akb8p
Jawu9y3wBd8gwkyhebprO2ddclW9PiSQZDPMGu8193wCRhAoJtxg3f0BWZPnQ2dg
INC1OHdDfTA7JyDHDbXjFnFOALYPr3Td7m9m+BVp9QQ722aSZPK/AoixMKf8HVJE
W/JMprOswxM66k2+CciwT71bBK97Qf4+TcNhm7+55oQqyiFA8FQyiaIT1vaHP77B
fbCjd/AzyCKt3Qe/8wiMyd4QtU0xbz8CqouTYui98RdlCLx47HN2du0DaWW4uDXK
Mz1mpvRiVx3jS6SwL7vppGLx3pKxWzXwb6flCAvTP4cYDP6o9qfz4C6rJv1Yxx+G
12XOiuXQOuMX+XBUjsQg/ghW+G/dHicyREXUeHW4pdDVxmHECXTC7WuNdb8Ft0nO
/mxcN2AbAkqh0G8a//nft8vXKd3c7MUU+IWtBEYxM6ffSDscdHSfuzy+L0BFC4CZ
CBlPxtEOQOIPhnV/LnKKmf77zat50AQNUSiRuoRJVJCOsB9i4ck2R0nRBvizeZzy
+MLjlkRdfbGJVfckc+LlfI4Fi1i8cayteP8umExCcxh8sY/oxQ4lWO/IbiaQToP1
G40PYns3vabOuFkVkKdI
=ZGD6
-----END PGP SIGNATURE-----

--wRtZRu2mMGBZ6YQ7--
