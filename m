Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab3IDAo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:44:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:50938 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934125Ab3IDAo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:44:26 -0400
Date: Wed, 4 Sep 2013 10:45:57 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 03/11] x86: Lock down IO port access when module
 security is enabled
In-Reply-To: <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1309041045470.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> IO port access would permit users to gain access to PCI configuration
> registers, which in turn (on a lot of hardware) give access to MMIO register
> space. This would potentially permit root to trigger arbitrary DMA, so lock
> it down by default.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>


Reviewed-by: James Morris <jmorris@namei.org>




> ---
>  arch/x86/kernel/ioport.c | 5 +++--
>  drivers/char/mem.c       | 4 ++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
> index 4ddaf66..00b4403 100644
> --- a/arch/x86/kernel/ioport.c
> +++ b/arch/x86/kernel/ioport.c
> @@ -15,6 +15,7 @@
>  #include <linux/thread_info.h>
>  #include <linux/syscalls.h>
>  #include <linux/bitmap.h>
> +#include <linux/module.h>
>  #include <asm/syscalls.h>
>  
>  /*
> @@ -28,7 +29,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
>  
>  	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
>  		return -EINVAL;
> -	if (turn_on && !capable(CAP_SYS_RAWIO))
> +	if (turn_on && (!capable(CAP_SYS_RAWIO) || secure_modules()))
>  		return -EPERM;
>  
>  	/*
> @@ -103,7 +104,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
>  		return -EINVAL;
>  	/* Trying to gain more privileges? */
>  	if (level > old) {
> -		if (!capable(CAP_SYS_RAWIO))
> +		if (!capable(CAP_SYS_RAWIO) || secure_modules())
>  			return -EPERM;
>  	}
>  	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) | (level << 12);
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index f895a8c..1af8664 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -28,6 +28,7 @@
>  #include <linux/export.h>
>  #include <linux/io.h>
>  #include <linux/aio.h>
> +#include <linux/module.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -563,6 +564,9 @@ static ssize_t write_port(struct file *file, const char __user *buf,
>  	unsigned long i = *ppos;
>  	const char __user *tmp = buf;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	if (!access_ok(VERIFY_READ, buf, count))
>  		return -EFAULT;
>  	while (count-- > 0 && i < 65536) {
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
