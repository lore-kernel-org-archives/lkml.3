Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaEGSZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:25:22 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:19560 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaEGSZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:25:17 -0400
Date: Wed, 7 May 2014 12:25:15 -0600
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: indou.takao@jp.fujitsu.com, bhe@redhat.com, joro@8bytes.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, zhenhua@hp.com
Subject: Re: [PATCH 0/8] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20140507182515.GA27949@anatevka.fc.hp.com>
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


David,

I received the following email from Bill Sumner addressing your
earlier email.

Jerry

On Wed, 2014-04-30, David Woodhouse wrote:
Addressing a portion of the last question first:
>Was that option considered and discounted for some reason? It seems like
>it would make sense.
Considered ?
   Yes. It is an interesting idea. See technical discussion below.

Discounted for some reason ?
   Not really. Only for lack of time.  With only a limited amount of time,
   I focused on providing a clean set of patches on a recent baseline.  

>On Thu, 2014-04-24 at 18:36 -0600, Bill Sumner wrote:
>>
>> This patch set modifies the behavior of the Intel iommu in the crashdump kernel:
>> 1. to accept the iommu hardware in an active state,
>> 2. to leave the current translations in-place so that legacy DMA will continue
>> using its current buffers until the device drivers in the crashdump kernel
>> initialize and initialize their devices,
>> 3. to use different portions of the iova address ranges for the device drivers
>> in the crashdump kernel than the iova ranges that were in-use at the time
>> of the panic.
>
>There could be all kinds of existing mappings in the DMA page tables,
>and I'm not sure it's safe to preserve them.

Actually I think it is safe to preserve them in a great number of cases,
and there is some percentage of cases where something else will work better. 

Fortunately, history shows that the panicked kernel generates bad
translations rarely enough that many crashdumps on systems
without iommu hardware still succeed by simply allowing the DMA/IO
to continue into the existing buffers. The patch set uses the same
technique when the iommu is active. So I think the odds start
out in our favor -- enough in our favor that we should implement
the current patch set into Linux and then begin work to improve it. 

Since the patch set is currently available, and its technique has already been
somewhat tested by three companies, the remaining path for including it
into Linux is short.  This would significantly improve the crashdump success
rate when the Intel iommu is active.  It would also provide a foundation for
investigations into more advanced techniques that would further increase
the success rate.

Bad translations do still happen -- bad programming, tables getting hosed,
etc.  We would like to find a way to get a good dump in this extra percentage
of cases. It sounds like you have some good ideas in this area.  

The iommu hardware guarantees that DMA/IO can only access the memory 
areas described in the DMA page tables.  We can be quite sure that the only
physical memory areas that any DMA/IO can access are ones that are described
by the contents of the translation tables. This comes with a few caveats:
1. hw-passthru and the 'si' domain -- see discussion under a later question. 
   The problem with these is that they allow DMA/IO access to any of 
   physical memory.  
2. The iommu hardware will use valid translation entries to the "wrong" place
   just as readily as it will use ones to the "right" place.  Having the
   kdump kernel check-out the memory areas described by the tables before
   using them seems like a good idea.  For instance: any DMA buffers from the
   panicked kernel that point into the kdump kernel's area would be highly
   suspect.
3. Random writes into the translate tables may well write known-bad values
   into fields or reserved areas -- values which will cause the iommu
   hardware to reject that entry.  Unfortunately we cannot count on this
   happening, but it felt like a bright-spot worth mentioning.  

>What prevents the crashdump
>kernel from trying to use any of the physical pages which are
>accessible, and which could thus be corrupted by stray DMA?

DMA into the kdump area will corrupt the kdump and cause loss of the dump.  
Note that this was the original problem with disabling the iommu at the
beginning of the kdump kernel which forced DMA that was going to 
its original (good) buffers to begin going into essentially random
places -- almost all of them "wrong".

However, I believe that the kdump kernel itself will not be the problem
for the following reasons:

