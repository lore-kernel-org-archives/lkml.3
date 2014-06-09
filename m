Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936480AbaFIJ15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:27:57 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56894 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbaFIJ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
References: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
Date: Mon, 9 Jun 2014 14:57:52 +0530
Message-ID: <CAKohpo=HxqVnd6VejLZTiKsQ95K0Fxu6DLhAJr3ZR3BK+gGyDQ@mail.gmail.com>
Subject: Re: [PATCH] hrtimers: conditionally lock/unlock spinlock in hrtimer_get_next_event
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, stuart.w.hayes@gmail.com,
        david.vrabel@citrix.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 June 2014 14:53, Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:
> In hrtimer_get_next_event we unconditionally lock/unlock spinlock, even if it's
> not required (hrtimer_hres_active() != 0). This patch moves
> locking/unlocking and mindelta range check inside the if clause,
> so we don't execute unnecessary operations.
>
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  kernel/hrtimer.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 39f339dcbe93..ce21e5f6bcf0 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1166,9 +1166,9 @@ ktime_t hrtimer_get_next_event(void)
>         unsigned long flags;
>         int i;
>
> -       raw_spin_lock_irqsave(&cpu_base->lock, flags);
> -
>         if (!hrtimer_hres_active()) {
> +               raw_spin_lock_irqsave(&cpu_base->lock, flags);
> +
>                 for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
>                         struct hrtimer *timer;
>                         struct timerqueue_node *next;
> @@ -1183,12 +1183,13 @@ ktime_t hrtimer_get_next_event(void)
>                         if (delta.tv64 < mindelta.tv64)
>                                 mindelta.tv64 = delta.tv64;
>                 }
> -       }
>
> -       raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
> +               raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
> +
> +               if (mindelta.tv64 < 0)
> +                       mindelta.tv64 = 0;
> +       }
>
> -       if (mindelta.tv64 < 0)
> -               mindelta.tv64 = 0;
>         return mindelta;
>  }

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
