Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbaDGWOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:14:23 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:58965 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaDGWOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <5342F083.5020509@linaro.org>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org>
 <1395436655-21670-3-git-send-email-john.stultz@linaro.org>
 <CAHGf_=pBUW1Za862NGeN2u2D8B9hjTk5DgP4SYqoM34KUnMMhQ@mail.gmail.com> <5342F083.5020509@linaro.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 7 Apr 2014 18:14:01 -0400
Message-ID: <CAHGf_=pRy-8XjMjE4Kk9AgO2oeRcy+DiMLiN-rBhuWOexxbXJw@mail.gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This change hwpoison and migration tag number. maybe ok, maybe not.
>
> Though depending on config can't these tag numbers change anyway?

I don't think distro disable any of these.


>> I'd suggest to use younger number than hwpoison.
>> (That's why hwpoison uses younger number than migration)
>
> So I can, but the way these are defined makes the results seem pretty
> terrible:
>
> #define SWP_MIGRATION_WRITE    (MAX_SWAPFILES + SWP_HWPOISON_NUM \
>                     + SWP_MVOLATILE_PURGED_NUM + 1)
>
> Particularly when:
> #define MAX_SWAPFILES ((1 << MAX_SWAPFILES_SHIFT)        \
>                 - SWP_MIGRATION_NUM        \
>                 - SWP_HWPOISON_NUM        \
>                 - SWP_MVOLATILE_PURGED_NUM    \
>             )
>
> Its a lot of unnecessary mental gymnastics. Yuck.
>
> Would a general cleanup like the following be ok to try to make this
> more extensible?
>
> thanks
> -john
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 3507115..21387df 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -49,29 +49,38 @@ static inline int current_is_kswapd(void)
>   * actions on faults.
>   */
>
> +enum {
> +       /*
> +        * NOTE: We use the high bits here (subtracting from
> +        * 1<<MAX_SWPFILES_SHIFT), so to preserve the values insert
> +        * new entries here at the top of the enum, not at the bottom
> +        */
> +#ifdef CONFIG_MEMORY_FAILURE
> +       SWP_HWPOISON_NR,
> +#endif
> +#ifdef CONFIG_MIGRATION
> +       SWP_MIGRATION_READ_NR,
> +       SWP_MIGRATION_WRITE_NR,
> +#endif
> +       SWP_MAX_NR,
> +};
> +#define MAX_SWAPFILES ((1 << MAX_SWAPFILES_SHIFT) - SWP_MAX_NR)
> +

I don't see any benefit of this code. At least, SWP_MAX_NR is suck.
The name doesn't match the actual meanings.
