Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab3HSUdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:33:09 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33788 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3HSUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <1376929831-18214-1-git-send-email-richard.genoud@gmail.com>
References: <1376929831-18214-1-git-send-email-richard.genoud@gmail.com>
Date: Mon, 19 Aug 2013 16:33:07 -0400
Message-ID: <CAB9dFduWPr0n8c7ckZr=2AQ-h4sy4U9YYzTRw335Xaimc4tk-A@mail.gmail.com>
Subject: Re: [PATCH] proc: return on proc_readdir error
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 12:30 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:
>
> commit f0c3b5093addc8bfe9fe3a5b01acb7ec7969eafa
> "[readdir] convert procfs" introduced a bug on the listing of the proc
> file-system.
> The return value of proc_readdir() isn't tested anymore in the
> proc_root_readdir function.
>
> This lead to an "interesting" behaviour when we are using the getdents()
> system call with a buffer too small:
> Instead of failing, it returns the first entries of /proc (enough to
> fill the given buffer), plus the PID directories.
>
> This is not triggered on glibc (as getdents is called with a 32KB
> buffer), but on uclibc, the buffer size is only 1KB, thus some proc
> entries are missing.
> (described more in details here: https://lkml.org/lkml/2013/8/12/288 )
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
> [added Linus Torvalds and Andrew Morton in CC since Al Viro seems to be
> on holidays and it's starting to getting late in the -rc cycles]
>
>  fs/proc/root.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 229e366..e0a790d 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -205,7 +205,9 @@ static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentr
>  static int proc_root_readdir(struct file *file, struct dir_context *ctx)
>  {
>         if (ctx->pos < FIRST_PROCESS_ENTRY) {
> -               proc_readdir(file, ctx);
> +               int error = proc_readdir(file, ctx);
> +               if (unlikely(error <= 0))
> +                       return error;
>                 ctx->pos = FIRST_PROCESS_ENTRY;
>         }

By my reading that commit (f0c3b5093add) also made proc_readdir always
return 0, so with this patch the effect I see is that no pid entries
are listed under /proc, breaking ps for instance.  I don't see how
even the previous version of proc_readdir could return a negative
value; looks like 1 and 0 were the only possible return values.

Marc
