Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbaIRUcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:32:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:56462 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbaIRUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:32:17 -0400
Date: Thu, 18 Sep 2014 13:32:06 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Torokhov <dtor@google.com>
cc: Eric Caruso <ejcaruso@google.com>, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@google.com>
Subject: Re: irq mask swapping during suspend/resume
In-Reply-To: <30052021.2q1IqLHYpU@dtor-glaptop>
Message-ID: <alpine.DEB.2.10.1409181326140.4206@nanos>
References: <CAA9CXT07f01KW4UeoPPy4k1NM6qfxdtsOQXXSPjTKx7mG_v7Rw@mail.gmail.com> <alpine.DEB.2.10.1409171200350.21313@nanos> <30052021.2q1IqLHYpU@dtor-glaptop>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Dmitry Torokhov wrote:
> Hi Thomas,
> 
> On Wednesday, September 17, 2014 12:05:42 PM Thomas Gleixner wrote:
> > On Tue, 16 Sep 2014, Eric Caruso wrote:
> > > We would like to be able to set different irq masks for triggers during
> > > normal operation and for waking up the system. For example, while a laptop
> > > is awake, closing the lid and opening the lid should both fire an
> > > interrupt, but when the system is asleep, we would like to stay asleep
> > > when
> > > closing the lid.
> > > 
> > > We are thinking about stashing the irq mask used specifically for waking
> > > the system up in the irq_desc struct, and then swapping it during
> > > enable_irq_wake and disable_irq_wake calls. Devices that do not specify a
> > > different wake mask will use their normal trigger mask for both
> > > situations.
> > > 
> > > Is this acceptable?
> > 
> > Not really. Why should irq_desc provide storage for random
> > configurations and bind them to some random system state?
> > 
> > What's wrong with calling
> > 
> >        irq_set_type(irq, B);
> >        enable_irq_wake(irq);
> > 
> >        disable_irq_wake(irq);
> >        irq_set_type(irq, A);
> 
> The desire is to avoid doing it in [every] driver but rather have it done
> centrally by device/PM core. It does not have to be irq_desc though,
> maybe you can suggest a better place for it (aside of the individual driver
> code that is)?

Well, if it should be done by the device/pm core then you want to
store that information in the device related data structure. 

struct dev_pm_info might be the right place for it, but that's up to
Rafael.

So driver would set

   dev->power.update_wakeirq_type = true;
   dev->power.irq_type_normal = IRQ_TYPE_EDGE_BOTH;
   dev->power.irq_type_sleep = IRQ_TYPE_EDGE_LOW;

And the dev/PM core can issue the calls on suspend/resume.

Thanks,

	tglx
