Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934811AbaE3XRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:17:19 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41632 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934701AbaE3XRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140530230830.GG1677@bart.dudau.co.uk>
References: <1401379426-9701-1-git-send-email-galak@codeaurora.org>
 <CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com>
 <47B1E3D0-4336-4529-80B0-172F4ACA5C97@codeaurora.org> <20140530005602.GE1677@bart.dudau.co.uk>
 <CAErSpo7qEhJyUAu58R8g6+AEhRGo_+Vv0EMgkK+3ZQOU9+jmhg@mail.gmail.com>
 <20140530014116.GF1677@bart.dudau.co.uk> <F22EE9D6-8F58-4AF0-9684-71B7A3BFF868@codeaurora.org>
 <20140530230830.GG1677@bart.dudau.co.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 May 2014 17:16:52 -0600
Message-ID: <CAErSpo7ViLMCgR7rBmOxYJsVK1DBvkZTWpEDOPDQ0NjvQmwiiA@mail.gmail.com>
Subject: Re: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
To: Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 5:11 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> On Fri, May 30, 2014 at 03:45:05PM -0500, Kumar Gala wrote:
>>
>> On May 29, 2014, at 8:41 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
>>
>> > On Thu, May 29, 2014 at 07:29:31PM -0600, Bjorn Helgaas wrote:
>> >> On Thu, May 29, 2014 at 6:56 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
>> >>> On Thu, May 29, 2014 at 03:51:28PM -0500, Kumar Gala wrote:
>> >>>>
>> >>>> On May 29, 2014, at 3:44 PM, Rob Herring <robherring2@gmail.com> wrote:
>> >>>>
>> >>>>> On Thu, May 29, 2014 at 11:03 AM, Kumar Gala <galak@codeaurora.org> wrote:
>> >>>>>> If we have a PCI config space specified in something like a ranges
>> >>>>>> property we should treat it as memory type resource.
>> >>>>>
>> >>>>> Config space should not be in ranges[1]. We have some cases that are,
>> >>>>> but we don't want new ones.
>> >>>>
>> >>>> For the cases we have I agree, however an ECAM based cfg seems completely legit.
>> >>>>
>> >>>>>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> >>>>>> ---
>> >>>>>> drivers/of/address.c | 3 +++
>> >>>>>> 1 file changed, 3 insertions(+)
>> >>>>>>
>> >>>>>> diff --git a/drivers/of/address.c b/drivers/of/address.c
>> >>>>>> index cb4242a..4e7ee59 100644
>> >>>>>> --- a/drivers/of/address.c
>> >>>>>> +++ b/drivers/of/address.c
>> >>>>>> @@ -122,6 +122,9 @@ static unsigned int of_bus_pci_get_flags(const __be32 *addr)
>> >>>>>>       u32 w = be32_to_cpup(addr);
>> >>>>>>
>> >>>>>>       switch((w >> 24) & 0x03) {
>> >>>>>> +       case 0x00: /* cfg space */
>> >>>>>> +               flags |= IORESOURCE_MEM;
>> >>>>>> +               break;
>> >>>>>
>> >>>>> How would you then distinguish actual memory ranges?
>> >>>>
>> >>>> One assumes you are still looking at pci_space as part of of_pci_range
>> >>>
>> >>> That doesn't happen when you start scanning the bus. The existing code will
>> >>> use the IORESOURCE_MEM for allocating memory space for devices, which is
>> >>> not what you want. Did you test your patch on any PCI system? I'm pretty
>> >>> sure that with my patch series that tries to make a generic framework for
>> >>> host controllers this will fail.
>> >>>
>> >>> We really need a IORESOURCE_CFG flag for this space.
>> >>
>> >> Maybe, but I'm not convinced yet.  The existing IORESOURCE_TYPE_BITS
>> >> types are for things that are mutually exclusive address spaces.  I
>> >> think this discussion is about ECAM, where the CPU side is definitely
>> >> in the same address space (IORESOURCE_MEM) as RAM, APICs, host bridge
>> >> apertures, device MMIO, etc.  The ECAM area must appear in the
>> >> iomem_resource tree so we avoid it when allocating other areas.
>> >
>> > Agree, I'm only concerned that if this ECAM config space gets added to
>> > the list of pci_host_bridge windows it will be indistinguishable from
>> > IORESOURCE_MEM resources and pci_create_root_bus() will add it to the
>> > bus and allow devices present on that bus to be assigned addresses from
>> > that range. Which might not be what one wants for certain BARs.
>> >
>> > I've had an aborted attempt to parse ECAM ranges in one version of my
>> > series (granted, I was trying to hack the IORESOURCE_TYPE_BITS as well)
>> > and things got horribly wrong quickly. I could give this patch a go with
>> > my series tomorrow when I'm in the office and report back.
>>
>> We need to fix the parsing code to be smarter about this case.
>
> Wow, what a sweeping statement! Did you not understand that the issue is not
> the parsing code but the way the rest of the core code uses an IORESOURCE_MEM
> once you have parsed it into a resource structure and added it to the list
> of pci_host_bridge_windows?

Why do you want to add the ECAM area to the list of host bridge
windows?  My intent was that the windows tell the core what resources
are available for devices behind the bridge.

Bjorn
