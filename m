Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaIVWk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:40:26 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:55206 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755153AbaIVWkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4C_6mh7hais14254rYBeMYArvf=nETmgvBjgP290aD4Q@mail.gmail.com>
References: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
	<1410906824-9321-2-git-send-email-tinamdar@apm.com>
	<20140919223258.GA32208@google.com>
	<CACoXjcnVU3+fQHQ0-zEVRjoedrrod-aua6AVybj7UuSHO9HBaw@mail.gmail.com>
	<CAErSpo4C_6mh7hais14254rYBeMYArvf=nETmgvBjgP290aD4Q@mail.gmail.com>
Date: Mon, 22 Sep 2014 15:40:03 -0700
Message-ID: <CACoXjc=od24kz4RbMLOZNGbMwsAjc8+Ko0rEXNc=2yKnN_3NkQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/4] pci:host: APM X-Gene PCIe host controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 3:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Sep 22, 2014 at 3:33 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>
>>>> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
>>>> +{
>>>> +     int i;
>>>> +
>>>> +     /* Hide the PCI host BARs from the kernel as their content doesn't
>>>> +      * fit well in the resource management
>>>> +      */
>>>
>>> This needs a better explanation than "doesn't fit well."
>>>
>>> I *think* you're probably talking about something similar to the MVEBU
>>> devices mentioned here:
>>> http://lkml.kernel.org/r/CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com
>>>
>>> where the device can be configured as either an endpoint or a root port,
>>> and the endpoint BARs are still visible when configured as a root port.
>>>
>>
>> It is true that X-Gene PCIe port can be configured as EP, however the
>> the FIXUP is required not because of the BARs are still visible when
>> configured as EP in past. X-Gene PCIe port, when configured as RC,
>> uses BAR0-BAR1 of RC's configuration space as inbound BARs. Entire DDR
>> region is mapped in these BARs so that it is accessible for EP devices
>> for DMA. So if the fixup is not done during enumeration, whole
>> outbound memory resource space gets assigned to RC and nothing is left
>> EP devices.
>
> I'm not familiar with the concept of an "inbound BAR"; at least I'm
> not aware of anything like this in the PCI specs.  I think it might
> reduce confusion if we avoided calling them "BARs".  They happen to be
> at the same addresses where real BARs would be, but they certainly
> don't behave like real BARs.
>
> It sounds like this is basically a trivial IOMMU that determines which
> DMA accesses can reach main memory.
>

Yes. That is correct.

>>> In any event, I'd like a description of exactly what these BARs are and wha
>>> the problem is.
>>
>> Is it ok to put above description in comment to explain the fixup?
>>
>>> Presumably the BARs exist and were sized by the PCI core
>>> in __pci_read_base().  That will generate some log messages and possibly
>>> some warnings, depending on how the host bridge windows are set up.
>
> Instead of doing this in a fixup, can you change the PCI config
> accessors so that when accessing these inbound DMA mapping registers,
> they drop writes and return zeros for reads?  Then the PCI core won't
> think there are BARs there, and it won't mistakenly corrupt them when
> it tries to size them.
>

I suppose this can be done. I will fix this in next revision.

> Bjorn
