Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3CHUWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:22:32 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:59085 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3CHUW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:22:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130308175920.GA26332@redhat.com>
References: <20130308175852.GA26300@redhat.com>
	<20130308175920.GA26332@redhat.com>
Date: Fri, 8 Mar 2013 12:22:29 -0800
X-Google-Sender-Auth: 1WeX0tcwzyhLdMlP6lzrTEauEpc
Message-ID: <CACBanvqjE_vaCdL=3OouFPtR2714X+55Wc1LAziK43_35cXr4w@mail.gmail.com>
Subject: Re: [PATCH 3/3] coredump: change wait_for_dump_helpers() to use wait_event_interruptible()
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 9:59 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> wait_for_dump_helpers() calls wake_up/kill_fasync from inside the
> wait_event-like loop. This is not needed and in fact this is not
> strictly correct, we can/should do this only once after we change
> pipe->writers. We could even check if it becomes zero.
>
> Change this code to use use wait_event_interruptible(), this can
> also help to make this wait freezable.
>
> With this patch we check pipe->readers without pipe_lock(), this
> is fine. Once we see pipe->readers == 1 we know that the handler
> decremented the counter, this is all we need.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Mandeep Singh Baines <msb@chromium.org>

> ---
>  fs/coredump.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 477f393..667413c 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -439,17 +439,20 @@ static void wait_for_dump_helpers(struct file *file)
>         pipe_lock(pipe);
>         pipe->readers++;
>         pipe->writers--;
> +       wake_up_interruptible_sync(&pipe->wait);
> +       kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> +       pipe_unlock(pipe);
>
> -       while ((pipe->readers > 1) && (!signal_pending(current))) {
> -               wake_up_interruptible_sync(&pipe->wait);
> -               kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> -               pipe_wait(pipe);
> -       }
> +       /*
> +        * We actually want wait_event_freezable() but then we need
> +        * to clear TIF_SIGPENDING and improve dump_interrupted().
> +        */
> +       wait_event_interruptible(pipe->wait, pipe->readers == 1);
>
> +       pipe_lock(pipe);
>         pipe->readers--;
>         pipe->writers++;
>         pipe_unlock(pipe);
> -
>  }
>
>  /*
> --
> 1.5.5.1
>
