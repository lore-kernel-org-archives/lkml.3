Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab3DYFGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:06:48 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40583 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3DYFGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <1366857842-17240-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1366857842-17240-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Thu, 25 Apr 2013 14:06:46 +0900
Message-ID: <CAKYAXd-7dkROw0wGQU-9yth90ObRm5b9Vr8aB_zMd4HX2=+ZrQ@mail.gmail.com>
Subject: Re: [PATCH] f2fs: avoid frequent background GC
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

With the change in the value of GC_THREAD_NOGC_SLEEP_TIME to 600000,
we will need to rewrite the gc_thread_func().
As there will be several paths which will not be reached or will have
no meaning after this change.

Considering the cases:
/* if return value is not zero, no victim was selected */
                if (f2fs_gc(sbi))
                        wait_ms = GC_THREAD_NOGC_SLEEP_TIME;
                else if (wait_ms == GC_THREAD_NOGC_SLEEP_TIME)
                        wait_ms = GC_THREAD_MAX_SLEEP_TIME;

Before this point, there are ‘2’ functions to change ‘wait_ms” ->
increase_sleep_time and decrease_sleep_time.
When we consider increase_sleep_time()  - the maximum possible value
for ‘wait_ms’ after coming out of this can be:
GC_THREAD_MAX_SLEEP_TIME
And in case in the last iteration it was set to
GC_THREAD_NOGC_SLEEP_TIME, once it enters increase_sleep_time() - the
value will be reseted to maximum GC_THREAD_MAX_SLEEP_TIME.
So,
                else if (wait_ms == GC_THREAD_NOGC_SLEEP_TIME)
                        wait_ms = GC_THREAD_MAX_SLEEP_TIME;
becomes unreachable path.

And second, maybe, After setting to GC_THREAD_NOGC_SLEEP_TIME(10min),
Although there are invalid blocks, GC thread might be sleep 9min
50sec.
Let me know your opinion.

Thanks.

2013/4/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> If there is no victim segments selected by background GC, let's wait
> a little bit longer time to collect dirty segments.
> By default, let's give 10 minutes.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/gc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
> index 30b2db0..1190d57 100644
> --- a/fs/f2fs/gc.h
> +++ b/fs/f2fs/gc.h
> @@ -13,9 +13,9 @@
>  						 * whether IO subsystem is idle
>  						 * or not
>  						 */
> -#define GC_THREAD_MIN_SLEEP_TIME	10000 /* milliseconds */
> +#define GC_THREAD_MIN_SLEEP_TIME	10000	/* milliseconds */
>  #define GC_THREAD_MAX_SLEEP_TIME	30000
> -#define GC_THREAD_NOGC_SLEEP_TIME	10000
> +#define GC_THREAD_NOGC_SLEEP_TIME	600000	/* wait 10 min */
>  #define LIMIT_INVALID_BLOCK	40 /* percentage over total user space */
>  #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
>
> --
> 1.8.1.3.566.gaa39828
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
