Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3CTQ0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:26:48 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54958 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CTQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <1363793126-11510-3-git-send-email-ming.lei@canonical.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
	<1363793126-11510-3-git-send-email-ming.lei@canonical.com>
Date: Wed, 20 Mar 2013 10:26:43 -0600
Message-ID: <CAKocOOP9wAiWSKhY-P6Yy7TvjTKfpek65WZB+TRpfd5FuDvGnw@mail.gmail.com>
Subject: Re: [PATCH 2/2] sysfs: handle failure path correctly for readdir()
From: Shuah Khan <shuahkhan@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 9:25 AM, Ming Lei <ming.lei@canonical.com> wrote:
> In case of 'if (filp->f_pos ==  0 or 1)' of sysfs_readdir(),
> the failure from filldir() isn't handled, and the reference counter
> of the sysfs_dirent object pointed by filp->private_data will be
> released without clearing filp->private_data, so use after free
> bug will be triggered later.
>
> This patch returns immeadiately under the situation for fixing the bug,
> and it is reasonable to return from readdir() when filldir() fails.
>
> Reported-by: Dave Jones <davej@redhat.com>
> Tested-by: Sasha Levin <levinsasha928@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  fs/sysfs/dir.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index c9e1660..e145126 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -1020,6 +1020,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
>                 ino = parent_sd->s_ino;
>                 if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
>                         filp->f_pos++;
> +               else
> +                       return 0;
>         }
>         if (filp->f_pos == 1) {
>                 if (parent_sd->s_parent)
> @@ -1028,6 +1030,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
>                         ino = parent_sd->s_ino;
>                 if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
>                         filp->f_pos++;
> +               else
> +                       return 0;
>         }

Looks good to me. This is just an observation. readdir callers are
checking against NULL as opposed 0. Not a problem really probably
since NULL is defined as 0.

-- Shuah
