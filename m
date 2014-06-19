Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbaFSGPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:15:44 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51978 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaFSGPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:15:43 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
References: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
Date: Thu, 19 Jun 2014 08:15:42 +0200
Message-ID: <CAKMK7uFbZgoVDkiJV34Tvf_KDdZo+xi9w3Qi+9_9-+WvPOKR3w@mail.gmail.com>
Subject: Re: [PATCH] drivers/i915: Fix unnoticed failure of init_ring_common()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: "Nikula, Jani" <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 12:38 AM, Konrad Zapalowicz
<bergo.torino@gmail.com> wrote:
> This commit add check for return value of init_ring_common() in the
> init_render_ring(). Now, when failure is detected the error code is
> propagated to the caller layer instead of being ignored.
>
> I believe that this fix will have a positive impact on the oops that
> I hit recently and which starts when init_ring_common() fails:
>
>     [drm:init_ring_common] *ERROR* render ring initialization failed
>              ctl 0001f001 head 0000000c tail 00000000 start 003eb000
>     BUG: unable to handle kernel NULL pointer dereference at 0000006c
>     IP: [<f8ca1679>] i915_gem_obj_to_ggtt+0x9/0x40 [i915]
>
> Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>

Do you have the full Oops somewhere?

> ---
>  drivers/gpu/drm/i915/intel_ringbuffer.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
> index 279488a..d205b0d 100644
> --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
> +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
> @@ -604,6 +604,8 @@ static int init_render_ring(struct intel_engine_cs *ring)
>         struct drm_device *dev = ring->dev;
>         struct drm_i915_private *dev_priv = dev->dev_private;
>         int ret = init_ring_common(ring);
> +       if (ret)
> +               return ret;

Yeah, on gen5+ this looks needed.
-Daniel

>
>         /* WaTimedSingleVertexDispatch:cl,bw,ctg,elk,ilk,snb */
>         if (INTEL_INFO(dev)->gen >= 4 && INTEL_INFO(dev)->gen < 7)
> --
> 1.8.1.2
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
