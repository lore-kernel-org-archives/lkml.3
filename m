Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbaAHPLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:11:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaAHPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:11:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references late
Date: Wed, 08 Jan 2014 16:11:08 +0100
Message-ID: <6734073.GzLvMSsKrR@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140108145525.GB21974@ulmo.nvidia.com>
References: <20140108011957.GK5074@atomide.com> <4589157.TquA4Q59fC@wuerfel> <20140108145525.GB21974@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:A4FIAxiJma06euE256mEFo/cKfeHyM+y75Sv7OFaGEF
 Plxr1gFP0UTrsdrqvRBvZVCbWzF6+lPGcwn6jPpNOUlSPHQlqk
 iqbKh6+aipsL1W5Z9IwaQWRr7ngrHN3Entb87khmgAZGTl0Q4v
 Rozk9ogIqT7UOgFLF0U35at5bbr5SgBFDPvGJlgUHXC4c8JbIW
 snltmioc2zO/U1qDiSRSY1Ab05VwC4o8exCf51tMzsJv2g/+Ao
 ugLqnKRUiz4CKBb6tuddTskbDLYg1P74RG6zyT+i4r4EBQJQCl
 Z1qoh85sKefw0JXb9SA3z+RhjS2uO3HGTcaMw06+cwKMIV/leU
 lEQ15HCWTbjW88cQt68I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 15:55:27 Thierry Reding wrote:
> On Wed, Jan 08, 2014 at 02:41:19PM +0100, Arnd Bergmann wrote:
> > On Wednesday 08 January 2014 13:51:17 Thierry Reding wrote:
> > I hope I read this thread correctly, sorry if I missed an important
> > part. My idea was to add the code not in platform_get_irq() but add
> > the resource in platform_drv_probe(), and just bail out with
> > -EPROBE_DEFER there if necessary.
> 
> One of the reasons we can't do that just yet is that we don't actually
> get back an accurate error code from the OF IRQ helpers. Therefore if we
> want to support deferred probing we either have to return -EPROBE_DEFER
> for all errors (which is a bad idea because some errors just can't be
> resolved by deferral) or we change the OF IRQ functions to propagate the
> error code properly so that we know exactly when -EPROBE_DEFER makes
> sense (i.e. the IRQ domain for an interrupt-parent hasn't been
> registered yet).

I see.

> Actually I posted a round of patches quite a while back that did exactly
> this for interrupts. The changes were somewhat involved because it means
> propagating an error code from fairly deep down in the OF code back to
> the various higher-level helpers. If you're interested, the last version
> of that is here:
> 
> 	https://lkml.org/lkml/2013/9/18/216
> 
> Grant in particular seemed to be uncomfortable about how invasive the
> patch series is.

Interesting. It seems like a worthwhile thing to do, but I can understand
Grant's reluctance.

> 
> One problem with the IOMMU patches is that they've received some strong
> pushback from both Greg and Grant, arguing that it doesn't belong in the
> core. If you want to read up on that, here's a link to the latest
> version:
> 
> 	https://lkml.org/lkml/2013/12/12/74
> 
> Some things had been discussed in earlier iterations of that series, but
> this should give you the basic idea.

I'm skipping that discussion for now and stick with your summary

> It stands to reason that if they push back on the IOMMU variant of what
> is essentially the same thing, they will push back on the IRQ variant as
> well. One alternative I proposed was to, just as you suggested earlier,
> move the code into platform_drv_probe() or rather a function called from
> it. That proposal never got any replies, though.
> 
> 	https://lkml.org/lkml/2013/12/14/39

I guess putting it into the platform_drv_probe function seems reasonable,
I would be more scared of the implications of a notifier based method.

> > We could then skip adding the resources at device creation time.
> > Is this something you already plan to do later, or is there a reason
> > it wouldn't work?
> 
> The current thread here suggests that it would be preferable not to have
> any static allocations at all, but rather introduce a new API to resolve
> things at probe time if necessary. I think the idea was to have a set of
> functions like:
> 
> 	int device_get_irq(struct device *dev, unsigned int num);
> 	struct resource *device_get_mem_region(struct device *dev,
> 					       unsigned int num);
> 
> Or even possible the more generic:
> 
> 	struct resource *device_get_resource(struct device *dev,
> 					     unsigned int type,
> 					     unsigned int num);
> 
> If every driver used these functions, all resources could trivially be
> resolved at probe time. That solution is also the most invasive one of
> course, because it requires all existing drivers to be converted. At
> least the API would be all new and therefore the conversion could happen
> piecemeal.

Right, that does sound nice, and has the added benefit of saving
some memory allocations. I'd prefer the less generic variant here,
but I haven't given it much thought.
 
> One downside of that approach is that, while it maps well to platform
> devices or generic devices that have some sort of firmware interface
> such as OF or ACPI, I don't see how it can be made to work with an I2C
> client that's registered from board setup code for example. Well, I
> suppose that problem could be solved by throwing another lookup table at
> it, just like we do for clocks, regulators, PWMs and GPIOs.

Wouldn't you still be able to attach resources in the traditional
way for those, but use the same new interface to get at them?

> The good thing about it would be more consistency between the various
> types of resources. Eventually I could imagine that we could even get
> rid of struct resource (or at least only use it for a single type of
> resource). But as I said, it'll take quite a bit of work to convert
> everything to that.

struct resource is a structure with a long and complex history.
I'd certainly like to put some of it behind us and do something
that fits better into the 'struct device' concept which it
predates. I agree it would be a big effort though.

> > In the meantime, I don't see anything with your patch, but it also
> > wouldn't hurt to do it now if it solves all the problems.
> 
> Well, the commit message explicitly states that this is only a temporary
> measure, mostly to fix a number of regressions on OMAP where things were
> broken by the conversion to DT in 3.13. The same is probably true of
> other boards as well.

Right.

> I'm willing to help fix things properly in the long run, but I think a
> simple and low-risk patch like this would be worthwhile if it means that
> a good many boards aren't broken in 3.13. Also given the history of the
> above I can imagine that it will take more than the 3.14 cycle to get
> this resolved satisfactorily, so at least for interrupts this would give
> us a good stopgap solution in the meantime.

Ok. Thanks so much for your detailed background information!

	Arnd
