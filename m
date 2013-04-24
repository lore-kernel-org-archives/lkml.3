Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3DXAES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:04:18 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:16459
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597Ab3DXAER convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:04:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Tue, 23 Apr 2013 19:04:06 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v2 12/15] powerpc/85xx: add time base sync support for
 e6500
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
	<1366368468-29143-12-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1366368468-29143-12-git-send-email-chenhui.zhao@freescale.com>
	(from chenhui.zhao@freescale.com on Fri Apr 19 05:47:45 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1366761846.5825.21@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 05:47:45 AM, Zhao Chenhui wrote:
> From: Chen-Hui Zhao <chenhui.zhao@freescale.com>
> 
> For e6500, two threads in one core share one time base. Just need
> to do time base sync on first thread of one core, and skip it on
> the other thread.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Andy Fleming <afleming@freescale.com>
> ---
>  arch/powerpc/platforms/85xx/smp.c |   52  
> +++++++++++++++++++++++++++++++-----
>  1 files changed, 44 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/smp.c  
> b/arch/powerpc/platforms/85xx/smp.c
> index 74d8cde..5f3eee3 100644
> --- a/arch/powerpc/platforms/85xx/smp.c
> +++ b/arch/powerpc/platforms/85xx/smp.c
> @@ -26,6 +26,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/dbell.h>
>  #include <asm/fsl_guts.h>
> +#include <asm/cputhreads.h>
> 
>  #include <sysdev/fsl_soc.h>
>  #include <sysdev/mpic.h>
> @@ -45,6 +46,7 @@ static u64 timebase;
>  static int tb_req;
>  static int tb_valid;
>  static u32 cur_booting_core;
> +static bool rcpmv2;
> 
>  #ifdef CONFIG_PPC_E500MC
>  /* get a physical mask of online cores and booting core */
> @@ -53,26 +55,40 @@ static inline u32 get_phy_cpu_mask(void)
>  	u32 mask;
>  	int cpu;
> 
> -	mask = 1 << cur_booting_core;
> -	for_each_online_cpu(cpu)
> -		mask |= 1 << get_hard_smp_processor_id(cpu);
> +	if (smt_capable()) {
> +		/* two threads in one core share one time base */
> +		mask = 1 << cpu_core_index_of_thread(cur_booting_core);
> +		for_each_online_cpu(cpu)
> +			mask |= 1 << cpu_core_index_of_thread(
> +					get_hard_smp_processor_id(cpu));
> +	} else {
> +		mask = 1 << cur_booting_core;
> +		for_each_online_cpu(cpu)
> +			mask |= 1 << get_hard_smp_processor_id(cpu);
> +	}

Where is smt_capable defined()?  I assume somewhere in the patchset but  
it's a pain to search 12 patches...

Is this really about whether we're SMT-capable or whether we have rcpm  
v2?

-Scott
