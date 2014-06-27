Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaF0WXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 18:23:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58775 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaF0WXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 18:23:30 -0400
Message-ID: <53ADEEDF.7060902@codeaurora.org>
Date: Fri, 27 Jun 2014 15:23:27 -0700
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
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com> <4545972.cM7IP1qTXQ@wuerfel> <53A4C0C9.2050908@codeaurora.org> <20140624091808.GC26013@arm.com> <53A9BC18.2090106@codeaurora.org> <20140624181150.GB4067@arm.com> <53A9EF3A.2070704@codeaurora.org> <20140625091858.GG6153@arm.com>
In-Reply-To: <20140625091858.GG6153@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/2014 2:18 AM, Will Deacon wrote:
> On Tue, Jun 24, 2014 at 10:35:54PM +0100, Olav Haugan wrote:
>> On 6/24/2014 11:11 AM, Will Deacon wrote:
>>> On Tue, Jun 24, 2014 at 06:57:44PM +0100, Olav Haugan wrote:
>>>> On 6/24/2014 2:18 AM, Will Deacon wrote:
>>>>> On Sat, Jun 21, 2014 at 12:16:25AM +0100, Olav Haugan wrote:
>>>>>> We have multiple-master SMMUs and each master emits a variable number of
>>>>>> StreamIDs. However, we have to apply a mask (the ARM SMMU spec allows
>>>>>> for this) to the StreamIDs due to limited number of StreamID 2 Context
>>>>>> Bank entries in the SMMU. If my understanding is correct we would
>>>>>> represent this in the DT like this:
>>>>>>
>>>>>> 	iommu {
>>>>>> 		#address-cells = <2>;
>>>>>> 		#size-cells = <0>;
>>>>>> 	};
>>>>>>
>>>>>> 	master@a {
>>>>>> 		...
>>>>>> 		iommus = <&iommu StreamID0 MASK0>,
>>>>>> 			 <&iommu StreamID1 MASK1>,
>>>>>> 			 <&iommu StreamID2 MASK2>;
>>>>>> 	};
>>>>>
>>>>> Stupid question, but why not simply describe the masked IDs? What use does
>>>>> the `raw' ID have to Linux?
>>>>
>>>> We do describe the masked StreamID (SID) but we need to specify the mask
>>>> that the SMMU should apply to the incoming SIDs, right?
>>>>
>>>> We have a bus master that emits 43 unique SIDs. However, we have only 40
>>>> SMMU_SMRn registers in the SMMU. So we need to mask out some of the
>>>> incoming SID bits so that the 43 SIDs can match one of 40 entries in the
>>>> SMR.
>>>
>>> Hmm, so you're talking about stream matching, right? That doesn't belong in
>>> the device-tree. I appreciate that the current driver does a terrible job at
>>> allocating the SMRs (it's bloody difficult!), but we should try to improve
>>> the dynamic behaviour instead of moving configuration of the SMMU out into
>>> device-tree, where it's inflexible at best.
>>
>> I am talking about SMMU_SMRn[MASK] register bits. This is not something
>> that can be dynamically detected at run-time. It is configuration at the
>> same level as the actual StreamIDs.
> 
> Why can't it be dynamically detected? Whilst the StreamIDs are fixed in
> hardware (from the SMMU architecture perspective), the SMRs are completely
> programmable. Why doesn't something like Andreas's proposal work for you?
> The idea there was to find the constant bits among the StreamIDs for a
> master and create the mask accordingly.
> 
Lets say I have an IOMMU with 2 masters and 2 SMRn slots with the
following stream IDs coming from the masters:

Master 1: 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28
Master 2: 0x30

To make this work I would program SMR[0] with StreamID 0x20 and mask 0xF
to ignore lower 4 bits. SMR[1] would just be StreamID 0x30 with mask 0x0.

However, I could also have an IOMMU with 2 masters and 9 SMRn slots with
the following stream IDs:

Master 1: 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28
Master 2: 0x29

Here I would program all SMRn and leave the mask to be 0 for all SMRn's.
So how do I detect when to apply a mask or not?

I am not familiar with Andreas's proposal. Do you have a link?

Thanks,

Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
