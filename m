Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaFXNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:25:58 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:60507 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaFXNZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140624130930.GN32514@n2100.arm.linux.org.uk>
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com>
 <1403603667-11302-3-git-send-email-acourbot@nvidia.com> <20140624100220.GK32514@n2100.arm.linux.org.uk>
 <53A953E6.2030503@nvidia.com> <53A95910.20104@nvidia.com> <CAAVeFu+rbCViC87kYCLfxGV18iYq=Pa0ABb+L=iNiYPLn+mR8Q@mail.gmail.com>
 <20140624130930.GN32514@n2100.arm.linux.org.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 24 Jun 2014 22:25:34 +0900
Message-ID: <CAAVeFuKah7yeTpzt+BySFGs7vSkuOw5GLWvJp5-b63HZ_G8=yA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] drm/ttm: introduce dma cache sync helpers
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexandre Courbot <acourbot@nvidia.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:09 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jun 24, 2014 at 09:23:05PM +0900, Alexandre Courbot wrote:
>> On Tue, Jun 24, 2014 at 7:55 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> > The only alternative I see here is to flush the CPU caches when syncing for
>> > the device, and invalidate them for the other direction. Of course if the
>> > device has caches on its side as well the opposite operation must also be
>> > done for it. Guess the only way is to handle it all by ourselves here. :/
>>
>> ... and it really sucks. Basically if we cannot use the DMA API here
>> we will lose the convenience of having a portable API that does just
>> the right thing for the underlying platform. Without it we would have
>> to duplicate arm_iommu_sync_single_for_cpu/device() and we would only
>> have support for ARM.
>>
>> The usage of the DMA API that we are doing might be illegal, but in
>> essence it does exactly what we need - at least for ARM. What are the
>> alternatives?
>
> It may seem /to you/ as a driver developer to be the easiest thing in
> the world to abuse an API in a way that it's not supposed to be used,
> and it is easy to do that.
>
> However, what you're actually saying is that you don't respect your
> fellow kernel developers who have to maintain the other side of that
> interface.  When they need to change the implementation of that
> interface, what if those changes then screw your abuse of that
> interface.
>
> The reason we define the behaviours and properties of APIs is to give
> both the user and the implementer of the API some degree of latitude
> in how that interface works, so that it can be maintained into the
> future.  If abuses (such as these) are allowed, then we've lost,
> because the interface can no longer be sanely maintained - especially
> if driver authors eventually end up not caring about their pile of
> abuse they've created after they've moved on to new wonderful hardware.
>
> With an API such as the DMA API, where we have hundreds, if not a
> thousand users of it, this /really/ matters.
>
> We've been here before with the DMA API on older ARM platforms, where
> we've had people abusing the API or going beneath the API because "it
> does what they need it to", which then makes stuff much harder to change
> at architecture level.
>
> Last time it happened, it was when ARMv6 came along and ARM moved away
> from VIVT caches.  The options were either to break the crap drivers
> and support ARMv6+ CPUs, or keep the crap drivers working and not
> support DMA in any shape or form on ARMv6+.
>
> Obviously, this was too important to for one or two abusive drivers to
> block, so I changed the architecture level /anyway/ and just said screw
> the drivers which end up being broken by their short-sightedness, they
> can either rot or someone else can fix them.
>
> I have no beef for intentionally breaking stuff when people abuse well
> defined interfaces and/or refuse to discuss their requirements when
> interfaces don't quite do what they want - or worse, refuse to listen
> to objections.
>
> As I say, it's disrespectful to your fellow kernel developers to abuse
> well defined interfaces.

Apologies if I sounded that way - I wasn't suggesting that we carry on
with this clearly illegal usage of the DMA API, but was merely noting
that if we were to implement the intended behavior on our side it
would look just like what the ARM implementation currently does. My
question about alternatives wasn't rethorical, I am not so familiar
with this part of the system (as should be obvious by now) and would
like to know whether there aren't other solutions that would spare us
the need to re-implement something that already exists.
