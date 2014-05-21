Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaEUPop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:44:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40518 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaEUPon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <11242680.PQytQQqlPJ@wuerfel>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
	<4506822.XX7GrvtHhk@wuerfel>
	<20140521090244.GB19268@ulmo>
	<11242680.PQytQQqlPJ@wuerfel>
Date: Wed, 21 May 2014 08:44:42 -0700
X-Google-Sender-Auth: GQjJewHln1FsGp9so0acQG9A98g
Message-ID: <CANEJEGvhEsC9wKqX_pYmOg7LwsQkoN9=jjXJuW0UeEa9XywSPw@mail.gmail.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
From: Grant Grundler <grundler@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 2:32 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 21 May 2014 11:02:45 Thierry Reding wrote:
>> On Wed, May 21, 2014 at 10:54:42AM +0200, Arnd Bergmann wrote:
>>
>> > Right. As long as we always unmap the buffers from the IOMMU after they
>> > have stopped being in use, it's very unlikely that even a broken device
>> > driver causes a DMA into some bus address that happens to be mapped for
>> > another device.
>>
>> I think that if buffers remain mapped in the IOMMU when they have been
>> deallocated that should be considered a bug.

There is currently no general requirement to tear down mappings immediately.
An option to enforce immediate tear down might be useful since I agree
Virtual Guests sharing host memory through shared physical devices
will want that. ie there should be no opportunity for a shared device
to be able to access another guests memory through "stale" (but live)
DMA mappings. I don't think that's the case but I'd ask someone like
Alex Williamson for a more certain answer.

> You could see it as a performance optimization in some cases, e.g. when you
> cannot flush individual IOTLBs or doing so is expensive, and you just keep
> assigning new addresses until every one has been used, then you do a global
> IOTLB flush once.

This is in fact exactly what several IOMMUs do - including the Intel
IOMMU driver.

IIRC, the Intel IOMMU driver collects 256 or so  entries to flush and
then flushes them all at once and updates the metadata. I don't if it
does this for ranges assigned to different virtual guests though or
just within a given range.

> Obviously you have to maintain the IO page tables correctly.

To be clear, "Correctly" in this case just means until the IOTLB is
flushed, the given IOMMU Pdir entries are marked "in use" even though
the driver has handed "ownership" back to the IOMMU driver.

cheers,
grant
