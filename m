Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbaFTXQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:16:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60708 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaFTXQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:16:28 -0400
Message-ID: <53A4C0C9.2050908@codeaurora.org>
Date: Fri, 20 Jun 2014 16:16:25 -0700
From: Olav Haugan <ohaugan@codeaurora.org>
Organization: Qualcomm Innovation Center, Inc.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com> <4545972.cM7IP1qTXQ@wuerfel>
In-Reply-To: <4545972.cM7IP1qTXQ@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/2014 12:06 PM, Arnd Bergmann wrote:
> On Friday 30 May 2014 08:16:05 Rob Herring wrote:
>> On Fri, May 23, 2014 at 3:33 PM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>> +IOMMU master node:
>>> +==================
>>> +
>>> +Devices that access memory through an IOMMU are called masters. A device can
>>> +have multiple master interfaces (to one or more IOMMU devices).
>>> +
>>> +Required properties:
>>> +--------------------
>>> +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
>>> +  master interfaces of the device. One entry in the list describes one master
>>> +  interface of the device.
>>> +
>>> +When an "iommus" property is specified in a device tree node, the IOMMU will
>>> +be used for address translation. If a "dma-ranges" property exists in the
>>> +device's parent node it will be ignored. An exception to this rule is if the
>>> +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
>>> +parent shall take effect.
>>
>> Just thinking out loud, could you have dma-ranges in the iommu node
>> for the case when the iommu is enabled rather than putting the DMA
>> window information into the iommus property?
>>
>> This would probably mean that you need both #iommu-cells and #address-cells.
> 
> The reason for doing like this was that you may need a different window
> for each device, while there can only be one dma-ranges property in 
> an iommu node.
> 
>>> +
>>> +Optional properties:
>>> +--------------------
>>> +- iommu-names: A list of names identifying each entry in the "iommus"
>>> +  property.
>>
>> Do we really need a name here? I would not expect that you have
>> clearly documented names here from the datasheet like you would for
>> interrupts or clocks, so you'd just be making up names. Sorry, but I'm
>> not a fan of names properties in general.
> 
> Good point, this was really overdesign by modeling it after other
> subsystems that can have a use for names.
>  
>>> +Multiple-master IOMMU:
>>> +----------------------
>>> +
>>> +       iommu {
>>> +               /* the specifier represents the ID of the master */
>>> +               #address-cells = <1>;
>>> +               #size-cells = <0>;
>>> +       };
>>> +
>>> +       master {
>>> +               /* device has master ID 42 in the IOMMU */
>>> +               iommus = <&/iommu 42>;
>>> +       };
>>
>> Presumably the ID would be the streamID on ARM's SMMU. How would a
>> master with 8 streamIDs be described? This is what Calxeda midway has
>> for SATA and I would expect that to be somewhat common. Either you
>> need some ID masking or you'll have lots of duplication when you have
>> windows.
> 
> I don't understand the problem. If you have stream IDs 0 through 7,
> you would have
> 
> 	master@a {
> 		...
> 		iommus = <&smmu 0>;
> 	};
> 
> 	master@b {
> 		...
> 		iommus = <&smmu 1;
> 	};
> 
> 	...
> 
> 	master@12 {
> 		...
> 		iommus = <&smmu 7;
> 	};
> 
> and you don't need a window at all. Why would you need a mask of
> some sort?

We have multiple-master SMMUs and each master emits a variable number of
StreamIDs. However, we have to apply a mask (the ARM SMMU spec allows
for this) to the StreamIDs due to limited number of StreamID 2 Context
Bank entries in the SMMU. If my understanding is correct we would
represent this in the DT like this:

	iommu {
		#address-cells = <2>;
		#size-cells = <0>;
	};

	master@a {
		...
		iommus = <&iommu StreamID0 MASK0>,
			 <&iommu StreamID1 MASK1>,
			 <&iommu StreamID2 MASK2>;
	};

	master@b {
		...
		iommus = <&iommu StreamID3 MASK3>,
			 <&iommu StreamID4 MASK4>;
	};


Thanks,

Olav Haugan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
