Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaBDDxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 22:53:24 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44867 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaBDDxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 22:53:22 -0500
MIME-Version: 1.0
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 4 Feb 2014 13:53:21 +1000
Message-ID: <CACAvsv4QFSL8u8hQFr-T_28n3icN_CwDsvLtrcPXx5nErD89wQ@mail.gmail.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>, Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 1:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Hello everyone,
Hey Alex,

The series looks pretty good to me.  I'll reply to the relevant
patches with any minor nit-picks on top of what's already been said by
others.

Thank you, and welcome to Nouveau :)

Ben.

>
> GK20A is the Kepler-based GPU used in the upcoming Tegra K1 chips. The following
> patches perform architectural changes to Nouveau that are necessary to support
> non-PCI GPUs and add initial support for GK20A. Although the support is still
> very basic and more user-space changes will be needed to make the full graphics
> stack run on top of it, we were able to successfully open channels and run
> simple pushbuffers with libdrm (more testing including rendering is in progress
> as we get more familiar with Nouveau's user-space interface).
>
> This work should be considered as a RFC and a proof-of-concept for driving
> future Tegra GPUs with Nouveau. Some design choices need to be discussed and
> quite a few inelegant shortcuts were purposely taken to minimize the size of
> this first set. Or said otherwise, apart from the changes that add support for
> non-PCI GPUs, remarkably little code needs to be added to get GK20A to a point
> where it is actually running. This is very encouraging, and it will be
> interesting to keep improving this support and see where this gets us.
>
> The first part of this series (patches 01/09) adds support for platform devices
> to Nouveau. Nouveau currently only supports PCI devices, and GK20A uses the
> platform bus and Device Tree. So the first step towards GK20A support is to
> abstract the PCI functions used by Nouveau (mainly resources range querying and
> page mapping functions) and add platform device probing functions. For most of
> the existing chips, platform device support does not make any sense, so only the
> subdev and engine drivers actually used by GK20A were updated to use these
> abstractions. If, for consistency reasons, it is deemed preferable to use them
> everywhere in the driver, we will do it in the next revision of this series.
>
> This part can be considered independently from the actual GK20A support, and I
> believe it would make sense to discuss what needs to be improved and drive it to
> merge separately, as the remainder of the series will likely require more work.
>
> The second part (10/14) updates existing subdev/engine drivers to support GK20A,
> and adds a very simple memory driver that simulates dedicated video memory by
> allocating a large system memory chunk at boot time. This is clearly sub-optimal
> and should not be merged, but allowed us to quickly bring GK20A up with Nouveau.
> Other drivers changes are fairly small, and are here to handle the difference in
> number of engines and units compared to desktop Kepler as well as to perform a
> few things usually done by the video BIOS (which Tegra does not feature).
>
> Finally, support for probing GK20A is added in the last 2 patches. It should be
> noted that contrary to what Nouveau currently expects, GK20A does not embed any
> display hardware (that part being handled by tegradrm). So this driver should
> really be only used through DRM render-nodes and collaborate with the display
> driver using PRIME. I have not yet figured out how to turn GK20A's instantiation
> of Nouveau into a render-node only driver without breaking support for existing
> desktop GPUs, and consequently the driver spawns a /dev/dri/cardX node which we
> should try to get rid of.
>
> I guess my email address might surprise some of you, so let me anticipate some
> questions you might have. :P Yes, this work is endorsed by NVIDIA. Several other
> NVIDIAns (CC'd), including core GPU experts, have provided significant technical
> guidance and will continue their involvement. Special thanks go to Terje
> Bergstrom and Ken Adams for their invaluable GPU expertise, and Thierry Reding
> (at FOSDEM this weekend) for help with debugging and user-space testing.
>
> Let me also stress that although very exciting, this effort is still
> experimental, so I would like to make sure that nobody makes excessive
> expectations based on these few patches. The scope of this work is strictly
> limited to Tegra (although given the similarities desktop GPU support will
> certainly benefit from it indirectly), and we do not have any plan to work on
> user-space support. So do not uninstall that proprietary driver just yet. ;)
>
> With this being clarified, we are looking forward to getting your feedback and
> working with you guys to bring and improve Tegra K1 support into Nouveau! :)
>
> Alexandre Courbot (16):
>   drm/nouveau: handle -EACCES runtime PM return code
>   drm/nouveau: basic support for platform devices
>   drm/nouveau: add platform device probing function
>   drm/nouveau/fifo: support platform devices
>   drm/nouveau/bar: support platform devices
>   drm/nouveau/bar: only ioremap BAR3 if it exists
>   drm/nouveau/bar/nvc0: support chips without BAR3
>   drm/nouveau/mc: support platform devices
>   drm/nouveau/fb: support platform devices
>   drm/nouveau/timer: skip calibration on GK20A
>   drm/nouveau/fifo: allocate usermem as needed
>   drm/nouveau/fifo: add GK20A support
>   drm/nouveau/ibus: add GK20A support
>   drm/nouveau/fb: add GK20A support
>   drm/nouveau: support GK20A in nouveau_accel_init()
>   drm/nouveau: support for probing GK20A
>
>  drivers/gpu/drm/nouveau/Makefile                   |   4 +
>  drivers/gpu/drm/nouveau/core/engine/device/base.c  |  92 +++++++++++++++-
>  drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  20 ++++
>  drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |   2 +-
>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c    |   4 +-
>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |   1 +
>  drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c    |  27 +++++
>  drivers/gpu/drm/nouveau/core/include/core/device.h |  27 +++++
>  .../gpu/drm/nouveau/core/include/engine/device.h   |  10 ++
>  drivers/gpu/drm/nouveau/core/include/engine/fifo.h |   1 +
>  drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   1 +
>  drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |   1 +
>  drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |   1 +
>  drivers/gpu/drm/nouveau/core/os.h                  |   1 +
>  drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |   7 +-
>  drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |   4 +-
>  drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     | 116 +++++++++++----------
>  drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |   9 +-
>  drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c      |  28 +++++
>  drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |   1 +
>  drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c   |  67 ++++++++++++
>  drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c    | 108 +++++++++++++++++++
>  drivers/gpu/drm/nouveau/core/subdev/mc/base.c      |  43 +++++---
>  drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |  19 ++--
>  drivers/gpu/drm/nouveau/dispnv04/crtc.c            |   2 +-
>  drivers/gpu/drm/nouveau/nouveau_abi16.c            |  13 ++-
>  drivers/gpu/drm/nouveau/nouveau_bo.c               |  22 ++--
>  drivers/gpu/drm/nouveau/nouveau_connector.c        |   2 +-
>  drivers/gpu/drm/nouveau/nouveau_display.c          |   3 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.c              |  86 ++++++++++++---
>  drivers/gpu/drm/nouveau/nouveau_sysfs.c            |   8 +-
>  drivers/gpu/drm/nouveau/nouveau_ttm.c              |  31 +++---
>  32 files changed, 622 insertions(+), 139 deletions(-)
>  create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c
>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c
>
> --
> 1.8.5.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
