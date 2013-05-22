Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3EVBKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 21:10:20 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36964 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3EVBKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 21:10:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130520165559.GA19645@redhat.com>
References: <20130520165559.GA19645@redhat.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 21 May 2013 22:09:57 -0300
Message-ID: <CAKi4VAJfYJ1SJzBj7QwOOu9ZoKqvQUWefGyN8jKzDCTQ7AaqyA@mail.gmail.com>
Subject: Re: [PATCH] usermodehelper: kill the sub_info->path[0] check
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Mon, May 20, 2013 at 1:55 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> call_usermodehelper_exec() does nothing but returns success if
> path[0] == 0. The only user which needs this strange feature is
> request_module(), it can check modprobe_path[0] itself like other
> users do if they want to detect the "disabled by admin" case.
>
> Kill it. Not only it looks strange, it can confuse other callers.
> And this allows us to revert 264b83c0 "usermodehelper: check
> subprocess_info->path != NULL", do_execve(NULL) is safe.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-By: Lucas De Marchi <lucas.demarchi@intel.com>

But... see below.

> ---
>  kernel/kmod.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 8241906..fb32636 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -147,6 +147,9 @@ int __request_module(bool wait, const char *fmt, ...)
>          */
>         WARN_ON_ONCE(wait && current_is_async());
>
> +       if (!modprobe_path[0])
> +               return 0;
> +

Any reason to not return -EINVAL here except for maintaining the
previous behavior? Checking the callers reveals just a few of them
actually check the return value and IMO this is no different than the
binary not existing and failing later on exec.

>         va_start(args, fmt);
>         ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
>         va_end(args);
> @@ -569,14 +572,6 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>         int retval = 0;
>
>         helper_lock();
> -       if (!sub_info->path) {
> -               retval = -EINVAL;
> -               goto out;
> -       }
> -
> -       if (sub_info->path[0] == '\0')
> -               goto out;
> -
>         if (!khelper_wq || usermodehelper_disabled) {
>                 retval = -EBUSY;
>                 goto out;
> --

Lucas De Marchi
