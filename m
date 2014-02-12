Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaBLVNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:13:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaBLVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:13:17 -0500
Date: Wed, 12 Feb 2014 13:13:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, rdunlap <rdunlap@infradead.org>
Subject: Re: [RFC 2/2] Arch: Kconfig: Disable obsolete syscalls
Message-Id: <20140212131314.ef423a5b1214b0a33345f03d@linux-foundation.org>
In-Reply-To: <20140212210440.6148aaa3b75240627576ba3f@skynet.be>
References: <20140212210440.6148aaa3b75240627576ba3f@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014 21:04:40 +0800 Fabian Frederick <fabf@skynet.be> wrote:

> fs: sysfs syscall: Disable if DISABLE_OBSOLETE_SYSCALLS
> 
> sysfs syscall is obsolete (cf man sysfs).
> 
> Don't define fs_index, fs_name, fs_maxindex functions when
> DISABLE_OBSOLETE_SYSCALLS is defined.
> In that case, SYSCALL_DEFINE3(sysfs...) returns automatically -EINVAL.
> 

Are there any other syscalls which will fall under
CONFIG_DISABLE_OBSOLETE_SYSCALLS?

There are plenty of other syscalls which can be disabled via Kconfig. 
As far as I recall, they each use their own CONFIG_foo.

So I'm thinking it would be better to add a CONFIG_SYS_SYSFS or
whatever which enables this syscall only.  It defaults to y.

> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -121,6 +121,7 @@ int unregister_filesystem(struct file_system_type * fs)
>  
>  EXPORT_SYMBOL(unregister_filesystem);
>  
> +#ifndef CONFIG_DISABLE_OBSOLETE_SYSCALLS
>  static int fs_index(const char __user * __name)
>  {
>  	struct file_system_type * tmp;
> @@ -199,6 +200,12 @@ SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
>  	}
>  	return retval;
>  }
> +#else
> +SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
> +{
> +	return -EINVAL;
> +}
> +#endif /*CONFIG_DISABLE_OBSOLETE_SYSCALLS*/

And this should be done in kernel/sys_ni.c along with all the others.
