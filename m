Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3IHHmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 03:42:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50436 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3IHHmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 03:42:54 -0400
MIME-Version: 1.0
In-Reply-To: <201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp>
References: <201309080100.FFE90102.FFOVOtJQOFHSLM@I-love.SAKURA.ne.jp>
	<201309081332.FEJ52163.FHJOMQVOFOLStF@I-love.SAKURA.ne.jp>
	<CAKb7UvjH1XZ3f-c=149s5=rqxkxVUhG_7-cfUYH3zrwJwr2_MQ@mail.gmail.com>
	<201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp>
Date: Sun, 8 Sep 2013 03:42:53 -0400
X-Google-Sender-Auth: 4Y64SjUbQyMUzJw9RY2GGhLry14
Message-ID: <CAKb7Uvh5fuFu2tRiOq8y5M+02QC5hi_t0+MbSgAKPM-i=Fc_PA@mail.gmail.com>
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootable kernel.
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>, a.p.zijlstra@chello.nl,
        mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 8, 2013 at 3:24 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> Ilia Mirkin wrote:
>> > Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
>> > "!__builtin_constant_p(p == NULL)" which I guess the author meant that
>> > "__builtin_constant_p(p) && p", but gcc 3.x cannot handle such expression
>> > correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
>>
>> I think that !__builtin_constant_p(p == NULL) is basically saying "I
>> am unable to conclude that p == NULL at build time", which would
>> translate to something along the lines of
>>
>> (__builtin_constant_p(p) && p) || !__builtin_constant_p(p)
>>
>
> I think
>
>   (__builtin_constant_p(p) && p) && p->acquired > 0
>
> is safe but
>
>   (!__builtin_constant_p(p)) && p->acquired > 0
>
> is not safe, for "p != NULL" check is required for avoiding NULL pointer
> dereference.
>
> It seems to me that
>
>   (!__builtin_constant_p(p == NULL))
>
> need to be translated to something along the lines of
>
>   (__builtin_constant_p(p) && p) || (!__builtin_constant_p(p) && p)
>
> which can be simplified as
>
>   (p)
>
> .
>
>> Or perhaps it's just equivalent to !__builtin_constant_p(p), since the
>> compiler's ability to conclude whether it is NULL at build-time should
>> be unaffected by whether it actually is NULL or not.
>
> Likewise, it seems to me that
>
>   (!__builtin_constant_p(p == NULL))
>
> need to be translated to something along the lines of
>
>   (!__builtin_constant_p(p) && p)

Well, I think the theory is that if p is not a compile-time constant
then it must not be null. At least that's the implication of the
current code. As I understand it, the == NULL is a no-op as far as gcc
is concerned, since it's not evaluating the expr, only checking if it
can be evaluated. Unless there can be a situation where it can know
whether a value is null or not, but not know its actual value, in
which case the && p is warranted.

>
> . Well this change as well can fix "boot failure on gcc 3.x" and avoid "locking
> selftests failure on gcc 3.x / 4.x". OK, let's wait for answer from the author.

Probably best to do that, yes. Maarten?

>
> Can I add "Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>" to below patch?

I don't think that's the correct usage of "Signed-off-by", since I
neither wrote the patch nor am I on the upstream path. If you really
want to give credit, you could invent a "Suggested-by" tag, but I
really don't care.

>
> ---------- good patch start ----------
> >From a8bbf6b3c2d44cb90d63820f146aaff119d871c9 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Sun, 8 Sep 2013 16:09:27 +0900
> Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.
>
> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
>
> Fix it by changing from "!__builtin_constant_p(p == NULL)" to
> "!__builtin_constant_p(p) && p".
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: <stable@kernel.org> [3.11+]
> ---
>  kernel/mutex.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index a52ee7bb..ef02003 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -448,7 +448,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>                 struct task_struct *owner;
>                 struct mspin_node  node;
>
> -               if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +               if (!__builtin_constant_p(ww_ctx) && ww_ctx && ww_ctx->acquired > 0) {
>                         struct ww_mutex *ww;
>
>                         ww = container_of(lock, struct ww_mutex, base);
> @@ -478,7 +478,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>                 if ((atomic_read(&lock->count) == 1) &&
>                     (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
>                         lock_acquired(&lock->dep_map, ip);
> -                       if (!__builtin_constant_p(ww_ctx == NULL)) {
> +                       if (!__builtin_constant_p(ww_ctx) && ww_ctx) {
>                                 struct ww_mutex *ww;
>                                 ww = container_of(lock, struct ww_mutex, base);
>
> @@ -548,7 +548,7 @@ slowpath:
>                         goto err;
>                 }
>
> -               if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +               if (!__builtin_constant_p(ww_ctx) && ww_ctx && ww_ctx->acquired > 0) {
>                         ret = __mutex_lock_check_stamp(lock, ww_ctx);
>                         if (ret)
>                                 goto err;
> @@ -568,7 +568,7 @@ done:
>         mutex_remove_waiter(lock, &waiter, current_thread_info());
>         mutex_set_owner(lock);
>
> -       if (!__builtin_constant_p(ww_ctx == NULL)) {
> +       if (!__builtin_constant_p(ww_ctx) && ww_ctx) {
>                 struct ww_mutex *ww = container_of(lock,
>                                                       struct ww_mutex,
>                                                       base);
> --
> 1.7.8
> ---------- good patch end ----------
