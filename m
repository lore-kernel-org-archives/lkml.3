Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaIIO0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:26:46 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41025 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbaIIO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:26:43 -0400
MIME-Version: 1.0
In-Reply-To: <540EC8CB.7010106@huawei.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com> <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com>
 <20140908145459.GO27864@e106497-lin.cambridge.arm.com> <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
 <20140908155931.GP27864@e106497-lin.cambridge.arm.com> <540E960D.7080408@huawei.com>
 <20140909084621.GS27864@e106497-lin.cambridge.arm.com> <540EC8CB.7010106@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 9 Sep 2014 08:26:19 -0600
Message-ID: <CAErSpo4cAfom2=07NYDRfTCdHO22M0v+ueiaZuG6v2Xd18wEnQ@mail.gmail.com>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI domain_nr
To: Yijing Wang <wangyijing@huawei.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Rob Herring <robherring2@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 3:30 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> On 2014/9/9 16:46, Liviu Dudau wrote:
>> On Tue, Sep 09, 2014 at 06:54:21AM +0100, Yijing Wang wrote:
>>>>>> on new requests. This function gets called quite a lot and I'm trying not to
>>>>>> make it too heavy weight.
>>>>>
>>>>> Generally, nothing should be accessing the same DT value frequently.
>>>>> It should get cached somewhere.
>>>>>
>>>>
>>>> The problem appears for DTs that don't have the pci-domain info. Then the cached
>>>> value is left at the default non-valid value and attempts to rescan the DT will
>>>> be made every time the function is called.
>>>>
>>>>> I don't really understand how domains are used so it's hard to provide
>>>>> a recommendation here. Do domains even belong in the DT?
>>>>
>>>> ACPI calls them segments and the way Bjorn explained it to me at some moment was
>>>> that it was an attempt to split up a bus in different groups (or alternatively,
>>>> merge a few busses together). To be honest I haven't seen systems where the domain
>>>> is anything other than zero, but JasonG (or maybe Benjamin) were floating an
>>>> idea of using the domain number to identify physical slots.
>>>
>>> PCI domain(or named segment) is provided by firmware, in ACPI system, we evaluated it
>>> by method "_SEG". in IA64 with ACPI, PCI hostbridge driver retrieves the domain from ACPI,
>>> if it's absent, the default domain is zero. So I wonder why in DTS, if it's absent, we get
>>> a auto increment domain value.
>>
>> Because you can have more than one hostbridge (rare, but not impossible) and unless you
>> want to join the two segments, you might want to give it a different domain.
>
> OK. Sorry, I have one last question, because domain will be used to calculate the address used to
> access PCI hardware config registers. So if DTS file doesn't report the domain, how do we know
> we would access the right registers when we use the auto increment domain vaule ?
> Has there a mechanism to make sure system can access the correct registers by the domain ?

I think you're referring to config access via ECAM (PCIe r3.0, sec
7.2.2).  In that case, I don't think the domain should be used to
compute the memory-mapped configuration address.  Each host bridge is
in exactly one domain, and each host bridge has an associated ECAM
area base.  The address calculation uses the bus number, device
number, function number, and register number to compute an offset into
the ECAM area.

So as long as the DT tells you the ECAM information for each host
bridge, that should be sufficient.  The domain number is then just a
Linux convenience and is not tied to the platform as it is on ia64.

Bjorn
