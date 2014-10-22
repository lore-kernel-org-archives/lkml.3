Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaJVQyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:54:13 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57526 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaJVQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:54:09 -0400
Message-ID: <5447E12F.2030905@gmail.com>
Date: Wed, 22 Oct 2014 09:54:07 -0700
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>
CC: "Li, Zhen-Hua" <zhen-hual@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linda.knippers@hp.com, jerry.hoemann@hp.com, lisa.mitchell@hp.com,
        rwright@hp.com, Joerg Roedel <joro@8bytes.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tom Vaden <tom.vaden@hp.com>, David Woodhouse <dwmw2@infradead.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1] pci: fix dmar fault for kdump kernel
References: <1412925191-27970-1-git-send-email-zhen-hual@hp.com> <543CEE32.50109@hp.com> <543E2CD5.60708@jp.fujitsu.com> <CAErSpo4isVMeBipp3TngVtZ2CmeQva-6RSHgS8O4C9M+p1ua=Q@mail.gmail.com>
In-Reply-To: <CAErSpo4isVMeBipp3TngVtZ2CmeQva-6RSHgS8O4C9M+p1ua=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 07:47 PM, Bjorn Helgaas wrote:
> [+cc Joerg, Eric, Tom, David, iommu list]
>
> On Wed, Oct 15, 2014 at 2:14 AM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
>> (2014/10/14 18:34), Li, ZhenHua wrote:
>>> I tested on the latest stable version 3.17, it works well.
>>>
>>> On 10/10/2014 03:13 PM, Li, Zhen-Hua wrote:
>>>> On a HP system with Intel vt-d supported and many PCI devices on it,
>>>> when kernel crashed and the kdump kernel boots with intel_iommu=on,
>>>> there may be some unexpected DMA requests on this adapter, which will
>>>> cause DMA Remapping faults like:
>>>>      dmar: DRHD: handling fault status reg 102
>>>>      dmar: DMAR:[DMA Read] Request device [41:00.0] fault addr fff81000
>>>>      DMAR:[fault reason 01] Present bit in root entry is clear
>>>>
>>>> This bug may happen on *any* PCI device.
>>>> Analysis for this bug:
>>>>
>>>> The present bit is set in this function:
>>>>
>>>> static struct context_entry * device_to_context_entry(
>>>>                  struct intel_iommu *iommu, u8 bus, u8 devfn)
>>>> {
>>>>      ......
>>>>                  set_root_present(root);
>>>>      ......
>>>> }
>>>>
>>>> Calling tree:
>>>>      device driver
>>>>          intel_alloc_coherent
>>>>              __intel_map_single
>>>>                  domain_context_mapping
>>>>                      domain_context_mapping_one
>>>>                          device_to_context_entry
>>>>
>>>> This means, the present bit in root entry will not be set until the device
>>>> driver is loaded.
>>>>
>>>> But in the kdump kernel, hardware devices are not aware that control has
>>>> transferred to the second kernel, and those drivers must initialize again.
>>>> Consequently there may be unexpected DMA requests from devices activity
>>>> initiated in the first kernel leading to the DMA Remapping errors in the
>>>> second kernel.
>>>>
>>>> To fix this DMAR fault, we need to reset the bus that this device on. Reset
>>>> the device itself does not work.
> You have not explained why the DMAR faults are a problem.  The fault
> is just an indication that the IOMMU prevented a DMA from completing.
> If the DMA is an artifact of the crashed kernel, we probably don't
> *want* it to complete, so taking a DMAR fault seems like exactly the
> right thing.
>
> If the problem is that we're being flooded with messages, it's easy
> enough to just tone down the printks.

As I recall what we have seen in the past with the network controllers
is that they get stuck in a state where they can no longer perform any
DMA due to the fact that some of the transactions have returned errors
from the IOMMU being reset.  The only way out is to perform a PCIe reset
on the part after the IOMMU has been enabled which doesn't occur
automatically unless AER or EEH is enabled in the system.

One thought would be to take a look at the IOMMU reset code.  Is there
any way to go through and make sure that all of the PCI devices that
make use of the IOMMU have the bus mastering disabled prior to the IOMMU
being reset?  For example could we suspend all of the parts in order to
force them to hold off any transactions, and then resume them after the
IOMMU has been reset?  If we could do at least that much that would
prevent the errors and should allow for a graceful reset.

Thanks,

Alex


