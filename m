Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaJVCRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:17:10 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39376 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaJVCRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:17:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140702133258.GN26537@8bytes.org>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
 <1398854973.12733.23.camel@i7.infradead.org> <20140702133258.GN26537@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 21 Oct 2014 20:16:46 -0600
Message-ID: <CAErSpo69VmK5zD-ztNVHCA=KrK8zucqubY17z0K3rcpe6ReNUA@mail.gmail.com>
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

[-cc Bill, +cc Zhen-Hua, Eric, Tom, Jerry]

Hi Joerg,

I was looking at Zhen-Hua's recent patches, trying to figure out if I
need to do anything with them.  Resetting devices in the old kernel
seems like a non-starter.  Resetting devices in the new kernel, ...,
well, maybe.  It seems ugly, and it seems like the sort of problem
that IOMMUs are designed to solve.  Anyway, I found this old
discussion that I didn't quite understand:

On Wed, Jul 2, 2014 at 7:32 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Wed, Apr 30, 2014 at 11:49:33AM +0100, David Woodhouse wrote:

>> After the last round of this patchset, we discussed a potential
>> improvement where you point every virtual bus address at the *same*
>> physical scratch page.
>
> That is a solution to prevent the in-flight DMA failures. But what
> happens when there is some in-flight DMA to a disk to write some inodes
> or a new superblock. Then this scratch address-space may cause
> filesystem corruption at worst.

This in-flight DMA is from a device programmed by the old kernel, and
it would be reading data from the old kernel's buffers.  I think
you're suggesting that we might want that DMA read to complete so the
device can update filesystem metadata?

I don't really understand that argument.  Don't we usually want to
stop any data from escaping the machine after a crash, on the theory
that the old kernel is crashing because something is catastrophically
wrong and we may have already corrupted things in memory?  If so,
allowing this old DMA to complete is just as likely to make things
worse as to make them better.

Without kdump, we likely would reboot through the BIOS and the device
would get reset and the DMA would never happen at all.  So if we made
the dump kernel program the IOMMU to prevent the DMA, that seems like
a similar situation.

> So with this in mind I would prefer initially taking over the
> page-tables from the old kernel before the device drivers re-initialize
> the devices.

This makes the dump kernel more dependent on data from the old kernel,
which we obviously want to avoid when possible.

I didn't find the previous discussion where pointing every virtual bus
address at the same physical scratch page was proposed.  Why was that
better than programming the IOMMU to reject every DMA?

Bjorn
