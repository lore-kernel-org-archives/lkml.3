Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965431AbaGCKFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:05:30 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:48258 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277AbaGCKF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <1403868134-31741-1-git-send-email-acourbot@nvidia.com>
References: <1403868134-31741-1-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 3 Jul 2014 19:05:05 +0900
Message-ID: <CAAVeFuLWpfjqWFRyGqROdxw7qP2OkXFZTPkCHCtwzwE=VjjRgQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] drm: nouveau: memory coherency for ARM
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While this series is more correct from the DMA API point of view, it
is also much heavier as it strictly disables the use of any cache on
all user-space mapped BOs, and is also much more restricted in terms
of which memory it can use.

I have a v4 in the works that lets us use TTM for user-mapped objects
and only falls back to using the DMA API for kernel-only objects
(fences & PBs basically). Will push it shortly but wanted to signal
this revision as deprecated in the meantime.

On Fri, Jun 27, 2014 at 8:22 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> v2 was doing some pretty nasty things with the DMA API, so I took a different
> approach for this v3.
>
> As suggested, this version uses ttm_dma_populate() to populate BOs. The reason
> for doing this was that it would entitle us to using the DMA sync functions,
> but since the memory returned is already coherent anyway, we do not even
> need to call these functions anymore.
>
> So this series has turned into 2 small patches:
>
> - The first attempts to make it more obvious that Nouveau can use different
> ways to populate TTs, and make it possible to choose which method to use from
> a single place.
> - The second leverages this work to select the DMA allocator to populate TTs
> on ARM.
>
> Doing this solves all our coherency problems with Nouveau on Tegra, and
> hopefully makes the code easier to read in the process.
>
> Alexandre Courbot (2):
>   drm/nouveau: cleanup TTM population logic
>   drm/nouveau: use DMA TT population method on ARM
>
>  drivers/gpu/drm/nouveau/nouveau_bo.c  | 63 ++++++++++++++++++-----------------
>  drivers/gpu/drm/nouveau/nouveau_drm.h | 11 ++++++
>  drivers/gpu/drm/nouveau/nouveau_ttm.c | 17 ++++++++++
>  3 files changed, 61 insertions(+), 30 deletions(-)
>
> --
> 2.0.0
>
