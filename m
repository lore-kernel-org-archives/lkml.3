Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030376AbaGAWni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:43:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965072AbaGAWnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:43:25 -0400
Date: Tue, 1 Jul 2014 15:36:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
Message-ID: <20140701223644.GA30330@kroah.com>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
 <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 11:47:29PM +0200, Thomas Schoebel-Theuer wrote:
> From: Thomas Schoebel-Theuer <schoebel@bell.site>
> 
> Mostly introduces missing EXPORT_SYMBOL().
> Should have no impact onto the kernel.
> 
> This is the generic version which exports all sys_*() system
> calls. This should not introduce any additional maintenance pain
> because that interfaces has to be stable anyway due to POSIX etc.
> 
> Signed-off-by: Thomas Schoebel-Theuer <schoebel@bell.site>
> ---
>  fs/open.c                  | 1 -
>  fs/utimes.c                | 2 ++
>  include/linux/syscalls.h   | 3 +++
>  include/uapi/linux/major.h | 1 +
>  mm/page_alloc.c            | 3 +++
>  5 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 36662d0..3b21b76 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -1064,7 +1064,6 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
>  
>  	return retval;
>  }
> -EXPORT_SYMBOL(sys_close);
>  
>  /*
>   * This routine simulates a hangup on the tty, to arrange that users
> diff --git a/fs/utimes.c b/fs/utimes.c
> index aa138d6..4a1f4a8 100644
> --- a/fs/utimes.c
> +++ b/fs/utimes.c
> @@ -1,3 +1,4 @@
> +#include <linux/module.h>
>  #include <linux/compiler.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
> @@ -181,6 +182,7 @@ retry:
>  out:
>  	return error;
>  }
> +EXPORT_SYMBOL(do_utimes);
>  
>  SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
>  		struct timespec __user *, utimes, int, flags)
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index b0881a0..c674309 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -75,6 +75,7 @@ struct sigaltstack;
>  #include <linux/sem.h>
>  #include <asm/siginfo.h>
>  #include <linux/unistd.h>
> +#include <linux/export.h>
>  #include <linux/quota.h>
>  #include <linux/key.h>
>  #include <trace/syscall.h>
> @@ -176,6 +177,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  
>  #define SYSCALL_DEFINE0(sname)					\
>  	SYSCALL_METADATA(_##sname, 0);				\
> +	EXPORT_SYMBOL(sys_##sname);				\
>  	asmlinkage long sys_##sname(void)
>  
>  #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
> @@ -202,6 +204,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
>  		return ret;						\
>  	}								\
> +	EXPORT_SYMBOL(sys##name);					\
>  	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
>  

Heh, nice try, but no, we aren't going to export all syscalls, that's
crazy.  And wrong on many levels, sorry.

Be explicit with your exports, and justify _why_ you need them.

thanks,

greg k-h
