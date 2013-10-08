Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3JHBe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:34:26 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38672 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3JHBeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:34:25 -0400
Date: Mon, 7 Oct 2013 21:34:20 -0400 (EDT)
From: Ben Skeggs <bskeggs@redhat.com>
To: Geyslan =?utf-8?Q?Greg=C3=B3rio?= Bem <geyslan@gmail.com>
Cc: Felipe Pena <felipensp@gmail.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel-br <kernel-br@googlegroups.com>
Message-ID: <272096591.2542958.1381196060612.JavaMail.root@redhat.com>
In-Reply-To: <CAGG-pUQGKmCQ_N2z5puPZYufW31keP-7sRBJRN=VGCkjZ+US9Q@mail.gmail.com>
References: <1381184066-10684-1-git-send-email-geyslan@gmail.com> <184520834.2485938.1381185329449.JavaMail.root@redhat.com> <CA+5g0SKCdnCCzHBXFN5JYyG5Sno14Tud78rN_MvygXkEg0dr_A@mail.gmail.com> <CAGG-pUQGKmCQ_N2z5puPZYufW31keP-7sRBJRN=VGCkjZ+US9Q@mail.gmail.com>
Subject: Re: [PATCH] drm: nouveau: fix nvbe leakage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC30 (Linux)/8.0.3_GA_5664)
Thread-Topic: nouveau: fix nvbe leakage
Thread-Index: C+S2yGocC3NsHIlO5US5tRMl4zMwkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Geyslan Gregório Bem" <geyslan@gmail.com>
> To: "Felipe Pena" <felipensp@gmail.com>
> Cc: "Ben Skeggs" <bskeggs@redhat.com>, airlied@linux.ie, dri-devel@lists.freedesktop.org,
> linux-kernel@vger.kernel.org, "kernel-br" <kernel-br@googlegroups.com>
> Sent: Tuesday, 8 October, 2013 9:39:02 AM
> Subject: Re: [PATCH] drm: nouveau: fix nvbe leakage
> 
> Felipe, thank you too.
> 
> I realized this after a code review.
> 
> Ben, what do you think?
> 
> Geyslan Gregório Bem
> hackingbits.com
> 
> 
> 2013/10/7 Felipe Pena <felipensp@gmail.com>:
> > Hi,
> >
> > On Mon, Oct 7, 2013 at 7:35 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
> >> ----- Original Message -----
> >>> From: "Geyslan G. Bem" <geyslan@gmail.com>
> >>> To: airlied@linux.ie, bskeggs@redhat.com, dri-devel@lists.freedesktop.org
> >>> Cc: linux-kernel@vger.kernel.org, kernel-br@googlegroups.com, "Geyslan G.
> >>> Bem" <geyslan@gmail.com>
> >>> Sent: Tuesday, 8 October, 2013 8:14:26 AM
> >>> Subject: [PATCH] drm: nouveau: fix nvbe leakage
> >>>
> >>> Free memory allocated to nvbe when returning NULL.
> >>>
> >>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> >> NACK.  ttm_dma_tt_init() calls the destructor if it fails, which frees the
> >> memory.
> >>
> >> Ben.
> >>
> >
> > But ttm_tt_destroy() just handles the ttm_tt part from nvbe, the nvbe
> > pointer itself is not being free'd.
Actually look at ttm_tt_destroy() and you'll see that right at the end it goes ttm->func->destroy(ttm), which is nouveau_sgdma_destroy().

Ben.
> >
> >>> ---
> >>>  drivers/gpu/drm/nouveau/nouveau_sgdma.c | 3 +++
> >>>  1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> >>> b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> >>> index 0843ebc..af8b66d 100644
> >>> --- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> >>> +++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> >>> @@ -105,6 +105,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_device *bdev,
> >>>               nvbe->ttm.ttm.func = &nv50_sgdma_backend;
> >>>
> >>>       if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags,
> >>>       dummy_read_page))
> >>> +     {
> >>> +             kfree(nvbe);
> >>>               return NULL;
> >>> +     }
> >>>       return &nvbe->ttm.ttm;
> >>>  }
> >>> --
> >>> 1.8.4
> >>>
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> >
> > --
> > Regards,
> > Felipe Pena
> 
