Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaEHJVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:21:47 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:34945 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaEHJVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <536B0900.10204@samsung.com>
References: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
 <1399217181-26442-3-git-send-email-djkurtz@chromium.org> <5369C13C.3080506@samsung.com>
 <CAGS+omAbuzRpNDvB6eTw67Dcv3WMdWF3yz+bU5p3j5JRourOyw@mail.gmail.com> <536B0900.10204@samsung.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 8 May 2014 17:21:22 +0800
X-Google-Sender-Auth: d9wDsb8k_HmAd7RZDWdf0hNxDBw
Message-ID: <CAGS+omB8iO2ioLcQEtxsww9kA4Yc8-8YaAkWwTy2ssLOqQvLZg@mail.gmail.com>
Subject: Re: [PATCH 2/4] drm/exynos/mixer: use MXR_GRP_SXY_SY
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@chromium.org>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 12:33 PM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
>
> Hello Daniel,
>
> On 2014년 05월 07일 23:14, Daniel Kurtz wrote:
> > On Wed, May 7, 2014 at 1:14 PM, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> >> Hi Daniel,
> >>
> >> On 2014년 05월 05일 00:26, Daniel Kurtz wrote:
> >>> Mixer hardware supports offsetting dma from start of source buffer using
> >>> the MXR_GRP_SXY register.
> >>>
> >>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> >>> ---
> >>>  drivers/gpu/drm/exynos/exynos_mixer.c | 8 +++-----
> >>>  1 file changed, 3 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
> >>> index 475eb49..40cf39b 100644
> >>> --- a/drivers/gpu/drm/exynos/exynos_mixer.c
> >>> +++ b/drivers/gpu/drm/exynos/exynos_mixer.c
> >>> @@ -529,13 +529,11 @@ static void mixer_graph_buffer(struct mixer_context *ctx, int win)
> >>>
> >>>       dst_x_offset = win_data->crtc_x;
> >>>       dst_y_offset = win_data->crtc_y;
> >>> +     src_x_offset = win_data->fb_x;
> >>> +     src_y_offset = win_data->fb_y;
> >>>
> >>>       /* converting dma address base and source offset */
> >>> -     dma_addr = win_data->dma_addr
> >>> -             + (win_data->fb_x * win_data->bpp >> 3)
> >>> -             + (win_data->fb_y * win_data->fb_width * win_data->bpp >> 3);
> >>> -     src_x_offset = 0;
> >>> -     src_y_offset = 0;
> >>> +     dma_addr = win_data->dma_addr;
> >>
> >> Basically, you are right and source offset register can be used. But
> >> because of limitation of resolution for mixer up to 1920x1080, I
> >> considered modified soruce dma address to set one frame buffer, which is
> >> bigger than 1920x1080, on to both fimd and hdmi.
> >
> > Hi Seung-Woo,
> >
> > I do not see why the maximum MIXER resolution matters for choosing
> > between offsetting BASE or using SXY.
> >
> > Let's say you have one big 1920x1908 framebuffer, with a span of 1920,
> > starting at dma_addr (there is no extra padding at the end of the
> > line).
> > Let's say you wanted the mixer to scan out 1920x1080 pixels starting
> > from (0, 800) in the framebuffer, and start drawing them at (0,0) on
> > the screen.
> >
> > What we currently do is:
> >   BASE = dma_addr + (800 * 1080 * 4)
> >   SPAN = 1920
> >   SXY = SX(0) | SY(0)
> >   WH = W(1920) | H(1080)
> >   DXY = DX(0) | DY(0)
> >
> > I am proposing we do:
> >   BASE = dma_addr
> >   SPAN = 1920
> >   SXY = SX(0) | SY(800)
> >   WH = W(1920) | H(1080)
> >   DXY = DX(0) | DY(0)
> >
> > In both cases, the mixer resolution is 1920x1080.
>
> In my test to show each half of big one framebuffer (3840 x 1080) to
> FIMD from 0 to 1079 and MIXER from 1080 to 3839 with exynos4210 and
> exynos4412, it was failed to show proper hdmi display. Also it is same
> for framebuffer (1920 x 2160). AFAIK, it is mainly because mixer dma has
> limitation of dma memory size.


That is unfortunate, but thank you for your explanation.

Is this limitation exynos4 specific, or does it also apply for the
exynos5 mixer?
Was the limitation perhaps the number of bits in the SXY register
fields (< 11) on those devices?
For 5250/5420 these fields are 11 bits, and I don't see any
restrictions about "dma memory size" in the documentation that I have.

Thanks,
-Dan

> In this case, I set register as like:
>   BASE = dma_addr /* 3840 x 1080 x 4 */
>   SPAN = 3840
>   SXY = SX(1920) | SY(0)
>   WH = W(1920) | H(1080)
>   DXY = DX(0) | DY(0)
> or:
>   BASE = dma_addr /* 1920 x 2160 x 4 */
>   SPAN = 1920
>   SXY = SX(0) | SY(1080)
>   WH = W(1920) | H(1080)
>   DXY = DX(0) | DY(0)
> but these two setting did not show hdmi display as I expected. So I used
> modified dma address.
>
> >
> > My motivation for wanting to program an un-modified dma_addr into BASE
> > is so we can then just check BASE_S to determine from which buffer the
> > mixer is actively being scanned out without worrying about the source
> > offset, since the source offset can change for a given framebuffer
> > (for example, when doing panning, or if an overlay is used for a HW
> > cursor).
>
> Actually, this patch is exactly same with my first implementation, so I
> completely understand your motivation. Anyway, I was focus on extended
> displays with one buffer, so I wrote modified dma base address.
>
> Thanks and Regards,
> - Seung-Woo Kim
>
> >
> > Best Regards,
> > -Daniel
> >
> >>
> >> Regards,
> >> - Seung-Woo Kim
> >>
> >>>
> >>>       if (win_data->scan_flags & DRM_MODE_FLAG_INTERLACE)
> >>>               ctx->interlace = true;
> >>>
> >>
> >> --
> >> Seung-Woo Kim
> >> Samsung Software R&D Center
> >> --
> >>
> >
>
> --
> Seung-Woo Kim
> Samsung Software R&D Center
> --
>
