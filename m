Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaJVDSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 23:18:18 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:34523 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaJVDSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 23:18:16 -0400
Message-ID: <54471FB4.4030602@hp.com>
Date: Wed, 22 Oct 2014 11:08:36 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Hoemann, Jerry" <jerry.hoemann@hp.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, Baoquan He <bhe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        doug.hatch@hp.com,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        zhenhua@hp.com,
        "Vaden, Tom L (HP Server OS Architecture)" <tom.vaden@hp.com>
Subject: Re: [PATCH 0/8] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com> <1398854973.12733.23.camel@i7.infradead.org> <20140702133258.GN26537@8bytes.org> <CAErSpo69VmK5zD-ztNVHCA=KrK8zucqubY17z0K3rcpe6ReNUA@mail.gmail.com> <87mw8on7lx.fsf@x220.int.ebiederm.org>
In-Reply-To: <87mw8on7lx.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need more time to read and think about these mails. I just want to 
clarify one thing: Bill has left HP, and now I inherited his works.
That's why I sent an update of his patch
	https://lkml.org/lkml/2014/10/21/134

On 10/22/2014 10:47 AM, Eric W. Biederman wrote:
> Bjorn Helgaas <bhelgaas@google.com> writes:
>
>> [-cc Bill, +cc Zhen-Hua, Eric, Tom, Jerry]
>>
>> Hi Joerg,
>>
>> I was looking at Zhen-Hua's recent patches, trying to figure out if I
>> need to do anything with them.  Resetting devices in the old kernel
>> seems like a non-starter.  Resetting devices in the new kernel, ...,
>> well, maybe.  It seems ugly, and it seems like the sort of problem
>> that IOMMUs are designed to solve.  Anyway, I found this old
>> discussion that I didn't quite understand:
>
> For context here is the kexec on panic design, and what I know from
> previous rounds of similar conversations.
>
> The way kexec on panic aka kdump is designed to work is that the
> recovery kernel lives in a piece of memory reserved at boot time and
> known not to be in use by any driver (because we never ever use it for
> DMA).  If DMA's continue from any source the old kernel may be a little
> more corrupted but our currently running kernel should not.
>
> Device drivers that we use in the recovery kernel are required to be
> able to initialize their devices from an arbitrary state or fail to
> initialize their devices.
>
> We have discussed things on various occassions but IOMMUs all have their
> own individual idiosynchrousies and came late to the party so that it
> is hard to generalize.
>
> The reserved region is generally low enough in memory that simply
> not using IOMMUs works.
>
> The major challenge with initializing an IOMMU would be that there are
> potentially devices whose driver is not loaded in the recover kernel
> with on-going DMA sessions (perhaps a NIC in response to network
> packet).
>
> Which essentially means that if you are going to use an IOMMU slot in a
> recovery kernel you have to either know that IOMMU slot was reserved for
> the recovery kernel (what has always felt like the easiest way to me).
> Or you have to know everything that could target that IOMMU slot has
> been reset or has it's driver loaded.
>
> I have always thought the simplist and easiest solution would be to
> reserve a few IOMMU slots for the kexec on panic kernel.  But if folks
> can find other ways to guarantee that an on-going DMA isn't targeting
> an IOMMU slot (such as resetting everything downstream from that
> IOMMU slot) more power to you.
>
>> On Wed, Jul 2, 2014 at 7:32 AM, Joerg Roedel <joro@8bytes.org> wrote:
>>> On Wed, Apr 30, 2014 at 11:49:33AM +0100, David Woodhouse wrote:
>>
>>>> After the last round of this patchset, we discussed a potential
>>>> improvement where you point every virtual bus address at the *same*
>>>> physical scratch page.
>>>
>>> That is a solution to prevent the in-flight DMA failures. But what
>>> happens when there is some in-flight DMA to a disk to write some inodes
>>> or a new superblock. Then this scratch address-space may cause
>>> filesystem corruption at worst.
>>
>> This in-flight DMA is from a device programmed by the old kernel, and
>> it would be reading data from the old kernel's buffers.  I think
>> you're suggesting that we might want that DMA read to complete so the
>> device can update filesystem metadata?
>>
>> I don't really understand that argument.  Don't we usually want to
>> stop any data from escaping the machine after a crash, on the theory
>> that the old kernel is crashing because something is catastrophically
>> wrong and we may have already corrupted things in memory?  If so,
>> allowing this old DMA to complete is just as likely to make things
>> worse as to make them better.
>>
>> Without kdump, we likely would reboot through the BIOS and the device
>> would get reset and the DMA would never happen at all.  So if we made
>> the dump kernel program the IOMMU to prevent the DMA, that seems like
>> a similar situation.
>>
>>> So with this in mind I would prefer initially taking over the
>>> page-tables from the old kernel before the device drivers re-initialize
>>> the devices.
>>
>> This makes the dump kernel more dependent on data from the old kernel,
>> which we obviously want to avoid when possible.
>>
>> I didn't find the previous discussion where pointing every virtual bus
>> address at the same physical scratch page was proposed.  Why was that
>> better than programming the IOMMU to reject every DMA?
>>
>> Bjorn
>
> Eric
>

