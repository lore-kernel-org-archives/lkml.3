Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3FIVeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 17:34:15 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34907 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3FIVeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 17:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <51B44DF9.5040705@gmail.com>
References: <51B44DF9.5040705@gmail.com>
Date: Sun, 9 Jun 2013 14:34:13 -0700
X-Google-Sender-Auth: nPVGVUDK4jSgJnIozVPAJWKJfFQ
Message-ID: <CAE9FiQWtJhubmrgwGjLjOHDJF+Vkt-Y4y2uHuXc6pZg1XUDRxg@mail.gmail.com>
Subject: Re: [PATCH buf-fix] kernel, range: fix broken mtrr_cleanup
From: Yinghai Lu <yinghai@kernel.org>
To: Shan Wei <shanwei88@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Liao <samuelliao@tencent.com>,
        Lin Feng <linfeng@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        davidshan <davidshan@tencent.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 2:42 AM, Shan Wei <shanwei88@gmail.com> wrote:
> From: Samuel Liao <samuelliao@tencent.com>
>
>
> commit fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c broken the mtrr_cleanup
> due to return incorrect merged range. this patch remove the empty range
> by swapping with the last.
>
> Error messages:
> Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 64K         num_reg: 4      lose cover RAM: -0G
> Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 128K        num_reg: 4      lose cover RAM: -0G
> Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 256K        num_reg: 4      lose cover RAM: -0G
> Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 512K        num_reg: 4      lose cover RAM: -0G
>
>
> Signed-off-by: Samuel Liao <samuelliao@tencent.com>
> ---
>  kernel/range.c | 15 ++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/range.c b/kernel/range.c
> index eb911db..b723697 100644
> --- a/kernel/range.c
> +++ b/kernel/range.c
> @@ -48,11 +48,18 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
>                 final_start = min(range[i].start, start);
>                 final_end = max(range[i].end, end);
>
> +               if (final_start == range[i].start && final_end == range[i].end)
> +                       return nr_range;
> +
>                 /* clear it and add it back for further merge */
> -               range[i].start = 0;
> -               range[i].end =  0;
> -               return add_range_with_merge(range, az, nr_range,
> -                       final_start, final_end);
> +               nr_range -= 1;
> +               if (i != nr_range) {
> +                       range[i].start = range[nr_range].start;
> +                       range[i].end = range[nr_range].end;
> +               }
> +               range[nr_range].start = 0;
> +               range[nr_range].end =  0;
> +               i = -1;
>         }
>
>         /* Need to add it: */

this patch is totally wrong.

if the ranges already have [0,1g), [2g, 3g). and want to add [1g, 2g) to it.

what is the result after this patch?
only [1g, 2g)

Thanks

Yinghai
