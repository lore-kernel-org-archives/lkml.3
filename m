Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaE3T3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:29:20 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1078 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbaE3T3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:29:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 30 May 2014 12:24:14 -0700
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com> <4545972.cM7IP1qTXQ@wuerfel>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
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
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
In-Reply-To: <4545972.cM7IP1qTXQ@wuerfel>
Date: Fri, 30 May 2014 22:29:13 +0300
Message-ID: <87tx87rrp2.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann <arnd@arndb.de> writes:

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

IIUC the original problem, "a master with 8 streamIDs" means something
like below, where some devices have multiple IDs but some have a
single. A sinle #address-cells cannot afford those 2 masters at once.

       iommu {
               /* the specifier represents the ID of the master */
               #address-cells = <1>;
               #size-cells = <0>;
       };

 	master@a {
 		...
 		iommus = <&smmu 1 2 3>; # 3 IDs
 	};

 	master@b {
 		...
 		iommus = <&smmu 4>;     # 1 ID
 	};

Tegra,SMMU has a similar problem and we have used a fixed size bitmap(64
bit) to afford 64 stream IDs so that a single device can hold multiple
IDs. If we apply the same bitmap to the above exmaple:

       iommu {
               /* the specifier represents the ID of the master */
               #address-cells = <1>;
               #size-cells = <0>;
       };

 	master@a {
 		...
 		iommus = <&smmu (BIT(1) | BIT(2) | BIT(3))>; # IDs 1 2 3
 	};

 	master@b {
 		...
 		iommus = <&smmu BIT(4)>;     # ID 4
 	};

The disadvantage of this is that this limits the max number of streamIDs
to support. If # of streamID is increased later more than 64, this
format cannot cover any more. You have to predict the max # of streamIDs
in advance if steamID is statically assigned.
