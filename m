Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbaJ1OMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:12:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:35070 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753625AbaJ1OMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:12:09 -0400
Date: Tue, 28 Oct 2014 10:11:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/7] fs: Convert show_fdinfo functions to void
Message-ID: <20141028101158.3dde9880@gandalf.local.home>
In-Reply-To: <e37e6e7b76acbdcc3bb4ab2a57c8f8ca1ae11b9a.1412031505.git.joe@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home>
	<cover.1412031505.git.joe@perches.com>
	<e37e6e7b76acbdcc3bb4ab2a57c8f8ca1ae11b9a.1412031505.git.joe@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 16:08:25 -0700
Joe Perches <joe@perches.com> wrote:

> seq_printf functions shouldn't really check the return value.
> Checking seq_is_full occasionally is used instead.
> 
> Update vfs documentation.
> 
> Signed-off-by: Joe Perches <joe@perches.com>


>  
> -#ifdef CONFIG_PROC_FS
> -static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
> +static void eventfd_show_fdinfo(struct seq_file *m, struct file *f)
>  {
> +#ifdef CONFIG_PROC_FS
>  	struct eventfd_ctx *ctx = f->private_data;
> -	int ret;
>  
>  	spin_lock_irq(&ctx->wqh.lock);
> -	ret = seq_printf(m, "eventfd-count: %16llx\n",
> -			 (unsigned long long)ctx->count);
> +	seq_printf(m, "eventfd-count: %16llx\n",
> +		   (unsigned long long)ctx->count);
>  	spin_unlock_irq(&ctx->wqh.lock);
> -
> -	return ret;
> -}
>  #endif
> +}
>  
>  static const struct file_operations eventfd_fops = {
> -#ifdef CONFIG_PROC_FS
>  	.show_fdinfo	= eventfd_show_fdinfo,
> -#endif

I wouldn't change logic on this. There's no reason to call this
function if it isn't doing anything.

I'll change this to just do the update and not change logic like this.

-- Steve

>  	.release	= eventfd_release,
>  	.poll		= eventfd_poll,
>  	.read		= eventfd_read,



> diff --git a/fs/proc/fd.c b/fs/proc/fd.c
> index e11d7c5..4c3c253 100644
> --- a/fs/proc/fd.c
> +++ b/fs/proc/fd.c
> @@ -53,7 +53,7 @@ static int seq_show(struct seq_file *m, void *v)
>  			   (long long)file->f_pos, f_flags,
>  			   real_mount(file->f_path.mnt)->mnt_id);
>  		if (file->f_op->show_fdinfo)
> -			ret = file->f_op->show_fdinfo(m, file);
> +			file->f_op->show_fdinfo(m, file);
>  		fput(file);
>  	}
>  
