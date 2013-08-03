Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3HCT1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:27:24 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:52336 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3HCT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:27:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130802192734.GA9565@redhat.com>
References: <20130802192713.GA9543@redhat.com>
	<20130802192734.GA9565@redhat.com>
Date: Sat, 3 Aug 2013 12:27:22 -0700
X-Google-Sender-Auth: i4yJfb5yCUoouXhGmk0m4u-l57E
Message-ID: <CAGXu5jKY1S7wxWCv6ZULU=rvp1fQ9KemcFZxY7ccoX06jdvP3w@mail.gmail.com>
Subject: Re: [PATCH 1/5] exec: move allow_write_access/fput to exec_binprm()
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 12:27 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> When search_binary_handler() succeeds it does allow_write_access()
> and fput(), then it clears bprm->file to ensure the caller will not
> do the same.
>
> We can simply move this code to exec_binprm() which is called only
> once. In fact we could move this to free_bprm() and remove the same
> code in do_execve_common's error path.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/exec.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index ad7d624..ef70320 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1400,10 +1400,6 @@ int search_binary_handler(struct linux_binprm *bprm)
>                         bprm->recursion_depth--;
>                         if (retval >= 0) {
>                                 put_binfmt(fmt);
> -                               allow_write_access(bprm->file);
> -                               if (bprm->file)
> -                                       fput(bprm->file);
> -                               bprm->file = NULL;
>                                 return retval;
>                         }
>                         read_lock(&binfmt_lock);
> @@ -1455,6 +1451,11 @@ static int exec_binprm(struct linux_binprm *bprm)
>                 ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
>                 current->did_exec = 1;
>                 proc_exec_connector(current);
> +
> +               if (bprm->file) {
> +                       allow_write_access(bprm->file);
> +                       fput(bprm->file);
> +               }

Why not keep the bprm->file = NULL assignment? Seems reasonable to
keep that just to be avoid use-after-free accidents.

-Kees

>         }
>
>         return ret;
> --
> 1.5.5.1
>



-- 
Kees Cook
Chrome OS Security
