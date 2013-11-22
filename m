Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3KVURk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:17:40 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54725 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3KVURi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:17:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131122191822.GA16943@redhat.com>
References: <20131122191803.GA16919@redhat.com> <20131122191822.GA16943@redhat.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Fri, 22 Nov 2013 12:17:16 -0800
X-Google-Sender-Auth: OUdv7q9mkiViDB2n1jzWYydlVdQ
Message-ID: <CANMivWZ+KZNE6W59MX9xXm24SpUJD+-MbwGCkMX+JAOHtyr3nA@mail.gmail.com>
Subject: Re: [PATCH 3/3] signals: change do_signal_stop/do_sigaction to use while_each_thread()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Change do_signal_stop() and do_sigaction() to avoid next_thread()
> and use while_each_thread() instead.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>

> ---
>  kernel/signal.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index ded28b9..086071d 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2047,8 +2047,8 @@ static bool do_signal_stop(int signr)
>                 if (task_set_jobctl_pending(current, signr | gstop))
>                         sig->group_stop_count++;
>
> -               for (t = next_thread(current); t != current;
> -                    t = next_thread(t)) {
> +               t = current;
> +               while_each_thread(current, t) {
>                         /*
>                          * Setting state to TASK_STOPPED for a group
>                          * stop is always done with the siglock held,
> @@ -3125,8 +3125,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
>                         rm_from_queue_full(&mask, &t->signal->shared_pending);
>                         do {
>                                 rm_from_queue_full(&mask, &t->pending);
> -                               t = next_thread(t);
> -                       } while (t != current);
> +                       } while_each_thread(current, t);
>                 }
>         }
>
> --
> 1.5.5.1
>



-- 
Sameer
