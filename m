Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaFXEfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:35:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:44609 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaFXEfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:35:21 -0400
Message-ID: <1403584501.4587.153.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix build warning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 24 Jun 2014 14:35:01 +1000
In-Reply-To: <1402677499-28289-1-git-send-email-linux@roeck-us.net>
References: <1402677499-28289-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 09:38 -0700, Guenter Roeck wrote:
> If compiled with W=1, the following warning is seen in powerpc builds.
> 
> arch/powerpc/kernel/smp.c:750:18: warning:
> 	type qualifiers ignored on function return type
> static const int powerpc_smt_flags(void)
>                  ^
> 
> This is caused by a function returning 'const int', which doesn't
> make sense to gcc. Drop 'const' to fix the problem.

This breaks the 64-bit build:

arch/powerpc/kernel/smp.c:764:2: error: initialization from incompatible pointer type [-Werror]
arch/powerpc/kernel/smp.c:764:2: error: (near initialization for 'powerpc_topology[0].sd_flags') [-Werror]

It appears that the generic definition in sched.h has this function
defined as const int, so that needs to be fixed too along with all
instances in all archs.

Cheers,
Ben.

> Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/powerpc/kernel/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 10ffffe..49d5d4e 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -768,7 +768,7 @@ int setup_profiling_timer(unsigned int multiplier)
>  
>  #ifdef CONFIG_SCHED_SMT
>  /* cpumask of CPUs with asymetric SMT dependancy */
> -static const int powerpc_smt_flags(void)
> +static int powerpc_smt_flags(void)
>  {
>  	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
>  


