Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaKXQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:57:18 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36045 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKXQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:57:16 -0500
MIME-Version: 1.0
In-Reply-To: <1416577403-7887-1-git-send-email-opensource.ganesh@gmail.com>
References: <1416577403-7887-1-git-send-email-opensource.ganesh@gmail.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 24 Nov 2014 11:56:55 -0500
X-Google-Sender-Auth: HJ0DV6Cnex1AUjrhoCtFgwqi1X4
Message-ID: <CALZtONCbto8t_RCpJrfH=ykP1t=AgxnP+4nPORdcf1wNb=6kCQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zsmalloc: avoid duplicate assignment of prev_class
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 8:43 AM, Mahendran Ganesh
<opensource.ganesh@gmail.com> wrote:
> In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1)
> times. And the prev_class only references to the previous size_class.
> So we do not need unnecessary assignement.
>
> This patch assigns *prev_class* when a new size_class structure
> is allocated and uses prev_class to check whether the first class
> has been allocated.
>
> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
>
> ---
> v1 -> v2:
>   - follow Dan Streetman's advise to use prev_class to
>     check whether the first class has been allocated
>   - follow Minchan Kim's advise to remove uninitialized_var()
> ---
>  mm/zsmalloc.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index b3b57ef..810eda1 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -970,7 +970,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
>                 int size;
>                 int pages_per_zspage;
>                 struct size_class *class;
> -               struct size_class *prev_class;
> +               struct size_class *prev_class = NULL;

Maybe I'm looking at the wrong source tree, but I don't think this
will work?  You have to move
prev_class outside the for loop, or it'll be NULL each iteration.

>
>                 size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
>                 if (size > ZS_MAX_ALLOC_SIZE)
> @@ -986,8 +986,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
>                  * characteristics. So, we makes size_class point to
>                  * previous size_class if possible.
>                  */
> -               if (i < ZS_SIZE_CLASSES - 1) {
> -                       prev_class = pool->size_class[i + 1];
> +               if (prev_class) {
>                         if (can_merge(prev_class, size, pages_per_zspage)) {
>                                 pool->size_class[i] = prev_class;
>                                 continue;
> @@ -1003,6 +1002,8 @@ struct zs_pool *zs_create_pool(gfp_t flags)
>                 class->pages_per_zspage = pages_per_zspage;
>                 spin_lock_init(&class->lock);
>                 pool->size_class[i] = class;
> +
> +               prev_class = class;
>         }
>
>         pool->flags = flags;
> --
> 1.7.9.5
>
