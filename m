Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaGQRyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:54:04 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34029 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaGQRyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:54:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140717174959.GA12788@www.outflux.net>
References: <20140717174959.GA12788@www.outflux.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Jul 2014 10:53:40 -0700
Message-ID: <CALCETrVRC8Zh3yGQuuMyWFob0v8i2x+PLMNK0nZ2cryHvv_NEQ@mail.gmail.com>
Subject: Re: [PATCH] seccomp: do not reject initial filter using TSYNC
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>,
        David Drysdale <drysdale@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:49 AM, Kees Cook <keescook@chromium.org> wrote:
> There was an unneeded sanity check in the TSYNC code that was causing
> the first filter applied to not allow the TSYNC flag. Additionally,
> this optimizes the thread loops to skip "current". It was harmless, but
> better to not cause problems in the future.
>
> Reported-by: David Drysdale <drysdale@google.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This goes on top of the v11 seccomp-tsync series. If I should respin
> as v12, please let me know.
>
> Thanks!
> ---
>  kernel/seccomp.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 2125b83ccfd4..0e0c6905b81d 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -255,14 +255,15 @@ static inline pid_t seccomp_can_sync_threads(void)
>         BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
>         BUG_ON(!spin_is_locked(&current->sighand->siglock));
>
> -       if (current->seccomp.mode != SECCOMP_MODE_FILTER)
> -               return -EACCES;
> -
>         /* Validate all threads being eligible for synchronization. */
>         caller = current;
>         for_each_thread(caller, thread) {
>                 pid_t failed;
>
> +               /* Skip current, since it is initiating the sync. */
> +               if (thread == current)
> +                       continue;
> +

Should that be "thread == caller"?

--Andy
