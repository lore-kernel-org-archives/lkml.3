Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3LYIrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 03:47:11 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:34353 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3LYIrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 03:47:10 -0500
MIME-Version: 1.0
In-Reply-To: <1387902787-257492-1-git-send-email-shawn@churchofgit.com>
References: <1387902787-257492-1-git-send-email-shawn@churchofgit.com>
Date: Wed, 25 Dec 2013 12:47:08 +0400
Message-ID: <CANaxB-xmF7uQSr_Xq63nTNTekVUb6RCKfYBEV_uNV5cgysx-qg@mail.gmail.com>
Subject: Re: [CRIU] [PATCH] timerfd: show procfs fdinfo helper
From: Andrey Wagin <avagin@gmail.com>
To: Shawn Landden <shawn@churchofgit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "criu@openvz.org" <criu@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/24 Shawn Landden <shawn@churchofgit.com>:
> | pos:  0
> | flags:        02004002
> | clockid:      0
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Shawn Landden <shawn@churchofgit.com>
> ---
>  fs/timerfd.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 9293121..e5fa587 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -25,6 +25,7 @@
>  #include <linux/syscalls.h>
>  #include <linux/compat.h>
>  #include <linux/rcupdate.h>
> +#include <linux/seq_file.h>
>
>  struct timerfd_ctx {
>         union {
> @@ -284,7 +285,23 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
>         return res;
>  }
>
> +#ifdef CONFIG_PROC_FS
> +static int timerfd_show_fdinfo(struct seq_file *m, struct file *f)
> +{
> +       struct timerfd_ctx *ctx = f->private_data;
> +       int clockid;
> +
> +       clockid = ctx->clockid;
> +       seq_printf(m, "clockid:\t%d\n", clockid);

I think we can show ctx->ticks, itimerspec here. The ctx->ticks is
required for proper dumping and restoring timerfd.

> +
> +       return 0;
> +}
> +#endif
> +
>  static const struct file_operations timerfd_fops = {
> +#ifdef CONFIG_PROC_FS
> +       .show_fdinfo    = timerfd_show_fdinfo,
> +#endif
>         .release        = timerfd_release,
>         .poll           = timerfd_poll,
>         .read           = timerfd_read,
> --
> 1.8.5.2.297.g3e57c29
>
> _______________________________________________
> CRIU mailing list
> CRIU@openvz.org
> https://lists.openvz.org/mailman/listinfo/criu
