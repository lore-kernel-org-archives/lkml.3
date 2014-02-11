Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBKWob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:44:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBKWoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:44:30 -0500
Date: Tue, 11 Feb 2014 14:44:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>,
        Dario Faggioli <raistlin@linux.it>,
        Michal Simek <michal.simek@xilinx.com>, josh@joshtriplett.org
Subject: Re: [PATCH 19/21] fs: Add prototype declaration to header file
 include/linux/syscalls.h
Message-Id: <20140211144428.596c1cae0b56b83bf16800ec@linux-foundation.org>
In-Reply-To: <71025cb48e277e15705eb5645228a4857f729234.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
	<71025cb48e277e15705eb5645228a4857f729234.1391949868.git.rashika.kheria@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Feb 2014 18:58:34 +0530 Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Subject: [PATCH 19/21] fs: Add prototype declaration to header file include/linux/syscalls.h

The subjects are pretty meaningless - this really isn't an "fs" patch.

I'll rewrite it to

Subject: include/linux/syscalls.h: add sys32_quotactl() prototype

> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -198,6 +198,11 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  	}								\
>  	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
>  
> +#ifdef CONFIG_QUOTACTL_COMPAT
> +asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
> +			       qid_t id, void __user *addr);
> +#endif
> +
>  asmlinkage long sys_time(time_t __user *tloc);
>  asmlinkage long sys_stime(time_t __user *tptr);
>  asmlinkage long sys_gettimeofday(struct timeval __user *tv,

Disagree with the ifdefs.  If we were to do this, syscalls.h would
have a tremendous number of ifdefs in it.  Take a look in
kernel/sys_ni.c.

Removing the ifdefs will cause a compile-time error to be deferred to
link time, which will inconvenience a small number of people a small
number of times.  However it will make the code more readable by a
large number of people a large number of times.  It's a good tradeoff.

--- a/include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype-fix
+++ a/include/linux/syscalls.h
@@ -198,11 +198,8 @@ extern struct trace_event_functions exit
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
-#ifdef CONFIG_QUOTACTL_COMPAT
 asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
 			       qid_t id, void __user *addr);
-#endif
-
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
_

