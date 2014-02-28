Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaB1RUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:20:42 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbaB1RUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:20:40 -0500
Date: Fri, 28 Feb 2014 17:20:06 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] arm64: Add seccomp support
Message-ID: <20140228172006.GF30996@mudshark.cambridge.arm.com>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320025-2855-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393320025-2855-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:20:24AM +0000, AKASHI Takahiro wrote:
> secure_computing() should always be called first in syscall_trace(), and
> if it returns non-zero, we should stop further handling. Then that system
> call may eventually fail, be trapped or the process itself be killed
> depending on loaded rules.

[...]

> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index d4ce70e..f2a74bc 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -20,12 +20,14 @@
>   */
>  
>  #include <linux/audit.h>
> +#include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/mm.h>
>  #include <linux/smp.h>
>  #include <linux/ptrace.h>
>  #include <linux/user.h>
> +#include <linux/seccomp.h>
>  #include <linux/security.h>
>  #include <linux/init.h>
>  #include <linux/signal.h>
> @@ -1064,6 +1066,10 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>  {
>  	unsigned long saved_reg;
>  
> +	if (!dir && secure_computing((int)regs->syscallno))

Why do you need this cast to (int)? Also, it's probably better to check for
-1 explicitly here.

I'm slightly surprised that we do the secure computing check first. Doesn't
this allow a debugger to change the syscall to something else after we've
decided that it's ok?

Will
