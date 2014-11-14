Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935275AbaKNQT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:19:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54372 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934046AbaKNQTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:19:25 -0500
Date: Fri, 14 Nov 2014 10:19:10 -0600
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Nishanth Menon <nm@ti.com>,
        <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20141114161901.GG11538@saruman>
Reply-To: <balbi@ti.com>
References: <20140919030333.GA6088@kahuna>
 <alpine.DEB.2.10.1409190710320.5612@nanos>
 <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos>
 <20140919191649.GQ14505@atomide.com>
 <alpine.DEB.2.10.1409191233590.4213@nanos>
 <20141002034345.GH3122@atomide.com>
 <20141106204629.GF31454@atomide.com>
 <alpine.DEB.2.11.1411131053050.3935@nanos>
 <20141113174030.GM26481@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCwQ2Y43eQY6RBgR"
Content-Disposition: inline
In-Reply-To: <20141113174030.GM26481@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rCwQ2Y43eQY6RBgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 13, 2014 at 09:40:31AM -0800, Tony Lindgren wrote:

[snip]

> From: Tony Lindgren <tony@atomide.com>
> Date: Tue, 11 Nov 2014 07:53:55 -0800
> Subject: [PATCH] genirq: Add support for wake-up interrupts to fix irq re=
entry issues in drivers
>=20
> As pointed out by Thomas Gleixner, at least omap wake-up interrupts
> have an issue with re-entrant interrupts because the wake-up interrupts
> are now handled as a secondary interrupt controller. Further, the
> wake-up interrupt just needs wake the system at least for omaps. So we
> should make the wake-up interrupt handling generic.
>=20
> Note that at least initially we are keeping things simple by assuming the
> wake-up interrupt is level sensitive, and the device pm_runtime_resume()
> can deal with the situation, and no replaying of the lost device interrup=
ts
> is needed.
>=20
> After tinkering with replaying of the lost device interrupts, my opinion =
is
> that it should be avoided because of the issues listed in the comments of
> this patch.
>=20
> Let's also add a minimal manage.h to allow us keeping the separation
> of devm functions and without having to include internals.h in devres.c.
>=20
> Signed-off-by: Tony Lindgren <tony@atomide.com>
>=20
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -139,11 +139,15 @@ extern int __must_check
>  request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  		   const char *devname, void __percpu *percpu_dev_id);
> =20
> +struct device;
> +
> +extern int __must_check
> +request_wake_irq(struct device *dev, unsigned int wakeirq,
> +		 unsigned long irqflags);
> +
>  extern void free_irq(unsigned int, void *);
>  extern void free_percpu_irq(unsigned int, void __percpu *);
> =20
> -struct device;
> -
>  extern int __must_check
>  devm_request_threaded_irq(struct device *dev, unsigned int irq,
>  			  irq_handler_t handler, irq_handler_t thread_fn,
> @@ -163,6 +167,10 @@ devm_request_any_context_irq(struct device *dev, uns=
igned int irq,
>  		 irq_handler_t handler, unsigned long irqflags,
>  		 const char *devname, void *dev_id);
> =20
> +extern int __must_check
> +devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
> +		      unsigned long irqflags);
> +
>  extern void devm_free_irq(struct device *dev, unsigned int irq, void *de=
v_id);
> =20
>  /*
> --- a/kernel/irq/devres.c
> +++ b/kernel/irq/devres.c
> @@ -3,6 +3,8 @@
>  #include <linux/device.h>
>  #include <linux/gfp.h>
> =20
> +#include "manage.h"
> +
>  /*
>   * Device resource management aware IRQ request/free implementation.
>   */
> @@ -118,6 +120,30 @@ int devm_request_any_context_irq(struct device *dev,=
 unsigned int irq,
>  EXPORT_SYMBOL(devm_request_any_context_irq);
> =20
>  /**
> + *	devm_request_wake_irq - request a wake-up interrupt for a device
> + *	@dev: device to wake on the wake-up interrupt
> + *	@wakeirq: wake-up interrupt for the device
> + *	@wakeirq: wake-up interrupt flags
> + *
> + *	The wake-up interrupt starts disabled and is typically enabled
> + *	when needed by the device driver runtime PM calls.
> + */
> +int devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
> +			  unsigned long wakeflags)
> +{
> +	int ret;
> +
> +	ret =3D init_disabled_wakeirq(dev, wakeirq, wakeflags);
> +	if (ret)
> +		return ret;
> +
> +	return devm_request_threaded_irq(dev, wakeirq, NULL,
> +					 handle_wakeirq_thread,
> +					 wakeflags, dev_name(dev), dev);
> +}
> +EXPORT_SYMBOL_GPL(devm_request_wake_irq);
> +
> +/**
>   *	devm_free_irq - free an interrupt
>   *	@dev: device to free interrupt for
>   *	@irq: Interrupt line to free
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -14,12 +14,14 @@
>  #include <linux/module.h>
>  #include <linux/random.h>
>  #include <linux/interrupt.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/sched/rt.h>
>  #include <linux/task_work.h>
> =20
>  #include "internals.h"
> +#include "manage.h"
> =20
>  #ifdef CONFIG_IRQ_FORCED_THREADING
>  __read_mostly bool force_irqthreads;
> @@ -1564,6 +1566,112 @@ int request_any_context_irq(unsigned int irq, irq=
_handler_t handler,
>  }
>  EXPORT_SYMBOL_GPL(request_any_context_irq);
> =20
> +/**
> + *	handle_wakeirq_thread - call device runtime pm calls on wake-up inter=
rupt
> + *	@wakeirq: device specific wake-up interrupt
> + *	@dev_id: struct device entry
> + */
> +irqreturn_t handle_wakeirq_thread(int wakeirq, void *dev_id)
> +{
> +	struct device *dev =3D dev_id;
> +	irqreturn_t ret =3D IRQ_NONE;
> +
> +	if (pm_runtime_suspended(dev)) {
> +		pm_runtime_mark_last_busy(dev);
> +		pm_request_resume(dev);

this assumes that every driver's ->resume() callback has a:

	if (pending)
		handle_pending_irqs();

which might not be very nice. I'd rather follow what Thomas suggested
and always pass device irq so this can mark it pending. Keep in mind
that we *don't* need a pm_runtime_get_sync() in every IRQ handler
because of that. Adding it is but the easiest way to get things working
and, quite frankly, very silly.

what we want is rather:

	irqreturn_t my_handler(int irq, void *dev_id)
	{
		struct device *dev =3D dev_id;

		if (pm_runtime_suspended(dev)) {
			pending_irqs_to_be_handled_from_runtime_resume =3D true;
			pm_runtime_get(dev);
			clear_irq_source(dev);
			return IRQ_HANDLED;
		}
	}

or something similar.

> +		ret =3D IRQ_HANDLED;
> +	}

you're not masking the wake irq here which means that when this handler
returns, wake irq will be unmasked by core IRQ subsystem leaving it
unmasked after ->resume().

> +	return ret;
> +}
> +
> +/**
> + *	init_disabled_wakeirq - initialize a wake-up interrupt for a device
> + *	@dev: device to wake up on the wake-up interrupt
> + *	@wakeirq: wake-up interrupt for the device
> + *	@wakeflags: wake-up interrupt flags
> + *
> + *	Note that the wake-up interrupt starts disabled. The wake-up interrupt
> + *	is typically enabled from the device pm_runtime_suspend() and disabled
> + *	again in the device pm_runtime_resume(). For runtime PM, the wake-up
> + *	interrupt should be always enabled, and for device suspend and resume,
> + *	the wake-up interrupt should be enabled depending on the device speci=
fic
> + *	configuration for device_can_wakeup().
> + *
> + *	Note also that we are not resending the lost device interrupts.
> + *	We assume that the wake-up interrupt just needs to wake-up the device,
> + *	and then device pm_runtime_resume() can deal with the situation.
> + *
> + *	There are at least the following reasons to not resend the lost device
> + *	interrupts automatically based on the wake-up interrupt:
> + *
> + *	1. There can be interrupt reentry issues calling the device interrupt
> + *	   based on the wake-up interrupt if done in the device driver. It
> + *	   could be done with check_irq_resend() after checking the device
> + *	   interrupt mask if we really wanted to though.
> + *
> + *	2. The device interrupt handler would need to be set up properly with
> + *	   pm_runtime_irq_safe(). Ideally you don't want to call pm_runtime
> + *	   calls from the device interrupt handler at all.
> + *
> + *	3. The IRQ subsystem may not know if it's safe to call the device
> + *	   interrupt unless the driver updates the interrupt status with
> + *	   disable_irq() and enable_irq() in addition to just disabling the
> + *	   interrupt at the hardware level in the device registers.
> + *
> + *	So if replaying the lost device interrupts is absolutely needed from =
the
> + *	hardware point of view, it's probably best to set up a completely
> + *	separate wake-up interrupt handler for the wake-up interrupt in the
> + *	device driver because of the reasons above.
> + */
> +int init_disabled_wakeirq(struct device *dev, unsigned int wakeirq,
> +			  unsigned long wakeflags)
> +{
> +	if (!(dev && wakeirq)) {
> +		pr_err("Missing device or wakeirq for %s irq %d\n",
> +		       dev_name(dev), wakeirq);
> +		return -EINVAL;
> +	}
> +
> +	if (!(wakeflags & IRQF_ONESHOT)) {
> +		pr_err("Invalid wakeirq for %s irq %d, must be oneshot\n",
> +		       dev_name(dev), wakeirq);
> +		return -EINVAL;
> +	}

you *know* you'll pass a NULL top half handler, why don't you just force
IRQF_ONESHOT instead of erroring out ? Just add:

	wakeflags |=3D IRQF_ONESHOT;

and get it over with :-)

