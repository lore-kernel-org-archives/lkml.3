Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaFXNwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:52:30 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:43549 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFXNw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:52:29 -0400
MIME-Version: 1.0
In-Reply-To: <1403616338.4230.8.camel@weser.hi.pengutronix.de>
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com>
 <1403603667-11302-3-git-send-email-acourbot@nvidia.com> <20140624100220.GK32514@n2100.arm.linux.org.uk>
 <53A953E6.2030503@nvidia.com> <53A95910.20104@nvidia.com> <CAAVeFu+rbCViC87kYCLfxGV18iYq=Pa0ABb+L=iNiYPLn+mR8Q@mail.gmail.com>
 <53A96EC5.3030701@canonical.com> <1403616338.4230.8.camel@weser.hi.pengutronix.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 24 Jun 2014 22:52:08 +0900
Message-ID: <CAAVeFuLcC30BdWierY8Bg0vBmfNCaB=Qs34h790jGB=BRYvGAg@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v2 2/3] drm/ttm: introduce dma cache sync helpers
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:25 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
> Am Dienstag, den 24.06.2014, 14:27 +0200 schrieb Maarten Lankhorst:
>> op 24-06-14 14:23, Alexandre Courbot schreef:
>> > On Tue, Jun 24, 2014 at 7:55 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> >> On 06/24/2014 07:33 PM, Alexandre Courbot wrote:
>> >>> On 06/24/2014 07:02 PM, Russell King - ARM Linux wrote:
>> >>>> On Tue, Jun 24, 2014 at 06:54:26PM +0900, Alexandre Courbot wrote:
>> >>>>> From: Lucas Stach <dev@lynxeye.de>
>> >>>>>
>> >>>>> On architectures for which access to GPU memory is non-coherent,
>> >>>>> caches need to be flushed and invalidated explicitly at the
>> >>>>> appropriate places. Introduce two small helpers to make things
>> >>>>> easy for TTM-based drivers.
>> >>>>
>> >>>> Have you run this with DMA API debugging enabled?  I suspect you haven't,
>> >>>> and I recommend that you do.
>> >>>
>> >>> # cat /sys/kernel/debug/dma-api/error_count
>> >>> 162621
>> >>>
>> >>> (╯°□°）╯︵ ┻━┻)
>> >>
>> >> *puts table back on its feet*
>> >>
>> >> So, yeah - TTM memory is not allocated using the DMA API, hence we cannot
>> >> use the DMA API to sync it. Thanks Russell for pointing it out.
>> >>
>> >> The only alternative I see here is to flush the CPU caches when syncing for
>> >> the device, and invalidate them for the other direction. Of course if the
>> >> device has caches on its side as well the opposite operation must also be
>> >> done for it. Guess the only way is to handle it all by ourselves here. :/
>> > ... and it really sucks. Basically if we cannot use the DMA API here
>> > we will lose the convenience of having a portable API that does just
>> > the right thing for the underlying platform. Without it we would have
>> > to duplicate arm_iommu_sync_single_for_cpu/device() and we would only
>> > have support for ARM.
>> >
>> > The usage of the DMA API that we are doing might be illegal, but in
>> > essence it does exactly what we need - at least for ARM. What are the
>> > alternatives?
>> Convert TTM to use the dma api? :-)
>
> Actually TTM already has a page alloc backend using the DMA API. It's
> just not used for the standard case right now.

Indeed, and Nouveau even already makes use of it if CONFIG_SWIOTLB is
set apparently.

> I would argue that we should just use this page allocator (which has the
> side effect of getting pages from CMA if available -> you are actually
> free to change the caching) and do away with the other allocator in the
> ARM case.

Mm? Does it mean that CMA memory is not mapped into lowmem? That would
certainly help in the present case, but I wonder how useful it will be
once the iommu support is in place. Will also need to consider
performance of such coherent memory for e.g. user-space mappings.

Anyway, I will experiment a bit with this tomorrow, thanks!
