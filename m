Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3LJHPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:15:12 -0500
Received: from ozlabs.org ([203.10.76.45]:40102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3LJHOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:14:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org
Cc: Sergei Ianovich <ynvich@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH v2] fix printk output
In-Reply-To: <1385826152-17531-1-git-send-email-ynvich@gmail.com>
References: <20131127220746.GA11255@order.stressinduktion.org> <1385826152-17531-1-git-send-email-ynvich@gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 10 Dec 2013 15:59:36 +1030
Message-ID: <87a9g9s27z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Ianovich <ynvich@gmail.com> writes:
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Hannes Frederic Sowa <hannes@stressinduktion.org>
> ---
>  Changes v1..v2
>  * 1-for-1 match between source and output lines
>  * clarify warning
>  * print tool name to avoid confusion with what to upgrade

Hmm, the copy here is gratuitous.  Using current->comm is safe, just
possibly ambigious if someone is changing the task name at the same time.

And we really want this one line anyway:

  		printk(KERN_WARNING
 		       "%s: waiting module removal not supported: please upgrade\n",
                        current->comm);

BTW, did you actually hit this?

Thanks,
Rusty.

>  kernel/module.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index f5a3b1e..0e627e7 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -816,8 +816,10 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  	name[MODULE_NAME_LEN-1] = '\0';
>  
>  	if (!(flags & O_NONBLOCK)) {
> +		char tool[TASK_COMM_LEN];
>  		printk(KERN_WARNING
> -		       "waiting module removal not supported: please upgrade");
> +		       "waiting module removal no longer supported\n"
> +		       "please upgrade %s\n", get_task_comm(tool, current));
>  	}
>  
>  	if (mutex_lock_interruptible(&module_mutex) != 0)
> -- 
> 1.8.4.3
