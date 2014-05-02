Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaEBUNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:13:23 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:59508 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaEBUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:13:21 -0400
Date: Fri, 2 May 2014 14:13:07 -0600
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Bill Sumner <bill.sumner@hp.com>, indou.takao@jp.fujitsu.com,
        bhe@redhat.com, joro@8bytes.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, doug.hatch@hp.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, zhenhua@hp.com
Subject: Re: [PATCH 0/8] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20140502201307.GA23419@anatevka.fc.hp.com>
Reply-To: Jerry.Hoemann@hp.com
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
 <1398854973.12733.23.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398854973.12733.23.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:49:33AM +0100, David Woodhouse wrote:

Hi David,

As you may know,  Bill has retired and I am picking up this work.
I am still coming up to speed in this area so my goal is to understand
your concerns and research them as I dig through code and specs.

My apologizes for the delay in replying and for our missing your
earlier questions.


> On Thu, 2014-04-24 at 18:36 -0600, Bill Sumner wrote:
> > 
> > This patch set modifies the behavior of the Intel iommu in the crashdump kernel: 
> > 1. to accept the iommu hardware in an active state,
> > 2. to leave the current translations in-place so that legacy DMA will continue
> >    using its current buffers until the device drivers in the crashdump kernel
> >    initialize and initialize their devices,
> > 3. to use different portions of the iova address ranges for the device drivers
> >    in the crashdump kernel than the iova ranges that were in-use at the time
> >    of the panic.  
> 
> There could be all kinds of existing mappings in the DMA page tables,
> and I'm not sure it's safe to preserve them. What prevents the crashdump
> kernel from trying to use any of the physical pages which are
> accessible, and which could thus be corrupted by stray DMA?

In kdump, we switch to, and execute from the capture kernel.  (AKA 2nd kernel,
crash kernel.)  This is a separate distinct instance of linux.  One of
the intents of this switch is to (kdump.txt):

    "This ensures that ongoing Direct Memory Access
(DMA) from the system kernel does not corrupt the dump-capture kernel.
The kexec -p command loads the dump-capture kernel into this reserved
memory."

As capture kernel is allocated early in boot, we shouldn't have DMA
targeted to it once the capture kernel is loaded.

Now,  the capture kernel will try to access 1st kernel memory via /proc/vmcore
after it boots and runs makedumpfile.   Is it this access that you
are concerned with?



> 
> In fact, the old kernel could even have set up 1:1 passthrough mappings
> for some devices, which would then be able to DMA *anywhere*. Surely we
> need to prevent that?

>From prior patch version comments,  I know Bill was aware of the
issue of pass-through, but don't know to what extent he tested with
the feature enabled.  E.g. in Jan and prior versions he stated he
had not tested w/ pass through.  He subsequently dropped this statement.

The approach of the patch is to just allow the outstanding DMA
to complete.  Assuming the targeted address of the pass through
was sane,  does this differ greatly from the non pass through case?
Now, if the DMA was truly going to random places (like the capture
kernel itself)  I'm not sure what we would do.  Suggestions?


> 
> After the last round of this patchset, we discussed a potential
> improvement where you point every virtual bus address at the *same*
> physical scratch page.
> 
> That way, we allow the "rogue" DMA to continue to the same virtual bus
> addresses, but it can only ever affect one piece of physical memory and
> can't have detrimental effects elsewhere.
> 
> Was that option considered and discounted for some reason? It seems like
> it would make sense...

I don't know if this was considered.

I will need time to go through code and the spec to understand
implications better.

Thanks

Jerry


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

