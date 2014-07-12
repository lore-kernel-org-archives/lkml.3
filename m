Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaGLL0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:26:43 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40872 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaGLL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140712093917.GD18601@arm.com>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
	<CAF6AEGv2P_Uq8CHgm1YdaUeMSNdH62ZwjLnT83Fr5GnxEAhTMw@mail.gmail.com>
	<20140712093917.GD18601@arm.com>
Date: Sat, 12 Jul 2014 07:26:39 -0400
Message-ID: <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
From: Rob Clark <robdclark@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Joerg Roedel <joro@8bytes.org>, Olav Haugan <ohaugan@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 5:39 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Rob,
>
> On Fri, Jul 11, 2014 at 09:55:14PM +0100, Rob Clark wrote:
>> On Fri, Jul 4, 2014 at 11:29 AM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>> > From: Thierry Reding <treding@nvidia.com>
>> ok, so I was working through this to try to convert my
>> {qcom,msm}-iommu-v0 RFC over to using these bindings.  For background,
>> I was initially using something that looked a bit more like the
>> current arm-smmu bindings:
>>
>>         gpu {
>>             #stream-id-cells = <16>;
>>             ...
>>         };
>>
>>         gfx3d: qcom,iommu@7c00000 {
>>             compatible = "qcom,iommu-v0";
>>             ...
>>             mmu-masters =
>>                 /* gfx3d_user: */
>>                 <&gpu 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15>,
>>                 /* gfx3d_priv: */
>>                 <&gpu 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31>;
>>         };
>>
>>         gfx3d1: qcom,iommu@7d00000 {
>>             compatible = "qcom,iommu-v0";
>>             ...
>>             mmu-masters =
>>                 /* gfx3d_user: */
>>                 <&gpu 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15>,
>>                 /* gfx3d_priv: */
>>                 <&gpu 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31>;
>>         };
>>
>> With my current arrangement, I have everything I need when the iommu
>> device is probed to set up each of the context banks
>>
>> This proposal inverts that relationship.  Which forces me to do a lot
>> more (including DT parsing) on device attach.  Which I'm not a huge
>> fan of.  Ie. if I even wanted to try to implement per-process
>> pagetables for gpu without completely going behind the IOMMU API's
>> back, I would want attach/detach to be as lightweight as possible.
>
> I think we'd have to walk the entire device-tree at IOMMU probe time in
> order to enumerate the masters, which sounds horrible... If we want to do
> clever SMR allocation on the ARM SMMU (as I've been discussing with Olav),
> we're going to need knowledge about *all* the valid Stream IDs in the system
> before we can program *any* translations.

I guess walking the whole tree would work.. but it really doesn't
really sound like a nice solution ;-)

also, I'm not really sure to what extent it is bad form to assume the
tree is static.

>> Was there actually a good reason for having the device link to the
>> iommu rather than the other way around?  How much would people hate it
>> if I just ignore the generic bindings and use something that works for
>> me instead.  I mean, it isn't exactly like there is going to be .dts
>> re-use across different SoC's..  and at least with current IOMMU API
>> some sort of of_get_named_iommu() API doesn't really make sense.
>
> The thing is, if you end up ignoring the generic binding then we have two
> IOMMUs using the same (ARM SMMU) binding and it begs the question as to
> which is the more generic! I know we're keen to get this merged, but merging
> something that people won't use and calling it generic doesn't seem ideal
> either. We do, however, desperately need a generic binding.

yeah, ignoring the generic binding is not my first choice.  I'd rather
have something that works well for everyone.  But I wasn't really sure
if the current proposal was arbitrary, or if there are some
conflicting requirements between different platforms.

> Turning the question around; Thierry -- what are the issue in using
> something like the ARM SMMU binding (master device IDs held in the IOMMU
> node) for the nvidia IOMMU?

+1 for doing it more like how arm-smmu is currently.. that works much
better for me :-)

BR,
-R

> Will
