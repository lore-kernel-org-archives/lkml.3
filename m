Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBCKof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:44:35 -0500
Received: from relay.parallels.com ([195.214.232.42]:58131 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaBCKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:44:34 -0500
Date: Mon, 3 Feb 2014 14:44:31 +0400
From: Andrew Vagin <avagin@parallels.com>
To: <shawn@churchofgit.com>
CC: Andrey Wagin <avagin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [CRIU] [PATCH] timerfd: show procfs fdinfo helper
Message-ID: <20140203104430.GA21968@paralelels.com>
References: <1387902787-257492-1-git-send-email-shawn@churchofgit.com>
 <CANaxB-xmF7uQSr_Xq63nTNTekVUb6RCKfYBEV_uNV5cgysx-qg@mail.gmail.com>
 <7d057f57b1aa6dd3f6871c07374ff5a1@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <7d057f57b1aa6dd3f6871c07374ff5a1@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:24:41AM +0000, shawn@churchofgit.com wrote:
>     ---- Original Message ----
>     From: "Andrey Wagin" <avagin@gmail.com>
>     To: "Shawn Landden" <shawn@churchofgit.com>
>     CC: "LKML" <linux-kernel@vger.kernel.org>, "criu@openvz.org"
>     <criu@openvz.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
>     linux-fsdevel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
>     Sent: Wed, Dec 25, 2013, 12:46 AM
>     Subject: Re: [CRIU] [PATCH] timerfd: show procfs fdinfo helper
> 
> 
>     2013/12/24 Shawn Landden <shawn@churchofgit.com>:
> 
>         | pos:  0
>         | flags:        02004002
>         | clockid:      0
> 
>         Cc: Thomas Gleixner <tglx@linutronix.de>
>         Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>         Signed-off-by: Shawn Landden <shawn@churchofgit.com>
>         ---
>         fs/timerfd.c | 17 +++++++++++++++++
>         1 file changed, 17 insertions(+)
> 
>         diff --git a/fs/timerfd.c b/fs/timerfd.c
>         index 9293121..e5fa587 100644
>         --- a/fs/timerfd.c
>         +++ b/fs/timerfd.c
>         @@ -25,6 +25,7 @@
>         #include <linux/syscalls.h>
>         #include <linux/compat.h>
>         #include <linux/rcupdate.h>
>         +#include <linux/seq_file.h>
> 
>         struct timerfd_ctx {
>         union {
>         @@ -284,7 +285,23 @@ static ssize_t timerfd_read(struct file *file,
>         char __user *buf, size_t count,
>         return res;
>         }
> 
>         +#ifdef CONFIG_PROC_FS
>         +static int timerfd_show_fdinfo(struct seq_file *m, struct file *f)
>         +{
>         +       struct timerfd_ctx *ctx = f->private_data;
>         +       int clockid;
>         +
>         +       clockid = ctx->clockid;
>         +       seq_printf(m, "clockid:\t%d\n", clockid);
> 
> 
> 
>     I think we can show ctx->ticks, itimerspec here. The ctx->ticks is
>     required for proper dumping and restoring timerfd.
> 
> 
> How? Shouldn't the itemerspec (from  timerfd_gettime and restored with
> timerfd_settime) and clockid be enough?

ctx->ticks is avaliable to userspace programs, so it must be restored,
otherwise you can break applications, which use this parameter in own
logic.

> How do we put the ctx->ticks back into
> the restored timerfd if we get it out with procfs?

read(2) returns ctx->ticks, so write() can be used for set it. It you
don't like this, you can add ioctl for setting ctx->ticks.

> 
>         +
>         +       return 0;
>         +}
>         +#endif
>         +
>         static const struct file_operations timerfd_fops = {
>         +#ifdef CONFIG_PROC_FS
>         +       .show_fdinfo    = timerfd_show_fdinfo,
>         +#endif
>         .release        = timerfd_release,
>         .poll           = timerfd_poll,
>         .read           = timerfd_read,
>         --
>         1.8.5.2.297.g3e57c29
> 
>         _______________________________________________
>         CRIU mailing list
>         CRIU@openvz.org
>         https://lists.openvz.org/mailman/listinfo/criu
> 

> _______________________________________________
> CRIU mailing list
> CRIU@openvz.org
> https://lists.openvz.org/mailman/listinfo/criu

