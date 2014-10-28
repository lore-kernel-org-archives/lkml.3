Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaJ1CBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 22:01:41 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54066 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaJ1CBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 22:01:39 -0400
MIME-Version: 1.0
In-Reply-To: <1414054881-17713-3-git-send-email-daniel.lezcano@linaro.org>
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org>
	<1414054881-17713-3-git-send-email-daniel.lezcano@linaro.org>
Date: Mon, 27 Oct 2014 22:01:38 -0400
X-Google-Sender-Auth: TDWJNczIa6ba8I67SNpU7Ck5XYs
Message-ID: <CAJvTdKm+jwv=2nbi8OZKHHbsieuggp53go=C-ztCr1w4SNpfpw@mail.gmail.com>
Subject: Re: [PATCH V2 3/5] cpuidle: idle: menu: Don't reflect when a state
 selection failed
From: Len Brown <lenb@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linaro-kernel@lists.linaro.org,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 5:01 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> In the current code, the check to reflect or not the outcoming state is done
> against the idle state which has been chosen and its value.
>
> Instead of doing a check in each of the reflect functions, just don't call reflect
> if something went wrong in the idle path.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> ---
>  drivers/cpuidle/governors/ladder.c | 3 +--
>  drivers/cpuidle/governors/menu.c   | 4 +---
>  kernel/sched/idle.c                | 3 ++-
>  3 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
> index fb396d6..c0b36a8 100644
> --- a/drivers/cpuidle/governors/ladder.c
> +++ b/drivers/cpuidle/governors/ladder.c
> @@ -165,8 +165,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
>  static void ladder_reflect(struct cpuidle_device *dev, int index)
>  {
>         struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
> -       if (index > 0)
> -               ldev->last_state_idx = index;

Before this patch, last_state_idx was never set to 0 here.
After this patch, last_state_idx will be set to 0 when entered_state is 0.
Is that okay?

thanks,
-Len

> +       ldev->last_state_idx = index;
>  }
>
>  static struct cpuidle_governor ladder_governor = {
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index a17515f..3907301 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -365,9 +365,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
>  static void menu_reflect(struct cpuidle_device *dev, int index)
>  {
>         struct menu_device *data = &__get_cpu_var(menu_devices);
> -       data->last_state_idx = index;
> -       if (index >= 0)
> -               data->needs_update = 1;
> +       data->needs_update = 1;
>  }
>
>  /**
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 58c7522..49dcc7d 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -162,7 +162,8 @@ use_default:
>         /*
>          * Give the governor an opportunity to reflect on the outcome
>          */
> -       cpuidle_reflect(dev, entered_state);
> +       if (entered_state >= 0)
> +               cpuidle_reflect(dev, entered_state);
>
>  exit_idle:
>         __current_set_polling();
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Len Brown, Intel Open Source Technology Center