As I understand the kdump architecture, the kdump kernel is restricted
to the physical memory area that was reserved for it by the platform
kernel during its initialization (when the platform kernel presumably was
still healthy.) The kdump kernel is assumed to be clean and healthy,
so it will not be attempting to use any memory outside of what it is
assigned -- except for reading pages of the panicked kernel in order to
write them to the dump file.

Assuming that the DMA page tables were checked to insure that no DMA page
table points into the kdump kernel's reserved area, no stray DMA/IO will
affect the kdump kernel.

>
>In fact, the old kernel could even have set up 1:1 passthrough mappings
>for some devices, which would then be able to DMA *anywhere*. Surely we
>need to prevent that?
Yes, I agree. 
The 1:1 passthrough mappings seem to be problematic -- both the
use of hw-passthrough by the iommu and the 'si' domain set up in the DMA
page tables.  These mappings completely bypass one of the basic reasons
for using the iommu hardware -- to restrict DMA access to known-safe
areas of memory.

I would prefer that Linux not use either of these mechanisms unless
it is absolutely necessary -- in which case it could be explicitly
enabled.  After all, there are probably still some (hopefully few) devices
that absolutely require it. Also, there may be circumstances where a
performance gain outweighs the additional risk to the crashdump.

If the kdump kernel finds a 1:1 passthrough domain among the DMA page tables,
the real issue comes if we also need that device for taking the crashdump.
If we do not need it, then pointing all of that device's IOVAs at a safe
buffer -- as you recommend -- looks like a good solution.

If kdump does need it, I can think of two ways to handle things:
1. Just leave it. This is what happens when there is no hardware iommu
   active, and this has worked OK there for a long time.  This option
   clearly depends upon the 1:1 passthrough device not being the problem.
   This is also what my patches do, since they are modeled on handling
   the DMA buffers in the same manner as when there is no iommu active.

2. As you suggest, create a safe buffer and force all of this device's 
   IOVAs into it.  Then begin mapping real buffers when the kdump kernel
   begins using the device.

>
>After the last round of this patchset, we discussed a potential
>improvement where you point every virtual bus address at the *same*
>physical scratch page.
>
>That way, we allow the "rogue" DMA to continue to the same virtual bus
>addresses, but it can only ever affect one piece of physical memory and
>can't have detrimental effects elsewhere.

Just a few technical observations and questions that hopefully will help
implement this enhancement:

Since each device may eventually be used by the kdump kernel, then each
device will need its own domain-id and its own set of DMA page tables 
so that the IOVAs requested by the kdump kernel can map that device's
IOVAs to that device's buffers.

As IO devices have grown smarter, many of them, particularly NICs and
storage interfaces, use DMA for work queues and status-reporting
vectors in addition to buffers of data to be transferred.  
Some experimenting and testing may be necessary to determine how
these devices behave when the translation for the work queue is
switched to a safe-buffer which does not contain valid entries for
that device.  

Questions that came to mind as I thought about this proposal:
1. Does the iommu need to know when the device driver has reset the device
   and that it is safe to add translations to the DMA page tables?

2. If it needs to know, how does it know, since the device driver asking
   for an IOVA via the DMA subsystem is usually the first indication to
   the iommu driver about the device and this may not guarantee that the
   device driver has already reset the device at that point?

3. For any given device, which IOVAs will be mapped to the safe buffer ?
   a. Only the IOVAs active at the time of the panic, which would require
      scanning the existing DMA page tables to find them.
   b. All possible IOVAs ? This would seem to be a very large number of
      pages for the page tables -- especially since each device may need
      its own set of DMA page tables.  There could still be only one
      "safe data buffer" with a lot of page tables pointing to it.
   c. Determine these "on the fly" by capturing DMAR faults or some similar
      mechanism ?
   d. Other possibilities ?


>
>Was that option considered and discounted for some reason? It seems like
>it would make sense.



--
Bill Sumner


Forwarded by Jerry Hoemann

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

