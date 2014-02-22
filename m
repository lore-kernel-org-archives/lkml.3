Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaBVMJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 07:09:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57806 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaBVMJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 07:09:19 -0500
Date: Sat, 22 Feb 2014 12:09:10 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Message-ID: <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
 <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org>
 <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
 <20140222103840.GH21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20140222103840.GH21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 Feb 2014 12:09:18.0633 (UTC) FILETIME=[E99B4190:01CF2FC6]
X-MC-Unique: 114022212091700201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 10:38:40AM +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 19, 2014 at 04:12:54PM +0000, Lorenzo Pieralisi wrote:
> > On Wed, Feb 19, 2014 at 01:52:09AM +0000, Sebastian Capella wrote:
> > > +/*
> > > + * Snapshot kernel memory and reset the system.
> > > + * After resume, the hibernation snapshot is written out.
> > > + */
> > > +static int notrace __swsusp_arch_save_image(unsigned long unused)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = swsusp_save();
> > > +	if (ret == 0)
> > > +		soft_restart(virt_to_phys(cpu_resume));
> > 
> > By the time the suspend finisher (ie this function) is run, the
> > processor state has been saved and I think that's all you have to do,
> > function can just return after calling swsusp_save(), unless I am missing
> > something.
> > 
> > I do not understand why a soft_restart is required here. On a side note,
> > finisher is called with irqs disabled so, since you added a function for
> > soft restart noirq, it should be used, if needed, but I have to understand
> > why in the first place.
> 
> It's required because you can't just return from the finisher.  A normal
> return from the finisher will always be interpreted as an abort rather
> than success (because the state has to be unwound.)
> 
> This is the only way to get a zero return from cpu_suspend().

Yes, that's the only reason why this code is jumping to cpu_resume, since
all it is needed is to snapshot the CPU context and by the time the
finisher is called that's done. Wanted to say that soft reboot is not
useful (cache flushing and resume with MMU off), but what you are saying
is correct. We might be saving swsusp_save return value in a global
variable and just return from the finisher, but that's horrible and
given the amount of time it takes to snapshot the image to disk the
cost of this soft reboot will be dwarfed by that.

I wanted to ask and clarify why the code was written like this though, given
its complexity.

> > > +/*
> > > + * The framework loads the hibernation image into a linked list anchored
> > > + * at restore_pblist, for swsusp_arch_resume() to copy back to the proper
> > > + * destinations.
> > > + *
> > > + * To make this work if resume is triggered from initramfs, the
> > > + * pagetables need to be switched to allow writes to kernel mem.
> > 
> > Can you elaborate a bit more on this please ?
> > 
> > > + */
> > > +static void notrace __swsusp_arch_restore_image(void *unused)
> > > +{
> > > +	struct pbe *pbe;
> > > +
> > > +	cpu_switch_mm(idmap_pgd, &init_mm);
> > 
> > Same here, thanks.
> > 
> > > +	for (pbe = restore_pblist; pbe; pbe = pbe->next)
> > > +		copy_page(pbe->orig_address, pbe->address);
> > > +
> > > +	soft_restart_noirq(virt_to_phys(cpu_resume));
> > 
> > This soft_restart is justified so that you resume from the context saved
> > when creating the image.
> 
> You need the idmap_pgd in place to call cpu_resume at it's physical
> address.  Other page tables just won't do here.  It's well established
> that this page table must be in place for the resume paths to work.

Well, we do not need idmap page tables for copying the restore_pblist,
but we do need a set of tables that won't be corrupted by the copy and
idmap does the trick (I was confused because 1:1 mappings are not needed
for the copy itself).

The switch to idmap is done for us in soft_reboot anyway before jumping to
cpu_resume and that's required, as you said.

Lorenzo

