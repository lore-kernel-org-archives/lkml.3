Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbaE3Tb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:31:59 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61506 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaE3Tb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <4545972.cM7IP1qTXQ@wuerfel>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
	<CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com>
	<4545972.cM7IP1qTXQ@wuerfel>
Date: Fri, 30 May 2014 14:31:55 -0500
Message-ID: <CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 2:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 30 May 2014 08:16:05 Rob Herring wrote:
>> On Fri, May 23, 2014 at 3:33 PM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>> > From: Thierry Reding <treding@nvidia.com>
>> > +IOMMU master node:
>> > +==================
>> > +
>> > +Devices that access memory through an IOMMU are called masters. A device can
>> > +have multiple master interfaces (to one or more IOMMU devices).
>> > +
>> > +Required properties:
>> > +--------------------
>> > +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
>> > +  master interfaces of the device. One entry in the list describes one master
>> > +  interface of the device.
>> > +
>> > +When an "iommus" property is specified in a device tree node, the IOMMU will
>> > +be used for address translation. If a "dma-ranges" property exists in the
>> > +device's parent node it will be ignored. An exception to this rule is if the
>> > +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
>> > +parent shall take effect.
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

My suggestion was that you also put the IDs in the dma-ranges as the
first cell much as ranges for PCI encodes other information in the
first cell. Then you can have an entry for each ID. The downside is
another special case like PCI.

The argument for using #address-cells and #size-cells seems to be to
align with how ranges work. If that's the route we want to go, then I
say we should not stop there and actually use dma-ranges as well.
Otherwise, I don't see the advantage over #iommu-cells.

>> > +
>> > +Optional properties:
>> > +--------------------
>> > +- iommu-names: A list of names identifying each entry in the "iommus"
>> > +  property.
>>
>> Do we really need a name here? I would not expect that you have
>> clearly documented names here from the datasheet like you would for
>> interrupts or clocks, so you'd just be making up names. Sorry, but I'm
>> not a fan of names properties in general.
>
> Good point, this was really overdesign by modeling it after other
> subsystems that can have a use for names.
>
>> > +Multiple-master IOMMU:
>> > +----------------------
>> > +
>> > +       iommu {
>> > +               /* the specifier represents the ID of the master */
>> > +               #address-cells = <1>;
>> > +               #size-cells = <0>;
>> > +       };
>> > +
>> > +       master {
>> > +               /* device has master ID 42 in the IOMMU */
>> > +               iommus = <&/iommu 42>;
>> > +       };
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
>         master@a {
>                 ...
>                 iommus = <&smmu 0>;
>         };
>
>         master@b {
>                 ...
>                 iommus = <&smmu 1;
>         };
>
>         ...
>
>         master@12 {
>                 ...
>                 iommus = <&smmu 7;
>         };
>
> and you don't need a window at all. Why would you need a mask of
> some sort?

1 master with 7 IDs like this:

         master@a {
                 ...
                 iommus = <&smmu 0> <&smmu 1> <&smmu 2> <&smmu 3>
<&smmu 4> <&smmu 5> <&smmu 6> <&smmu 7>;
         };

If there was any sort of window, then it is almost certainly the same
window for each ID.

Rob