> +	if (wakeflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))
> +		pr_warn("Not replaying device IRQs for %s on wakeirq%d\n",
> +			dev_name(dev), wakeirq);
> +
> +	irq_set_status_flags(wakeirq, _IRQ_NOAUTOEN);
> +
> +	return 0;
> +}
> +
> +/**
> + *	request_wake_irq - request a wake-up interrupt for a device
> + *	@dev: device to wake on the wake-up interrupt
> + *	@wakeirq: wake-up interrupt for the device
> + *	@wakeirq: wake-up interrupt flags
> + *
> + *	The wake-up interrupt starts disabled and is typically enabled
> + *	when needed by the device driver runtime PM calls.
> + */
> +int request_wake_irq(struct device *dev, unsigned int wakeirq,
> +		     unsigned long wakeflags)
> +{
> +	int ret;
> +
> +	ret =3D init_disabled_wakeirq(dev, wakeirq, wakeflags);
> +	if (ret)
> +		return ret;
> +
> +	return request_threaded_irq(wakeirq, NULL,
> +				    handle_wakeirq_thread,
> +				    wakeflags, dev_name(dev), dev);
> +}
> +EXPORT_SYMBOL_GPL(request_wake_irq);
> +
>  void enable_percpu_irq(unsigned int irq, unsigned int type)
>  {
>  	unsigned int cpu =3D smp_processor_id();
> --- /dev/null
> +++ b/kernel/irq/manage.h
> @@ -0,0 +1,11 @@
> +/*
> + * IRQ subsystem internal management functions and variables:
> + *
> + * Do not ever include this file from anything else than
> + * kernel/irq/. Do not even think about using any information outside
> + * of this file for your non core code.
> + */
> +
> +irqreturn_t handle_wakeirq_thread(int wakeirq, void *dev_id);
> +int init_disabled_wakeirq(struct device *dev, unsigned int wakeirq,
> +			  unsigned long wakeflags);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--rCwQ2Y43eQY6RBgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZit+AAoJEIaOsuA1yqREBUsQAKAejs/8d7lHTwLz8VEOx2yw
VVG5JeWgjsTwxem2LAEoNY+T9dpnJOAv3ywnrqn+o9Q08n0NeeRPhRY0cGNUTkeR
F1HM3kqH9iZD+6P1ss/BmAY1pkVjggqZi74LTbrqXItOBpuRRvU83Yn/4XeUlQyO
ffAJGDa+ZHpv0P7kS49sbibWstg3SyRzkTHUxZrn+ZyhO27yo1T6VzPhS4vnpk9E
Wzl9TTG6NlEcD66Xw/1NbG0+0HJEGqaZbb738pI3GCWUKgsGuWPBmG/gcKQcXWuq
AB4EWG4bnkdIgdBXOCkhxunFuFdxzipRMq8wceZaEcNJuno8jxtSLn14tYGaQxXZ
bcTKwvrLqPwJ/NxFin2Ax8yWiacsMm5B+R/EabAjRJIoYNL5VRoNkbxv/nrF5QCU
i5CrOKntCA3uBPTs20BZlhC73Lw/Pu+6nWl2ZbpadWBaXgCTFpiVOxFBuMTYzDVl
5ualDuetqikJkrviRD3oySIX9kiLgUGQ/0Y8y8unvrpZHjWvPDiiUaMDrx65nwvt
MBQSV0+p6wqoCVBBFRevmfq0fg4R3p+Nil3KFQwxQZl8m/sysHOh7yToqXwddcfc
Kwr+o794friQrT7tGl0cKijz/pg5PwS3xC+WD5dQyYyiJx3jI6YhdsoSfqvA1tmn
WZzPVREKn7IZcssJpC9/
=Mmir
-----END PGP SIGNATURE-----

--rCwQ2Y43eQY6RBgR--
