Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaKMRlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:41:13 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62664 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932596AbaKMRlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:41:11 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JSMKWk4ftQ4ngEzunhUuW
Date: Thu, 13 Nov 2014 09:40:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nishanth Menon <nm@ti.com>, lee.jones@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20141113174030.GM26481@atomide.com>
References: <alpine.DEB.2.10.1409181749170.4206@nanos>
 <20140919030333.GA6088@kahuna>
 <alpine.DEB.2.10.1409190710320.5612@nanos>
 <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos>
 <20140919191649.GQ14505@atomide.com>
 <alpine.DEB.2.10.1409191233590.4213@nanos>
 <20141002034345.GH3122@atomide.com>
 <20141106204629.GF31454@atomide.com>
 <alpine.DEB.2.11.1411131053050.3935@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411131053050.3935@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [141113 02:04]:
> Tony,
> 
> On Thu, 6 Nov 2014, Tony Lindgren wrote:
> > 
> > Any comments on the patch below? Let me know if you want to keep the
> > devm stuff out of kernel/irq/manage.c.
> 
> Sorry, this slipped through the cracks.

No problem I should have posted it as a separate thread anyways.
  
> > > +static int setup_wakeirq(struct device *dev, unsigned int wakeirq,
> > > +			 unsigned long wakeflags, bool devm)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (!(dev && wakeirq)) {
> > > +		pr_err("Missing device or wakeirq for %s irq %d\n",
> > > +		       dev_name(dev), wakeirq);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (!(wakeflags &
> > > +	      (IRQF_TRIGGER_LOW | IRQF_TRIGGER_HIGH | IRQF_ONESHOT))) {
> > > +		pr_err("Invalid wakeirq for %s irq %d, must be level oneshot\n",
> > > +		       dev_name(dev), wakeirq);
> 
> This looks odd.
> 
> Why do you want to enforce LEVEL and ONESHOT?  I can see the point for
> ONESHOT, but I'm wondering about the requirement for level.
> 
> Now if you really want to enforce level AND oneshot, your check is
> wrong as it will not trigger on
> 
>       wakeflags = IRQF_TRIGGER_LOW;
>       wakeflags = IRQF_TRIGGER_HIGH;
>       wakeflags = IRQF_ONESHOT;
> 
> Not what you really want, right?

Hmm yes that's right. I've just added a warning about not replaying
device interrupts in case somebody passes EDGE. Not sure how useful
that is, but might get somebody to add more features if really needed.

> > > +int request_wake_irq(struct device *dev, unsigned int wakeirq,
> > > +		     unsigned long wakeflags)
> > > +{
> > > +	return setup_wakeirq(dev, wakeirq, wakeflags, false);
> > > +}
> > > +EXPORT_SYMBOL(request_wake_irq);
> 
>   _GPL please

Sure.
 
> > > +
> > > +int devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
> > > +			  unsigned long wakeflags)
> > > +{
> > > +	return setup_wakeirq(dev, wakeirq, wakeflags, false);
> 
> Shouldnt that have devm = true?

Oops thanks for catching that. As the devres stuff is separate, I've
updated the patch to keep it that way by adding a minimal manage.h.
This avoids including internals.h in devres.c. Does that seem usable
for you?

Regards,

Tony

8< -----------------
From: Tony Lindgren <tony@atomide.com>
Date: Tue, 11 Nov 2014 07:53:55 -0800
Subject: [PATCH] genirq: Add support for wake-up interrupts to fix irq reentry issues in drivers

As pointed out by Thomas Gleixner, at least omap wake-up interrupts
have an issue with re-entrant interrupts because the wake-up interrupts
are now handled as a secondary interrupt controller. Further, the
wake-up interrupt just needs wake the system at least for omaps. So we
should make the wake-up interrupt handling generic.

Note that at least initially we are keeping things simple by assuming the
wake-up interrupt is level sensitive, and the device pm_runtime_resume()
can deal with the situation, and no replaying of the lost device interrupts
is needed.

After tinkering with replaying of the lost device interrupts, my opinion is
that it should be avoided because of the issues listed in the comments of
this patch.

Let's also add a minimal manage.h to allow us keeping the separation
of devm functions and without having to include internals.h in devres.c.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -139,11 +139,15 @@ extern int __must_check
 request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		   const char *devname, void __percpu *percpu_dev_id);
 
+struct device;
+
+extern int __must_check
+request_wake_irq(struct device *dev, unsigned int wakeirq,
+		 unsigned long irqflags);
+
 extern void free_irq(unsigned int, void *);
 extern void free_percpu_irq(unsigned int, void __percpu *);
 
-struct device;
-
 extern int __must_check
 devm_request_threaded_irq(struct device *dev, unsigned int irq,
 			  irq_handler_t handler, irq_handler_t thread_fn,
@@ -163,6 +167,10 @@ devm_request_any_context_irq(struct device *dev, unsigned int irq,
 		 irq_handler_t handler, unsigned long irqflags,
 		 const char *devname, void *dev_id);
 
+extern int __must_check
+devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
+		      unsigned long irqflags);
+
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
 /*
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -3,6 +3,8 @@
 #include <linux/device.h>
 #include <linux/gfp.h>
 
+#include "manage.h"
+
 /*
  * Device resource management aware IRQ request/free implementation.
  */
@@ -118,6 +120,30 @@ int devm_request_any_context_irq(struct device *dev, unsigned int irq,
 EXPORT_SYMBOL(devm_request_any_context_irq);
 
 /**
+ *	devm_request_wake_irq - request a wake-up interrupt for a device
+ *	@dev: device to wake on the wake-up interrupt
+ *	@wakeirq: wake-up interrupt for the device
+ *	@wakeirq: wake-up interrupt flags
+ *
+ *	The wake-up interrupt starts disabled and is typically enabled
+ *	when needed by the device driver runtime PM calls.
+ */
+int devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
+			  unsigned long wakeflags)
+{
+	int ret;
+
+	ret = init_disabled_wakeirq(dev, wakeirq, wakeflags);
+	if (ret)
+		return ret;
+
+	return devm_request_threaded_irq(dev, wakeirq, NULL,
+					 handle_wakeirq_thread,
+					 wakeflags, dev_name(dev), dev);
+}
+EXPORT_SYMBOL_GPL(devm_request_wake_irq);
+
+/**
  *	devm_free_irq - free an interrupt
  *	@dev: device to free interrupt for
  *	@irq: Interrupt line to free
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -14,12 +14,14 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
 #include <linux/task_work.h>
 
 #include "internals.h"
+#include "manage.h"
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 __read_mostly bool force_irqthreads;
@@ -1564,6 +1566,112 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
 }
 EXPORT_SYMBOL_GPL(request_any_context_irq);
 
+/**
+ *	handle_wakeirq_thread - call device runtime pm calls on wake-up interrupt
+ *	@wakeirq: device specific wake-up interrupt
+ *	@dev_id: struct device entry
+ */
+irqreturn_t handle_wakeirq_thread(int wakeirq, void *dev_id)
+{
+	struct device *dev = dev_id;
+	irqreturn_t ret = IRQ_NONE;
+
+	if (pm_runtime_suspended(dev)) {
+		pm_runtime_mark_last_busy(dev);
+		pm_request_resume(dev);
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
+/**
+ *	init_disabled_wakeirq - initialize a wake-up interrupt for a device
+ *	@dev: device to wake up on the wake-up interrupt
+ *	@wakeirq: wake-up interrupt for the device
+ *	@wakeflags: wake-up interrupt flags
+ *
+ *	Note that the wake-up interrupt starts disabled. The wake-up interrupt
+ *	is typically enabled from the device pm_runtime_suspend() and disabled
+ *	again in the device pm_runtime_resume(). For runtime PM, the wake-up
+ *	interrupt should be always enabled, and for device suspend and resume,
+ *	the wake-up interrupt should be enabled depending on the device specific
+ *	configuration for device_can_wakeup().
+ *
+ *	Note also that we are not resending the lost device interrupts.
+ *	We assume that the wake-up interrupt just needs to wake-up the device,
+ *	and then device pm_runtime_resume() can deal with the situation.
+ *
+ *	There are at least the following reasons to not resend the lost device
+ *	interrupts automatically based on the wake-up interrupt:
+ *
+ *	1. There can be interrupt reentry issues calling the device interrupt
+ *	   based on the wake-up interrupt if done in the device driver. It
+ *	   could be done with check_irq_resend() after checking the device
+ *	   interrupt mask if we really wanted to though.
+ *
+ *	2. The device interrupt handler would need to be set up properly with
+ *	   pm_runtime_irq_safe(). Ideally you don't want to call pm_runtime
+ *	   calls from the device interrupt handler at all.
+ *
+ *	3. The IRQ subsystem may not know if it's safe to call the device
+ *	   interrupt unless the driver updates the interrupt status with
+ *	   disable_irq() and enable_irq() in addition to just disabling the
+ *	   interrupt at the hardware level in the device registers.
+ *
+ *	So if replaying the lost device interrupts is absolutely needed from the
+ *	hardware point of view, it's probably best to set up a completely
+ *	separate wake-up interrupt handler for the wake-up interrupt in the
+ *	device driver because of the reasons above.
+ */
+int init_disabled_wakeirq(struct device *dev, unsigned int wakeirq,
+			  unsigned long wakeflags)
+{
+	if (!(dev && wakeirq)) {
+		pr_err("Missing device or wakeirq for %s irq %d\n",
+		       dev_name(dev), wakeirq);
+		return -EINVAL;
+	}
+
+	if (!(wakeflags & IRQF_ONESHOT)) {
+		pr_err("Invalid wakeirq for %s irq %d, must be oneshot\n",
+		       dev_name(dev), wakeirq);
+		return -EINVAL;
+	}
+
+	if (wakeflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))
+		pr_warn("Not replaying device IRQs for %s on wakeirq%d\n",
+			dev_name(dev), wakeirq);
+
+	irq_set_status_flags(wakeirq, _IRQ_NOAUTOEN);
+
+	return 0;
+}
+
+/**
+ *	request_wake_irq - request a wake-up interrupt for a device
+ *	@dev: device to wake on the wake-up interrupt
+ *	@wakeirq: wake-up interrupt for the device
+ *	@wakeirq: wake-up interrupt flags
+ *
+ *	The wake-up interrupt starts disabled and is typically enabled
+ *	when needed by the device driver runtime PM calls.
+ */
+int request_wake_irq(struct device *dev, unsigned int wakeirq,
+		     unsigned long wakeflags)
+{
+	int ret;
+
+	ret = init_disabled_wakeirq(dev, wakeirq, wakeflags);
+	if (ret)
+		return ret;
+
+	return request_threaded_irq(wakeirq, NULL,
+				    handle_wakeirq_thread,
+				    wakeflags, dev_name(dev), dev);
+}
+EXPORT_SYMBOL_GPL(request_wake_irq);
+
 void enable_percpu_irq(unsigned int irq, unsigned int type)
 {
 	unsigned int cpu = smp_processor_id();
--- /dev/null
+++ b/kernel/irq/manage.h
@@ -0,0 +1,11 @@
+/*
+ * IRQ subsystem internal management functions and variables:
+ *
+ * Do not ever include this file from anything else than
+ * kernel/irq/. Do not even think about using any information outside
+ * of this file for your non core code.
+ */
+
+irqreturn_t handle_wakeirq_thread(int wakeirq, void *dev_id);
+int init_disabled_wakeirq(struct device *dev, unsigned int wakeirq,
+			  unsigned long wakeflags);
