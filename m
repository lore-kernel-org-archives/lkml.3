Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3FQUsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:48:22 -0400
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:35324
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753244Ab3FQUsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:48:21 -0400
Message-ID: <51BF7610.10803@caviumnetworks.com>
Date: Mon, 17 Jun 2013 13:48:16 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: Linux 3.10-rc6
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com> <CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com> <CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com> <20130617133055.20463ce157e104af15ef60a1@linux-foundation.org>
In-Reply-To: <20130617133055.20463ce157e104af15ef60a1@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-Antispam-Report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:0;SRVR:SN2PR07MB015;H:BLUPR07MB002.namprd07.prod.outlook.com;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 01:30 PM, Andrew Morton wrote:
[...]
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: include/linux/smp.h:on_each_cpu(): switch back to a macro
>
> f21afc25f9ed4 ("smp.h: Use local_irq_{save,restore}() in !SMP version of
> on_each_cpu()") converted on_each_cpu() to a C function.  This required
> inclusion of irqflags.h, which broke ia64 and mn10300 (at least) due to
> header ordering hell.
>
> Switch on_each_cpu() back to a macro to fix this.

FYI:  I have already sent a pair of patches that fix the include 
dependencies:

https://lkml.org/lkml/2013/6/16/113
https://lkml.org/lkml/2013/6/17/422

Obviously, it is Linus' choice as to how best to handle the failure, but 
I think it is important to know that there are two options (fixing ia64 
and mn10300, or reverting the patch).

David Daney



>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Daney <david.daney@cavium.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   include/linux/smp.h |   20 ++++++++------------
>   1 file changed, 8 insertions(+), 12 deletions(-)
>
> diff -puN include/linux/smp.h~include-linux-smph-on_each_cpu-switch-back-to-a-macro include/linux/smp.h
> --- a/include/linux/smp.h~include-linux-smph-on_each_cpu-switch-back-to-a-macro
> +++ a/include/linux/smp.h
> @@ -11,7 +11,6 @@
>   #include <linux/list.h>
>   #include <linux/cpumask.h>
>   #include <linux/init.h>
> -#include <linux/irqflags.h>
>
>   extern void cpu_idle(void);
>
> @@ -140,17 +139,14 @@ static inline int up_smp_call_function(s
>   }
>   #define smp_call_function(func, info, wait) \
>   			(up_smp_call_function(func, info))
> -
> -static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	func(info);
> -	local_irq_restore(flags);
> -	return 0;
> -}
> -
> +#define on_each_cpu(func,info,wait)		\
> +	({					\
> +		unsigned long flags;		\
> +		local_irq_save(flags);		\
> +		func(info);			\
> +		local_irq_restore(flags);	\
> +		0;				\
> +	})
>   /*
>    * Note we still need to test the mask even for UP
>    * because we actually can get an empty mask from
> _
>
>

