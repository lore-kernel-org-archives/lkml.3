Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaKDLgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:36:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48971 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaKDLgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:36:07 -0500
Message-ID: <5458B9FC.3050309@ti.com>
Date: Tue, 4 Nov 2014 13:35:24 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com> <20141103105716.GC23162@arm.com> <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On 11/03/2014 01:10 PM, Stefano Stabellini wrote:
> On Mon, 3 Nov 2014, Will Deacon wrote:
>> On Mon, Nov 03, 2014 at 10:46:03AM +0000, Stefano Stabellini wrote:
>>> On Mon, 27 Oct 2014, Stefano Stabellini wrote:
>>>> Introduce a boolean flag and an accessor function to check whether a
>>>> device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
>>>>
>>>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>>> CC: will.deacon@arm.com
>>>
>>> Will, Catalin,
>>> are you OK with this patch?
>>
>> It would be nicer if the dma_coherent flag didn't have to be duplicated by
>> each architecture in dev_archdata. Is there any reason not to put it in the
>> core code?
> 
> Yes, there is a reason for it: if I added a boolean dma_coherent flag in
> struct device as Catalin initially suggested, what would be the default
> for each architecture? Where would I set it for arch that don't use
> device tree? It is not easy.
> 
> I thought it would be better to introduce is_device_dma_coherent only on
> the architectures where it certainly makes sense to have it. In fact I
> checked and arm and arm64 are the only architectures to define
> set_arch_dma_coherent_ops at the moment. At that point if
> is_device_dma_coherent becomes arch-specific, it makes sense to store
> the flag in dev_archdata instead of struct device.

The proposition from Will looks reasonable for me too, because
there is "small" side-effect of adding such kind of properties to
arch-specific data or even to the core device structure. ;(

There are some sub-systems in kernel which do not create their devices
from DT and instead some host device populates its children devices manually.
 Now, I know at least two cases:
- usb: dwc3 core creates xhci device manually
- pci: adds its client devices

In such, case DMA configuration have to be propagated from host to
child (in our case host device's got DMA configuration from DT), like:
	dma_set_coherent_mask(&xhci->dev, dwc->dev->coherent_dma_mask);

	xhci->dev.parent	= dwc->dev;
	xhci->dev.dma_mask	= dwc->dev->dma_mask;
	xhci->dev.dma_parms	= dwc->dev->dma_parms;

So, once new DMA property is added it has to be propagated from 
host to child device too.

Recently, the new property  dma_pfn_offset was introduced in struct device 
and such kind of problem was observed on keystone 2:
- for usb case it was fixed using Platform Bus notifier (xhci - platform device)
- for pci - the work is in progress, because solution with PCI Bus notifier
  was rejected https://lkml.org/lkml/2014/10/10/308.

In general, if dma_coherent will belong to struct device then
such problems will be possible to fix directly in drivers/subsystems:
xhci->dev.dma_coherent	= dwc->dev->dma_coherent;

But, if it will be arch-specific data then it will be impossible to
set it without introducing proper and arch-specific setters/getters functions.

Also, as an idea, we are thinking about introducing something like:
  void dma_apply_parent_cfg(struct device *dev, struct device *parent)
which will ensure that all DMA configuration properly copied from
parent to children device. Now it should be (as minimum for ARM):
 dma_mask
 coherent_dma_mask
 dma_parms
 dma_pfn_offset
 dev_archdata->dma_ops
 [dma_coherent]?

regards,
-grygorii 

