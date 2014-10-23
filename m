Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaJWQm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:42:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaJWQmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:42:55 -0400
Date: Thu, 23 Oct 2014 18:39:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] coredump: fix incomplete core file created when
	dump_skip was used last
Message-ID: <20141023163934.GA31508@redhat.com>
References: <1413932228-27642-1-git-send-email-victor.kamensky@linaro.org> <1413932228-27642-2-git-send-email-victor.kamensky@linaro.org> <20141022165530.GA30358@redhat.com> <CAA3XUr0N_fcOqmSnT2Y=Dz+5uH1YN+qrJ=2-fJrQaHcnu1cQXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA3XUr0N_fcOqmSnT2Y=Dz+5uH1YN+qrJ=2-fJrQaHcnu1cQXw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, Victor Kamensky wrote:
>
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -664,6 +664,14 @@ void do_coredump(const siginfo_t *siginfo)
>         if (!dump_interrupted()) {
>                 file_start_write(cprm.file);
>                 core_dumped = binfmt->core_dump(&cprm);
> +               /*
> +                * If last operation was dump_skip with llseek, we need to
> +                * truncate file up to f_pos to match expected size.
> +                */
> +               if (!ispipe &&
> +                   (cprm.file->f_pos > i_size_read(file_inode(cprm.file))))
> +                       do_truncate(cprm.file->f_path.dentry,
> +                                   cprm.file->f_pos, 0, cprm.file);
>                 file_end_write(cprm.file);
>         }
>         if (ispipe && core_pipe_limit)
>
> May I use your name with Suggested-by tag?

Sure, thanks ;)

I'd suggest to add a simple helper, but I won't insist. And perhaps the
caller can also check "core_dumped" along with !ispipe, but this is
purely cosmetic.

Oleg.

