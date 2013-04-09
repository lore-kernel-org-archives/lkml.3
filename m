Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935423Ab3DITVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:21:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40772 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304Ab3DITVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:21:01 -0400
Date: Tue, 9 Apr 2013 15:20:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: xen-devel@lists.xensource.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Feng Jin <joe.jin@oracle.com>, ben@guthro.net
Subject: Re: [PATCH] xen: minor fix in apic ipi interface func
Message-ID: <20130409192054.GA1768@phenom.dumpdata.com>
References: <5163F29D.6080605@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163F29D.6080605@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 06:51:09PM +0800, Zhenzhong Duan wrote:
> xen_send_IPI_mask_allbutself uses native vector as input other than xen_vector.

Ouch. But it looks as the only user of the .send_IPI_mask_allbutself
is just xen_send_IPI_allbutself? Or is there another user of this?


Is there a particular bug that was found with this?
> 
> xen_send_IPI_one need to be called to pass xen_vector in xen_send_IPI_mask_allbutself.

Right, as we are using now 'xen_vector'.

> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  arch/x86/xen/smp.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 09ea61d..bf27868 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -565,6 +565,10 @@ void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
>  {
>  	unsigned cpu;
>  	unsigned int this_cpu = smp_processor_id();
> +	int xen_vector = xen_map_vector(vector);
> +
> +	if (xen_vector < 0)
> +		return;
>  
>  	if (!(num_online_cpus() > 1))
>  		return;
> @@ -573,16 +577,13 @@ void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
>  		if (this_cpu == cpu)
>  			continue;
>  
> -		xen_smp_send_call_function_single_ipi(cpu);
> +		xen_send_IPI_one(cpu, xen_vector);
>  	}
>  }
>  
>  void xen_send_IPI_allbutself(int vector)
>  {
> -	int xen_vector = xen_map_vector(vector);
> -
> -	if (xen_vector >= 0)
> -		xen_send_IPI_mask_allbutself(cpu_online_mask, xen_vector);
> +	xen_send_IPI_mask_allbutself(cpu_online_mask, vector);
>  }
>  
>  static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
> -- 
> 1.7.3
> 
