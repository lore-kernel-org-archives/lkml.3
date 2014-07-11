Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaGKBHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:07:38 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35109 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaGKBHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:07:36 -0400
MIME-Version: 1.0
In-Reply-To: <1404977677-22248-1-git-send-email-acourbot@nvidia.com>
References: <1404977677-22248-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 11 Jul 2014 11:07:35 +1000
Message-ID: <CACAvsv7cxHbXaF-0wi=cijACUBdrH_rqamM+=okrb0+cJxYAsw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 0/3] drm/gk20a: support for reclocking
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 5:34 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> This series adds support for reclocking on GK20A. The first two patches touch
> the clock subsystem to allow GK20A to operate, by making the presence of the
> thermal and voltage devices optional, and allowing pstates to be provided
> directly instead of being probed using the BIOS (which Tegra does not have).
Hey Alex,

I mentioned a while back I had some stuff in-progress to make
implementing this a bit cleaner for you, but as you can probably tell,
I didn't get to it yet.  It's likely I won't manage to before the next
merge window either.  So, I'll likely take these patches as-is
(assuming no objections on reviews here) and rebase my stuff on top.

>
> The last patch adds the GK20A clock device. Arguably the clock can be seen as a
> stripped-down version of what is seen on NVE0, however instead of using NVE0
> support has been written from scratch using the ChromeOS kernel as a basis.
> There are several reasons for this:
>
> - The ChromeOS driver uses a lookup table for the P coefficient which I could
>   not find in the NVE0 driver,
Interesting.  Can you give more details on how "PL" works exactly,
we'd been operating on the assumption (mainly inherited from code that
appeared in xf86-video-nv) that it was always a straight division.

> - Some registers that NVE0 expects to find are not present on GK20A (e.g.
>   0x137120 and 0x137140),
> - Calculation of MNP is done differently from what is performed in
>   nva3_pll_calc(), and it might be interesting to compare the two methods,
> - All the same, the programming sequence is done differently in the ChromeOS
>   driver and NVE0 could possibly benefit from it (?)
>
> It would be interesting to try and merge both, but for now I prefer to have the
> two coexisting to ensure proper operation on GK20A and besure I don't break
> dGPU support. :)
It's something we can look to achieving down the road, but won't block
merging the support.

>
> Regarding the first patch, one might argue that I could as well add thermal
> and voltage devices to GK20A. The reason this is not done is because these
> currently depend heavily on the presence of a BIOS, and will require a rework
> similar to that done in patch 2 for clocks. I would like to make sure this
> approach is approved because applying it to other subdevs.
They don't *need* to depend on the BIOS, you can opt for an
implementation that doesn't use the base classes that the rest of the
dGPU implementations do.  But, it's fine to take the approach you've
taken.

Thanks!
Ben.

>
> Alexandre Courbot (3):
>   drm/nouveau/clk: make therm and volt devices optional
>   drm/nouveau/clk: support for non-BIOS pstates
>   drm/gk20a: reclocking support
>
>  drivers/gpu/drm/nouveau/Makefile                   |   1 +
>  drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |   1 +
>  .../gpu/drm/nouveau/core/include/subdev/clock.h    |   9 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/base.c   |  52 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c  | 670 +++++++++++++++++++++
>  drivers/gpu/drm/nouveau/core/subdev/clock/nv04.c   |   4 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/nv40.c   |   4 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c   |   2 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |   4 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c   |   4 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |   4 +-
>  drivers/gpu/drm/nouveau/core/subdev/clock/nve0.c   |   4 +-
>  12 files changed, 725 insertions(+), 34 deletions(-)
>  create mode 100644 drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c
>
> --
> 2.0.0
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
