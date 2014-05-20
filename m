Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaETCgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:36:08 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63762 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaETCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 20 May 2014 10:35:24 +0800
Message-ID: <CAHz2CGU-0pvu=jMx88BG5e2CJCByZGQR_v=T-c+6eeOzciESPw@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Rik van Riel <riel@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
        Fengguang Wu <fengguang.wu@intel.com>, kamezawa.hiroyu@jp.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:40 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Since the kernel worker thread needs to escape from the while loop so that
> alloc_page() can allocate memory (and eventually allow xfs_vm_writepage()
> to release memory), I think that we should not block forever. This patch
> introduces 30 seconds timeout for userspace processes and 5 seconds timeout
> for kernel processes.
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  mm/vmscan.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 32c661d..3eeeda6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1459,13 +1459,18 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
>         int file = is_file_lru(lru);
>         struct zone *zone = lruvec_zone(lruvec);
>         struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
> +       int i = 0;
>
> -       while (unlikely(too_many_isolated(zone, file, sc))) {
> +       /* Throttle with timeout. */
> +       while (unlikely(too_many_isolated(zone, file, sc)) && i++ < 300) {
>                 congestion_wait(BLK_RW_ASYNC, HZ/10);
>
>                 /* We are about to die and free our memory. Return now. */
>                 if (fatal_signal_pending(current))
>                         return SWAP_CLUSTER_MAX;
> +               /* Kernel threads should not be blocked for too long. */
> +               if (i == 50 && (current->flags & PF_KTHREAD))
> +                       break;
>         }
>
>         lru_add_drain();

Hi, Tetsuo Handa

I think it is good to use a MACRO for this magic number instead of harding code
it, in a long-term maintainability view,  and would better with
appropriate document.

Thanks,
Jianyu Zhan
