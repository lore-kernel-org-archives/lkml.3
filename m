Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbaGRP3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:29:20 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:50228 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762301AbaGRP3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:29:17 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1405365496-58404-3-git-send-email-seth.forshee@canonical.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
	<1405365496-58404-3-git-send-email-seth.forshee@canonical.com>
Date: Fri, 18 Jul 2014 17:29:16 +0200
Message-ID: <CAJfpegsknFCRRksUZ8-4MjqAoxNgB4-gq=cBdKadVR2K3HJacw@mail.gmail.com>
Subject: Re: [PATCH 2/3] fuse: Translate pid making a request into the
 server's pid namespace
From: Miklos Szeredi <miklos@szeredi.hu>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> If the server is executing in a pid namespace then then giving it
> the global pid of the process making the request is useless.
> Translate the pid into the server's pid namespace.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  fs/fuse/dev.c    | 9 +++++----
>  fs/fuse/fuse_i.h | 4 ++++
>  fs/fuse/inode.c  | 2 ++
>  3 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 219d1e685183..db781ff6392b 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -20,6 +20,7 @@
>  #include <linux/swap.h>
>  #include <linux/splice.h>
>  #include <linux/aio.h>
> +#include <linux/sched.h>
>
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>  MODULE_ALIAS("devname:fuse");
> @@ -124,11 +125,11 @@ static void __fuse_put_request(struct fuse_req *req)
>         atomic_dec(&req->count);
>  }
>
> -static void fuse_req_init_context(struct fuse_req *req)
> +static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
>  {
>         req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
>         req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
> -       req->in.h.pid = current->pid;
> +       req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);

I think this is wrong.  We should store struct pid* in req->in and
translate into the server's pid in fuse_dev_do_read() before we copy
in.h.

Thanks,
Miklos
