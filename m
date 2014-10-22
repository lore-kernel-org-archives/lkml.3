Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaJVRYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:24:49 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:61234 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaJVRYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <5447E12F.2030905@gmail.com>
References: <1412925191-27970-1-git-send-email-zhen-hual@hp.com>
 <543CEE32.50109@hp.com> <543E2CD5.60708@jp.fujitsu.com> <CAErSpo4isVMeBipp3TngVtZ2CmeQva-6RSHgS8O4C9M+p1ua=Q@mail.gmail.com>
 <5447E12F.2030905@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 22 Oct 2014 11:24:23 -0600
Message-ID: <CAErSpo4JhOyT=HX95uMeghAtnQC1UJQ+NkSbAoRk_2zFrh3vVA@mail.gmail.com>
Subject: Re: [PATCH 1/1] pci: fix dmar fault for kdump kernel
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linda.knippers@hp.com, jerry.hoemann@hp.com, lisa.mitchell@hp.com,
        rwright@hp.com, Joerg Roedel <joro@8bytes.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tom Vaden <tom.vaden@hp.com>, David Woodhouse <dwmw2@infradead.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:54 AM, Alexander Duyck
<alexander.duyck@gmail.com> wrote:
> On 10/21/2014 07:47 PM, Bjorn Helgaas wrote:
>> [+cc Joerg, Eric, Tom, David, iommu list]
>>
>> On Wed, Oct 15, 2014 at 2:14 AM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
>>> (2014/10/14 18:34), Li, ZhenHua wrote:
>>>> I tested on the latest stable version 3.17, it works well.
>>>>
>>>> On 10/10/2014 03:13 PM, Li, Zhen-Hua wrote:

>>>>> To fix this DMAR fault, we need to reset the bus that this device on. Reset
>>>>> the device itself does not work.
>> You have not explained why the DMAR faults are a problem.  The fault
>> is just an indication that the IOMMU prevented a DMA from completing.
>> If the DMA is an artifact of the crashed kernel, we probably don't
>> *want* it to complete, so taking a DMAR fault seems like exactly the
>> right thing.
>>
>> If the problem is that we're being flooded with messages, it's easy
>> enough to just tone down the printks.
>
> As I recall what we have seen in the past with the network controllers
> is that they get stuck in a state where they can no longer perform any
> DMA due to the fact that some of the transactions have returned errors
> from the IOMMU being reset.  The only way out is to perform a PCIe reset
> on the part after the IOMMU has been enabled which doesn't occur
> automatically unless AER or EEH is enabled in the system.

OK, now we're talking about a real issue, the sort of thing that
should be in the changelog for a change like this.

I'm uneasy about the strategy of "it hurts when an IOMMU fault occurs,
therefore we need to avoid all IOMMU faults."  Isn't the whole *point*
of an IOMMU to generate faults?  It seems like we need to be able to
handle faults gracefully.

If having AER or EEH enabled in the kdump kernel is part of what's
required to recover, I don't see a problem with requiring that.

Don't we have to be able to recover from IOMMU faults for the device
pass-through case anyway?  If a NIC is passed through to a malicious
guest, I assume the guest can cause IOMMU faults.  I assume we handle
this today by resetting the NIC when the guest exits.

> One thought would be to take a look at the IOMMU reset code.  Is there
> any way to go through and make sure that all of the PCI devices that
> make use of the IOMMU have the bus mastering disabled prior to the IOMMU
> being reset?  For example could we suspend all of the parts in order to
> force them to hold off any transactions, and then resume them after the
> IOMMU has been reset?  If we could do at least that much that would
> prevent the errors and should allow for a graceful reset.
>
> Thanks,
>
> Alex
>
>
