Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbbAEPgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:36:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbbAEPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:36:32 -0500
Message-ID: <54AAAF67.9050507@redhat.com>
Date: Mon, 05 Jan 2015 16:36:07 +0100
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2] x86/xen: avoid freeing static 'name' when kasprintf()
 fails
References: <1420463205-19249-1-git-send-email-vkuznets@redhat.com> <1420471671-32051-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1420471671-32051-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/15 16:27, Vitaly Kuznetsov wrote:
> In case kasprintf() fails in xen_setup_timer() we assign name to the static
> string "<timer kasprintf failed>". We, however, don't check that fact before
> issuing kfree() in xen_teardown_timer(), kernel is supposed to crash with
> 'kernel BUG at mm/slub.c:3341!'
> 
> Solve the issue by making name a fixed length string inside struct
> xen_clock_event_device. 16 bytes should be enough.
> 
> Suggested-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> Changes from v1 (David Vrabel):
> - add 'struct xen_clock_event_device *xevt' for covenience
> - sizeof(xevt->name) in snprintf() call
> - Suggested-by: Laszlo Ersek
> ---
>  arch/x86/xen/time.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index f473d26..9f743f4 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -391,7 +391,7 @@ static const struct clock_event_device *xen_clockevent =
>  
>  struct xen_clock_event_device {
>  	struct clock_event_device evt;
> -	char *name;
> +	char name[16];
>  };
>  static DEFINE_PER_CPU(struct xen_clock_event_device, xen_clock_events) = { .evt.irq = -1 };
>  
> @@ -420,39 +420,33 @@ void xen_teardown_timer(int cpu)
>  	if (evt->irq >= 0) {
>  		unbind_from_irqhandler(evt->irq, NULL);
>  		evt->irq = -1;
> -		kfree(per_cpu(xen_clock_events, cpu).name);
> -		per_cpu(xen_clock_events, cpu).name = NULL;
>  	}
>  }
>  
>  void xen_setup_timer(int cpu)
>  {
> -	char *name;
> -	struct clock_event_device *evt;
> +	struct xen_clock_event_device *xevt = &per_cpu(xen_clock_events, cpu);
> +	struct clock_event_device *evt = &xevt->evt;
>  	int irq;
>  
> -	evt = &per_cpu(xen_clock_events, cpu).evt;
>  	WARN(evt->irq >= 0, "IRQ%d for CPU%d is already allocated\n", evt->irq, cpu);
>  	if (evt->irq >= 0)
>  		xen_teardown_timer(cpu);
>  
>  	printk(KERN_INFO "installing Xen timer for CPU %d\n", cpu);
>  
> -	name = kasprintf(GFP_KERNEL, "timer%d", cpu);
> -	if (!name)
> -		name = "<timer kasprintf failed>";
> +	snprintf(xevt->name, sizeof(xevt->name), "timer%d", cpu);
>  
>  	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
>  				      IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER|
>  				      IRQF_FORCE_RESUME|IRQF_EARLY_RESUME,
> -				      name, NULL);
> +				      xevt->name, NULL);
>  	(void)xen_set_irq_priority(irq, XEN_IRQ_PRIORITY_MAX);
>  
>  	memcpy(evt, xen_clockevent, sizeof(*evt));
>  
>  	evt->cpumask = cpumask_of(cpu);
>  	evt->irq = irq;
> -	per_cpu(xen_clock_events, cpu).name = name;
>  }
>  
>  
> 

Looks good to me (but I defer to Xen people of course :))

Reviewed-by: Laszlo Ersek <lersek@redhat.com>

Thanks!
Laszlo
