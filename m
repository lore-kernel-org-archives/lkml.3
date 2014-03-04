Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbaCDOwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:52:07 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:43781 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbaCDOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:52:06 -0500
MIME-Version: 1.0
In-Reply-To: <1393925688.3038.22.camel@x220>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
	<1391085212.5170.9.camel@x41>
	<1392930177.15264.5.camel@x220>
	<CAKb7Uvg=U+b0d2uBM3rrXzotdCM=VZsJ0ArPU82Nzy95S=WZRw@mail.gmail.com>
	<1392931493.15264.17.camel@x220>
	<20140221082021.GG22574@ulmo.nvidia.com>
	<1393925688.3038.22.camel@x220>
Date: Tue, 4 Mar 2014 09:52:04 -0500
Message-ID: <CADnq5_NsV4p7coPd3nz_+e1Cf-0o62LtG3OZsZd3d=ATSOGrHg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/radeon: silence GCC warning on 32 bit
From: Alex Deucher <alexdeucher@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 4:34 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
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
> Silence this warning by using min_t(). Since cur_size will never be
> negative and its upper bound is PAGE_SIZE, we can change its type to
> size_t and use min_t(size_t, [...]) here.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to my -fixes tree.

Thanks!

Alex

> ---
> v2: use min_t() as Ilia suggested, and convert cur_size to size_t, as
> Thierry suggested.
>
> Still compile tested only (on 32 and 64 bit x86).
>
>  drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 77f5b0c..1ce6ba6 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -935,7 +935,7 @@ static ssize_t radeon_ttm_gtt_read(struct file *f, char __user *buf,
>         while (size) {
>                 loff_t p = *pos / PAGE_SIZE;
>                 unsigned off = *pos & ~PAGE_MASK;
> -               ssize_t cur_size = min(size, PAGE_SIZE - off);
> +               size_t cur_size = min_t(size_t, size, PAGE_SIZE - off);
>                 struct page *page;
>                 void *ptr;
>
> --
> 1.8.5.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
