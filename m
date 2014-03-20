Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbaCTJxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:53:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:39744 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbaCTJxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:53:42 -0400
Date: Thu, 20 Mar 2014 10:53:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefani Seibold <stefani@seibold.net>
cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH] x86, vdso32: fix out of memory handling setup vDSO
In-Reply-To: <1395301511-5908-1-git-send-email-stefani@seibold.net>
Message-ID: <alpine.DEB.2.02.1403201039400.18573@ionos.tec.linutronix.de>
References: <1395301511-5908-1-git-send-email-stefani@seibold.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014, Stefani Seibold wrote:

> This patch add a correct out of memory handling for setup a 32 bit vDSO.
> 
> The patch is against tip commit 4e40112c4ff6a577dd06d92b2a54cdf06265bf74
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/vdso/vdso32-setup.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
> index 0bc363a..e1171c2 100644
> --- a/arch/x86/vdso/vdso32-setup.c
> +++ b/arch/x86/vdso/vdso32-setup.c
> @@ -134,8 +134,14 @@ int __init sysenter_setup(void)
>  	}
>  
>  	vdso32_size = (vdso_len + PAGE_SIZE - 1) / PAGE_SIZE;
> -	vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC); 
> +
> +	vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC);

Why is this GFP_ATOMIC and not GFP_ATOMIC ?

That code is called either from identify_boot_cpu(), where GFP_KERNEL
is perfectly valid and from subsys_initcall(sysenter_setup) which is
way late in the boot process where GFP_KERNEL is the RightThing.

Aside of that, why do we need to call it early for X86_32 and late for
X86_64?

We need the vdso before we head off to user space, but not in the
early boot process.

Thanks,

	tglx

