Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbaISQUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:20:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39259 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaISQUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:20:10 -0400
Date: Fri, 19 Sep 2014 11:19:27 -0500
From: Nishanth Menon <nm@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
CC: <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
Message-ID: <20140919161927.GA28613@kahuna>
References: <1411067086-16613-1-git-send-email-nm@ti.com>
 <1411067086-16613-4-git-send-email-nm@ti.com>
 <alpine.DEB.2.10.1409181749170.4206@nanos>
 <20140919030333.GA6088@kahuna>
 <alpine.DEB.2.10.1409190710320.5612@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409190710320.5612@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:37-20140919, Thomas Gleixner wrote:
> On Thu, 18 Sep 2014, Nishanth Menon wrote:
> > On 17:57-20140918, Thomas Gleixner wrote:
> > 
> > I suppose I can improve the commit message to elaborate this better?
> > Will that help?
> 
> You also want to improve the comment in the empty handler.
OK. will do the same. Thanks for suggesting.

> 
> > > 
> > > > +	 */
> > > > +	return IRQ_NONE;
> 
> And it still does not explain WHY you think that returning IRQ_NONE is
> the right thing to do here. You actually handle the interrupt, right?
> Just because the handler is an NOP does not mean you did not handle
> it.

Hmm.. My motivation for IRQ_NONE was because this specific handler does
not handle the interrupt. Now, from this discussion, I understand that I
should rather use IRQ_HANDLED since the event is indeed handled (just
not here).

Thank you for correcting my understanding. Will update in my next rev
(once we solve the following discussion)..

> 
> > > > +static int palmas_i2c_suspend(struct i2c_client *i2c,  pm_message_t mesg)
> > > > +{
> > > > +	struct palmas *palmas = i2c_get_clientdata(i2c);
> > > > +	struct device *dev = &i2c->dev;
> > > > +
> > > > +	if (!palmas->wakeirq)
> > > > +		return 0;
> > > > +
> > > > +	if (device_may_wakeup(dev))
> > > > +		enable_irq(palmas->wakeirq);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int palmas_i2c_resume(struct i2c_client *i2c)
> > > > +{
> > > > +	struct palmas *palmas = i2c_get_clientdata(i2c);
> > > > +	struct device *dev = &i2c->dev;
> > > > +
> > > > +	if (!palmas->wakeirq)
> > > > +		return 0;
> > > > +
> > > > +	if (device_may_wakeup(dev))
> > > > +		disable_irq_nosync(palmas->wakeirq);
> > > 
> > > Again, why nosync?
> > true - nosync is not necessary at here. disable_irq is however necessary
> > as we are not interested in wakeup events for level changes.
> > 
> > We just use the enable/disable to control when we'd want to arm the pin
> > for waking up from suspend state.
> 
> And what is issuing the call to enable/disable_irq_wake()? 
> 
> So if that interrupt is not marked proper then you can bring your
> device into a wont resume state easily
> 
>        start suspend
>        enable wakeirq
>        disable_device_irqs()
> 	   if (!iswakeup_irq())
> 	      disable_irq() // does not mask due to lazy masking
> 
>        ....
>        wakeirq fires
>           if (irq_is_disabled())
> 	     mask_irq();
> 
>        transition into suspend
> 
> Now your pinctrl irq is masked at the HW level and wont wake the
> machine up ever again.
True.

> 
> So now looking at that pinctrl irq chip thing, which seems to be
> designed to handle these kind of wakeups. That thing looks massivly
> wrong as well, simply because it enforces to use
> enable_irq/disable_irq().
> 
> So because the sole purpose of this chip is to handle the separate
> wakeup style interrupt, it should actually NOT enable the interrupt in
> the irq_unmask callback.
> 
> Simply because during normal operation nothing is interested in the
> interrupt and any operation which might enable it (including request
> irq) is just making the system handle completely pointless interrupts
> and hoops and loops juggling with enable/disable irq.
> 
> So the right thing here is to have an empty unmask function and do the
> actual unmask only in the irq_set_wake() callback. mask of course
> needs to do what it says. The point is, that the following sequence of
> code will just work w/o generating an interrupt on the wakeirq line
> outside of the wake enabled context.
> 
> dev_init()
> 	request_wakeirq();
> 
> suspend()
> 	if (may_wake())
> 	   enable_irq_wake();
> 
> resume()
> 	if (may_wake())
> 	   disable_irq_wake();
> 
> The other omap drivers using this have the same issue ... And of
> course they are subtly different.
> 
> The uart one handles the actual device interrupt, which is violating
> the general rule of possible interrupt reentrancy in the pm-runtime
> case if the two interrupts are affine to two different cores. Yes,
> it's protected by a lock and works by chance ....
> 
> The mmc one issues a disable_irq_nosync() in the wakeup irq handler
> itself.
> 
> WHY does one driver need that and the other does not? You are not even
> able to come up with a common scheme for OMAP. I don't want to see the
> mess others are going to create when this stuff becomes more used.
> 
> Thanks,
> 
> 	tglx

I think I understand your concern - I request Tony to comment about
this. I mean, I can try and hook things like uart in other drivers
(like https://patchwork.kernel.org/patch/4759171/ ), but w.r.t overall
generic usage guideline wise, I would prefer Tony to comment.

-- 
Regards,
Nishanth Menon
