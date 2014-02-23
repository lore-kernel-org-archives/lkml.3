Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaBWUCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:02:11 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60447 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaBWUCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:02:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russ Dill" <Russ.Dill@ti.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Len Brown" <len.brown@intel.com>, "Pavel Machek" <pavel@ucw.cz>,
        "Nicolas Pitre" <nico@linaro.org>,
        "Santosh Shilimkar" <santosh.shilimkar@ti.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        "Cyril Chemparathy" <cyril@ti.com>,
        "Jonathan Austin" <Jonathan.Austin@arm.com>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        "Stephen Boyd" <sboyd@codeaurora.org>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
 <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org>
 <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
 <20140222103840.GH21483@n2100.arm.linux.org.uk>
 <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
Message-ID: <20140223200208.12998.47604@capellas-linux>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Date: Sun, 23 Feb 2014 12:02:08 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lorenzo Pieralisi (2014-02-22 04:09:10)
> On Sat, Feb 22, 2014 at 10:38:40AM +0000, Russell King - ARM Linux wrote:
> > On Wed, Feb 19, 2014 at 04:12:54PM +0000, Lorenzo Pieralisi wrote:
> > > On Wed, Feb 19, 2014 at 01:52:09AM +0000, Sebastian Capella wrote:
> > > > +/*
> > > > + * Snapshot kernel memory and reset the system.
> > > > + * After resume, the hibernation snapshot is written out.
> > > > + */
> > > > +static int notrace __swsusp_arch_save_image(unsigned long unused)
> > > > +{
> > > > + int ret;
> > > > +
> > > > + ret = swsusp_save();
> > > > + if (ret == 0)
> > > > +         soft_restart(virt_to_phys(cpu_resume));
> > > 
> > > By the time the suspend finisher (ie this function) is run, the
> > > processor state has been saved and I think that's all you have to do,
> > > function can just return after calling swsusp_save(), unless I am missing
> > > something.
> > > 
> > > I do not understand why a soft_restart is required here. On a side note,
> > > finisher is called with irqs disabled so, since you added a function for
> > > soft restart noirq, it should be used, if needed, but I have to understand
> > > why in the first place.
> > 
> > It's required because you can't just return from the finisher.  A normal
> > return from the finisher will always be interpreted as an abort rather
> > than success (because the state has to be unwound.)
> > 
> > This is the only way to get a zero return from cpu_suspend().
> 
> Yes, that's the only reason why this code is jumping to cpu_resume, since
> all it is needed is to snapshot the CPU context and by the time the
> finisher is called that's done. Wanted to say that soft reboot is not
> useful (cache flushing and resume with MMU off), but what you are saying
> is correct. We might be saving swsusp_save return value in a global
> variable and just return from the finisher, but that's horrible and
> given the amount of time it takes to snapshot the image to disk the
> cost of this soft reboot will be dwarfed by that.
> 
> I wanted to ask and clarify why the code was written like this though, given
> its complexity.

We could also return a constant > 1.  __cpu_suspend code will replace
a 0 return with 1 for paths exiting suspend, but will not change return
values != 0.  

cpu_suspend_abort:
        ldmia   sp!, {r1 - r3}          @ pop phys pgd, virt SP, phys
	resume fn
	teq     r0, #0
	moveq   r0, #1                  @ force non-zero value
	mov     sp, r2
	ldmfd   sp!, {r4 - r11, pc}

We could take advantage of that if we wanted, but Lorenzo pointed out
also that the relative benefit is very low since the cost of
resuming is >> soft_restart. 

I'll go with leaving the soft_restart as is unless someone feels
strongly against.

Thanks!

Sebastian
