Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaKFUrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:47:32 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16096 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbaKFUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:47:30 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+K1igV3+6Jjnm6Px1mN/q
Date: Thu, 6 Nov 2014 12:46:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nishanth Menon <nm@ti.com>, lee.jones@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20141106204629.GF31454@atomide.com>
References: <1411067086-16613-1-git-send-email-nm@ti.com>
 <1411067086-16613-4-git-send-email-nm@ti.com>
 <alpine.DEB.2.10.1409181749170.4206@nanos>
 <20140919030333.GA6088@kahuna>
 <alpine.DEB.2.10.1409190710320.5612@nanos>
 <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos>
 <20140919191649.GQ14505@atomide.com>
 <alpine.DEB.2.10.1409191233590.4213@nanos>
 <20141002034345.GH3122@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002034345.GH3122@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Any comments on the patch below? Let me know if you want to keep the
devm stuff out of kernel/irq/manage.c.

* Tony Lindgren <tony@atomide.com> [141001 20:45]:
> Hi Thomas,
> 
> * Thomas Gleixner <tglx@linutronix.de> [140919 12:47]:
> > 
> > The wakeup handler is supposed to bring the thing out of deep sleep
> > and nothing else. All you want it to do is to mask itself and save the
> > information that the real device irq is pending.
> > 
> > A stub handler for the wakeup irq is enough. We can have that in the
> > irq/pm core and all it would do is simply:
> 
> Here's a patch along the lines of what you described, hopefully that's
> fairly close to what you had in mind.
> 
> I also did play with the replaying of the interrupts but I don't think
> that's needed. Well at least not for the omap case. I added some
> comments about that to the code.
> 
> So far I've tested with the omap-serial and omap_hsmmc drivers. The
> serial driver does not have any status as the device is powered off.
> So replaying of the interrupt does not help there, we need to wait for
> the next event anyways.
> 
> Then with omap_hsmmc the SDIO interrupt on dat1 line is level
> sensitive and is noticed after the MMC controller is powered on
> again. So no replaying of the device interrupt needed here either.
> 
> I still have not tested the MMC remux lines to GPIO for wake-up
> events that's also needed for some omaps.
> 
> Regards,
> 
> Tony
> 
> 8<-----------
> From: Tony Lindgren <tony@atomide.com>
> Date: Wed, 1 Oct 2014 14:56:35 -0700
> Subject: [PATCH] genirq: Add support for wake-up interrupts to fix irq reentry issues in drivers
> 
> As pointed out by Thomas Gleixner, at least omap wake-up interrupts
> have an issue with re-entrant interrupts because the wake-up interrupts
> are now handled as a secondary interrupt controller. Further, the
> wake-up interrupt just needs wake the system at least for omaps. So we
> should just make the wake-up interrupt handling generic.
> 
> Note that at least initially we are keeping things simple by assuming the
> wake-up interrupt is level sensitive, and the device pm_runtime_resume()
> can deal with the situation, and no replaying of the lost device interrupts
> is needed.
> 
> After tinkering with replaying of the lost device interrupts, my opinion is
> that it should be avoided because of the issues listed in the comments of
> this patch.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -139,11 +139,15 @@ extern int __must_check
>  request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  		   const char *devname, void __percpu *percpu_dev_id);
>  
> +struct device;
> +
> +extern int __must_check
> +request_wake_irq(struct device *dev, unsigned int wakeirq,
> +		 unsigned long irqflags);
> +
>  extern void free_irq(unsigned int, void *);
>  extern void free_percpu_irq(unsigned int, void __percpu *);
>  
> -struct device;
> -
>  extern int __must_check
>  devm_request_threaded_irq(struct device *dev, unsigned int irq,
>  			  irq_handler_t handler, irq_handler_t thread_fn,
> @@ -163,6 +167,10 @@ devm_request_any_context_irq(struct device *dev, unsigned int irq,
>  		 irq_handler_t handler, unsigned long irqflags,
>  		 const char *devname, void *dev_id);
>  
> +extern int __must_check
> +devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
> +		      unsigned long irqflags);
> +
>  extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
>  
>  /*
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -14,6 +14,7 @@
>  #include <linux/module.h>
>  #include <linux/random.h>
>  #include <linux/interrupt.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/sched/rt.h>
> @@ -1578,6 +1579,111 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
>  }
>  EXPORT_SYMBOL_GPL(request_any_context_irq);
>  
> +/**
> + *	handle_wakeirq_thread - call device runtime pm calls on wake-up interrupt
> + *	@wakeirq: device specific wake-up interrupt
> + *	@dev_id: struct device entry
> + */
> +static irqreturn_t handle_wakeirq_thread(int wakeirq, void *dev_id)
> +{
> +	struct device *dev = dev_id;
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	if (pm_runtime_suspended(dev)) {
> +		pm_runtime_mark_last_busy(dev);
> +		pm_request_resume(dev);
> +		ret = IRQ_HANDLED;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + *	setup_wakeirq - allocate a wake-up interrupt for a device
> + *	@dev: device to wake up
> + *	@wakeirq: interrupt that wakes up the device
> + *	@wakeflags: flags to pass to the interrupt handler
> + *	@devm: use devm
> + *
> + *	Note that the wake-up interrupt starts disabled. The wake-up interrupt
> + *	is typically enabled from the device pm_runtime_suspend() and disabled
> + *	again in the device pm_runtime_resume(). For runtime PM, the wake-up
> + *	interrupt should be always enabled, and for device suspend and resume,
> + *	the wake-up interrupt should be enabled depending on the device specific
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
> + *	So if replaying the lost device interrupts is absolutely needed from the
> + *	hardware point of view, it's probably best to set up a completely
> + *	separate wake-up interrupt handler for the wake-up interrupt in the
> + *	device driver because of the reasons above.
> + */
> +static int setup_wakeirq(struct device *dev, unsigned int wakeirq,
> +			 unsigned long wakeflags, bool devm)
> +{
> +	int ret;
> +
> +	if (!(dev && wakeirq)) {
> +		pr_err("Missing device or wakeirq for %s irq %d\n",
> +		       dev_name(dev), wakeirq);
> +		return -EINVAL;
> +	}
> +
> +	if (!(wakeflags &
> +	      (IRQF_TRIGGER_LOW | IRQF_TRIGGER_HIGH | IRQF_ONESHOT))) {
> +		pr_err("Invalid wakeirq for %s irq %d, must be level oneshot\n",
> +		       dev_name(dev), wakeirq);
> +		return -EINVAL;
> +	}
> +
> +	irq_set_status_flags(wakeirq, _IRQ_NOAUTOEN);
> +
> +	if (devm)
> +		ret = devm_request_threaded_irq(dev, wakeirq, NULL,
> +						handle_wakeirq_thread,
> +						wakeflags, dev_name(dev), dev);
> +	else
> +		ret = request_threaded_irq(wakeirq, NULL,
> +					   handle_wakeirq_thread,
> +					   wakeflags, dev_name(dev), dev);
> +
> +	return ret;
> +}
> +
> +int request_wake_irq(struct device *dev, unsigned int wakeirq,
> +		     unsigned long wakeflags)
> +{
> +	return setup_wakeirq(dev, wakeirq, wakeflags, false);
> +}
> +EXPORT_SYMBOL(request_wake_irq);
> +
> +int devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
> +			  unsigned long wakeflags)
> +{
> +	return setup_wakeirq(dev, wakeirq, wakeflags, false);
> +}
> +EXPORT_SYMBOL(devm_request_wake_irq);
> +
>  void enable_percpu_irq(unsigned int irq, unsigned int type)
>  {
>  	unsigned int cpu = smp_processor_id();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
