Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaBTVHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:07:14 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64069 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaBTVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <1392930177.15264.5.camel@x220>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
	<1391085212.5170.9.camel@x41>
	<1392930177.15264.5.camel@x220>
Date: Thu, 20 Feb 2014 16:07:11 -0500
X-Google-Sender-Auth: YKqIhS_pbo861z6FvSW1Xc6Dtoo
Message-ID: <CAKb7Uvg=U+b0d2uBM3rrXzotdCM=VZsJ0ArPU82Nzy95S=WZRw@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: silence GCC warning on 32 bit
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Dave Airlie <airlied@linux.ie>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 4:02 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Building radeon_ttm.o on 32 bit x86 triggers a warning:
>     In file included from include/asm-generic/bug.h:13:0,
>                      from [...]/arch/x86/include/asm/bug.h:38,
>                      from include/linux/bug.h:4,
>                      from include/drm/drm_mm.h:39,
>                      from include/drm/drm_vma_manager.h:26,
>                      from include/drm/ttm/ttm_bo_api.h:35,
>                      from drivers/gpu/drm/radeon/radeon_ttm.c:32:
>     drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_gtt_read':
>     include/linux/kernel.h:712:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>       (void) (&_min1 == &_min2);  \
>                      ^
>     drivers/gpu/drm/radeon/radeon_ttm.c:938:22: note: in expansion of macro 'min'
>        ssize_t cur_size = min(size, PAGE_SIZE - off);
>                           ^
>
> Silence this warning by casting "PAGE_SIZE - off" to size_t. Since
> "PAGE_SIZE - off" is between 0 and PAGE_SIZE, and PAGE_SIZE is at most
> 21 bits wide while size_t is at least 32 bits wide, this should be safe.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Compile tested only (on 32 and 64 bit x86).
>
>  drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 77f5b0c..5c87979 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -935,7 +935,7 @@ static ssize_t radeon_ttm_gtt_read(struct file *f, char __user *buf,
>         while (size) {
>                 loff_t p = *pos / PAGE_SIZE;
>                 unsigned off = *pos & ~PAGE_MASK;
> -               ssize_t cur_size = min(size, PAGE_SIZE - off);
> +               ssize_t cur_size = min(size, (size_t)(PAGE_SIZE - off));

Isn't the usual way of dealing with these to do something like

ssize_t cur_size = min_t(ssize_t, size, PAGE_SIZE - off)

>                 struct page *page;
>                 void *ptr;
>
> --
> 1.8.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
