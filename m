Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaEMUaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:30:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaEMU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:29:59 -0400
Date: Tue, 13 May 2014 13:29:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Derek Basehore <dbasehore@chromium.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Petr Mladek <pmladek@suse.cz>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Fix lockup on panic with lockdep
Message-Id: <20140513132958.e9a0bcee461e375b90ce7bbd@linux-foundation.org>
In-Reply-To: <1399941714-20145-1-git-send-email-dbasehore@chromium.org>
References: <1399941714-20145-1-git-send-email-dbasehore@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 17:41:54 -0700 Derek Basehore <dbasehore@chromium.org> wrote:

> If we don't call mutex_acquire at the beginning of console_unblank, we can run
> into a lockup on the logbuf_lock between console_unlock and printk during panic.
> What happens in console_unlock is:
> 
> -locks logbuf_lock
> -calls mutex_release
>  -which calls printk
>   -which locks logbuf_lock
> 
> This fixes the problem by calling console_trylock (which calls mutex_acquire)
> instead of directly accessing the semaphore in console_unblank and moves the
> mutex_release to after we unlock logbuf_lock in console_unlock (interrupts are
> still disabled).

Please take a look at linux-next, where this code has changed a lot.

> index 7228258..c599ab5 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2084,7 +2084,6 @@ skip:
>  		local_irq_restore(flags);
>  	}
>  	console_locked = 0;
> -	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
>  
>  	/* Release the exclusive_console once it is used */
>  	if (unlikely(exclusive_console))
> @@ -2092,6 +2091,7 @@ skip:
>  
>  	raw_spin_unlock(&logbuf_lock);
>  
> +	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
>  	up(&console_sem);
>  
>  	/*
> @@ -2137,7 +2137,7 @@ void console_unblank(void)
>  	 * oops_in_progress is set to 1..
>  	 */
>  	if (oops_in_progress) {
> -		if (down_trylock(&console_sem) != 0)
> +		if (!console_trylock())
>  			return;
>  	} else
>  		console_lock();

Although the code is quite different, an equivalent change appears to
have been made already.  I'm not sure that bugfix was intentional ;)

