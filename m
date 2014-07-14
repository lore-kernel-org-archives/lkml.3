Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaGNKNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:13:16 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56448 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaGNKNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140714062428.GC2081@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
	<20140712093917.GD18601@arm.com>
	<CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
	<201407121422.02078.arnd@arndb.de>
	<CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
	<20140714062428.GC2081@ulmo>
Date: Mon, 14 Jul 2014 06:13:03 -0400
Message-ID: <CAF6AEGspVSxdEj_3LNtMp752LF-RbfQ+Y4EdWoWfT9O8wMnh-g@mail.gmail.com>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
From: Rob Clark <robdclark@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joerg Roedel <joro@8bytes.org>,
        Olav Haugan <ohaugan@codeaurora.org>,
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

On Mon, Jul 14, 2014 at 2:24 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Sat, Jul 12, 2014 at 08:57:31AM -0400, Rob Clark wrote:
>> On Sat, Jul 12, 2014 at 8:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> [...]
>> > The way that Thierry's binding does that is the obvious solution to this,
>> > and it mirrors what we do in practically every other subsystem. I definitely
>> > want the SMMU to change before anybody starts using it in a real system,
>> > which we fortunately do not have yet.
>>
>> hmm, well if some of the things I need for (like this or batching
>> mappings) are too weird and gpu specific, I'm willing to duplicate the
>> IOMMU driver in drm/msm.  It really isn't so much code, and that gives
>> me a lot more more flexibility to do crazy things... at some point I'm
>> probably going to want to do context switches by banging the IOMMU
>> registers directly from the gpu.
>
> If the IOMMU API doesn't provide for what you need, then perhaps it's
> time to enhance it? We do that all the time in other parts of the
> kernel, why should IOMMU be special?

sure.. and my comment was also about the map/unmap batching.

Bypassing IOMMU wouldn't be my first choice.  (Especially because I'd
then get to implement it twice.)  But if some of the things I need are
too specific to one driver (or worse, problematic for other IOMMU
use-cases which I don't know about), then it is an option I'd be
willing to consider.  If nothing else, it would get me out of
allocating sglists for every buffer..  I wonder how much memory
scatterlists take up for 500M of gfx buffers?

> It seems to me like context switching for per-process address space
> isolation is one of the important features of an IOMMU. If the current
> API doesn't let you do that then we should think of ways how it can be
> improved. And if it doesn't do it fast enough, then we should equally
> find ways to speed it up.
>
> This is part of why I think it would be good to have explicit objects
> associated with IOMMU contexts. That would give us a good place to add
> caching for this kind of situation. Currently we're required to handle
> most of this in drivers (map from struct device to context, ...).

well, it is at least awkward that the current api conflates attaching
device and attaching context.  I think we could get some use out of an
iommu_swap() API which conceptually acts as:

  iommu_swap(olddomain, newdomain, dev)
  {
     iommu_detach_device(olddomain, dev);
     iommu_attach_device(newdomain, dev);
  }

BR,
-R

> Thierry
