Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325Ab3D3RfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:35:01 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52666 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761169Ab3D3Re4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:34:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,582,1363132800"; 
   d="scan'208";a="21382015"
Date: Tue, 30 Apr 2013 18:34:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH V2] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
In-Reply-To: <1367342953-27509-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1304301834260.5398@kaball.uk.xensource.com>
References: <1367342953-27509-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad, are you going to take care of this patch (assuming that you are
OK with it)?

On Tue, 30 Apr 2013, Julien Grall wrote:
> Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
> default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
> irq_startup, that is responsible for calling irq_unmask at startup time.
> As a result event channels remain masked.
> 
> The clear is already made in bind_evtchn_to_irq with commit a8636c0 but was
> missing on all others bind_*_to_irq. Move the clear in xen_irq_info_common_init.
> 
> On x86, IRQ_NOAUTOEN and IRQ_NOREQUEST are cleared by default, so this commit
> doesn't impact this architecture.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  Changes since v1:
>    - Specify this commit will not impact x86 in the comment
>    - Clear flag directly in xen_irq_info_common_init, this function is
>    called by all bind_*_to_irq
> 
>  drivers/xen/events.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index d8cc812..6a6bbe4 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -167,6 +167,8 @@ static void xen_irq_info_common_init(struct irq_info *info,
>  	info->cpu = cpu;
>  
>  	evtchn_to_irq[evtchn] = irq;
> +
> +	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
>  }
>  
>  static void xen_irq_info_evtchn_init(unsigned irq,
> @@ -874,7 +876,6 @@ int bind_evtchn_to_irq(unsigned int evtchn)
>  		struct irq_info *info = info_for_irq(irq);
>  		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
>  	}
> -	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
>  
>  out:
>  	mutex_unlock(&irq_mapping_update_lock);
> -- 
> 1.7.10.4
> 
