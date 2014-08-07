Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaHGSL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:11:28 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56754 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaHGSL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:11:27 -0400
Date: Thu, 7 Aug 2014 11:11:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        davej@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH] [BUGFIX] x86: mm: fix rcu splat from new TLB tracepoints
Message-ID: <20140807181122.GF5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140807175841.5C92D878@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807175841.5C92D878@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080718-1344-0000-0000-000003510917
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:58:41AM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This is a bug fix that needs to be pushed to mainline before the
> 3.17 release.
> 
> Dave Jones reported seeing a bug from one of my TLB tracepoints:
> 
>         http://lkml.kernel.org/r/20140806181801.GA4605@redhat.com
> 
> According to Paul McKenney, the right way to fix this is adding
> an _rcuidle suffix to the tracepoint.
> 
>         http://lkml.kernel.org/r/20140807065055.GA5821@linux.vnet.ibm.com
> 
> This patch does just that.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reported-by: Dave Jones <davej@redhat.com>,
> Cc: paulmck@linux.vnet.ibm.com

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
> 
>  b/arch/x86/mm/tlb.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff -puN arch/x86/mm/tlb.c~mm-fix-rcu-splat-from-tlb-tracepoints arch/x86/mm/tlb.c
> --- a/arch/x86/mm/tlb.c~mm-fix-rcu-splat-from-tlb-tracepoints	2014-08-07 10:55:43.312283542 -0700
> +++ b/arch/x86/mm/tlb.c	2014-08-07 10:56:49.763352575 -0700
> @@ -49,7 +49,13 @@ void leave_mm(int cpu)
>  	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
>  		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
>  		load_cr3(swapper_pg_dir);
> -		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
> +		/*
> +		 * This gets called in the idle path where RCU
> +		 * functions differently.  Tracing normally
> +		 * uses RCU, so we have to call the tracepoint
> +		 * specially here.
> +		 */
> +		trace_tlb_flush_rcuidle(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(leave_mm);
> _
> 

