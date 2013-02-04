Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3BDUUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:20:08 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37731 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3BDUUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:20:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130204170655.GA20950@redhat.com>
References: <20130204170655.GA20950@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 4 Feb 2013 15:19:44 -0500
Message-ID: <CA+1xoqdDoKxU4L6u4XRXVMCSiMG174_y9kwoEO6i9rXS2AfUig@mail.gmail.com>
Subject: Re: [GIT PULL] Revert "dlm: check the maximum size of a request from user"
To: David Teigland <teigland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

This opens up a hole for userspace to force the kernel to allocate
huge chunks of memory, triggering oom killing spree and such.

It should probably be fixed instead of just reverted.

I'll look into it.


Thanks,
Sasha

On Mon, Feb 4, 2013 at 12:06 PM, David Teigland <teigland@redhat.com> wrote:
> Hi Linus,
>
> Please pull the following fix from branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git for-linus
>
> This reverts commit 2b75bc9121e54e22537207b47b71373bcb0be41c.
>
> There is something wrong with the CONFIG_COMPAT max size
> check in ioctl write.  There is a report of a case where
> this breaks userland (clvmd) when maximum resource name
> lengths are used.  I am still sorting out exactly which
> combinations of kernel and userland libs are a problem.
>
> Reported-by: Jana Saout <jana@saout.de>
> CC: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: David Teigland <teigland@redhat.com>
> ---
>  fs/dlm/user.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/fs/dlm/user.c b/fs/dlm/user.c
> index 7ff4985..eb4ed9b 100644
> --- a/fs/dlm/user.c
> +++ b/fs/dlm/user.c
> @@ -503,13 +503,6 @@ static ssize_t device_write(struct file *file, const char __user *buf,
>  #endif
>                 return -EINVAL;
>
> -#ifdef CONFIG_COMPAT
> -       if (count > sizeof(struct dlm_write_request32) + DLM_RESNAME_MAXLEN)
> -#else
> -       if (count > sizeof(struct dlm_write_request) + DLM_RESNAME_MAXLEN)
> -#endif
> -               return -EINVAL;
> -
>         kbuf = kzalloc(count + 1, GFP_NOFS);
>         if (!kbuf)
>                 return -ENOMEM;
> --
> 1.8.1.rc1.5.g7e0651a
>
