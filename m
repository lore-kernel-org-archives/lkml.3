Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaHOKnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 06:43:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38980 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbaHOKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 06:43:54 -0400
Date: Fri, 15 Aug 2014 11:43:34 +0100
From: Will Deacon <will.deacon@arm.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: smp: Update the topology masks before calling
 CPU_STARTING notifiers
Message-ID: <20140815104333.GH27466@arm.com>
References: <1407892269-28650-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407892269-28650-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 02:11:09AM +0100, Rohit Vaswani wrote:
> Currently, the CPU_STARTING notifiers would observe an incorrect sibling
> mask since the notifier chain is called before the topology masks are updated
> for the new cpu.
> Update the topology masks before calling the notifier chain to fix this
> problem.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/kernel/smp.c   | 4 ++--
>  arch/arm64/kernel/smp.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 7c4fada..0e2237c 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -363,12 +363,12 @@ asmlinkage void secondary_start_kernel(void)
>  	if (smp_ops.smp_secondary_init)
>  		smp_ops.smp_secondary_init(cpu);
>  
> +	smp_store_cpu_info(cpu);
> +
>  	notify_cpu_starting(cpu);
>  
>  	calibrate_delay();
>  
> -	smp_store_cpu_info(cpu);
> -

Hmm, smp_store_cpu_info takes a copy of loops_per_jiffy. Are you sure it's
safe to move the call before calibrate_delay?

Will
