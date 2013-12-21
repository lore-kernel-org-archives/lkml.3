Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3LURrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:47:18 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34084 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3LURrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:47:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAB5gotvTv7Y=rMCvO0b5Jg-fx5rLUro+OfWMD0EoLpuHCsQ8TA@mail.gmail.com>
References: <CAB5gotvTv7Y=rMCvO0b5Jg-fx5rLUro+OfWMD0EoLpuHCsQ8TA@mail.gmail.com>
Date: Sat, 21 Dec 2013 09:47:17 -0800
X-Google-Sender-Auth: RYuy_L4-Iv1kyChCq5MIXA0MnRs
Message-ID: <CA+55aFwBwrindu1AJU4S7XgYyxpuBUyq=wrwdDVn2EJUuChVDg@mail.gmail.com>
Subject: Re: [PATCH] skip increamenting nr for TASK_UNINTERRUPTIBLE
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vaibhav Shinde <v.bhav.shinde@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, adding Oleg to the cc. And I don't think this is correct, since
SIGKILL can actually kill uninterruptible processes too
(TASK_WAKEKILL) so the basic premise of the patch is incorrect. And
again, we do have that whole issue with exit_mm() serialization.

                   Linus

On Sat, Dec 21, 2013 at 4:18 AM, Vaibhav Shinde <v.bhav.shinde@gmail.com> wrote:
> Dear All,
>
> We found below issue in coredump for uninterruptible task -
>
> From 1c46f0327d98ad593d8913f9f1dad352f8f44304 Mon Sep 17 00:00:00 2001
> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Date: Sat, 21 Dec 2013 17:06:05 +0530
> Subject: [PATCH] skip increamenting nr for TASK_UNINTERRUPTIBLE
>
> In coredump case, where thread_1 faults while thread_2 is in
> TASK_UNINTERRUPTIBLE state, it cannot handle the SIGKILL.
> Thus the process hangs on event.
> The coredump routine freezes until the thread state is
> uninterruptible.
>
> Solution: Continue for coredump, without waiting for uninterruptible
>  thread, as it will get killed as soon as it returns from
>  uninterruptible state.
>  Therefore do not increament thread count for threads with
>  TASK_UNINTERRUPTIBLE.
>
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Signed-off-by: Vaibhav Shinde <v.bhav.shinde@gmail.com>
> ---
>  fs/coredump.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 447b02c..54b0664 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -281,7 +281,8 @@ static int zap_process(struct task_struct *start,
> int exit_code)
>   if (t != current && t->mm) {
>   sigaddset(&t->pending.signal, SIGKILL);
>   signal_wake_up(t, 1);
> - nr++;
> + if(!(t->state & TASK_UNINTERRUPTIBLE))
> + nr++;
>   }
>   } while_each_thread(start, t);
>
> --
> 1.7.9.5
