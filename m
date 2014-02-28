Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaB1Wto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:49:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50310 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaB1Wtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:49:42 -0500
Date: Fri, 28 Feb 2014 22:49:33 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v6 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140228224933.GA11040@e102568-lin.cambridge.arm.com>
References: <1393545478-14908-1-git-send-email-sebastian.capella@linaro.org>
 <1393545478-14908-3-git-send-email-sebastian.capella@linaro.org>
 <20140228095022.GA25090@e102568-lin.cambridge.arm.com>
 <20140228201557.29118.62126@capellas-linux>
MIME-Version: 1.0
In-Reply-To: <20140228201557.29118.62126@capellas-linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 Feb 2014 22:49:43.0697 (UTC) FILETIME=[5F353810:01CF34D7]
X-MC-Unique: 114022822493901501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 08:15:57PM +0000, Sebastian Capella wrote:

[...]

> > > +
> > > +/*
> > > + * The framework loads the hibernation image into a linked list anchored
> > > + * at restore_pblist, for swsusp_arch_resume() to copy back to the proper
> > > + * destinations.
> > > + *
> > > + * To make this work if resume is triggered from initramfs, the
> > > + * pagetables need to be switched to allow writes to kernel mem.
> > > + */
> > 
> > Comment above needs updating. We are switching page tables to a set of
> > page tables that are certain to live at the same location in the older
> > kernel, that's the only reason, as we discussed. soft_restart will make
> > sure (again) to switch to 1:1 page tables so that we can call cpu_resume
> > with the MMU off.
> 
> How does this look?
> 
> The framework loads as much of the hibernation image to final physical
> pages as possible.  Any pages that were in use, will need to be restored
> prior to the soft_restart.  The pages to restore are maintained in
> the list anchored at restore_pblist.  At this point, we can swap the
> pages to their final location.  We must switch the mapping to 1:1 to
> ensure that when we overwrite the page table physical pages we're using
> a known physical location (idmap_pgd) with known contents.

It is ok, a tad too verbose. All I care about is a comment describing
what's really needed, the existing one was confusing and wrong.

> > > +/*
> > > + * Resume from the hibernation image.
> > > + * Due to the kernel heap / data restore, stack contents change underneath
> > > + * and that would make function calls impossible; switch to a temporary
> > > + * stack within the nosave region to avoid that problem.
> > > + */
> > > +int swsusp_arch_resume(void)
> > > +{
> > > +     extern void call_with_stack(void (*fn)(void *), void *arg, void *sp);
> > > +     call_with_stack(arch_restore_image, 0,
> > > +             resume_stack + sizeof(resume_stack));
> > 
> > This does not guarantee your stack is 8-byte aligned, that's not AAPCS
> > compliant and might buy you trouble.
> > 
> > Either you align the stack or you align the pointer you are passing.
> > 
> > Please have a look at kernel/process.c
> 
> I've added this for now, do you see any issues?
> 
> -static u8 resume_stack[PAGE_SIZE/2] __nosavedata;
> +static u64 resume_stack[PAGE_SIZE/2/sizeof(u64)] __nosavedata;
> -               resume_stack + sizeof(resume_stack));
> +               resume_stack + ARRAY_SIZE(resume_stack));

I do not see why the stack depends on the PAGE_SIZE. I would be surprised
if you need more than a few bytes (given that soft_restart switches stack
again...), go through it with a debugger, it is easy to check the stack
usage and allow for some extra buffer (but half a page is not needed).

My main concern was alignment, and now that's fixed.

Thanks !
Lorenzo

