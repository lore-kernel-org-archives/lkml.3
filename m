Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3IWN3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:29:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39737 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3IWN3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:29:15 -0400
Date: Mon, 23 Sep 2013 09:29:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: xen-devel@lists.xen.org, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/5] xen/PMU: Cache MSR accesses during interrupt
 handling
Message-ID: <20130923132903.GF3175@phenom.dumpdata.com>
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
 <1378827110-4192-6-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378827110-4192-6-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:31:50AM -0400, Boris Ostrovsky wrote:
> Avoid trapping to hypervisor on each MSR access during interrupt handling.
> Instead, use cached MSR values provided in shared xenpmu_data by Xen. When
> handling is completed, flush the registers to hypervisor who will load them
> into HW.

Looks OK.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/xen/pmu.c             | 15 ++++++++++++++-
>  include/xen/interface/xenpmu.h |  1 +
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
> index d8b059b..bdd7c4a 100644
> --- a/arch/x86/xen/pmu.c
> +++ b/arch/x86/xen/pmu.c
> @@ -345,14 +345,27 @@ static void xen_convert_regs(struct cpu_user_regs *xen_regs,
>  
>  irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id)
>  {
> -	int ret = IRQ_NONE;
> +	int err, ret = IRQ_NONE;
>  	struct pt_regs regs;
>  	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
>  						  smp_processor_id());
>  
> +	/*
> +	 * While handling the interrupt MSR accesses will be cached
> +	 * in PMU context
> +	 */
> +	xenpmu_data->pmu_flags |= PMU_CACHED;
>  	xen_convert_regs(&xenpmu_data->regs, &regs);
>  	if (x86_pmu.handle_irq(&regs))
>  		ret = IRQ_HANDLED;
> +	xenpmu_data->pmu_flags &= ~PMU_CACHED;
> +
> +	/* Write out cached context to HW */
> +	err = HYPERVISOR_xenpmu_op(XENPMU_flush, NULL);
> +	if (err) {
> +		WARN(1, "%s failed hypercall, err: %d\n", __func__, err);
> +		return IRQ_NONE;
> +	}
>  
>  	return ret;
>  }
> diff --git a/include/xen/interface/xenpmu.h b/include/xen/interface/xenpmu.h
> index 16fe1ab..ec0e802 100644
> --- a/include/xen/interface/xenpmu.h
> +++ b/include/xen/interface/xenpmu.h
> @@ -16,6 +16,7 @@
>  #define XENPMU_init            4
>  #define XENPMU_finish          5
>  #define XENPMU_lvtpc_set       6
> +#define XENPMU_flush           7 /* Write cached MSR values to HW */
>  
>  /* Parameter structure for HYPERVISOR_xenpmu_op call */
>  struct xenpmu_params {
> -- 
> 1.8.1.4
> 
