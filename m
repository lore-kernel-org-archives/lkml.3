Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3FJK4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:56:05 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:57989 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3FJK4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:56:02 -0400
MIME-Version: 1.0
In-Reply-To: <1370845742-18919-1-git-send-email-yinghai@kernel.org>
References: <1370845742-18919-1-git-send-email-yinghai@kernel.org>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Mon, 10 Jun 2013 13:55:40 +0300
Message-ID: <CA+QCeVRdOOuh4aVZsQhucBNETnDp5OhAZguigLTbyD9bOONO1A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] x86, range: Do not add new blank slot with add_range_with_merge
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10 June 2013 09:29, Yinghai Lu <yinghai@kernel.org> wrote:
> Joshua reported: Commit cd7b304dfaf1 (x86, range: fix missing merge
> during add range) broke mtrr cleanup on his setup in 3.9.5.
> corresponding commit in upstream is fbe06b7bae7c.
>
> The reason is add_range_with_merge could generate blank spot.
>
> We could avoid that by searching new expanded start/end, that
> new range should include all connected ranges in range array.
> At last add the new expanded start/end to the range array.
> Also move up left array so do not add new blank slot in the
> range array.
>
> -v2: move left array to avoid enhance add_range()
>
> Reported-by: Joshua Covington <joshuacov@googlemail.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: <stable@vger.kernel.org> v3.9
>
> ---
>  arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
>  kernel/range.c                     |   21 +++++++++++----------
>  2 files changed, 12 insertions(+), 11 deletions(-)
>
> Index: linux-2.6/kernel/range.c
> ===================================================================
> --- linux-2.6.orig/kernel/range.c
> +++ linux-2.6/kernel/range.c
> @@ -32,9 +32,8 @@ int add_range_with_merge(struct range *r
>         if (start >= end)
>                 return nr_range;
>
> -       /* Try to merge it with old one: */
> +       /* get new start/end: */
>         for (i = 0; i < nr_range; i++) {
> -               u64 final_start, final_end;
>                 u64 common_start, common_end;
>
>                 if (!range[i].end)
> @@ -45,14 +44,16 @@ int add_range_with_merge(struct range *r
>                 if (common_start > common_end)
>                         continue;
>
> -               final_start = min(range[i].start, start);
> -               final_end = max(range[i].end, end);
> -
> -               /* clear it and add it back for further merge */
> -               range[i].start = 0;
> -               range[i].end =  0;
> -               return add_range_with_merge(range, az, nr_range,
> -                       final_start, final_end);
> +               /* new start/end, will add it back at last */
> +               start = min(range[i].start, start);
> +               end = max(range[i].end, end);
> +
> +               memmove(&range[i], &range[i + 1],
> +                       (nr_range - (i + 1)) * sizeof(range[i]));
> +               range[nr_range - 1].start = 0;
> +               range[nr_range - 1].end   = 0;
> +               nr_range--;
> +               i--;
>         }
>
>         /* Need to add it: */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

patches 1,2(latest one) have not helped me on 3.9.5:

rathamahata@piledriver /usr/local/src/linux-3.9.5 $ cat /proc/cmdline
BOOT_IMAGE=/boot/linux-3.9.5 root=/dev/sda1 rootflags=commit=9
elevator=cfq enable_mtrr_cleanup mtrr_spare_reg_nr=1
rathamahata@piledriver /usr/local/src/linux-3.9.5 $ cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size=  256MB, count=1: write-back
reg02: base=0x08f800000 ( 2296MB), size=    8MB, count=1: uncachable
reg03: base=0x0b0000000 ( 2816MB), size=  256MB, count=1: write-combining
reg04: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-combining
rathamahata@piledriver /usr/local/src/linux-3.9.5 $ free -m
             total       used       free     shared    buffers     cached
Mem:          7370        714       6656          0         35        243
-/+ buffers/cache:        434       6935
Swap:         3659          0       3659
rathamahata@piledriver /usr/local/src/linux-3.9.5 $
