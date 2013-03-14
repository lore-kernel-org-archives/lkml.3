Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab3CNNjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:39:31 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:56855 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab3CNNj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
	<1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
Date: Thu, 14 Mar 2013 15:39:28 +0200
Message-ID: <CA+ydwtoY8OGSjRDkUK1OxEpqTX9rj=7EZYW5PSF4CFmnzc0Xmg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Sanity check incoming ioctl data for a NULL pointer
From: Tommi Rantala <tt.rantala@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/14 Chris Wilson <chris@chris-wilson.co.uk>:
> In order to prevent a potential NULL deference with hostile userspace,
> we need to check whether the ioctl was passed an invalid args pointer.
>
> Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> Link: http://lkml.kernel.org/r/CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Thanks, looks good. I still see a flood of oopses from the other
ioctls, so it's a bit difficult to test this patch properly.

> ---
>  drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> index 365e41a..9f5602e 100644
> --- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
> @@ -1103,7 +1103,11 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
>         struct drm_i915_gem_exec_object2 *exec2_list = NULL;
>         int ret, i;
>
> -       if (args->buffer_count < 1) {
> +       if (args == NULL)
> +               return -EINVAL;
> +
> +       if (args->buffer_count < 1 ||
> +           args->buffer_count > INT_MAX / sizeof(*exec2_list)) {
>                 DRM_DEBUG("execbuf with %d buffers\n", args->buffer_count);
>                 return -EINVAL;
>         }
> @@ -1182,8 +1186,11 @@ i915_gem_execbuffer2(struct drm_device *dev, void *data,
>         struct drm_i915_gem_exec_object2 *exec2_list = NULL;
>         int ret;
>
> +       if (args == NULL)
> +               return -EINVAL;
> +
>         if (args->buffer_count < 1 ||
> -           args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
> +           args->buffer_count > INT_MAX / sizeof(*exec2_list)) {
>                 DRM_DEBUG("execbuf2 with %d buffers\n", args->buffer_count);
>                 return -EINVAL;
>         }
> --
> 1.7.10.4
>
