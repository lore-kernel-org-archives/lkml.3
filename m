Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3HTCXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:23:49 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50320 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3HTCXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <1376961393.20932.8.camel@leonma-sh>
References: <1376961393.20932.8.camel@leonma-sh>
Date: Mon, 19 Aug 2013 19:23:47 -0700
X-Google-Sender-Auth: 6-rQG5x7m9ri6P39bFXZ-nEdX5A
Message-ID: <CAMbhsRRT0bERsZc0UOp=en3KQqotviGs+JzX6c30hVCMdDZPcA@mail.gmail.com>
Subject: Re: [PATCH] LMK: Optimize lowmem_shrink
From: Colin Cross <ccross@android.com>
To: Leon Ma <xindong.ma@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 6:16 PM, Leon Ma <xindong.ma@intel.com> wrote:
> From: Leon Ma <xindong.ma@intel.com>
> Date: Mon, 19 Aug 2013 14:22:38 +0800
> Subject: [PATCH] LMK: Optimize lowmem_shrink.
>
> By comparing with selected_oom_score_adj instead of min_score_adj,
> we may do less calculation.
>
> Signed-off-by: Leon Ma <xindong.ma@intel.com>
> ---
>  drivers/staging/android/lowmemorykiller.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/android/lowmemorykiller.c
> b/drivers/staging/android/lowmemorykiller.c
> index f6c05c9..cb944c5 100644
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -126,7 +126,7 @@ static int lowmem_shrink(struct shrinker *s, struct
> shrink_control *sc)
>                         return 0;
>                 }
>                 oom_score_adj = p->signal->oom_score_adj;
> -               if (oom_score_adj < min_score_adj) {
> +               if (oom_score_adj < selected_oom_score_adj) {

This needs to be oom_score_adj <= selected_oom_score_adj.

>                         task_unlock(p);
>                         continue;
>                 }
> @@ -134,13 +134,9 @@ static int lowmem_shrink(struct shrinker *s, struct
> shrink_control *sc)
>                 task_unlock(p);
>                 if (tasksize <= 0)
>                         continue;
> -               if (selected) {
> -                       if (oom_score_adj < selected_oom_score_adj)
> -                               continue;
> -                       if (oom_score_adj == selected_oom_score_adj &&
> -                           tasksize <= selected_tasksize)
> -                               continue;
> -               }
> +               if (selected && oom_score_adj == selected_oom_score_adj &&
> +                       tasksize <= selected_tasksize)
> +                       continue;
>                 selected = p;
>                 selected_tasksize = tasksize;
>                 selected_oom_score_adj = oom_score_adj;
> --
> 1.7.4.1
>
>
>
