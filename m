Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaBVKiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 05:38:51 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46794 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814AbaBVKit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 05:38:49 -0500
Date: Sat, 22 Feb 2014 10:38:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Message-ID: <20140222103840.GH21483@n2100.arm.linux.org.uk>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org> <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org> <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:12:54PM +0000, Lorenzo Pieralisi wrote:
> On Wed, Feb 19, 2014 at 01:52:09AM +0000, Sebastian Capella wrote:
> > +/*
> > + * Snapshot kernel memory and reset the system.
> > + * After resume, the hibernation snapshot is written out.
> > + */
> > +static int notrace __swsusp_arch_save_image(unsigned long unused)
> > +{
> > +	int ret;
> > +
> > +	ret = swsusp_save();
> > +	if (ret == 0)
> > +		soft_restart(virt_to_phys(cpu_resume));
> 
> By the time the suspend finisher (ie this function) is run, the
> processor state has been saved and I think that's all you have to do,
> function can just return after calling swsusp_save(), unless I am missing
> something.
> 
> I do not understand why a soft_restart is required here. On a side note,
> finisher is called with irqs disabled so, since you added a function for
> soft restart noirq, it should be used, if needed, but I have to understand
> why in the first place.

It's required because you can't just return from the finisher.  A normal
return from the finisher will always be interpreted as an abort rather
than success (because the state has to be unwound.)

This is the only way to get a zero return from cpu_suspend().

> > +/*
> > + * The framework loads the hibernation image into a linked list anchored
> > + * at restore_pblist, for swsusp_arch_resume() to copy back to the proper
> > + * destinations.
> > + *
> > + * To make this work if resume is triggered from initramfs, the
> > + * pagetables need to be switched to allow writes to kernel mem.
> 
> Can you elaborate a bit more on this please ?
> 
> > + */
> > +static void notrace __swsusp_arch_restore_image(void *unused)
> > +{
> > +	struct pbe *pbe;
> > +
> > +	cpu_switch_mm(idmap_pgd, &init_mm);
> 
> Same here, thanks.
> 
> > +	for (pbe = restore_pblist; pbe; pbe = pbe->next)
> > +		copy_page(pbe->orig_address, pbe->address);
> > +
> > +	soft_restart_noirq(virt_to_phys(cpu_resume));
> 
> This soft_restart is justified so that you resume from the context saved
> when creating the image.

You need the idmap_pgd in place to call cpu_resume at it's physical
address.  Other page tables just won't do here.  It's well established
that this page table must be in place for the resume paths to work.

So yes, the comments above the function are wrong.  idmap_pgd must be
in place for cpu_resume() to work.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
