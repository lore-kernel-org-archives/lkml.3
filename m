Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaCWRm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 13:42:59 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:50209 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaCWRm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 13:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <1395436655-21670-3-git-send-email-john.stultz@linaro.org>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <1395436655-21670-3-git-send-email-john.stultz@linaro.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 23 Mar 2014 10:42:37 -0700
Message-ID: <CAHGf_=pBUW1Za862NGeN2u2D8B9hjTk5DgP4SYqoM34KUnMMhQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] vrange: Add purged page detection on setting memory non-volatile
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 2:17 PM, John Stultz <john.stultz@linaro.org> wrote:
> Users of volatile ranges will need to know if memory was discarded.
> This patch adds the purged state tracking required to inform userland
> when it marks memory as non-volatile that some memory in that range
> was purged and needs to be regenerated.
>
> This simplified implementation which uses some of the logic from
> Minchan's earlier efforts, so credit to Minchan for his work.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Robert Love <rlove@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Dave Hansen <dave@sr71.net>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mike Hommey <mh@glandium.org>
> Cc: Taras Glek <tglek@mozilla.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: linux-mm@kvack.org <linux-mm@kvack.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  include/linux/swap.h    | 15 ++++++++--
>  include/linux/swapops.h | 10 +++++++
>  include/linux/vrange.h  |  3 ++
>  mm/vrange.c             | 75 +++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 101 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 46ba0c6..18c12f9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -70,8 +70,19 @@ static inline int current_is_kswapd(void)
>  #define SWP_HWPOISON_NUM 0
>  #endif
>
> -#define MAX_SWAPFILES \
> -       ((1 << MAX_SWAPFILES_SHIFT) - SWP_MIGRATION_NUM - SWP_HWPOISON_NUM)
> +
> +/*
> + * Purged volatile range pages
> + */
> +#define SWP_VRANGE_PURGED_NUM 1
> +#define SWP_VRANGE_PURGED (MAX_SWAPFILES + SWP_HWPOISON_NUM + SWP_MIGRATION_NUM)
> +
> +
> +#define MAX_SWAPFILES ((1 << MAX_SWAPFILES_SHIFT)      \
> +                               - SWP_MIGRATION_NUM     \
> +                               - SWP_HWPOISON_NUM      \
> +                               - SWP_VRANGE_PURGED_NUM \
> +                       )

This change hwpoison and migration tag number. maybe ok, maybe not.
I'd suggest to use younger number than hwpoison.
(That's why hwpoison uses younger number than migration)
