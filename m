Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3DZQPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:15:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6693 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab3DZQPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:15:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="20804678"
Date: Fri, 26 Apr 2013 17:15:09 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 5/9] xen/time: Add default value of -1 for IRQ and check
 for that.
In-Reply-To: <1366142947-18655-6-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1304261715020.4180@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> If the timer interrupt has been de-init or is just now being
> initialized, the default value of -1 should be preset as
> interrupt line. Check for that and if something is odd
> WARN us.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/time.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 054cc01..3d88bfd 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -377,7 +377,7 @@ static const struct clock_event_device xen_vcpuop_clockevent = {
>  
>  static const struct clock_event_device *xen_clockevent =
>  	&xen_timerop_clockevent;
> -static DEFINE_PER_CPU(struct clock_event_device, xen_clock_events);
> +static DEFINE_PER_CPU(struct clock_event_device, xen_clock_events) = { .irq = -1 };
>  
>  static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
>  {
> @@ -401,6 +401,9 @@ void xen_setup_timer(int cpu)
>  	struct clock_event_device *evt;
>  	int irq;
>  
> +	evt = &per_cpu(xen_clock_events, cpu);
> +	WARN(evt->irq >= 0, "IRQ%d for CPU%d is already allocated\n", evt->irq, cpu);
> +
>  	printk(KERN_INFO "installing Xen timer for CPU %d\n", cpu);
>  
>  	name = kasprintf(GFP_KERNEL, "timer%d", cpu);
> @@ -413,7 +416,6 @@ void xen_setup_timer(int cpu)
>  				      IRQF_FORCE_RESUME,
>  				      name, NULL);
>  
> -	evt = &per_cpu(xen_clock_events, cpu);
>  	memcpy(evt, xen_clockevent, sizeof(*evt));
>  
>  	evt->cpumask = cpumask_of(cpu);
> @@ -426,6 +428,7 @@ void xen_teardown_timer(int cpu)
>  	BUG_ON(cpu == 0);
>  	evt = &per_cpu(xen_clock_events, cpu);
>  	unbind_from_irqhandler(evt->irq, NULL);
> +	evt->irq = -1;
>  }
>  
>  void xen_setup_cpu_clockevents(void)
> -- 
> 1.8.1.4
> 
