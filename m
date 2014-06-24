Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaFXOnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:43:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbaFXOnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:43:19 -0400
Message-ID: <1403620984.16078.18.camel@ul30vt.home>
Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2014 08:43:04 -0600
In-Reply-To: <53A98C38.8020205@ozlabs.ru>
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>
			 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>
			 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>
			 <1403234514.3707.278.camel@ul30vt.home>
	 <1403305961.4587.66.camel@pasglop>	 <53A94EBD.101@ozlabs.ru>
	 <53A955F5.6050801@suse.de>	 <53A9741B.1040500@ozlabs.ru>
	 <53A97486.4070604@suse.de>	 <53A976B7.3070709@ozlabs.ru>
	 <53A97BA9.4020702@suse.de> <1403619685.16078.15.camel@ul30vt.home>
	 <53A98C38.8020205@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 00:33 +1000, Alexey Kardashevskiy wrote:
> On 06/25/2014 12:21 AM, Alex Williamson wrote:
> > On Tue, 2014-06-24 at 15:22 +0200, Alexander Graf wrote:
> >> On 24.06.14 15:01, Alexey Kardashevskiy wrote:
> >>> On 06/24/2014 10:52 PM, Alexander Graf wrote:
> >>>> On 24.06.14 14:50, Alexey Kardashevskiy wrote:
> >>>>> On 06/24/2014 08:41 PM, Alexander Graf wrote:
> >>>>>> On 24.06.14 12:11, Alexey Kardashevskiy wrote:
> >>>>>>> On 06/21/2014 09:12 AM, Benjamin Herrenschmidt wrote:
> >>>>>>>> On Thu, 2014-06-19 at 21:21 -0600, Alex Williamson wrote:
> >>>>>>>>
> >>>>>>>>> Working on big endian being an accident may be a matter of perspective
> >>>>>>>>     :-)
> >>>>>>>>
> >>>>>>>>> The comment remains that this patch doesn't actually fix anything except
> >>>>>>>>> the overhead on big endian systems doing redundant byte swapping and
> >>>>>>>>> maybe the philosophy that vfio regions are little endian.
> >>>>>>>> Yes, that works by accident because technically VFIO is a transport and
> >>>>>>>> thus shouldn't perform any endian swapping of any sort, which remains
> >>>>>>>> the responsibility of the end driver which is the only one to know
> >>>>>>>> whether a given BAR location is a a register or some streaming data
> >>>>>>>> and in the former case whether it's LE or BE (some PCI devices are BE
> >>>>>>>> even ! :-)
> >>>>>>>>
> >>>>>>>> But yes, in the end, it works with the dual "cancelling" swaps and the
> >>>>>>>> overhead of those swaps is probably drowned in the noise of the syscall
> >>>>>>>> overhead.
> >>>>>>>>
> >>>>>>>>> I'm still not a fan of iowrite vs iowritebe, there must be something we
> >>>>>>>>> can use that doesn't have an implicit swap.
> >>>>>>>> Sadly there isn't ... In the old day we didn't even have the "be"
> >>>>>>>> variant and readl/writel style accessors still don't have them either
> >>>>>>>> for all archs.
> >>>>>>>>
> >>>>>>>> There is __raw_readl/writel but here the semantics are much more than
> >>>>>>>> just "don't swap", they also don't have memory barriers (which means
> >>>>>>>> they are essentially useless to most drivers unless those are platform
> >>>>>>>> specific drivers which know exactly what they are doing, or in the rare
> >>>>>>>> cases such as accessing a framebuffer which we know never have side
> >>>>>>>> effects).
> >>>>>>>>
> >>>>>>>>>     Calling it iowrite*_native is also an abuse of the namespace.
> >>>>>>>>>     Next thing we know some common code
> >>>>>>>>> will legitimately use that name.
> >>>>>>>> I might make sense to those definitions into a common header. There have
> >>>>>>>> been a handful of cases in the past that wanted that sort of "native
> >>>>>>>> byte order" MMIOs iirc (though don't ask me for examples, I can't really
> >>>>>>>> remember).
> >>>>>>>>
> >>>>>>>>>     If we do need to define an alias
> >>>>>>>>> (which I'd like to avoid) it should be something like vfio_iowrite32.
> >>>>>>> Ping?
> >>>>>>>
> >>>>>>> We need to make a decision whether to move those xxx_native() helpers
> >>>>>>> somewhere (where?) or leave the patch as is (as we figured out that
> >>>>>>> iowriteXX functions implement barriers and we cannot just use raw
> >>>>>>> accessors) and fix commit log to explain everything.
> >>>>>> Is there actually any difference in generated code with this patch applied
> >>>>>> and without? I would hope that iowrite..() is inlined and cancels out the
> >>>>>> cpu_to_le..() calls that are also inlined?
> >>>>> iowrite32 is a non-inline function so conversions take place so are the
> >>>>> others. And sorry but I fail to see why this matters. We are not trying to
> >>>>> accelerate things, we are removing redundant operations which confuse
> >>>>> people who read the code.
> >>>> The confusion depends on where you're coming from. If you happen to know
> >>>> that "iowrite32" writes in LE, then the LE conversion makes a lot of sense.
> >>> It was like this (and this is just confusing):
> >>>
> >>> iowrite32(le32_to_cpu(val), io + off);
> >>>
> >>> What would make sense (according to you and I would understand this) is this:
> >>>
> >>> iowrite32(cpu_to_le32(val), io + off);
> >>>
> >>>
> >>> Or I missed your point, did I?
> >>
> >> No, you didn't miss it. I think for people who know how iowrite32() 
> >> works the above is obvious. I find the fact that iowrite32() writes in 
> >> LE always pretty scary though ;).
> >>
> >> So IMHO we should either create new, generic iowrite helpers that don't 
> >> do any endian swapping at all or do iowrite32(cpu_to_le32(val)) calls.
> > 
> > I'm one of those people for whom iowrite32(le32_to_cpu(val)) makes sense
> 
> 
> I do not understand why @val is considered LE here and need to be converted
> to CPU. Really. I truly believe it should be cpu_to_le32().

Because iowrite32 is defined to take a cpu byte order value and write it
as little endian.

> > and keeps the byte order consistent regardless of the platform, while
> > iowrite32(val) or iowrite32be(val) makes me scratch my head and try to
> > remember that the byte swaps are a nop on the given platforms.  As Ben
> > noted, a native, no-swap ioread/write doesn't exist, but perhaps should.
> > I'd prefer an attempt be made to make it exist before adding
> > vfio-specific macros.  vfio is arguably doing the right thing here given
> > the functions available.  Thanks,
> 
> 



