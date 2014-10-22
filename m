Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaJVS0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:26:38 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35579 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbaJVS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141022132158.GD10074@8bytes.org>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
 <1398854973.12733.23.camel@i7.infradead.org> <20140702133258.GN26537@8bytes.org>
 <CAErSpo69VmK5zD-ztNVHCA=KrK8zucqubY17z0K3rcpe6ReNUA@mail.gmail.com> <20141022132158.GD10074@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 22 Oct 2014 12:26:07 -0600
Message-ID: <CAErSpo60ziF7hG8ek322LoNATy6O=OhFn4XFBxbP5_SDRnGg8w@mail.gmail.com>
Subject: Re: [PATCH 0/8] iommu/vt-d: Fix crash dump failure caused by legacy DMA/IO
To: Joerg Roedel <joro@8bytes.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "Hoemann, Jerry" <jerry.hoemann@hp.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, Baoquan He <bhe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        doug.hatch@hp.com,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        zhenhua@hp.com, Zhen-Hua <zhen-hual@hp.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Vaden, Tom L (HP Server OS Architecture)" <tom.vaden@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 7:21 AM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi Bjorn,
>
> On Tue, Oct 21, 2014 at 08:16:46PM -0600, Bjorn Helgaas wrote:
>> I was looking at Zhen-Hua's recent patches, trying to figure out if I
>> need to do anything with them.  Resetting devices in the old kernel
>> seems like a non-starter.  Resetting devices in the new kernel, ...,
>> well, maybe.  It seems ugly, and it seems like the sort of problem
>> that IOMMUs are designed to solve.
>
> Actually resetting the devices in the kdump kernel would be one of the
> better solutions for this problem. When we have a generic way to stop
> all in-flight DMA from the PCI endpoints we could safely disable and
> then re-enable the IOMMU.
>
>> On Wed, Jul 2, 2014 at 7:32 AM, Joerg Roedel <joro@8bytes.org> wrote:
>> > That is a solution to prevent the in-flight DMA failures. But what
>> > happens when there is some in-flight DMA to a disk to write some inodes
>> > or a new superblock. Then this scratch address-space may cause
>> > filesystem corruption at worst.
>>
>> This in-flight DMA is from a device programmed by the old kernel, and
>> it would be reading data from the old kernel's buffers.  I think
>> you're suggesting that we might want that DMA read to complete so the
>> device can update filesystem metadata?
>
> Well, it is not about updating filesystem metadata. In the kdump kernel
> we have these options:
>
>         1) Disable the IOMMU. Problem here is, that DMA is now
>            untranslated, so that any in-flight DMA might read or write
>            from a random location in memory, corrupting the kdump or
>            even the new kexec kernel memory. So this is a non-starter.

Agreed (at least if the IOMMU was enabled in the crashed kernel).

>         2) Re-program the IOMMU to block all DMA. This is safer as it
>            does not corrupt any data in memory. But some devices react
>            very poorly on a master abort from the IOMMU, so bad that the
>            driver in the kdump kernel fails to initialize that device.
>            In this case taking dump itself might fail (and often does,
>            according to reports)

Sounds like an option, even though broken devices work poorly.

>         3) To prevent master aborts like in option (2), David suggested
>            to map the whole DMA address space to a scratch page. This
>            also prevents system memory corruption and the master aborts.
>            But the problem is, that in-flight DMA will now read all
>            zeros. This can corrupt disk and network data, at worst it
>            nulls out the superblocks of your filesystem and you lose all
>            data. So this is not an option too.

Ah, yes, I see your point now.  This allows corrupted data, e.g., all
zeroes, to be written to disk or network after the kernel crash.  I
agree; this doesn't sound like a good option.

And the proposal below is a 4th option (leave IOMMU enabled, reusing
crashed kernel's mappings until drivers make new mappings).

> What we currently do in the VT-d driver is a mixture of (1) and (2). The
> VT-d driver disables the IOMMU hardware (opening a race window for
> memory data corruption), re-initializes it to reject any ongoing DMA
> (which causes master aborts for in-flight DMA) and re-enables the IOMMU
> hardware.
>
> But this strategy fails in heavy IO environments quite often and we look
> into ways to solve the problem, or at least improve the current
> situation as good as we can.
>
> I talked to David about this at LPC and we came up with basically this
> procedure:
>
>         1. If the VT-d driver finds the IOMMU enabled, it reuses its
>            root-context table. This way the IOMMU must not be disabled
>            and re-enabled, eliminating the race we have now.
>            Other data structures like the context-entries are copied
>            over from the old kernel.  We basically keep all mappings
>            from the old kernel, allowing any in-flight DMA to succeed.
>            No memory or disk data corruption.

If the crashed kernel had corrupted memory, couldn't an in-flight DMA
read that corrupted data from memory and write it to disk?

I guess you could argue that this is merely a race, and the in-flight
DMA could just as easily have happened before the kernel crash, so
there's always a window and the only question is whether it closes
when the IOMMU driver starts up or when the device driver starts up.

>            The issue here is, that we modify data from the old kernel
>            which is about to be dumped. But there are ways to work
>            around that.
>
>         2. When a device driver issues the first dma_map command for a
>            device, we assign a new and empty page-table, thus removing
>            all mappings from the old kernel for the device.
>            Rationale is, that at this point the device driver should
>            have reset the device to a point where all in-flight DMA is
>            canceled.
>
> This approach goes into the same direction as Bill Sumners patch-set,
> which Li took over. But it goes not as far as keeping the old mappings
> while the kdump kernel is still working with the devices (which might
> introduce new issues and corner cases).
>
>> > So with this in mind I would prefer initially taking over the
>> > page-tables from the old kernel before the device drivers re-initialize
>> > the devices.
>>
>> This makes the dump kernel more dependent on data from the old kernel,
>> which we obviously want to avoid when possible.
>
> Sure, but this is not really possible here (unless we have a generic and
> reliable way to reset all PCI endpoint devices and cancel all in-flight
> DMA before we disable the IOMMU in the kdump kernel).
> Otherwise we always risk data corruption somewhere, in system memory or
> on disk.
>
>> I didn't find the previous discussion where pointing every virtual bus
>> address at the same physical scratch page was proposed.  Why was that
>> better than programming the IOMMU to reject every DMA?
>
> As I said, the problem is that this causes master aborts which some
> devices can't recover from, so that the device driver in the kdump
> kernel fails to initialize the device.

Yes, thanks for making that explicit again.

Bjorn
