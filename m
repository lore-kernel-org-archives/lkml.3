Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LURlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:41:50 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:64429 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3LURls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:41:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ8eaTzkKtwM2Xvw_GYRrefUVJg0uzaqFNPJcNc_ffSayQiDUA@mail.gmail.com>
References: <CAJ8eaTzkKtwM2Xvw_GYRrefUVJg0uzaqFNPJcNc_ffSayQiDUA@mail.gmail.com>
Date: Sat, 21 Dec 2013 09:41:48 -0800
X-Google-Sender-Auth: UcrA18wuXWgvIJlRAKhKIJYVNMg
Message-ID: <CA+55aFyVrrvDzUt0OU4d9YZM8C-N+ycSKEa3+-5nowUoZ=rb8w@mail.gmail.com>
Subject: Re: [PATCH] secure unlock_task_sighand() call
From: Linus Torvalds <torvalds@linux-foundation.org>
To: naveen yadav <yad.naveen@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Vaibhav Shinde <v.bhav.shinde@gmail.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did you actually *see* the problem, or was this just from looking at the code?

I don't hate the patch, and it might be the right thing to do in any
case (just to avoid depending on subtle things), but this really *is*
subtle, and I'm adding Oleg to the participants since it is his code
(going back to 2006, no less).

We have coredump serialization in exit_mm() that I think *should* make
this all ok - if we still see p->mm matching our mm, I don't think it
should be able to get to __exit_signal() and make the sighand go away,
so the lock_task_sighand() shouldn't ever fail. But I might miss
something, and as mentioned the patch might be a good idea regardless
just to avoid overly subtle rules that can confuse people.

Oleg?

                   Linus

On Sat, Dec 21, 2013 at 1:55 AM, naveen yadav <yad.naveen@gmail.com> wrote:
>
> When check code , we found below issue in zap_thread function().
>
> From 57bf616d0e20086d73122373baf799c675f4e3d5 Mon Sep 17 00:00:00 2001
> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Date: Sat, 21 Dec 2013 14:45:48 +0530
> Subject: [PATCH] secure unlock_task_sighand() call
>
> Since the return value was not checked for lock_task_sighand(),
> there was a chance that spin_unlock_irqrestore being called
> from unlock_task_sighand gets called wihout actually acquire
> the lock, which inturn can lead to kernel crash.
>
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Signed-off-by: Vaibhav Shinde <v.bhav.shinde@gmail.com>
>
> ---
>  fs/coredump.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 6d8b4cd..447b02c 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -357,9 +357,10 @@ static inline int zap_threads(struct task_struct
> *tsk, struct mm_struct *mm,
>                 do {
>                         if (p->mm) {
>                                 if (unlikely(p->mm == mm)) {
> -                                       lock_task_sighand(p, &flags);
> -                                       nr += zap_process(p, exit_code);
> -                                       unlock_task_sighand(p, &flags);
> +                                       if (lock_task_sighand(p, &flags) {
> +                                               nr += zap_process(p, exit_code);
> +                                               unlock_task_sighand(p, &flags);
> +                                       }
>                                 }
>                                 break;
>                         }
> --
> 1.7.9.5
