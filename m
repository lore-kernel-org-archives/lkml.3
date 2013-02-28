Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab3B1UTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:19:10 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57333 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3B1UTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:19:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130224173209.GA32209@redhat.com>
References: <20130224173144.GA32179@redhat.com>
	<20130224173209.GA32209@redhat.com>
Date: Thu, 28 Feb 2013 12:19:04 -0800
X-Google-Sender-Auth: 48pM2vLwsvq833F_9ZymXAw5X5k
Message-ID: <CACBanvqZM-AVwwpTDW-ofi=8KH8K13jLRBzTvoB=1Mg=VPxHOQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] coredump: make wait_for_dump_helpers() freezable
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 9:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> wait_for_dump_helpers() calls wake_up/kill_fasync from inside the
> wait_event-like loop. This is not needed and in fact this is not
> strictly correct, we can/should do this only once after we change
> pipe->writers. We could even check if it becomes zero.
>
> With this change it is trivial to convert this code to use
> wait_event_freezable() and make this function freezable/killable,
> only SIGKILL can set TIF_SIGPENDING.
>
> With this patch we check pipe->readers without pipe_lock(), this
> is fine. Once we see pipe->readers == 1 we know that the handler
> decremented the counter, this is all we need.
>
> Note: wait_event_freezable() is "strange", perhaps it should be
> changed or simply removed. In the latter case we can change this
> code again to use freezer_do_not_count + wait_event_interruptible.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Mandeep Singh Baines <msb@chromium.org>

> ---
>  fs/coredump.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 4f3c8d1..284d841 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -32,6 +32,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/oom.h>
>  #include <linux/compat.h>
> +#include <linux/freezer.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
> @@ -428,17 +429,16 @@ static void wait_for_dump_helpers(struct file *file)
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
> +       wait_event_freezable(pipe->wait, pipe->readers == 1);
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
