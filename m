Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbaKMKDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:03:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:45671 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaKMKDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:03:18 -0500
Date: Thu, 13 Nov 2014 11:03:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Lindgren <tony@atomide.com>
cc: Nishanth Menon <nm@ti.com>, lee.jones@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
In-Reply-To: <20141106204629.GF31454@atomide.com>
Message-ID: <alpine.DEB.2.11.1411131053050.3935@nanos>
References: <1411067086-16613-1-git-send-email-nm@ti.com> <1411067086-16613-4-git-send-email-nm@ti.com> <alpine.DEB.2.10.1409181749170.4206@nanos> <20140919030333.GA6088@kahuna> <alpine.DEB.2.10.1409190710320.5612@nanos> <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos> <20140919191649.GQ14505@atomide.com> <alpine.DEB.2.10.1409191233590.4213@nanos> <20141002034345.GH3122@atomide.com> <20141106204629.GF31454@atomide.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

On Thu, 6 Nov 2014, Tony Lindgren wrote:
> 
> Any comments on the patch below? Let me know if you want to keep the
> devm stuff out of kernel/irq/manage.c.

Sorry, this slipped through the cracks.
 
> > +static int setup_wakeirq(struct device *dev, unsigned int wakeirq,
> > +			 unsigned long wakeflags, bool devm)
> > +{
> > +	int ret;
> > +
> > +	if (!(dev && wakeirq)) {
> > +		pr_err("Missing device or wakeirq for %s irq %d\n",
> > +		       dev_name(dev), wakeirq);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!(wakeflags &
> > +	      (IRQF_TRIGGER_LOW | IRQF_TRIGGER_HIGH | IRQF_ONESHOT))) {
> > +		pr_err("Invalid wakeirq for %s irq %d, must be level oneshot\n",
> > +		       dev_name(dev), wakeirq);

This looks odd.

Why do you want to enforce LEVEL and ONESHOT?  I can see the point for
ONESHOT, but I'm wondering about the requirement for level.

Now if you really want to enforce level AND oneshot, your check is
wrong as it will not trigger on

      wakeflags = IRQF_TRIGGER_LOW;
      wakeflags = IRQF_TRIGGER_HIGH;
      wakeflags = IRQF_ONESHOT;

Not what you really want, right?

> > +int request_wake_irq(struct device *dev, unsigned int wakeirq,
> > +		     unsigned long wakeflags)
> > +{
> > +	return setup_wakeirq(dev, wakeirq, wakeflags, false);
> > +}
> > +EXPORT_SYMBOL(request_wake_irq);

  _GPL please

> > +
> > +int devm_request_wake_irq(struct device *dev, unsigned int wakeirq,
> > +			  unsigned long wakeflags)
> > +{
> > +	return setup_wakeirq(dev, wakeirq, wakeflags, false);

Shouldnt that have devm = true?

Thanks,

	tglx
