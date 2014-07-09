Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaGIBHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:07:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51786 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaGIBHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:07:41 -0400
Message-ID: <53BC95DA.1010500@codeaurora.org>
Date: Tue, 08 Jul 2014 18:07:38 -0700
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, mitchelh@codeaurora.org
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com> <4545972.cM7IP1qTXQ@wuerfel> <53A4C0C9.2050908@codeaurora.org> <20140624091808.GC26013@arm.com> <53A9BC18.2090106@codeaurora.org> <20140624181150.GB4067@arm.com> <53A9EF3A.2070704@codeaurora.org> <20140625091858.GG6153@arm.com> <53ADEEDF.7060902@codeaurora.org> <20140630095220.GA25779@arm.com>
In-Reply-To: <20140630095220.GA25779@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/2014 2:52 AM, Will Deacon wrote:
> Hi Olav,
> 
> On Fri, Jun 27, 2014 at 11:23:27PM +0100, Olav Haugan wrote:
>> On 6/25/2014 2:18 AM, Will Deacon wrote:
>>> Why can't it be dynamically detected? Whilst the StreamIDs are fixed in
>>> hardware (from the SMMU architecture perspective), the SMRs are completely
>>> programmable. Why doesn't something like Andreas's proposal work for you?
>>> The idea there was to find the constant bits among the StreamIDs for a
>>> master and create the mask accordingly.
>>>
>> Lets say I have an IOMMU with 2 masters and 2 SMRn slots with the
>> following stream IDs coming from the masters:
>>
>> Master 1: 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28
>> Master 2: 0x30
>>
>> To make this work I would program SMR[0] with StreamID 0x20 and mask 0xF
>> to ignore lower 4 bits. SMR[1] would just be StreamID 0x30 with mask 0x0.
>>
>> However, I could also have an IOMMU with 2 masters and 9 SMRn slots with
>> the following stream IDs:
>>
>> Master 1: 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28
>> Master 2: 0x29
>>
>> Here I would program all SMRn and leave the mask to be 0 for all SMRn's.
>> So how do I detect when to apply a mask or not?
> 
> You would aim to use the smallest number of SMRs per master possible.
> You could probably use:
> 
>   Master 1: SMR[0].id == 0x20, SMR[0].mask = 0x07
>             SMR[1].id == 0x28, SMR[1].mask = 0x00
> 
>   Master 2: SMR[2].id == 0x29, SMR[2].mask = 0x00

So how does an algorithm figure this out in both my examples? The
algorithm would have to know about both (all) bus masters and their
stream IDs for a specific SMMU. If the algorithm operates on the set of
stream IDs for one bus master at a time the algorithm has no way of
knowing which bits can be ignored since it doesn't know the value of the
other stream IDs for the other bus masters and thus could potentially
create a mask that could cause a stream ID to match in two different
entries.

>> I am not familiar with Andreas's proposal. Do you have a link?
> 
>   http://marc.info/?l=linux-arm-kernel&m=139110598005846&w=2

Unless I am mistaken the algorithm works on one bus master at a time. I
don't think that will work.

Thanks,

Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
