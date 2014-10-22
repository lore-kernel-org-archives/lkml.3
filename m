Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaJVRx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:53:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62196 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaJVRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:53:27 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:f81c:4bce:c938:9df2]
In-Reply-To: <1413996389.4202.218.camel@ul30vt.home>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205825-6370-8-git-send-email-a.motakis@virtualopensystems.com>
 <1413909282.4202.141.camel@ul30vt.home> <CAG8rG2yiqBk2Y+b0WvcZGypNj3XhGDNet-GM3yOYaLiHc4pU=w@mail.gmail.com>
 <1413996389.4202.218.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 22 Oct 2014 19:53:06 +0200
Message-ID: <CAG8rG2zZa0kGOtPaA+R1=MZL03J8_=k3Hq4AQDftG5Bc_us8dw@mail.gmail.com>
Subject: Re: [PATCH v8 07/18] vfio/platform: return info for device memory
 mapped IO regions
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 6:46 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Wed, 2014-10-22 at 15:54 +0200, Antonios Motakis wrote:
>> On Tue, Oct 21, 2014 at 6:34 PM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>> > On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
>> >> This patch enables the IOCTLs VFIO_DEVICE_GET_REGION_INFO ioctl call,
>> >> which allows the user to learn about the available MMIO resources of
>> >> a device.
>> >>
>> >> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> >> ---
>> >>  drivers/vfio/platform/vfio_platform_common.c  | 93 +++++++++++++++++++++++++--
>> >>  drivers/vfio/platform/vfio_platform_private.h | 22 +++++++
>> >>  2 files changed, 111 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> >> index 1e4073f..8a7e474 100644
>> >> --- a/drivers/vfio/platform/vfio_platform_common.c
>> >> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> >> @@ -27,17 +27,84 @@
>> >>
>> >>  #include "vfio_platform_private.h"
>> >>
>> >> +static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>> >> +{
>> >> +     int cnt = 0, i;
>> >> +
>> >> +     while (vdev->get_resource(vdev, cnt))
>> >> +             cnt++;
>> >> +
>> >> +     vdev->regions = kcalloc(cnt, sizeof(struct vfio_platform_region),
>> >> +                             GFP_KERNEL);
>> >> +     if (!vdev->regions)
>> >> +             return -ENOMEM;
>> >> +
>> >> +     for (i = 0; i < cnt;  i++) {
>> >> +             struct resource *res =
>> >> +                     vdev->get_resource(vdev, i);
>> >> +
>> >> +             if (!res)
>> >> +                     goto err;
>> >> +
>> >> +             vdev->regions[i].addr = res->start;
>> >> +             vdev->regions[i].size = resource_size(res);
>> >> +             vdev->regions[i].flags = 0;
>> >> +
>> >> +             switch (resource_type(res)) {
>> >> +             case IORESOURCE_MEM:
>> >> +                     vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
>> >> +                     break;
>> >> +             case IORESOURCE_IO:
>> >> +                     vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
>> >> +                     break;
>> >
>> > Ok, we have support for PIO in platform now (thanks!), does the user
>> > know what type of region they're dealing with?  Do they care?  For PCI
>> > the user tests the PCI BAR in config space to determine which type it
>> > is.  I'm guessing that platform would do something similar against the
>> > device tree or ACPI, right?
>>
>> Maybe is worthwhile to add an explicit flag in
>> VFIO_DEVICE_GET_REGION_INFO for PIO regions. For platform devices I
>> don't know if we can always rely on DT or ACPI info to be available.
>> For VFIO PCI the BAR is always implemented, and while I have proposed
>> an RFC to return DT information, I don't think we can assume how a
>> device is described in the host, whether DT, ACPI, or dark magic.
>
> Is this already handled by the fact that vfio-platform is not meant to
> be a generic meta driver to the same extent as vfio-pci?  There is no
> self-describing config space on platform devices like there is on PCI,
> so the user will need to know in advance somehow what the device is and
> what resources/irqs it uses.  We do need to make sure though that we
> provide a userspace ABI that allows them to match VFIO indexes to the
> device in a predictable way.  It's not fully clear to me how that works.
> Thanks,

Yeah, it is a fact of life that the user needs to know what regions he
is accessing, just from their ordering. Even with the extension for
accessing device tree data, the user still needs to know what each
region is and what info he is looking for from the device tree. In
that respect we could delegate the responsibility to the user to just
"know" what kind of device he is accessing and what kind of regions it
features (and in what order).

>
> Alex
>



-- 
Antonios Motakis
Virtual Open Systems
