Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3HPWuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:50:23 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757253Ab3HPWuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:50:20 -0400
Message-ID: <520E8599.4080803@nod.at>
Date: Fri, 16 Aug 2013 22:03:37 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        tj@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] um: Implement probe_kernel_read()
References: <1376682288-25315-1-git-send-email-richard@nod.at>
In-Reply-To: <1376682288-25315-1-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.08.2013 21:44, schrieb Richard Weinberger:
> UML needs it's own probe_kernel_read() to handle kernel
> mode faults correctly.
> The implementation uses mincore() on the host side to detect
> whether a page is owned by the UML kernel process.
> 
> This fixes also a possible crash when sysrq-t is used.
> Starting with 3.10 sysrq-t calls probe_kernel_read() to
> read details from the kernel workers. As kernel worker are
> completely async pointers may turn NULL while reading them.
> 
> Cc: <tj@kernel.org>
> Cc: <stable@vger.kernel.org> # 3.10.x
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/include/shared/os.h |  1 +
>  arch/um/kernel/Makefile     |  2 +-
>  arch/um/kernel/maccess.c    | 24 +++++++++++++++++++++
>  arch/um/os-Linux/process.c  | 52 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 78 insertions(+), 1 deletion(-)
>  create mode 100644 arch/um/kernel/maccess.c
> 
> diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
> index 95feaa4..c70a234 100644
> --- a/arch/um/include/shared/os.h
> +++ b/arch/um/include/shared/os.h
> @@ -200,6 +200,7 @@ extern int os_unmap_memory(void *addr, int len);
>  extern int os_drop_memory(void *addr, int length);
>  extern int can_drop_memory(void);
>  extern void os_flush_stdout(void);
> +extern int os_mincore(void *addr, unsigned long len);
>  
>  /* execvp.c */
>  extern int execvp_noalloc(char *buf, const char *file, char *const argv[]);
> diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
> index babe218..d8b78a0 100644
> --- a/arch/um/kernel/Makefile
> +++ b/arch/um/kernel/Makefile
> @@ -13,7 +13,7 @@ clean-files :=
>  obj-y = config.o exec.o exitcode.o irq.o ksyms.o mem.o \
>  	physmem.o process.o ptrace.o reboot.o sigio.o \
>  	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o \
> -	um_arch.o umid.o skas/
> +	um_arch.o umid.o maccess.o skas/
>  
>  obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
>  obj-$(CONFIG_GPROF)	+= gprof_syms.o
> diff --git a/arch/um/kernel/maccess.c b/arch/um/kernel/maccess.c
> new file mode 100644
> index 0000000..214e2e0
> --- /dev/null
> +++ b/arch/um/kernel/maccess.c
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (C) 2013 Richard Weinberger <richrd@nod.at>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/uaccess.h>
> +#include <linux/kernel.h>
> +#include <os.h>
> +
> +long probe_kernel_read(void *dst, const void *src, size_t size)
> +{
> +	void *psrc = (void *)rounddown((u64)src, PAGE_SIZE);
> +
> +	if ((u64)src < PAGE_SIZE || size <= 0)
> +		return -EFAULT;
> +

*grrr*, while pressing the send button I realized that it should be s/u64/unsigned long/g.

> +	if (os_mincore(psrc, size) <= 0)
> +		return -EFAULT;
> +
> +	return __probe_kernel_read(dst, src, size);
> +}
> diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
> index b8f34c9..67b9c8f 100644
> --- a/arch/um/os-Linux/process.c
> +++ b/arch/um/os-Linux/process.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <stdio.h>
> +#include <stdlib.h>
>  #include <unistd.h>
>  #include <errno.h>
>  #include <signal.h>
> @@ -232,6 +233,57 @@ out:
>  	return ok;
>  }
>  
> +static int os_page_mincore(void *addr)
> +{
> +	char vec[2];
> +	int ret;
> +
> +	ret = mincore(addr, UM_KERN_PAGE_SIZE, vec);
> +	if (ret < 0) {
> +		if (errno == ENOMEM || errno == EINVAL)
> +			return 0;
> +		else
> +			return -errno;
> +	}
> +
> +	return vec[0] & 1;
> +}
> +
> +int os_mincore(void *addr, unsigned long len)
> +{
> +	char *vec;
> +	int ret, i;
> +
> +	if (len <= UM_KERN_PAGE_SIZE)
> +		return os_page_mincore(addr);
> +
> +	vec = calloc(1, (len + UM_KERN_PAGE_SIZE - 1) / UM_KERN_PAGE_SIZE);
> +	if (!vec)
> +		return -ENOMEM;
> +
> +	ret = mincore(addr, UM_KERN_PAGE_SIZE, vec);
> +	if (ret < 0) {
> +		if (errno == ENOMEM || errno == EINVAL)
> +			ret = 0;
> +		else
> +			ret = -errno;
> +
> +		goto out;
> +	}
> +
> +	for (i = 0; i < ((len + UM_KERN_PAGE_SIZE - 1) / UM_KERN_PAGE_SIZE); i++) {
> +		if (!(vec[i] & 1)) {
> +			ret = 0;
> +			goto out;
> +		}
> +	}
> +
> +	ret = 1;
> +out:
> +	free(vec);
> +	return ret;
> +}
> +
>  void init_new_thread_signals(void)
>  {
>  	set_handler(SIGSEGV);
> 

