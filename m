Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3BUIEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:04:01 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:41383 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3BUIEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:04:00 -0500
Subject: Re: prctl(PR_SET_MM)
To: gorcunov@openvz.org (Cyrill Gorcunov)
Date: Thu, 21 Feb 2013 19:03:58 +1100 (EST)
Cc: rostedt@goodmis.org (Steven Rostedt), u3557@dialix.com.au,
        oleg@redhat.com (Oleg Nesterov), palves@redhat.com (Pedro Alves),
        dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        xemul@parallels.com (Pavel Emelyanov),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org (Andrew Morton)
Reply-To: u3557@dialix.com.au
In-Reply-To: <20130221080028.GE1740@moon>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130221080358.7965659207B@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Cyrill Gorcunov wrote:

> Wouldn't the below do the same trick but eliminate OR in preproc code?

Yes it would.  I don't mind having it either way.

Best Regards,
Amnon.

> ---
> From: Amnon Shiloh <u3557@miso.sublimeip.com>
> Subject: prctl: Make PR_SET_MM being depend on own CONFIG_MM_FIELDS_SETTING
> 
> ...
> 
> Signed-off-by: Amnon Shiloh <u3557@miso.sublimeip.com>
> ---
>  init/Kconfig |   17 +++++++++++++++++
>  kernel/sys.c |   16 ++++++++--------
>  2 files changed, 25 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6.git/init/Kconfig
> ===================================================================
> --- linux-2.6.git.orig/init/Kconfig
> +++ linux-2.6.git/init/Kconfig
> @@ -991,6 +991,7 @@ endif # CGROUPS
>  config CHECKPOINT_RESTORE
>  	bool "Checkpoint/restore support" if EXPERT
>  	default n
> +	select MM_FIELDS_SETTING
>  	help
>  	  Enables additional kernel features in a sake of checkpoint/restore.
>  	  In particular it adds auxiliary prctl codes to setup process text,
> @@ -999,6 +1000,22 @@ config CHECKPOINT_RESTORE
>  
>  	  If unsure, say N here.
>  
> +config MM_FIELDS_SETTING
> +	bool "Allow modifying per-process memory-region fields"
> +	default y
> +	help
> +	   Support "prctl(PR_SET_MM)" which allows applications to modify
> +	   the following in their "mm_struct":
> +
> +	      start_code, end_code, start_data, end_data, start_brk, brk,
> +	      start_stack, arg_start, arg_end, env_start, env_end.
> +
> +	    Also to modify their executable file ("/proc/self/exe").
> +
> +	    This option is needed for reconstructing processes (such as when
> +	    restoring a process from a checkpoint; duplicating a process;
> +	    or migrating it to another computer).
> +
>  menuconfig NAMESPACES
>  	bool "Namespaces support" if EXPERT
>  	default !EXPERT
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -1788,7 +1788,7 @@ SYSCALL_DEFINE1(umask, int, mask)
>  	return mask;
>  }
>  
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> +#ifdef CONFIG_MM_FIELDS_SETTING
>  static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
>  {
>  	struct fd exe;
> @@ -1981,23 +1981,23 @@ out:
>  	up_read(&mm->mmap_sem);
>  	return error;
>  }
> +#else /* CONFIG_MM_FIELDS_SETTING */
>  
> -static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
> -{
> -	return put_user(me->clear_child_tid, tid_addr);
> -}
> -
> -#else /* CONFIG_CHECKPOINT_RESTORE */
>  static int prctl_set_mm(int opt, unsigned long addr,
>  			unsigned long arg4, unsigned long arg5)
>  {
>  	return -EINVAL;
>  }
> +#endif
> +
>  static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
>  {
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +	return put_user(me->clear_child_tid, tid_addr);
> +#else
>  	return -EINVAL;
> -}
>  #endif
> +}
>  
>  SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		unsigned long, arg4, unsigned long, arg5)
> 

