Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3EaJOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:14:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37641 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3EaJOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:14:03 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
Date: Fri, 31 May 2013 11:14:02 +0200
Message-ID: <CAKMK7uHYLG3iNphE+g4BBB-LuUM67NRvbQPBvCHE2FN71-GLnA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] dma-buf: add importer private data for reimporting
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:54 AM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> importer private data in dma-buf attachment can be used by importer to
> reimport same dma-buf.
>
> Seung-Woo Kim (2):
>   dma-buf: add importer private data to attachment
>   drm/prime: find gem object from the reimported dma-buf

Self-import should already work (at least with the latest refcount
fixes merged). At least the tests to check both re-import on the same
drm fd and on a different all work as expected now.

Second, the dma_buf_attachment is _definitely_ the wrong place to do
this. If you need iommu mapping caching, that should happen at a lower
level (i.e. in the map_attachment callback somewhere of the exporter,
that's what the priv field in the attachment is for). Snatching away
the attachement from some random other import is certainly not the way
to go - attachements are _not_ refcounted!
-Daniel

>
>  drivers/base/dma-buf.c                     |   31 ++++++++++++++++++++++++++++
>  drivers/gpu/drm/drm_prime.c                |   19 ++++++++++++----
>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
>  drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
>  drivers/gpu/drm/udl/udl_gem.c              |    1 +
>  include/linux/dma-buf.h                    |    4 +++
>  6 files changed, 52 insertions(+), 5 deletions(-)
>
> --
> 1.7.4.1
>



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
